using Gtk;
using GLib;
using Adw;

public async void on_intel_power_fix_button_clicked(Button button) {
    try {
        var dialog = new Adw.AlertDialog(_("Warning"), _("You are changing the rights to intel energy_uj, which could potentially lead to security issues."));
        
        dialog.add_response("cancel", _("Cancel"));
        dialog.add_response("temporary", _("Until Reboot"));
        dialog.add_response("permanent", _("Permanently"));
        dialog.set_default_response("cancel");
        dialog.set_close_response("cancel");
        
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
            Process.spawn_command_line_sync("pkexec sh -c 'chmod " + new_mode + " /sys/class/powercap/intel-rapl\\:0/energy_uj && " +
                                         "echo \"chmod " + new_mode + " /sys/class/powercap/intel-rapl:0/energy_uj\" > /etc/udev/rules.d/99-intel-rapl.rules'");
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

    try {
        var file = File.new_for_path(file_path);
        var info = yield file.query_info_async("*", FileQueryInfoFlags.NONE);
        has_permissions = (info.get_attribute_uint32(FileAttribute.UNIX_MODE) & 0777) == 0644;
    } catch (Error e) {
        stderr.printf("Permission check failed: %s\n", e.message);
    }

    Idle.add(() => {
        if (has_permissions) {
            button.add_css_class("suggested-action");
        } else {
            button.remove_css_class("suggested-action");
        }
        return false;
    });
}