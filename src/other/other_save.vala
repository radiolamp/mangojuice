using Gtk;
using Gee;

public class OtherSave {

    public static void save_states (OtherBox other_box) {
        // Определяем путь к директории конфигурации
        var config_dir = File.new_for_path (Environment.get_home_dir ())
                             .get_child (".config")
                             .get_child ("vkBasalt");
        var config_file = config_dir.get_child ("vkBasalt.conf");

        // Проверяем, существует ли директория, и создаем ее, если нет
        if (!config_dir.query_exists ()) {
            try {
                config_dir.make_directory_with_parents ();
            } catch (Error e) {
                stderr.printf ("Ошибка при создании директории: %s\n", e.message);
                return;
            }
        }

        DataOutputStream file_stream_write = null;
        try {
            // Открываем файл для записи (создаем новый, если он уже существует)
            file_stream_write = new DataOutputStream (config_file.replace (null, false, FileCreateFlags.NONE));

            // Сохраняем значение CAS Sharpness
            double casSharpness = other_box.cas_scale.get_value ();
            string casSharpness_line = "casSharpness=%.2f\n".printf (casSharpness).replace (",", ".");
            file_stream_write.put_string (casSharpness_line);

            // Сохраняем значение DLS Sharpness
            double dlsSharpness = other_box.dls_sharpness_scale.get_value ();
            string dlsSharpness_line = "dlsSharpness=%.2f\n".printf (dlsSharpness).replace (",", ".");
            file_stream_write.put_string (dlsSharpness_line);

            // Сохраняем значение DLS Denoise
            double dlsDenoise = other_box.dls_denoise_scale.get_value ();
            string dlsDenoise_line = "dlsDenoise=%.2f\n".printf (dlsDenoise).replace (",", ".");
            file_stream_write.put_string (dlsDenoise_line);

            // Сохраняем активные эффекты
            var active_effects = new Gee.ArrayList<string> ();
            string[] config_vars = { "cas", "dls", "fxaa", "smaa", "lut" };
            for (int i = 0; i < other_box.switches.size; i++) {
                if (other_box.switches[i].get_active ()) {
                    active_effects.add (config_vars[i]);
                }
            }

            if (!active_effects.is_empty) {
                string effects_line = "effects = " + string.joinv (":", (string[]) active_effects.to_array ()) + "\n";
                file_stream_write.put_string (effects_line);
            }

        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        } finally {
            // Закрываем поток записи
            if (file_stream_write != null) {
                try {
                    file_stream_write.close ();
                } catch (Error e) {
                    stderr.printf ("Ошибка при закрытии файла: %s\n", e.message);
                }
            }
        }
    }
}