using Gtk;

public class OtherLoad {

    public static void load_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("vkBasalt");
        var file = config_dir.get_child ("vkBasalt.conf");

        if (!config_dir.query_exists ()) {
            stdout.printf ("Config directory does not exist. Creating...\n");
            try {
                config_dir.make_directory_with_parents ();
            } catch (Error e) {
                stderr.printf ("Error creating config directory: %s\n", e.message);
                return;
            }
        }

        if (!file.query_exists ()) {
            stdout.printf ("Config file does not exist. Skipping load.\n");
            return;
        }

        try {
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("casSharpness=")) {
                    string value_str = line.split ("=")[1].replace (",", ".");
                    double value = double.parse (value_str);
                    if (other_box.cas_scale != null) {
                        other_box.cas_scale.set_value (value);
                        other_box.cas_value_label.label = "%.2f".printf (value).replace (",", ".");
                    } else {
                        stderr.printf ("Error: cas_scale is null\n");
                    }
                }
            }
        } catch (Error e) {
            stderr.printf ("Error reading the file: %s\n", e.message);
        }
    }
}