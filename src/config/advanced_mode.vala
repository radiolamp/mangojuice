/* config/advanced_mode.vala // License: GPL-3.0+ */
namespace MangoJuice.Config {

public class AdvancedMode : GLib.Object {

    Paths paths;

    public AdvancedMode (Paths paths) {
        this.paths = paths;
    }

    public void load (State state) {
        var config_file = paths.first_run_file;
        try {
            if (!config_file.query_exists ()) return;
            var dis = new DataInputStream (config_file.read ());
            string line;
            while ((line = dis.read_line ()) != null) {
                if (line == "Advances=1") {
                    state.custom_order_changed = true;
                    break;
                }
            }
            dis.close ();
        } catch (Error e) {
            stderr.printf ("Error loading advanced mode state: %s\n", e.message);
        }
    }

    public void save (State state) {
        var config_file = paths.first_run_file;
        try {
            if (!config_file.query_exists ()) return;
            var lines = new Gee.ArrayList<string> ();
            var dis = new DataInputStream (config_file.read ());
            string line;
            bool found = false;
            while ((line = dis.read_line ()) != null) {
                if (line.has_prefix ("Advances=")) {
                    lines.add (state.custom_order_changed ? "Advances=1" : "Advances=0");
                    found = true;
                } else {
                    lines.add (line);
                }
            }
            dis.close ();
            if (!found) {
                lines.add (state.custom_order_changed ? "Advances=1" : "Advances=0");
            }
            var dos = new DataOutputStream (config_file.replace (null, false, FileCreateFlags.NONE));
            foreach (string l in lines) {
                dos.put_string (l + "\n");
            }
            dos.close ();
        } catch (Error e) {
            stderr.printf ("Error saving advanced mode state: %s\n", e.message);
        }
    }
}

}
