using Gtk;
using GLib;

public async void on_intel_power_fix_button_clicked(Button button) {
    try {
        var file = File.new_for_path ("/sys/class/powercap/intel-rapl:0/energy_uj");
        var info = file.query_info ("*", FileQueryInfoFlags.NONE);
        var current_mode = info.get_attribute_uint32 (FileAttribute.UNIX_MODE);

        string new_mode = ((current_mode & 0777) == 0644) ? "0600" : "0644";

        Process.spawn_command_line_sync ("pkexec chmod " + new_mode + " /sys/class/powercap/intel-rapl\\:0/energy_uj");

        yield check_file_permissions_async (button);

    } catch (Error e) {
        stderr.printf ("Error: %s\n", e.message);
    }
}

public async void check_file_permissions_async(Button button) {
    string file_path = "/sys/class/powercap/intel-rapl:0/energy_uj";
    bool has_permissions = false;

    try {
        var file = File.new_for_path (file_path);
        var info = yield file.query_info_async ("*", FileQueryInfoFlags.NONE);
        has_permissions = (info.get_attribute_uint32 (FileAttribute.UNIX_MODE) & 0777) == 0644;
    } catch (Error e) {
        stderr.printf ("Permission check failed: %s\n", e.message);
    }

    Idle.add (() => {
        if (has_permissions) {
            button.add_css_class ("suggested-action");
        } else {
            button.remove_css_class ("suggested-action");
        }
        return false;
    });
}