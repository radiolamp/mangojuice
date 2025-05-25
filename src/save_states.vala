/* save_states.vala // Licence:  GPL-v3.0 */
using Gtk;
using Gee;

public class SaveStates {
    public static void update_parameter (DataOutputStream data_stream, string parameter_name, string parameter_value) throws Error {
        if (
          parameter_value == "" ||
          (parameter_name  == "round_corners"       && parameter_value == "0")   ||
          (parameter_name  == "font_size"           && parameter_value == "24")  ||
          (parameter_name  == "log_duration"        && parameter_value == "30")  ||
          (parameter_name  == "log_interval"        && parameter_value == "100") ||
          (parameter_name  == "table_columns"       && parameter_value == "3")   ||
          (parameter_name  == "fps_sampling_period" && parameter_value == "500") ||
          (parameter_name  == "offset_x"            && parameter_value == "0")   ||
          (parameter_name  == "offset_y"            && parameter_value == "0")   
        ) {
            return;
        }
        data_stream.put_string ("%s=%s\n".printf (parameter_name, parameter_value));
    }

    public static void update_pci_dev_in_file (string pci_dev_value) {
        update_file ("pci_dev=", pci_dev_value);
    }

    public static void update_fps_limit_in_file (string fps_limit_1, string fps_limit_2, string fps_limit_3) {
        update_file ("fps_limit=", "%s,%s,%s".printf (fps_limit_1, fps_limit_2, fps_limit_3));
    }

    public static void update_fps_sampling_period_in_file (string fps_sampling_period_value) {
        update_file ("fps_sampling_period=", fps_sampling_period_value);
    }

    public static void update_logs_key_in_file (string logs_key) {
        update_file ("toggle_logging=", logs_key);
    }

    public static void update_toggle_hud_key_in_file (string toggle_hud_position) {
        update_file ("toggle_hud_position=", toggle_hud_position);
    }

    public static void update_blacklist_in_file (string blacklist_value) {
        update_file ("blacklist=", blacklist_value);
    }

    public static void update_gpu_in_file (string gpu_value) {
        update_file ("gpu_list=", gpu_value);
    }

    public static void update_position_in_file (string position_value) {
        update_file ("position=", position_value);
    }

    public static void update_toggle_hud_in_file (string toggle_hud_value) {
        update_file ("toggle_hud=", toggle_hud_value);
    }

    public static void update_offset_x_in_file (string offset_x_value) {
        update_file ("offset_x=", offset_x_value);
    }

    public static void update_offset_y_in_file (string offset_y_value) {
        update_file ("offset_y=", offset_y_value);
    }

    public static void update_gpu_color_in_file (string gpu_color) {
        update_file ("gpu_color=", gpu_color);
    }

    public static void update_cpu_color_in_file (string cpu_color) {
        update_file ("cpu_color=", cpu_color);
    }

    public static void update_gpu_text_in_file (string gpu_text) {
        update_file ("gpu_text=", gpu_text);
    }

    public static void update_cpu_text_in_file (string cpu_text) {
        update_file ("cpu_text=", cpu_text);
    }

    public static void update_fps_value_in_file (string fps_value_1, string fps_value_2) {
        if ( fps_value_1 == "" || fps_value_2 == "") {
            return;
        }
        update_file ("fps_value=", "%s,%s".printf (fps_value_1, fps_value_2));
    }

    public static void update_fps_color_in_file (string fps_color_1, string fps_color_2, string fps_color_3) {
        update_file ("fps_color=", "%s,%s,%s".printf (fps_color_1, fps_color_2, fps_color_3));
    }

    public static void update_gpu_load_value_in_file(string gpu_load_value_1, string gpu_load_value_2) {
        if (gpu_load_value_1 == "" || gpu_load_value_2 == "") {
            return;
        }
        update_file ("gpu_load_value=", "%s,%s".printf(gpu_load_value_1, gpu_load_value_2));
    }

    public static void update_gpu_load_color_in_file (string gpu_load_color_1, string gpu_load_color_2, string gpu_load_color_3) {
        update_file ("gpu_load_color=", "%s,%s,%s".printf (gpu_load_color_1, gpu_load_color_2, gpu_load_color_3));
    }

    public static void update_font_file_in_file (string font_path) {
        update_file ("font_file=", font_path);
    }

    public static void update_cpu_load_value_in_file(string cpu_load_value_1, string cpu_load_value_2) {
        if (cpu_load_value_1 == "" || cpu_load_value_2 == "") {
            return;
        }
        update_file ("cpu_load_value=", "%s,%s".printf(cpu_load_value_1, cpu_load_value_2));
    }

    public static void update_cpu_load_color_in_file (string cpu_load_color_1, string cpu_load_color_2, string cpu_load_color_3) {
        update_file ("cpu_load_color=", "%s,%s,%s".printf (cpu_load_color_1, cpu_load_color_2, cpu_load_color_3));
    }

    public static void update_background_color_in_file (string background_color) {
        update_file ("background_color=", background_color);
    }

    public static void update_frametime_color_in_file (string frametime_color) {
        update_file ("frametime_color=", frametime_color);
    }

    public static void update_vram_color_in_file (string vram_color) {
        update_file ("vram_color=", vram_color);
    }

    public static void update_ram_color_in_file (string ram_color) {
        update_file ("ram_color=", ram_color);
    }

    public static void update_wine_color_in_file (string wine_color) {
        update_file ("wine_color=", wine_color);
    }

    public static void update_engine_color_in_file (string engine_color) {
        update_file ("engine_color=", engine_color);
    }

    public static void update_text_color_in_file (string text_color) {
        update_file ("text_color=", text_color);
    }

    public static void update_media_player_color_in_file (string media_player_color) {
        update_file ("media_player_color=", media_player_color);
    }

    public static void update_network_color_in_file (string network_color) {
        update_file ("network_color=", network_color);
    }

    public static void update_battery_color_in_file (string battery_color) {
        update_file ("battery_color=", battery_color);
    }

    public static void update_media_player_format_in_file (string format_value) {
        update_file ("media_player_format=", format_value);
    }

    static void update_file (string prefix, string value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix (prefix)) {
                    line = "%s%s".printf (prefix, value);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public static void save_states_to_file (MangoJuice mango_juice) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        bool is_horizontal = mango_juice.custom_switch.active;

        try {
            if (!config_dir.query_exists ()) {
                config_dir.make_directory_with_parents ();
            }

            var data_stream = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            data_stream.put_string ("# Config Generated by MangoJuice #\n");
            data_stream.put_string ("legacy_layout=false\n");

            update_parameter (data_stream, "blacklist", mango_juice.blacklist_entry.text);

            update_parameter (data_stream, "gpu_list", mango_juice.gpu_entry.text);

            if (mango_juice.gpu_dropdown.selected_item != null) {
                var selected_pci_address = (mango_juice.gpu_dropdown.selected_item as StringObject)?.get_string () ?? "";
                if (selected_pci_address != _("All video cards")) {
                    data_stream.put_string ("pci_dev=%s\n".printf (selected_pci_address));
                }
            }

            var custom_command = mango_juice.custom_command_entry.text;
            if (custom_command != "") {
                data_stream.put_string ("%s #custom_command\n".printf (custom_command));
            }

            if (mango_juice.offset_x_scale != null) {
                update_parameter (data_stream, "offset_x", ((int)mango_juice.offset_x_scale.get_value ()).to_string ());
            }

            if (mango_juice.offset_y_scale != null) {
                update_parameter (data_stream, "offset_y", ((int)mango_juice.offset_y_scale.get_value ()).to_string ());
            }

            if (is_horizontal) {
                update_parameter (data_stream, "custom_text", mango_juice.custom_text_center_entry.text);
            } else {
                update_parameter (data_stream, "custom_text_center", mango_juice.custom_text_center_entry.text);
            }

            var order_map = new HashMap<string, ArrayList<int>> ();

            var inform_start = new ArrayList<int> ();
            for (int i = 0; i < 5; i++) {
                inform_start.add (i);
            }
            order_map.set ("inform_start", inform_start);

            var inform_end = new ArrayList<int> ();
            inform_end.add (11);
            for (int i = 5; i < 11; i++) {
                inform_end.add (i);
            }
            order_map.set ("inform_end", inform_end);

            var gpu_start = new ArrayList<int> ();
            gpu_start.add (0);
            gpu_start.add (1);
            gpu_start.add (2);
            gpu_start.add (3);
            gpu_start.add (4);
            gpu_start.add (5);
            gpu_start.add (6);
            gpu_start.add (7);
            gpu_start.add (8);
            gpu_start.add (10);
            gpu_start.add (11);
            gpu_start.add (12);
            gpu_start.add (13);
            order_map.set ("gpu_start", gpu_start);

            var gpu_end = new ArrayList<int> ();
            gpu_end.add (9);
            gpu_end.add (14);
            order_map.set ("gpu_end", gpu_end);

            var system_start = new ArrayList<int> ();
            system_start.add (0);
            system_start.add (1);
            system_start.add (2);
            system_start.add (3);
            system_start.add (4);
            system_start.add (6);
            order_map.set ("system_start", system_start);

            var system_end = new ArrayList<int> ();
            system_end.add (7);
            system_end.add (5);
            order_map.set ("system_end", system_end);

            save_switches_to_file (data_stream, mango_juice.gpu_switches, mango_juice.gpu_config_vars, (int[]) order_map.get ("gpu_start").to_array ());

            int[] cpu_order = {0, 1, 2, 3, 4, 5, 6, 7, 8};
            save_switches_to_file (data_stream, mango_juice.cpu_switches, mango_juice.cpu_config_vars, cpu_order);

            int[] memory_order = {0, 1, 2, 3};
            save_switches_to_file (data_stream, mango_juice.memory_switches, mango_juice.memory_config_vars, memory_order);

            if (Config.IS_DEVEL) {
            int[] git_order = {0, 1, 2};
            save_switches_to_file (data_stream, mango_juice.git_switches, mango_juice.git_config_vars, git_order);
            }

            save_switches_to_file (data_stream, mango_juice.inform_switches, mango_juice.inform_config_vars, (int[]) order_map.get ("inform_start").to_array ());

            save_switches_to_file (data_stream, mango_juice.system_switches, mango_juice.system_config_vars, (int[]) order_map.get ("system_end").to_array ());

            int[] options_order = {0 ,1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10, 11};
            save_switches_to_file (data_stream, mango_juice.options_switches, mango_juice.options_config_vars, options_order);

            save_switches_to_file (data_stream, mango_juice.gpu_switches, mango_juice.gpu_config_vars, (int[]) order_map.get ("gpu_end").to_array ());

            save_switches_to_file (data_stream, mango_juice.system_switches, mango_juice.system_config_vars, (int[]) order_map.get ("system_start").to_array ());

            save_switches_to_file (data_stream, mango_juice.inform_switches, mango_juice.inform_config_vars, (int[]) order_map.get ("inform_end").to_array ());

            int[] battery_order = {0, 1, 2, 3, 4, 5};
            save_switches_to_file (data_stream, mango_juice.battery_switches, mango_juice.battery_config_vars, battery_order);

            int[] other_extra_order = {1, 2, 0, 3};
            save_switches_to_file (data_stream, mango_juice.other_extra_switches, mango_juice.other_extra_config_vars, other_extra_order);

            int[] wine_order = {0, 1};
            save_switches_to_file (data_stream, mango_juice.wine_switches, mango_juice.wine_config_vars, wine_order);

            if (mango_juice.logs_key_combo.selected_item != null) {
                var logs_key = (mango_juice.logs_key_combo.selected_item as StringObject)?.get_string () ?? "";
                update_parameter (data_stream, "toggle_logging", logs_key);
            }

            if (mango_juice.toggle_hud_key_combo.selected_item != null) {
                var toggle_hud_position = (mango_juice.toggle_hud_key_combo.selected_item as StringObject)?.get_string () ?? "";
                update_parameter (data_stream, "toggle_hud_position", toggle_hud_position);
            }

            if (mango_juice.duracion_scale != null && (int)mango_juice.duracion_scale.get_value () != 0) {
                update_parameter (data_stream, "log_duration", ((int)mango_juice.duracion_scale.get_value ()).to_string ());
            }

            if (mango_juice.autostart_scale != null && (int)mango_juice.autostart_scale.get_value () != 0) {
                update_parameter (data_stream, "autostart_log", ((int)mango_juice.autostart_scale.get_value ()).to_string ());
            }

            if (mango_juice.interval_scale != null && (int)mango_juice.interval_scale.get_value () != 0) {
                update_parameter (data_stream, "log_interval", ((int)mango_juice.interval_scale.get_value ()).to_string ());
            }

            update_parameter (data_stream, "output_folder", mango_juice.custom_logs_path_entry.text);

            if (mango_juice.fps_limit_method.selected_item != null) {
                var fps_limit_method_value = (mango_juice.fps_limit_method.selected_item as StringObject)?.get_string () ?? "";
                update_parameter (data_stream, "fps_limit_method", fps_limit_method_value);
            }

            if (mango_juice.toggle_fps_limit.selected_item != null) {
                var toggle_fps_limit_value = (mango_juice.toggle_fps_limit.selected_item as StringObject)?.get_string () ?? "";
                update_parameter (data_stream, "toggle_fps_limit", toggle_fps_limit_value);
            }

            var fps_limit_1 = mango_juice.fps_limit_entry_1.text;
            var fps_limit_2 = mango_juice.fps_limit_entry_2.text;
            var fps_limit_3 = mango_juice.fps_limit_entry_3.text;
            if (fps_limit_1 != "" || fps_limit_2 != "" || fps_limit_3 != "") {
                update_parameter (data_stream, "fps_limit", "%s,%s,%s".printf (fps_limit_1, fps_limit_2, fps_limit_3));
            }

            if (mango_juice.vulkan_dropdown.selected_item != null) {
                var vulkan_value = (mango_juice.vulkan_dropdown.selected_item as StringObject)?.get_string () ?? "";
                var vulkan_config_value = mango_juice.get_vulkan_config_value (vulkan_value);
                update_parameter (data_stream, "vsync", vulkan_config_value);
            }

            if (mango_juice.opengl_dropdown.selected_item != null) {
                var opengl_value = (mango_juice.opengl_dropdown.selected_item as StringObject)?.get_string () ?? "";
                var opengl_config_value = mango_juice.get_opengl_config_value (opengl_value);
                update_parameter (data_stream, "gl_vsync", opengl_config_value);
            }

            if (mango_juice.filter_dropdown.selected_item != null) {
                var filter_value = (mango_juice.filter_dropdown.selected_item as StringObject)?.get_string () ?? "";
                if (filter_value != "none") {
                    data_stream.put_string ("%s #filters\n".printf (filter_value));
                }
            }

            if (mango_juice.af != null && (int)mango_juice.af.get_value () != 0) {
                update_parameter (data_stream, "af", ((int)mango_juice.af.get_value ()).to_string ());
            }

            if (mango_juice.picmip != null && (int)mango_juice.picmip.get_value () != 0) {
                update_parameter (data_stream, "picmip", ((int)mango_juice.picmip.get_value ()).to_string ());
            }

            if (mango_juice.custom_switch.active) {
                try {
                    data_stream.put_string ("horizontal\nhorizontal_stretch=0\n");
                } catch (Error e) {
                    stderr.printf ("Error writing to the file: %s\n", e.message);
                }
            }

            if (mango_juice.borders_scale != null) {
                update_parameter (data_stream, "round_corners", ((int)mango_juice.borders_scale.get_value ()).to_string ());
            }

            if (mango_juice.alpha_scale != null) {
                double alpha_value = mango_juice.alpha_scale.get_value () / 100.0;
                string alpha_value_str = "%.1f".printf (alpha_value).replace (",", ".");
                update_parameter (data_stream, "background_alpha", alpha_value_str);
            }

            if (mango_juice.position_dropdown.selected_item != null) {
                var position_value = (mango_juice.position_dropdown.selected_item as StringObject)?.get_string () ?? "";
                update_parameter (data_stream, "position", position_value);
            }

            if (mango_juice.colums_scale != null) {
                update_parameter (data_stream, "table_columns", ((int)mango_juice.colums_scale.get_value ()).to_string ());
            }

            update_parameter (data_stream, "toggle_hud", mango_juice.toggle_hud_entry.text);

            if (mango_juice.font_size_scale != null) {
                update_parameter (data_stream, "font_size", ((int)mango_juice.font_size_scale.get_value ()).to_string ());
            }

            if (mango_juice.font_button != null) {
                var font_name = mango_juice.font_button.label;
                if (font_name != _("Default") && font_name != _("Select Font")) {
                    var font_path = mango_juice.find_font_path_by_name(font_name, mango_juice.find_fonts());
                    if (font_path != "") {
                        update_parameter(data_stream, "font_file", font_path);
                        data_stream.put_string("font_glyph_ranges=korean, chinese, chinese_simplified, japanese, cyrillic, thai, vietnamese, latin_ext_a, latin_ext_b\n");
                    }
                }
            }

            if (mango_juice.fps_sampling_period_scale != null) {
                update_parameter (data_stream, "fps_sampling_period", ((int)mango_juice.fps_sampling_period_scale.get_value ()).to_string ());
            }

            update_parameter (data_stream, "gpu_text", mango_juice.gpu_text_entry.text);

            if (mango_juice.gpu_color_button != null) {
                var gpu_color = mango_juice.rgba_to_hex (mango_juice.gpu_color_button.get_rgba ());
                update_parameter (data_stream, "gpu_color", gpu_color);
            }

            update_parameter (data_stream, "cpu_text", mango_juice.cpu_text_entry.text);

            if (mango_juice.cpu_color_button != null) {
                var cpu_color = mango_juice.rgba_to_hex (mango_juice.cpu_color_button.get_rgba ());
                update_parameter (data_stream, "cpu_color", cpu_color);
            }

            if (mango_juice.fps_value_entry_1 != null && mango_juice.fps_value_entry_2 != null) {
                var fps_value_1 = mango_juice.fps_value_entry_1.text;
                var fps_value_2 = mango_juice.fps_value_entry_2.text;
                if (fps_value_1 != "" && fps_value_2 != "") {
                    update_parameter (data_stream, "fps_value", "%s,%s".printf (fps_value_1, fps_value_2));
                }
            }

            if (mango_juice.fps_color_button_1 != null && mango_juice.fps_color_button_2 != null && mango_juice.fps_color_button_3 != null) {
                var fps_color_1 = mango_juice.rgba_to_hex (mango_juice.fps_color_button_1.get_rgba ());
                var fps_color_2 = mango_juice.rgba_to_hex (mango_juice.fps_color_button_2.get_rgba ());
                var fps_color_3 = mango_juice.rgba_to_hex (mango_juice.fps_color_button_3.get_rgba ());
                if (fps_color_1 != "" && fps_color_2 != "" && fps_color_3 != "") {
                    update_parameter (data_stream, "fps_color", "%s,%s,%s".printf (fps_color_1, fps_color_2, fps_color_3));
                }
            }

            if (mango_juice.gpu_load_value_entry_1 != null && mango_juice.gpu_load_value_entry_2 != null) {
                var gpu_load_value_1 = mango_juice.gpu_load_value_entry_1.text;
                var gpu_load_value_2 = mango_juice.gpu_load_value_entry_2.text;
                if (gpu_load_value_1 != "" && gpu_load_value_2 != "") {
                    update_parameter (data_stream, "gpu_load_value", "%s,%s".printf (gpu_load_value_1, gpu_load_value_2));
                }
            }

            if (mango_juice.gpu_load_color_button_1 != null && mango_juice.gpu_load_color_button_2 != null && mango_juice.gpu_load_color_button_3 != null) {
                var gpu_load_color_1 = mango_juice.rgba_to_hex (mango_juice.gpu_load_color_button_1.get_rgba ());
                var gpu_load_color_2 = mango_juice.rgba_to_hex (mango_juice.gpu_load_color_button_2.get_rgba ());
                var gpu_load_color_3 = mango_juice.rgba_to_hex (mango_juice.gpu_load_color_button_3.get_rgba ());
                if (gpu_load_color_1 != "" && gpu_load_color_2 != "" && gpu_load_color_3 != "") {
                    update_parameter (data_stream, "gpu_load_color", "%s,%s,%s".printf (gpu_load_color_1, gpu_load_color_2, gpu_load_color_3));
                }
            }

            if (mango_juice.cpu_load_value_entry_1 != null && mango_juice.cpu_load_value_entry_2 != null) {
                var cpu_load_value_1 = mango_juice.cpu_load_value_entry_1.text;
                var cpu_load_value_2 = mango_juice.cpu_load_value_entry_2.text;
                if (cpu_load_value_1 != "" && cpu_load_value_2 != "") {
                    update_parameter (data_stream, "cpu_load_value", "%s,%s".printf (cpu_load_value_1, cpu_load_value_2));
                }
            }

            if (mango_juice.cpu_load_color_button_1 != null && mango_juice.cpu_load_color_button_2 != null && mango_juice.cpu_load_color_button_3 != null) {
                var cpu_load_color_1 = mango_juice.rgba_to_hex (mango_juice.cpu_load_color_button_1.get_rgba ());
                var cpu_load_color_2 = mango_juice.rgba_to_hex (mango_juice.cpu_load_color_button_2.get_rgba ());
                var cpu_load_color_3 = mango_juice.rgba_to_hex (mango_juice.cpu_load_color_button_3.get_rgba ());
                if (cpu_load_color_1 != "" && cpu_load_color_2 != "" && cpu_load_color_3 != "") {
                    update_parameter (data_stream, "cpu_load_color", "%s,%s,%s".printf (cpu_load_color_1, cpu_load_color_2, cpu_load_color_3));
                }
            }

            if (mango_juice.background_color_button != null) {
                var background_color = mango_juice.rgba_to_hex (mango_juice.background_color_button.get_rgba ());
                update_parameter (data_stream, "background_color", background_color);
            }

            if (mango_juice.frametime_color_button != null) {
                var frametime_color = mango_juice.rgba_to_hex (mango_juice.frametime_color_button.get_rgba ());
                update_parameter (data_stream, "frametime_color", frametime_color);
            }

            if (mango_juice.vram_color_button != null) {
                var vram_color = mango_juice.rgba_to_hex (mango_juice.vram_color_button.get_rgba ());
                update_parameter (data_stream, "vram_color", vram_color);
            }

            if (mango_juice.ram_color_button != null) {
                var ram_color = mango_juice.rgba_to_hex (mango_juice.ram_color_button.get_rgba ());
                update_parameter (data_stream, "ram_color", ram_color);
            }

            if (mango_juice.wine_color_button != null) {
                var wine_color = mango_juice.rgba_to_hex (mango_juice.wine_color_button.get_rgba ());
                update_parameter (data_stream, "wine_color", wine_color);
            }

            if (mango_juice.engine_color_button != null) {
                var engine_color = mango_juice.rgba_to_hex (mango_juice.engine_color_button.get_rgba ());
                update_parameter (data_stream, "engine_color", engine_color);
            }

            if (mango_juice.text_color_button != null) {
                var text_color = mango_juice.rgba_to_hex (mango_juice.text_color_button.get_rgba ());
                update_parameter (data_stream, "text_color", text_color);
            }

            if (mango_juice.media_player_color_button != null) {
                var media_player_color = mango_juice.rgba_to_hex (mango_juice.media_player_color_button.get_rgba ());
                update_parameter (data_stream, "media_player_color", media_player_color);
            }

            if (mango_juice.network_color_button != null) {
                var network_color = mango_juice.rgba_to_hex (mango_juice.network_color_button.get_rgba ());
                update_parameter (data_stream, "network_color", network_color);
            }

            if (mango_juice.battery_color_button != null) {
                var battery_color = mango_juice.rgba_to_hex (mango_juice.battery_color_button.get_rgba ());
                update_parameter (data_stream, "battery_color", battery_color);
            }

            if (mango_juice.media_format_dropdowns != null) {
                var active_values = new Gee.ArrayList<string>();

                foreach (var dropdown in mango_juice.media_format_dropdowns) {
                    var selected_item = dropdown.selected_item as StringObject;
                    string? value = selected_item?.get_string();
                    if (value != null && value != "" && value != "none") {
                        active_values.add(value);
                    }
                }
                
                string media_format = "";
                if (active_values.size > 0) {
                    var sb = new StringBuilder();
                    sb.append("{");
                    bool first = true;
                    foreach (string val in active_values) {
                        if (!first) sb.append("};{");
                        sb.append(val);
                        first = false;
                    }
                    sb.append("}");
                    media_format = sb.str;
                }
                update_parameter(data_stream, "media_player_format", media_format);
            }

            data_stream.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    // Метод для сохранения состояний переключателей в файл
    public static void save_switches_to_file (DataOutputStream data_stream, Switch[] switches, string[] config_vars, int[] order) {
        for (int i = 0; i < order.length; i++) {
            int index = order[i];
            if (switches[index].active) {
                try {
                    string config_var = config_vars[index];
                    if (config_var == "io_read \n io_write") {
                        data_stream.put_string ("io_read\n");
                        data_stream.put_string ("io_write\n");
                    } else {
                        data_stream.put_string ("%s\n".printf (config_var));
                    }
                } catch (Error e) {
                    stderr.printf ("Error writing to the file: %s\n", e.message);
                }
            }
        }
    }
}
