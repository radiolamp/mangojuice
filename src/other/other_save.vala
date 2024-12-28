using Gtk;
using Gee;

public class OtherSave {

    public static void save_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");

        try {
            var lines = new ArrayList<string> ();
            if (file.query_exists ()) {
                var file_stream = new DataInputStream (file.read ());
                string line;
                while ((line = file_stream.read_line ()) != null) {
                    if (!line.has_prefix ("other_option_1=") && !line.has_prefix ("other_option_2=") && !line.has_prefix ("other_option_3=")) {
                        lines.add (line);
                    }
                }
            }

            lines.add ("other_option_1=%s".printf (other_box.switches[0].active.to_string ()));
            lines.add ("other_option_2=%s".printf (other_box.switches[1].active.to_string ()));
            lines.add ("other_option_3=%s".printf (other_box.switches[2].active.to_string ()));

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }
}