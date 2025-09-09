/* OtherSave.vala // Licence:  GPL-v3.0 */
using Gtk;
using Gee;

public class OtherSave {

    public static void save_states (OtherBox other_box) {
        var config_dir = File.new_for_path (Environment.get_home_dir ())
                             .get_child (".config")
                             .get_child ("vkBasalt");
        var config_file = config_dir.get_child ("vkBasalt.conf");

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
            file_stream_write = new DataOutputStream (config_file.replace (null, false, FileCreateFlags.NONE));

            string hotkey = other_box.hotkey_entry.get_text ().strip ();
            if (hotkey != "" && hotkey != "Home") {
                file_stream_write.put_string ("toggleKey=%s\n".printf (hotkey));
            }

            save_scale_value_if_active (file_stream_write, "casSharpness", other_box.scales[0], other_box.entries[0], "%.2f", other_box, "cas");
            save_scale_value_if_active (file_stream_write, "dlsSharpness", other_box.scales[1], other_box.entries[1], "%.2f", other_box, "dls");
            save_scale_value_if_active (file_stream_write, "dlsDenoise", other_box.scales[2], other_box.entries[2], "%.2f", other_box, "dls");
            save_scale_value_if_active (file_stream_write, "fxaaQualitySubpix", other_box.scales[3], other_box.entries[3], "%.2f", other_box, "fxaa");
            save_scale_value_if_active (file_stream_write, "fxaaEdgeThreshold", other_box.scales[4], other_box.entries[4], "%.3f", other_box, "fxaa");
            save_scale_value_if_active (file_stream_write, "fxaaEdgeThresholdMin", other_box.scales[5], other_box.entries[5], "%.4f", other_box, "fxaa");
            save_scale_value_if_active (file_stream_write, "smaaThreshold", other_box.scales[6], other_box.entries[6], "%.2f", other_box, "smaa");
            save_int_scale_value_if_active (file_stream_write, "smaaMaxSearchSteps", other_box.scales[7], other_box.entries[7], other_box, "smaa");
            save_int_scale_value_if_active (file_stream_write, "smaaMaxSearchStepsDiag", other_box.scales[8], other_box.entries[8], other_box, "smaa");
            save_int_scale_value_if_active (file_stream_write, "smaaCornerRounding", other_box.scales[9], other_box.entries[9], other_box, "smaa");

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

            if (other_box.reshade_texture_path != null && other_box.reshade_include_path != null) {
                string folders_path = other_box.reshade_include_path.replace("/shaders", "");
                file_stream_write.put_string ("#reshadeFoldersPath = %s\n".printf(folders_path));
                file_stream_write.put_string ("reshadeTexturePath = %s\n".printf(other_box.reshade_texture_path));
                file_stream_write.put_string ("reshadeIncludePath = %s\n".printf(other_box.reshade_include_path));
                
                foreach (string shader in other_box.reshade_shaders) {
                    file_stream_write.put_string ("%s = %s/shaders/%s.fx #effects\n".printf(shader, 
                        folders_path, shader));
                }
                
                if (other_box.reshade_shaders.size > 0) {
                    string switch_line = "# Switch = ";
                    bool first = true;
                    foreach (string shader in other_box.reshade_shaders) {
                        if (!first) {
                            switch_line += ", ";
                        }
                        switch_line += shader;
                        first = false;
                    }
                    file_stream_write.put_string (switch_line + "\n");
                }
            }

        } catch (Error e) {
            stderr.printf ("Ошибка при записи в файл: %s\n", e.message);
        } finally {
            if (file_stream_write != null) {
                try {
                    file_stream_write.close ();
                } catch (Error e) {
                    stderr.printf ("Ошибка при закрытии файла: %s\n", e.message);
                }
            }
        }
    }

    // Вспомогательный метод для сохранения дробных значений, если Scale активен
    private static void save_scale_value_if_active (DataOutputStream file_stream_write, string key, Scale scale, Entry entry, string format, OtherBox other_box, string switch_name) throws Error {
        if (other_box.is_scale_active (scale, switch_name)) {
            double value = scale.get_value ();
            string line = "%s=%s\n".printf (key, format.printf (value).replace (",", "."));
            file_stream_write.put_string (line);
        }
    }

    // Вспомогательный метод для сохранения целочисленных значений, если Scale активен
    private static void save_int_scale_value_if_active (DataOutputStream file_stream_write, string key, Scale scale, Entry entry, OtherBox other_box, string switch_name) throws Error {
        if (other_box.is_scale_active (scale, switch_name)) {
            int value = (int) scale.get_value ();
            string line = "%s=%d\n".printf (key, value);
            file_stream_write.put_string (line);
        }
    }
}