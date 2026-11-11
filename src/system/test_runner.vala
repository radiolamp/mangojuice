/* system/test_runner.vala // License: GPL-3.0+ */
using GLib;
using MangoJuice.Config;

namespace MangoJuice.System {

public class TestRunner : GLib.Object {

    MangoJuice.Config.Paths paths;
    MangoJuice.Config.Saver saver;
    MangoJuice.Config.State state;
    Env env;
    TestApps test_apps;

    bool test_button_pressed = false;
    GLib.Subprocess? running_test_app = null;

    public TestRunner (MangoJuice.Config.Paths paths, MangoJuice.Config.Saver saver,
                       MangoJuice.Config.State state, Env env, TestApps test_apps) {
        this.paths = paths;
        this.saver = saver;
        this.state = state;
        this.env = env;
        this.test_apps = test_apps;
    }

    public void run_test () {
        saver.flush_all_pending ();

        if (!paths.mangohud_conf.query_exists ()) {
            save_config ();
        }

        start_test_app (null);
        test_button_pressed = true;
    }

    void save_config () {
        if (!state.is_loading) {
            saver.save_states (state);
        }
    }

    static bool is_wayland_session () {
        string? wayland_display = Environment.get_variable ("WAYLAND_DISPLAY");
        return wayland_display != null && wayland_display != "";
    }

    static bool has_x11_display () {
        string? display = Environment.get_variable ("DISPLAY");
        return display != null && display != "";
    }

    static bool should_use_wayland_wsi () {
        return is_wayland_session () && !has_x11_display ();
    }

    void start_test_app (string? config_file) {
        stop_test_app ();

        if (env.is_flatpak () && is_wayland_session ()) {
            spawn_vkcube_wayland (config_file);
        } else if (test_apps.is_vkcube_available ()) {
            if (should_use_wayland_wsi ()) {
                spawn_vkcube_wayland_wsi (config_file);
            } else {
                spawn_vkcube_xcb (config_file);
            }
        } else if (test_apps.is_glxgears_available ()) {
            spawn_glxgears (config_file);
        }
    }

    SubprocessLauncher build_launcher (string? config_file) {
        var launcher = new SubprocessLauncher (SubprocessFlags.NONE);
        if (config_file != null && config_file != "") {
            launcher.setenv ("MANGOHUD_CONFIGFILE", config_file, true);
        }
        return launcher;
    }

    void spawn_vkcube_wayland (string? config_file) {
        try {
            running_test_app = build_launcher (config_file).spawn ("mangohud", "vkcube-wayland");
        } catch (Error e) {
            stderr.printf (_ ("Error when starting the test app: %s\n"), e.message);
        }
    }

    void spawn_vkcube_wayland_wsi (string? config_file) {
        try {
            running_test_app = build_launcher (config_file).spawn ("mangohud", "vkcube", "--wsi", "wayland");
        } catch (Error e) {
            stderr.printf (_ ("Error when starting the test app: %s\n"), e.message);
        }
    }

    void spawn_vkcube_xcb (string? config_file) {
        try {
            running_test_app = build_launcher (config_file).spawn ("mangohud", "vkcube", "--wsi", "xcb");
        } catch (Error e) {
            stderr.printf (_ ("Error when starting the test app: %s\n"), e.message);
        }
    }

    void spawn_glxgears (string? config_file) {
        try {
            running_test_app = build_launcher (config_file).spawn ("mangohud", "glxgears");
        } catch (Error e) {
            stderr.printf (_ ("Error when starting the test app: %s\n"), e.message);
        }
    }

    public void stop_test_app () {
        var running = running_test_app;
        running_test_app = null;
        if (running != null) {
            running.force_exit ();
        }
    }

    public bool is_test_app_running () {
        return running_test_app != null;
    }

    public void run_vkcube_with_profile (string config_path) {
        start_test_app (config_path);
        test_button_pressed = true;
    }

    public void run_test_with_vkbasalt () {
        saver.flush_all_pending ();

        if (!paths.mangohud_conf.query_exists ()) {
            save_config ();
        }

        stop_test_app ();
        try {
            var launcher = new SubprocessLauncher (SubprocessFlags.NONE);
            launcher.setenv ("ENABLE_VKBASALT", "1", true);
            if (should_use_wayland_wsi ()) {
                running_test_app = launcher.spawn ("mangohud", "vkcube", "--wsi", "wayland");
            } else {
                running_test_app = launcher.spawn ("mangohud", "vkcube", "--wsi", "xcb");
            }
        } catch (Error e) {
            stderr.printf (_ ("Error when starting the test app: %s\n"), e.message);
        }
        test_button_pressed = true;
    }

    public void restart_vkcube_or_glxgears () {
        if (!is_test_app_running ()) {
            return;
        }
        run_test ();
    }

    public void save_and_restart () {
        save_config ();
        restart_vkcube_or_glxgears ();
    }

    public void restart_if_testing () {
        if (test_button_pressed && is_test_app_running ()) {
            restart_vkcube_or_glxgears ();
        }
    }
}

}
