using Gtk;

public class OtherLoad {

    public static void load_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("vkBasalt");
        var file = config_dir.get_child ("vkBasalt.conf");

        // Проверяем, существует ли директория
        if (!config_dir.query_exists ()) {
            stdout.printf ("Config directory does not exist. Skipping load.\n");
            return;
        }

        // Проверяем, существует ли файл
        if (!file.query_exists ()) {
            stdout.printf ("Config file does not exist. Skipping load.\n");
            return;
        }

        // Чтение файла
        try {
            var file_stream = new DataInputStream (file.read ());
            string line;
            bool casSharpnessFound = false;
            bool effectsCasFound = false;

            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("casSharpness=")) {
                    // Парсим значение для cas_scale
                    string value_str = line.split ("=")[1].replace (",", "."); // Заменяем запятую на точку
                    double value = double.parse (value_str);
                    if (other_box.cas_scale != null) {
                        other_box.cas_scale.set_value (value); // Устанавливаем значение Scale
                        other_box.cas_value_label.label = "%.2f".printf (value).replace (",", "."); // Обновляем метку
                        stdout.printf ("Loaded casSharpness: %.2f\n", value);
                    } else {
                        stderr.printf ("Error: cas_scale is null\n");
                    }
                    casSharpnessFound = true;
                } else if (line.has_prefix ("effects = cas")) {
                    // Устанавливаем состояние переключателя
                    if (other_box.cas_switch != null) {
                        other_box.cas_switch.set_active (true);
                        stdout.printf ("Loaded effects = cas\n");
                    } else {
                        stderr.printf ("Error: cas_switch is null\n");
                    }
                    effectsCasFound = true;
                }
            }

            // Если casSharpness не найден, устанавливаем значение по умолчанию (0)
            if (!casSharpnessFound && other_box.cas_scale != null) {
                other_box.cas_scale.set_value (0);
                other_box.cas_value_label.label = "0.00";
            }

            // Если effects = cas не найден, устанавливаем состояние переключателя по умолчанию (выключено)
            if (!effectsCasFound && other_box.cas_switch != null) {
                other_box.cas_switch.set_active (false);
            }
        } catch (Error e) {
            stderr.printf ("Error reading the file: %s\n", e.message);
        }
    }
}