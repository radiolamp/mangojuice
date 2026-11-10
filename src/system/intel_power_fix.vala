/* system/intel_power_fix.vala // License: GPL-3.0+ */
using Gtk;
using GLib;
using Adw;

namespace MangoJuice.System {

public struct IntelPowerFixStatus {
    public bool available;
    public bool has_permissions;
    public bool service_installed;
    public bool service_active;
}

public class IntelPowerFix : GLib.Object {

    private const string ENERGY_UJ_PATH = "/sys/class/powercap/intel-rapl:0/energy_uj";
    private const string SERVICE_NAME = "powercap-permissions.service";
    private const string SERVICE_PATH = "/etc/systemd/system/powercap-permissions.service";
    private const uint32 MODE_OPEN = 0644;
    private const string MODE_OPEN_TEXT = "0644";
    private const string MODE_CLOSED_TEXT = "0600";

    private static bool run_command (string command_line) {
        try {
            int exit_status;
            Process.spawn_command_line_sync (command_line, null, null, out exit_status);
            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Command failed: %s\n", e.message);
            return false;
        }
    }

    private void show_error_dialog (Gtk.Window window, string message) {
        var dialog = new Adw.AlertDialog (_("Error"), message);
        dialog.add_response ("ok", _("OK"));
        dialog.present (window);
    }

    public static bool is_available () {
        return FileUtils.test (ENERGY_UJ_PATH, FileTest.EXISTS);
    }

    public async IntelPowerFixStatus get_permissions_status_async () {
        var status = IntelPowerFixStatus ();
        status.available = is_available ();

        if (!status.available) {
            return status;
        }

        try {
            var file = File.new_for_path (ENERGY_UJ_PATH);
            var info = yield file.query_info_async (FileAttribute.UNIX_MODE, FileQueryInfoFlags.NONE);
            status.has_permissions =
                (info.get_attribute_uint32 (FileAttribute.UNIX_MODE) & 0777) == MODE_OPEN;

            status.service_installed = FileUtils.test (SERVICE_PATH, FileTest.EXISTS);

            if (status.service_installed) {
                int exit_status;
                Process.spawn_command_line_sync (
                    "systemctl is-active --quiet " + SERVICE_NAME,
                    null, null, out exit_status
                );
                status.service_active = (exit_status == 0);
            }
        } catch (Error e) {
            if (!e.matches (FileError.quark (), FileError.NOENT)) {
                stderr.printf ("Permission check failed: %s\n", e.message);
            }
        }

        return status;
    }

    public async void open_fix_dialog (Gtk.Window window) {
        if (!is_available ()) {
            return;
        }

        try {
            bool is_service_active = false;
            try {
                int exit_status;
                Process.spawn_command_line_sync (
                    "systemctl is-active --quiet " + SERVICE_NAME,
                    null, null, out exit_status
                );
                is_service_active = (exit_status == 0);
            } catch (Error e) {
                stderr.printf ("Service check failed: %s\n", e.message);
            }

            var dialog = new Adw.AlertDialog (
                _("Warning"),
                _("You are changing the rights to intel energy_uj, which could potentially lead to security issues.")
            );

            dialog.add_response ("cancel", _("Cancel"));
            dialog.add_response ("temporary", _("Until Reboot"));
            dialog.add_response ("permanent", _("Permanently"));
            dialog.set_default_response ("cancel");
            dialog.set_close_response ("cancel");

            if (is_service_active) {
                dialog.set_response_appearance ("permanent", Adw.ResponseAppearance.SUGGESTED);
            }

            string response = yield dialog.choose (window, null);

            if (response == "cancel") {
                return;
            }

            var file = File.new_for_path (ENERGY_UJ_PATH);
            var info = yield file.query_info_async (FileAttribute.UNIX_MODE, FileQueryInfoFlags.NONE);
            uint32 current_mode = info.get_attribute_uint32 (FileAttribute.UNIX_MODE) & 0777;
            string new_mode = current_mode == MODE_OPEN ? MODE_CLOSED_TEXT : MODE_OPEN_TEXT;

            if (response == "temporary") {
                if (!run_command ("pkexec chmod " + new_mode + " " + ENERGY_UJ_PATH)) {
                    show_error_dialog (window, _("Failed to change permissions."));
                    return;
                }
                var app = window.get_application () as MangoJuice.Application;
                if (app != null) {
                    app.run_test ();
                }
            } else if (response == "permanent") {
                bool service_exists = FileUtils.test (SERVICE_PATH, FileTest.EXISTS);

                if (service_exists) {
                    if (!run_command (
                        "pkexec sh -c 'systemctl stop " + SERVICE_NAME + " && " +
                        "systemctl disable " + SERVICE_NAME + " && " +
                        "rm " + SERVICE_PATH + " && " +
                        "chmod " + MODE_CLOSED_TEXT + " " + ENERGY_UJ_PATH + " && " +
                        "systemctl daemon-reload'"
                    )) {
                        show_error_dialog (window, _("Failed to remove the permissions service."));
                        return;
                    }
                } else {
                    string service_content = "[Unit]\n" +
                        "Description=Change permissions of intel-rapl energy_uj file\n" +
                        "After=sysinit.target\n\n" +
                        "[Service]\n" +
                        "Type=oneshot\n" +
                        "ExecStart=/bin/chmod " + MODE_OPEN_TEXT + " " + ENERGY_UJ_PATH + "\n" +
                        "RemainAfterExit=yes\n\n" +
                        "[Install]\n" +
                        "WantedBy=multi-user.target";

                    if (!run_command (
                        "pkexec sh -c 'echo \"" + service_content + "\" " +
                        "> " + SERVICE_PATH + " && " +
                        "systemctl daemon-reload && " +
                        "systemctl enable " + SERVICE_NAME + " && " +
                        "systemctl start " + SERVICE_NAME + "'"
                    )) {
                        show_error_dialog (window, _("Failed to install the permissions service."));
                        return;
                    }

                    var reboot_dialog = new Adw.AlertDialog (
                        _("Warning"),
                        _("For the permanent changes to take full effect, " +
                          "a reboot is recommended. Would you like to reboot now?")
                    );
                    reboot_dialog.add_response ("no", _("Later"));
                    reboot_dialog.add_response ("yes", _("Reboot Now"));
                    reboot_dialog.set_response_appearance ("yes", Adw.ResponseAppearance.DESTRUCTIVE);

                    string reboot_response = yield reboot_dialog.choose (window, null);
                    if (reboot_response == "yes") {
                        Process.spawn_command_line_async ("pkexec reboot");
                    }
                }
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
            show_error_dialog (window, e.message);
        }
    }
}

}
