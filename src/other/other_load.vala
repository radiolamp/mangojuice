using Gtk;
using Gee;

public class OtherLoad {

    // Вспомогательная функция для проверки наличия строки в массиве
    private static bool contains_string (string[] array, string target) {
        foreach (string item in array) {
            if (item == target) {
                return true;
            }
        }
        return false;
    }

    public static void load_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ())
                             .get_child (".config")
                             .get_child ("vkBasalt");
        var config_file = config_dir.get_child ("vkBasalt.conf");

        // Если директория или файл конфигурации не существуют, выходим
        if (!config_dir.query_exists () || !config_file.query_exists ()) {
            return;
        }

        try {
            var file_stream = new DataInputStream (config_file.read ());
            string line;
            bool casSharpnessFound = false;
            bool dlsSharpnessFound = false;
            bool dlsDenoiseFound = false;
            bool effectsFound = false;

            string[] config_vars = { "cas", "dls", "fxaa", "smaa", "lut" };

            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("casSharpness=")) {
                    string value_str = line.split ("=")[1].replace (",", ".");
                    double value = double.parse (value_str);
                    if (other_box.cas_scale != null) {
                        other_box.cas_scale.set_value (value);
                        if (other_box.cas_value_entry != null) {
                            other_box.cas_value_entry.set_text ("%.2f".printf (value).replace (",", "."));
                        }
                    }
                    casSharpnessFound = true;
                } else if (line.has_prefix ("dlsSharpness=")) {
                    string value_str = line.split ("=")[1].replace (",", ".");
                    double value = double.parse (value_str);
                    if (other_box.dls_sharpness_scale != null) {
                        other_box.dls_sharpness_scale.set_value (value);
                        if (other_box.dls_sharpness_entry != null) {
                            other_box.dls_sharpness_entry.set_text ("%.2f".printf (value).replace (",", "."));
                        }
                    }
                    dlsSharpnessFound = true;
                } else if (line.has_prefix ("dlsDenoise=")) {
                    string value_str = line.split ("=")[1].replace (",", ".");
                    double value = double.parse (value_str);
                    if (other_box.dls_denoise_scale != null) {
                        other_box.dls_denoise_scale.set_value (value);
                        if (other_box.dls_denoise_entry != null) {
                            other_box.dls_denoise_entry.set_text ("%.2f".printf (value).replace (",", "."));
                        }
                    }
                    dlsDenoiseFound = true;
                } else if (line.has_prefix ("effects = ")) {
                    string[] effects = line.split (" = ")[1].split (":");
                    for (int i = 0; i < other_box.switches.size; i++) {
                        if (contains_string (effects, config_vars[i])) {
                            if (i < other_box.switches.size) {
                                other_box.switches[i].set_active (true);
                            }
                        }
                    }
                    effectsFound = true;
                }
            }

            // Если значение CAS Sharpness не найдено, устанавливаем по умолчанию
            if (!casSharpnessFound && other_box.cas_scale != null) {
                other_box.cas_scale.set_value (0);
                if (other_box.cas_value_entry != null) {
                    other_box.cas_value_entry.set_text ("0.00");
                }
            }

            // Если значение DLS Sharpness не найдено, устанавливаем по умолчанию
            if (!dlsSharpnessFound && other_box.dls_sharpness_scale != null) {
                other_box.dls_sharpness_scale.set_value (0.5);
                if (other_box.dls_sharpness_entry != null) {
                    other_box.dls_sharpness_entry.set_text ("0.50");
                }
            }

            // Если значение DLS Denoise не найдено, устанавливаем по умолчанию
            if (!dlsDenoiseFound && other_box.dls_denoise_scale != null) {
                other_box.dls_denoise_scale.set_value (0.17);
                if (other_box.dls_denoise_entry != null) {
                    other_box.dls_denoise_entry.set_text ("0.17");
                }
            }

            // Если эффекты не найдены, отключаем все переключатели
            if (!effectsFound) {
                for (int i = 0; i < other_box.switches.size; i++) {
                    other_box.switches[i].set_active (false);
                }
            }
        } catch (Error e) {
            stderr.printf ("Ошибка при чтении файла: %s\n", e.message);
        }
    }
}