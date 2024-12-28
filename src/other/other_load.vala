using Gtk;

public class OtherLoad {

    public static void load_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");

        if (file.query_exists ()) {
            try {
                var file_stream = new DataInputStream (file.read ());
                string line;
                while ((line = file_stream.read_line ()) != null) {
                    if (line.has_prefix ("other_option_1=")) {
                        other_box.switches[0].active = bool.parse (line.split ("=")[1]);
                    } else if (line.has_prefix ("other_option_2=")) {
                        other_box.switches[1].active = bool.parse (line.split ("=")[1]);
                    } else if (line.has_prefix ("other_option_3=")) {
                        other_box.switches[2].active = bool.parse (line.split ("=")[1]);
                    }
                }
            } catch (Error e) {
                stderr.printf ("Error reading the file: %s\n", e.message);
            }
        }
    }
}