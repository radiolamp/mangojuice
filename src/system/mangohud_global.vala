/* system/mangohud_global.vala // License: GPL-3.0+ */
namespace MangoJuice.System {

public class MangohudGlobal : GLib.Object {

    MangoJuice.Config.State state;
    bool mangohud_global_enabled = false;

    public Gtk.Window window { get; set; }

    public MangohudGlobal (MangoJuice.Config.State state) {
        this.state = state;
    }

    public void on_button_clicked () {
        bool success = false;

        if (mangohud_global_enabled) {
            try {
                Process.spawn_command_line_sync ("pkexec sed -i '/MANGOHUD=1/d' /etc/environment");
                string file_contents;
                FileUtils.get_contents ("/etc/environment", out file_contents);
                if (!file_contents.contains ("MANGOHUD=1")) {
                    success = true;
                    mangohud_global_enabled = false;
                    state.mangohud_global_button.remove_css_class ("suggested-action");
                }
            } catch (Error e) {
                stderr.printf (_ ("Error deleting MANGOHUD from /etc/environment: %s\n"), e.message);
            }
        } else {
            try {
                Process.spawn_command_line_sync ("pkexec sh -c 'echo \"MANGOHUD=1\" >> /etc/environment'");
                string file_contents;
                FileUtils.get_contents ("/etc/environment", out file_contents);
                if (file_contents.contains ("MANGOHUD=1")) {
                    success = true;
                    mangohud_global_enabled = true;
                    state.mangohud_global_button.add_css_class ("suggested-action");
                }
            } catch (Error e) {
                stderr.printf (_ ("Error adding MANGOHUD to /etc/environment: %s\n"), e.message);
            }
        }

        if (success) {
            check_status ();
            show_restart_warning ();
        } else {
            stderr.printf (_ ("Failed to modify /etc/environment.\n"));
        }
    }

    public void check_status () {
        new Thread<void> ("check-mangohud-status", () => {
            try {
                string[] argv = { "grep", "MANGOHUD=1", "/etc/environment" };
                int exit_status;
                string standard_output;
                string standard_error;
                Process.spawn_sync (null, argv, null,
                                    SpawnFlags.SEARCH_PATH, null,
                                    out standard_output, out standard_error,
                                    out exit_status);

                bool enabled = (exit_status == 0);

                Idle.add (() => {
                    mangohud_global_enabled = enabled;
                    if (enabled) {
                        state.mangohud_global_button.add_css_class ("suggested-action");
                    } else {
                        state.mangohud_global_button.remove_css_class ("suggested-action");
                    }
                    return false;
                });
            } catch (Error e) {
                stderr.printf (_ ("Error checking the MANGOHUD status: %s\n"), e.message);
            }
        });
    }

    void show_restart_warning () {
        var dialog = new Adw.AlertDialog (_ ("Warning"),
            _ ("The changes will take effect only after the system is restarted.")
        );
        dialog.add_response ("ok", _ ("OK"));
        dialog.add_response ("restart", _ ("Restart"));

        dialog.set_default_response ("ok");
        dialog.set_response_appearance ("restart", Adw.ResponseAppearance.SUGGESTED);
        dialog.present (window);

        dialog.response.connect ((response) => {
            if (response == "restart") {
                try {
                    Process.spawn_command_line_sync ("reboot");
                } catch (Error e) {
                    stderr.printf (_ ("Error when restarting the system: %s\n"), e.message);
                }
            }
            dialog.destroy ();
        });
    }
}

}
