using Gtk;
using Gee;

public class OtherSave {

    public static void save_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("vkBasalt");
        var file = config_dir.get_child ("vkBasalt.conf");

        if (!config_dir.query_exists ()) {
            stdout.printf ("Config directory does not exist. Creating...\n");
            try {
                config_dir.make_directory_with_parents (); // Создаем директорию, если ее нет
            } catch (Error e) {
                stderr.printf ("Error creating config directory: %s\n", e.message);
                return;
            }
        }

        try {
            var lines = new ArrayList<string> ();
            if (file.query_exists ()) {
                var file_stream = new DataInputStream (file.read ());
                string line;
                while ((line = file_stream.read_line ()) != null) {
                    if (!line.has_prefix ("casSharpness=")) {
                        lines.add (line);
                    }
                }
            }

            lines.add ("casSharpness=%.2f".printf (other_box.cas_scale.get_value ()).replace (",", "."));

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