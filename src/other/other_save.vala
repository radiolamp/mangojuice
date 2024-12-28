using Gtk;

public class OtherSave {

    public static void save_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("vkBasalt");
        var file = config_dir.get_child ("vkBasalt.conf");

        // Проверяем, существует ли директория
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
            var lines = new Gee.ArrayList<string> ();

            // Если файл существует, читаем его содержимое
            if (file.query_exists ()) {
                var file_stream = new DataInputStream (file.read ());
                string line;
                while ((line = file_stream.read_line ()) != null) {
                    if (!line.has_prefix ("casSharpness=") && !line.has_prefix ("effects = ")) {
                        lines.add (line); // Сохраняем все строки, кроме casSharpness и effects
                    }
                }
                file_stream.close (); // Закрываем поток чтения
            }

            // Если значение cas_scale не равно 0, добавляем его в файл
            double casSharpness = other_box.cas_scale.get_value ();
            if (casSharpness != 0) {
                lines.add ("casSharpness=%.2f".printf (casSharpness).replace (",", "."));
            }

            // Если переключатель включен, добавляем effects = cas
            if (other_box.cas_switch.get_active ()) {
                lines.add ("effects = cas");
            }

            // Записываем обновленные строки в файл
            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();

            stdout.printf ("Config file saved successfully.\n"); // Логируем успешное сохранение

        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }
}