using Gtk;
using GLib;
using Adw;

public async void on_intel_power_fix_button_clicked(Button button) {
    try {
        bool is_service_active = false;
        try {
            int exit_status;
            Process.spawn_command_line_sync("systemctl is-active --quiet powercap-permissions.service", null, null, out exit_status);
            is_service_active = (exit_status == 0);
        } catch (Error e) {
            stderr.printf("Service check failed: %s\n", e.message);
        }

        var dialog = new Adw.AlertDialog(_("Warning"), _("You are changing the rights to intel energy_uj, which could potentially lead to security issues."));
        
        dialog.add_response("cancel", _("Cancel"));
        dialog.add_response("temporary", _("Until Reboot"));
        dialog.add_response("permanent", _("Permanently"));
        dialog.set_default_response("cancel");
        dialog.set_close_response("cancel");
        
        if (is_service_active) {
            dialog.set_response_appearance("permanent", Adw.ResponseAppearance.SUGGESTED);
        }
        
        var window = (Gtk.Window) button.get_root();
        string response = yield dialog.choose(window, null);
        
        if (response == "cancel") {
            return;
        }

        var file = File.new_for_path("/sys/class/powercap/intel-rapl:0/energy_uj");
        var info = yield file.query_info_async("*", FileQueryInfoFlags.NONE);
        var current_mode = info.get_attribute_uint32(FileAttribute.UNIX_MODE);

        string new_mode = ((current_mode & 0777) == 0644) ? "0600" : "0644";

        if (response == "temporary") {
            Process.spawn_command_line_sync("pkexec chmod " + new_mode + " /sys/class/powercap/intel-rapl\\:0/energy_uj");
        } else if (response == "permanent") {
            bool service_exists = FileUtils.test("/etc/systemd/system/powercap-permissions.service", FileTest.EXISTS);
            
            if (service_exists) {
                Process.spawn_command_line_sync("pkexec sh -c 'systemctl stop powercap-permissions.service && " +
                                               "systemctl disable powercap-permissions.service && " +
                                               "rm /etc/systemd/system/powercap-permissions.service && " +
                                               "pkexec chmod 0600 /sys/class/powercap/intel-rapl\\:0/energy_uj && " +
                                               "systemctl daemon-reload'");
            } else {
                string service_content = "[Unit]\n" +
                                       "Description=Change permissions of intel-rapl energy_uj file\n" +
                                       "After=sysinit.target\n\n" +
                                       "[Service]\n" +
                                       "Type=oneshot\n" +
                                       "ExecStart=/bin/chmod 0644 /sys/class/powercap/intel-rapl:0/energy_uj\n" +
                                       "RemainAfterExit=yes\n\n" +
                                       "[Install]\n" +
                                       "WantedBy=multi-user.target";
                
                Process.spawn_command_line_sync("pkexec sh -c 'echo \"" + service_content + "\" > /etc/systemd/system/powercap-permissions.service && " +
                                               "systemctl daemon-reload && " +
                                               "systemctl enable powercap-permissions.service && " +
                                               "systemctl start powercap-permissions.service'");
                
                // Show reboot suggestion after permanent change
                var reboot_dialog = new Adw.AlertDialog(
                    _("Reboot Recommended"),
                    _("For the permanent changes to take full effect, a reboot is recommended. Would you like to reboot now?")
                );
                reboot_dialog.add_response("no", _("Later"));
                reboot_dialog.add_response("yes", _("Reboot Now"));
                reboot_dialog.set_response_appearance("yes", Adw.ResponseAppearance.DESTRUCTIVE);
                
                string reboot_response = yield reboot_dialog.choose(window, null);
                if (reboot_response == "yes") {
                    Process.spawn_command_line_async("pkexec reboot");
                }
            }
        }

        yield check_file_permissions_async(button);

    } catch (Error e) {
        stderr.printf("Error: %s\n", e.message);
        
        var error_dialog = new Adw.AlertDialog(
            _("Error"),
            e.message
        );
        error_dialog.add_response("ok", _("OK"));
        
        var window = (Gtk.Window) button.get_root();
        error_dialog.present(window);
    }
}

public async void check_file_permissions_async(Button button) {
    string file_path = "/sys/class/powercap/intel-rapl:0/energy_uj";
    bool has_permissions = false;
    bool permanent_solution = false;
    bool is_service_active = false;

    try {
        var file = File.new_for_path(file_path);
        var info = yield file.query_info_async("*", FileQueryInfoFlags.NONE);
        has_permissions = (info.get_attribute_uint32(FileAttribute.UNIX_MODE) & 0777) == 0644;
        
        permanent_solution = FileUtils.test("/etc/systemd/system/powercap-permissions.service", FileTest.EXISTS);
        
        if (permanent_solution) {
            int exit_status;
            Process.spawn_command_line_sync("systemctl is-active --quiet powercap-permissions.service", null, null, out exit_status);
            is_service_active = (exit_status == 0);
        }
    } catch (Error e) {
        stderr.printf("Permission check failed: %s\n", e.message);
    }

    Idle.add(() => {
        if (has_permissions) {
            button.add_css_class("suggested-action");
            button.set_tooltip_text(is_service_active ? _("Permissions set permanently (systemd service active)") : 
                                  (permanent_solution ? _("Service exists but not active") : _("Permissions set until reboot")));
        } else {
            button.remove_css_class("suggested-action");
            button.set_tooltip_text(is_service_active ? _("Service active but permissions not set") : 
                                  (permanent_solution ? _("Service exists but inactive") : _("Permissions not set")));
        }
        return false;
    });
}