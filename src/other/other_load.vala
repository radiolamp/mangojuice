using Gtk;
using Gee;

public class OtherLoad {

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

        // Если директория или файл конфигурации не существуют, создаем их с настройками по умолчанию
        if (!config_dir.query_exists () || !config_file.query_exists ()) {
            create_default_config (config_dir, config_file);
        }

        try {
            var file_stream = new DataInputStream (config_file.read ());
            string line;
            bool[] found = new bool[10]; // Массив для отслеживания найденных параметров
            bool effectsFound = false;

            string[] config_vars = { "cas", "dls", "fxaa", "smaa", "lut" };

            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("casSharpness=")) {
                    load_scale_value (line, other_box.scales[0], other_box.entries[0], "%.2f");
                    found[0] = true;
                } else if (line.has_prefix ("dlsSharpness=")) {
                    load_scale_value (line, other_box.scales[1], other_box.entries[1], "%.2f");
                    found[1] = true;
                } else if (line.has_prefix ("dlsDenoise=")) {
                    load_scale_value (line, other_box.scales[2], other_box.entries[2], "%.2f");
                    found[2] = true;
                } else if (line.has_prefix ("fxaaQualitySubpix=")) {
                    load_scale_value (line, other_box.scales[3], other_box.entries[3], "%.2f");
                    found[3] = true;
                } else if (line.has_prefix ("fxaaEdgeThreshold=")) {
                    load_scale_value (line, other_box.scales[4], other_box.entries[4], "%.3f");
                    found[4] = true;
                } else if (line.has_prefix ("fxaaEdgeThresholdMin=")) {
                    load_scale_value (line, other_box.scales[5], other_box.entries[5], "%.4f");
                    found[5] = true;
                } else if (line.has_prefix ("smaaThreshold=")) {
                    load_scale_value (line, other_box.scales[6], other_box.entries[6], "%.2f");
                    found[6] = true;
                } else if (line.has_prefix ("smaaMaxSearchSteps=")) {
                    load_int_scale_value (line, other_box.scales[7], other_box.entries[7]);
                    found[7] = true;
                } else if (line.has_prefix ("smaaMaxSearchStepsDiag=")) {
                    load_int_scale_value (line, other_box.scales[8], other_box.entries[8]);
                    found[8] = true;
                } else if (line.has_prefix ("smaaCornerRounding=")) {
                    load_int_scale_value (line, other_box.scales[9], other_box.entries[9]);
                    found[9] = true;
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

            // Устанавливаем значения по умолчанию, если параметры не найдены
            if (!found[0]) set_default_scale_value (other_box.scales[0], other_box.entries[0], 0, "%.2f");
            if (!found[1]) set_default_scale_value (other_box.scales[1], other_box.entries[1], 0, "%.2f");
            if (!found[2]) set_default_scale_value (other_box.scales[2], other_box.entries[2], 0, "%.2f");
            if (!found[3]) set_default_scale_value (other_box.scales[3], other_box.entries[3], 0.75, "%.2f");
            if (!found[4]) set_default_scale_value (other_box.scales[4], other_box.entries[4], 0.125, "%.3f");
            if (!found[5]) set_default_scale_value (other_box.scales[5], other_box.entries[5], 0.0833, "%.4f");
            if (!found[6]) set_default_scale_value (other_box.scales[6], other_box.entries[6], 0.05, "%.2f");
            if (!found[7]) set_default_int_scale_value (other_box.scales[7], other_box.entries[7], 8);
            if (!found[8]) set_default_int_scale_value (other_box.scales[8], other_box.entries[8], 0);
            if (!found[9]) set_default_int_scale_value (other_box.scales[9], other_box.entries[9], 25);

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

    // Метод для создания конфигурационного файла с настройками по умолчанию
    private static void create_default_config (File config_dir, File config_file) {
        try {
            // Создаем директорию, если она не существует
            if (!config_dir.query_exists ()) {
                config_dir.make_directory_with_parents ();
            }

            // Создаем файл и записываем настройки по умолчанию
            var file_stream = new DataOutputStream (config_file.create (FileCreateFlags.REPLACE_DESTINATION));

            // Записываем значения по умолчанию
            file_stream.put_string ("# Config Generated by MangoJuice #\n");
            file_stream.put_string ("casSharpness=0.00\n");
            file_stream.put_string ("dlsSharpness=0.50\n");
            file_stream.put_string ("dlsDenoise=0.17\n");
            file_stream.put_string ("fxaaQualitySubpix=0.75\n");
            file_stream.put_string ("fxaaEdgeThreshold=0.125\n");
            file_stream.put_string ("fxaaEdgeThresholdMin=0.0000\n");
            file_stream.put_string ("smaaThreshold=0.05\n");
            file_stream.put_string ("smaaMaxSearchSteps=8\n");
            file_stream.put_string ("smaaMaxSearchStepsDiag=0\n");
            file_stream.put_string ("smaaCornerRounding=25\n");

            file_stream.close ();
        } catch (Error e) {
            stderr.printf ("Ошибка при создании конфигурационного файла: %s\n", e.message);
        }
    }

    // Вспомогательный метод для загрузки дробных значений
    private static void load_scale_value (string line, Scale scale, Entry entry, string format) {
        string value_str = line.split ("=")[1].replace (",", ".");
        double value = double.parse (value_str);
        if (scale != null) {
            scale.set_value (value);
            if (entry != null) {
                entry.set_text (format.printf (value).replace (",", "."));
            }
        }
    }

    // Вспомогательный метод для загрузки целочисленных значений
    private static void load_int_scale_value (string line, Scale scale, Entry entry) {
        string value_str = line.split ("=")[1].replace (",", ".");
        // Убираем дробную часть, если она есть
        if (value_str.contains (".")) {
            value_str = value_str.split (".")[0];
        }
        int value = int.parse (value_str);
        if (scale != null) {
            scale.set_value (value);
            if (entry != null) {
                entry.set_text ("%d".printf (value));
            }
        }
    }

    // Вспомогательный метод для установки значений по умолчанию для дробных значений
    private static void set_default_scale_value (Scale scale, Entry entry, double default_value, string format) {
        if (scale != null) {
            scale.set_value (default_value);
            if (entry != null) {
                entry.set_text (format.printf (default_value).replace (",", "."));
            }
        }
    }

    // Вспомогательный метод для установки значений по умолчанию для целочисленных значений
    private static void set_default_int_scale_value (Scale scale, Entry entry, int default_value) {
        if (scale != null) {
            scale.set_value (default_value);
            if (entry != null) {
                entry.set_text ("%d".printf (default_value));
            }
        }
    }
}