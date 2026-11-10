/* system/test_apps.vala // License: GPL-3.0+ */
using GLib;

namespace MangoJuice.System {

public class TestApps : GLib.Object {

public bool is_vkcube_available () {
    try {
        string[] argv = { "which", "vkcube" };
        int exit_status;
        string standard_output;
        string standard_error;
        Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null,
                out standard_output, out standard_error,
                out exit_status);
        return exit_status == 0;
    } catch (Error e) {
        stderr.printf (_ ("Error checking vkcube availability: %s\n"), e.message);
        return false;
    }
}

public bool is_mangohud_available () {
    try {
        string[] argv = { "which", "mangohud" };
        int exit_status;
        string standard_output;
        string standard_error;
        Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null,
                out standard_output, out standard_error,
                out exit_status);
        if (exit_status != 0) {
            stderr.printf (_ ("MangoHud not found. Please install MangoHud to use this application.\n"));
        }
        return exit_status == 0;
    } catch (Error e) {
        stderr.printf (_ ("Error checking MangoHud availability: %s\n"), e.message);
        return false;
    }
}

public bool is_glxgears_available () {
    try {
        string[] argv = { "which", "glxgears" };
        int exit_status;
        string standard_output;
        string standard_error;
        Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null,
                out standard_output, out standard_error,
                out exit_status);
        return exit_status == 0;
    } catch (Error e) {
        stderr.printf (_ ("Error checking glxgears availability: %s\n"), e.message);
        return false;
    }
}

public bool is_vkcube_running () {
    try {
        string[] argv = { "pgrep", "vkcube" };
        int exit_status;
        string standard_output;
        string standard_error;
        Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null,
                out standard_output, out standard_error,
                out exit_status);

        return exit_status == 0;
    } catch (Error e) {
        stderr.printf (_ ("Error checking running processes: %s\n"), e.message);
        return false;
    }
}

public bool is_glxgears_running () {
    try {
        string[] argv = { "pgrep", "glxgears" };
        int exit_status;
        string standard_output;
        string standard_error;
        Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null,
                out standard_output, out standard_error,
                out exit_status);

        return exit_status == 0;
    } catch (Error e) {
        stderr.printf (_ ("Error checking running processes: %s\n"), e.message);
        return false;
    }
}
}

}
