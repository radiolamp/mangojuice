/* save_states.vala // License: GPL-3.0+ */
using Gtk;
using Gee;

public class SaveStates {

    static File? config_file_cache = null;

    static File get_config_file () {
        if (config_file_cache == null) {
            var config_dir = File.new_for_path (Environment.get_home_dir ())
                .get_child (".config").get_child ("MangoHud");
            config_file_cache = config_dir.get_child ("MangoHud.conf");
        }
        return config_file_cache;
    }

    public static void update_parameter (
        DataOutputStream data_stream, string parameter_name,
        string parameter_value
    ) throws Error {
        if (
            parameter_value == "" ||
            (parameter_name == "round_corners" && parameter_value == "0") ||
            (parameter_name == "font_size" && parameter_value == "24") ||
            (parameter_name == "log_duration" && parameter_value == "30") ||
            (parameter_name == "log_interval" && parameter_value == "100") ||
            (parameter_name == "table_columns" && parameter_value == "3") ||
            (parameter_name == "fps_sampling_period" && parameter_value == "500") ||
            (parameter_name == "offset_x" && parameter_value == "0") ||
            (parameter_name == "offset_y" && parameter_value == "0")
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

    public static void update_gpu_load_value_in_file (string gpu_load_value_1, string gpu_load_value_2) {
        if (gpu_load_value_1 == "" || gpu_load_value_2 == "") {
            return;
        }
        update_file ("gpu_load_value=", "%s,%s".printf (gpu_load_value_1, gpu_load_value_2));
    }

    public static void update_gpu_load_color_in_file (
        string gpu_load_color_1, string gpu_load_color_2,
        string gpu_load_color_3
    ) {
        update_file ("gpu_load_color=", "%s,%s,%s".printf (gpu_load_color_1, gpu_load_color_2, gpu_load_color_3));
    }

    public static void update_font_file_in_file (string font_path) {
        update_file ("font_file=", font_path);
    }

    public static void update_cpu_load_value_in_file (string cpu_load_value_1, string cpu_load_value_2) {
        if (cpu_load_value_1 == "" || cpu_load_value_2 == "") {
            return;
        }
        update_file ("cpu_load_value=", "%s,%s".printf (cpu_load_value_1, cpu_load_value_2));
    }

    public static void update_cpu_load_color_in_file (
        string cpu_load_color_1, string cpu_load_color_2,
        string cpu_load_color_3
    ) {
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

    public static void update_horizontal_separator_color_in_file (string horizontal_separator_color) {
        update_file ("horizontal_separator_color=", horizontal_separator_color);
    }

    public static void update_media_player_format_in_file (string format_value) {
        update_file ("media_player_format=", format_value);
    }

    static Mutex update_file_mutex = Mutex ();
    static uint? pending_timeout_id = null;
    static HashMap<string, string>? pending_updates = null;
    static bool flush_in_progress = false;

    static HashMap<string, string> get_pending_updates () {
        if (pending_updates == null) {
            pending_updates = new HashMap<string, string> ();
        }
        return pending_updates;
    }

    static void update_file (string prefix, string value) {
        bool should_schedule_flush = false;

        update_file_mutex.lock ();
        var updates = get_pending_updates ();
        updates[prefix] = value;

        if (!flush_in_progress && pending_timeout_id == null) {
            should_schedule_flush = true;
        }

        if (pending_timeout_id != null) {
            Source.remove (pending_timeout_id);
            pending_timeout_id = null;
        }

        if (should_schedule_flush) {
            pending_timeout_id = Timeout.add (50, () => {
                bool sync = false;
                update_file_mutex.lock ();
                pending_timeout_id = null;
                if (get_pending_updates ().is_empty) {
                    update_file_mutex.unlock ();
                    return false;
                }
                flush_in_progress = true;
                update_file_mutex.unlock ();
                flush_pending_updates_internal (sync);
                update_file_mutex.lock ();
                flush_in_progress = false;
                update_file_mutex.unlock ();
                return false;
            });
        }
        update_file_mutex.unlock ();
    }

    static void flush_pending_updates (bool synchronous = false) {
        update_file_mutex.lock ();
        if (get_pending_updates ().is_empty) {
            update_file_mutex.unlock ();
            return;
        }

        if (pending_timeout_id != null) {
            Source.remove (pending_timeout_id);
            pending_timeout_id = null;
        }
        flush_in_progress = true;
        update_file_mutex.unlock ();

        flush_pending_updates_internal (synchronous);

        update_file_mutex.lock ();
        flush_in_progress = false;
        update_file_mutex.unlock ();
    }

    static void flush_pending_updates_internal (bool synchronous) {
        update_file_mutex.lock ();
        var updates_map = get_pending_updates ();
        if (updates_map.is_empty) {
            update_file_mutex.unlock ();
            return;
        }

        var updates = new HashMap<string, string> ();
        foreach (var entry in updates_map.entries) {
            updates[entry.key] = entry.value;
        }
        updates_map.clear ();
        update_file_mutex.unlock ();

        if (synchronous) {
            try {
                var file = get_config_file ();
                if (!file.query_exists ()) {
                    return;
                }

                var lines = new ArrayList<string> ();
                var file_stream = new DataInputStream (file.read ());
                string? line;
                var updated_keys = new HashSet<string> ();

                while ((line = file_stream.read_line ()) != null) {
                    bool updated = false;
                    foreach (var entry in updates.entries) {
                        if (line.has_prefix (entry.key)) {
                            lines.add ("%s%s".printf (entry.key, entry.value));
                            updated_keys.add (entry.key);
                            updated = true;
                            break;
                        }
                    }
                    if (!updated) {
                        lines.add (line);
                    }
                }

                foreach (var entry in updates.entries) {
                    if (!updated_keys.contains (entry.key)) {
                        lines.add ("%s%s".printf (entry.key, entry.value));
                    }
                }

                var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
                foreach (var l in lines) {
                    file_stream_write.put_string (l + "\n");
                }
                file_stream_write.close ();
            } catch (Error e) {
                stderr.printf ("Error writing to the file: %s\n", e.message);
            }
        } else {
            Idle.add_full (Priority.HIGH_IDLE, () => {
                try {
                    var file = get_config_file ();
                    if (!file.query_exists ()) {
                        return false;
                    }

                    var lines = new ArrayList<string> ();
                    var file_stream = new DataInputStream (file.read ());
                    string? line;
                    var updated_keys = new HashSet<string> ();

                    while ((line = file_stream.read_line ()) != null) {
                        bool updated = false;
                        foreach (var entry in updates.entries) {
                            if (line.has_prefix (entry.key)) {
                                lines.add ("%s%s".printf (entry.key, entry.value));
                                updated_keys.add (entry.key);
                                updated = true;
                                break;
                            }
                        }
                        if (!updated) {
                            lines.add (line);
                        }
                    }

                    foreach (var entry in updates.entries) {
                        if (!updated_keys.contains (entry.key)) {
                            lines.add ("%s%s".printf (entry.key, entry.value));
                        }
                    }

                    var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
                    foreach (var l in lines) {
                        file_stream_write.put_string (l + "\n");
                    }
                    file_stream_write.close ();
                } catch (Error e) {
                    stderr.printf ("Error writing to the file: %s\n", e.message);
                }
                return false;
            });
        }
    }

    public static void flush_all_pending () {
        update_file_mutex.lock ();
        if (pending_timeout_id != null) {
            Source.remove (pending_timeout_id);
            pending_timeout_id = null;
        }
        update_file_mutex.unlock ();
        flush_pending_updates (true);
    }

    static void save_color_setting (
        DataOutputStream data_stream, Gtk.ColorDialogButton? color_button,
        string setting_name, MangoJuice mango_juice
    ) throws Error {
        if (color_button != null) {
            var color = mango_juice.rgba_to_hex (color_button.get_rgba ());
            if (color != "") {
                update_parameter (data_stream, setting_name, color);
            }
        }
    }

    static void save_multi_color_setting (DataOutputStream data_stream,
                                                 Gtk.ColorDialogButton? color_button_1,
                                                 Gtk.ColorDialogButton? color_button_2,
                                                 Gtk.ColorDialogButton? color_button_3,
                                                 string setting_name,
                                                 MangoJuice mango_juice) throws Error {
        if (color_button_1 != null && color_button_2 != null && color_button_3 != null) {
            var color_1 = mango_juice.rgba_to_hex (color_button_1.get_rgba ());
            var color_2 = mango_juice.rgba_to_hex (color_button_2.get_rgba ());
            var color_3 = mango_juice.rgba_to_hex (color_button_3.get_rgba ());

            if (color_1 != "" && color_2 != "" && color_3 != "") {
                update_parameter (data_stream, setting_name, "%s,%s,%s".printf (color_1, color_2, color_3));
            }
        }
    }

    public static void save_states_to_file (MangoJuice mango_juice) {
        if (mango_juice.custom_order_changed) {
            save_states_with_diff (mango_juice);
            return;
        }
        save_states_full (mango_juice);
    }

    static void save_states_full (MangoJuice mango_juice) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = get_config_file ();
        bool is_horizontal = mango_juice.custom_switch.active;

        try {
            if (!config_dir.query_exists ()) {
                config_dir.make_directory_with_parents ();
            }

            var data_stream = new DataOutputStream (
                file.replace (null, false, FileCreateFlags.NONE)
            );
            data_stream.put_string ("# Config Generated by MangoJuice #\n");
            data_stream.put_string ("legacy_layout=false\n");
            data_stream.put_string (mango_juice.custom_order_changed ? "#Advances=1\n" : "#Advances=0\n");

            update_parameter (data_stream, "blacklist", mango_juice.blacklist_entry.text);

            update_parameter (data_stream, "gpu_list", mango_juice.gpu_entry.text);

            if (mango_juice.gpu_dropdown.selected_item != null) {
                var selected_pci_address = (
                    mango_juice.gpu_dropdown.selected_item as StringObject
                )?.get_string () ?? "";
                if (selected_pci_address != _("All video cards")) {
                    data_stream.put_string ("pci_dev=%s\n".printf (selected_pci_address));
                }
            }

           var custom_command = mango_juice.custom_command_entry.text;
            if (custom_command != "") {
                if (custom_command.contains (",")) {
                    string[] commands = custom_command.split (",");
                    foreach (string cmd in commands) {
                        string trimmed_cmd = cmd.strip ();
                        if (trimmed_cmd != "") {
                            data_stream.put_string ("%s #custom_command\n".printf (trimmed_cmd));
                        }
                    }
                } else {
                    data_stream.put_string ("%s #custom_command\n".printf (custom_command));
                }
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
            gpu_end.add (15);
            gpu_end.add (16);
            gpu_end.add (17);
            gpu_end.add (18);
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

            save_switches_to_file (
                data_stream, mango_juice.gpu_switches,
                mango_juice.gpu_config_vars,
                (int[]) order_map.get ("gpu_start").to_array ()
            );

            int[] cpu_order = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
            save_switches_to_file (
                data_stream, mango_juice.cpu_switches,
                mango_juice.cpu_config_vars, cpu_order
            );

            int[] memory_order = {0, 1, 2, 3, 4, 5, 6};
            save_switches_to_file (
                data_stream, mango_juice.memory_switches,
                mango_juice.memory_config_vars, memory_order
            );

            if (Config.IS_DEVEL) {
                int[] git_order = {0, 1, 2};
                save_switches_to_file (
                    data_stream, mango_juice.git_switches,
                    mango_juice.git_config_vars, git_order
                );
            }

            save_switches_to_file (
                data_stream, mango_juice.inform_switches,
                mango_juice.inform_config_vars,
                (int[]) order_map.get ("inform_start").to_array ()
            );

            save_switches_to_file (
                data_stream, mango_juice.system_switches,
                mango_juice.system_config_vars,
                (int[]) order_map.get ("system_end").to_array ()
            );

            int[] options_order = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
            save_switches_to_file (
                data_stream, mango_juice.options_switches,
                mango_juice.options_config_vars, options_order
            );

            save_switches_to_file (
                data_stream, mango_juice.gpu_switches,
                mango_juice.gpu_config_vars,
                (int[]) order_map.get ("gpu_end").to_array ()
            );

            save_switches_to_file (
                data_stream, mango_juice.system_switches,
                mango_juice.system_config_vars,
                (int[]) order_map.get ("system_start").to_array ()
            );

            save_switches_to_file (
                data_stream, mango_juice.inform_switches,
                mango_juice.inform_config_vars,
                (int[]) order_map.get ("inform_end").to_array ()
            );

            int[] battery_order = {0, 1, 2, 3, 4, 5};
            save_switches_to_file (
                data_stream, mango_juice.battery_switches,
                mango_juice.battery_config_vars, battery_order
            );

            int[] other_extra_order = {1, 2, 0, 3};
            save_switches_to_file (
                data_stream, mango_juice.other_extra_switches,
                mango_juice.other_extra_config_vars, other_extra_order
            );

            int[] wine_order = {0, 1};
            save_switches_to_file (
                data_stream, mango_juice.wine_switches,
                mango_juice.wine_config_vars, wine_order
            );

            if (mango_juice.logs_key_recorder.shortcut != null && mango_juice.logs_key_recorder.shortcut != "") {
                update_parameter (data_stream, "toggle_logging", mango_juice.logs_key_recorder.shortcut);
            }

            if (mango_juice.toggle_hud_key_recorder.shortcut != null &&
                mango_juice.toggle_hud_key_recorder.shortcut != "") {
                update_parameter (data_stream, "toggle_hud_position", mango_juice.toggle_hud_key_recorder.shortcut);
            }

            if (mango_juice.duracion_scale != null && (int)mango_juice.duracion_scale.get_value () != 0) {
                update_parameter (
                    data_stream, "log_duration",
                    ((int)mango_juice.duracion_scale.get_value ()).to_string ()
                );
            }

            if (mango_juice.autostart_scale != null && (int)mango_juice.autostart_scale.get_value () != 0) {
                update_parameter (
                    data_stream, "autostart_log",
                    ((int)mango_juice.autostart_scale.get_value ()).to_string ()
                );
            }

            if (mango_juice.interval_scale != null && (int)mango_juice.interval_scale.get_value () != 0) {
                update_parameter (
                    data_stream, "log_interval",
                    ((int)mango_juice.interval_scale.get_value ()).to_string ()
                );
            }

            update_parameter (data_stream, "output_folder", mango_juice.custom_logs_path_entry.text);

            if (mango_juice.fps_limit_method.selected_item != null) {
                var fps_limit_method_value = (
                    mango_juice.fps_limit_method.selected_item as StringObject
                )?.get_string () ?? "";
                update_parameter (data_stream, "fps_limit_method", fps_limit_method_value);
            }

            if (mango_juice.toggle_fps_limit_recorder != null &&
                mango_juice.toggle_fps_limit_recorder.shortcut != null) {
                update_parameter (data_stream, "toggle_fps_limit", mango_juice.toggle_fps_limit_recorder.shortcut);
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

            string[] filter_values = {"", "bicubic", "trilinear", "retro"};

            if (mango_juice.filter_dropdown.selected != Gtk.INVALID_LIST_POSITION) {
                int selected = (int)mango_juice.filter_dropdown.selected;
                if (selected >= 0 && selected < filter_values.length) {
                    string filter_value = filter_values[selected];
                    if (filter_value.length > 0) {
                        data_stream.put_string ("%s #filters\n".printf (filter_value));
                    } else {
                        data_stream.put_string ("");
                    }
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
                update_parameter (
                    data_stream, "round_corners",
                    ((int)mango_juice.borders_scale.get_value ()).to_string ()
                );
            }

            if (mango_juice.alpha_scale != null) {
                double alpha_value = mango_juice.alpha_scale.get_value () / 10.0;
                string alpha_value_str = "%.1f".printf (alpha_value).replace (",", ".");
                update_parameter (data_stream, "background_alpha", alpha_value_str);
            }

            if (mango_juice.position_dropdown.selected_item != null) {
                var position_label = (
                    mango_juice.position_dropdown.selected_item as StringObject
                )?.get_string () ?? "";
                string position_value = position_label;
                if (position_label == _("Top Left")) {
                    position_value = "top-left";
                } else if (position_label == _("Top Center")) {
                    position_value = "top-center";
                } else if (position_label == _("Top Right")) {
                    position_value = "top-right";
                } else if (position_label == _("Middle Left")) {
                    position_value = "middle-left";
                } else if (position_label == _("Middle Right")) {
                    position_value = "middle-right";
                } else if (position_label == _("Bottom Left")) {
                    position_value = "bottom-left";
                } else if (position_label == _("Bottom Center")) {
                    position_value = "bottom-center";
                } else if (position_label == _("Bottom Right")) {
                    position_value = "bottom-right";
                }
                update_parameter (data_stream, "position", position_value);
            }

            if (mango_juice.colums_scale != null) {
                update_parameter (
                    data_stream, "table_columns",
                    ((int)mango_juice.colums_scale.get_value ()).to_string ()
                );
            }

            update_parameter (data_stream, "toggle_hud", mango_juice.toggle_hud_entry.text);

            if (mango_juice.font_size_scale != null) {
                update_parameter (
                    data_stream, "font_size",
                    ((int)mango_juice.font_size_scale.get_value ()).to_string ()
                );
            }

            if (mango_juice.font_size_secondary_scale != null) {
                update_parameter (
                    data_stream, "font_size_secondary",
                    ((int)mango_juice.font_size_secondary_scale.get_value ()).to_string ()
                );
            }

            if (mango_juice.font_button != null) {
                var font_name = mango_juice.font_button.label;
                if (font_name != _("Default") && font_name != _("Select Font")) {
                    var font_path = mango_juice.find_font_path_by_name (font_name, mango_juice.find_fonts ());
                    if (font_path != "") {
                        update_parameter (data_stream, "font_file", font_path);
                        data_stream.put_string (
                            "font_glyph_ranges=korean, chinese, " +
                            "chinese_simplified, japanese, cyrillic, " +
                            "thai, vietnamese, latin_ext_a, latin_ext_b\n"
                        );
                    }
                }
            }

            if (mango_juice.fps_sampling_period_scale != null) {
                update_parameter (
                    data_stream, "fps_sampling_period",
                    ((int)mango_juice.fps_sampling_period_scale.get_value ()).to_string ()
                );
            }

            update_parameter (data_stream, "gpu_text", mango_juice.gpu_text_entry.text);

            save_color_setting (data_stream, mango_juice.gpu_color_button, "gpu_color", mango_juice);

            update_parameter (data_stream, "cpu_text", mango_juice.cpu_text_entry.text);

            save_color_setting (data_stream, mango_juice.cpu_color_button, "cpu_color", mango_juice);

            if (mango_juice.fps_value_entry_1 != null && mango_juice.fps_value_entry_2 != null) {
                var fps_value_1 = mango_juice.fps_value_entry_1.text;
                var fps_value_2 = mango_juice.fps_value_entry_2.text;
                if (fps_value_1 != "" && fps_value_2 != "") {
                    update_parameter (data_stream, "fps_value", "%s,%s".printf (fps_value_1, fps_value_2));
                }
            }

            save_multi_color_setting (data_stream,
                                   mango_juice.fps_color_button_1,
                                   mango_juice.fps_color_button_2,
                                   mango_juice.fps_color_button_3,
                                   "fps_color",
                                   mango_juice);

            if (mango_juice.gpu_load_value_entry_1 != null && mango_juice.gpu_load_value_entry_2 != null) {
                var gpu_load_value_1 = mango_juice.gpu_load_value_entry_1.text;
                var gpu_load_value_2 = mango_juice.gpu_load_value_entry_2.text;
                if (gpu_load_value_1 != "" && gpu_load_value_2 != "") {
                    update_parameter (
                        data_stream, "gpu_load_value",
                        "%s,%s".printf (gpu_load_value_1, gpu_load_value_2)
                    );
                }
            }

            save_multi_color_setting (data_stream,
                                   mango_juice.gpu_load_color_button_1,
                                   mango_juice.gpu_load_color_button_2,
                                   mango_juice.gpu_load_color_button_3,
                                   "gpu_load_color",
                                   mango_juice);

            if (mango_juice.cpu_load_value_entry_1 != null && mango_juice.cpu_load_value_entry_2 != null) {
                var cpu_load_value_1 = mango_juice.cpu_load_value_entry_1.text;
                var cpu_load_value_2 = mango_juice.cpu_load_value_entry_2.text;
                if (cpu_load_value_1 != "" && cpu_load_value_2 != "") {
                    update_parameter (
                        data_stream, "cpu_load_value",
                        "%s,%s".printf (cpu_load_value_1, cpu_load_value_2)
                    );
                }
            }

            save_multi_color_setting (data_stream,
                                   mango_juice.cpu_load_color_button_1,
                                   mango_juice.cpu_load_color_button_2,
                                   mango_juice.cpu_load_color_button_3,
                                   "cpu_load_color",
                                   mango_juice);

            save_color_setting (data_stream, mango_juice.background_color_button, "background_color", mango_juice);
            save_color_setting (data_stream, mango_juice.frametime_color_button, "frametime_color", mango_juice);
            save_color_setting (data_stream, mango_juice.vram_color_button, "vram_color", mango_juice);
            save_color_setting (data_stream, mango_juice.ram_color_button, "ram_color", mango_juice);
            save_color_setting (data_stream, mango_juice.wine_color_button, "wine_color", mango_juice);
            save_color_setting (data_stream, mango_juice.engine_color_button, "engine_color", mango_juice);
            save_color_setting (data_stream, mango_juice.text_color_button, "text_color", mango_juice);
            save_color_setting (data_stream, mango_juice.media_player_color_button, "media_player_color", mango_juice);
            save_color_setting (data_stream, mango_juice.network_color_button, "network_color", mango_juice);
            save_color_setting (data_stream, mango_juice.battery_color_button, "battery_color", mango_juice);
            save_color_setting (
                data_stream, mango_juice.horizontal_separator_color_button,
                "horizontal_separator_color", mango_juice
            );

            const string[] FORMAT_VALUES = { "title", "artist", "album", "none" };

            if (mango_juice.media_format_dropdowns != null) {
                var active_values = new Gee.ArrayList<string> ();
                foreach (var dropdown in mango_juice.media_format_dropdowns) {
                    int selected = (int)dropdown.selected;
                    if (selected >= 0 && selected < FORMAT_VALUES.length) {
                        string english_value = FORMAT_VALUES[selected];
                        if (english_value != "none") {
                            active_values.add (english_value);
                        }
                    }
                }

                string media_format = "";
                if (active_values.size > 0) {
                    var sb = new StringBuilder ();
                    sb.append ("{");
                    bool first = true;
                    foreach (string val in active_values) {
                        if (!first) sb.append ("};{");
                        sb.append (val);
                        first = false;
                    }
                    sb.append ("}");
                    media_format = sb.str;
                }
                update_parameter (data_stream, "media_player_format", media_format);
            }

            data_stream.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public static void reset_config_file_cache () {
        config_file_cache = null;
    }

    static void save_states_with_diff (MangoJuice mango_juice) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = get_config_file ();

        try {
            if (!file.query_exists ()) {
                if (!config_dir.query_exists ()) {
                    config_dir.make_directory_with_parents ();
                }
                save_states_full (mango_juice);
                return;
            }
        } catch (Error e) {
            save_states_full (mango_juice);
            return;
        }

        var all_known_bare = new HashSet<string> ();
        var active_bare = new HashSet<string> ();
        collect_all_bare_states (mango_juice, all_known_bare, active_bare);

        var desired_kv = new HashMap<string, string> ();
        collect_kv_desired (mango_juice, desired_kv);

        var existing_lines = new ArrayList<string> ();
        try {
            var dis = new DataInputStream (file.read ());
            string line;
            while ((line = dis.read_line ()) != null) {
                existing_lines.add (line);
            }
            dis.close ();
        } catch (Error e) {
            stderr.printf ("Error reading the file: %s\n", e.message);
            save_states_full (mango_juice);
            return;
        }

        var result = new ArrayList<string> ();
        var kept_bare = new HashSet<string> ();
        var written_prefixes = new HashSet<string> ();

        bool handled_custom_cmd = false;
        bool handled_filter = false;
        bool handled_horizontal = false;
        bool handled_pci_dev = false;
        bool handled_font_glyph = false;
        bool handled_advances = false;

        foreach (string existing_line in existing_lines) {
            string stripped = existing_line.strip ();
            if (stripped == "") continue;

            if (stripped.has_suffix ("#custom_command")) {
                if (!handled_custom_cmd) {
                    append_custom_commands_to (mango_juice, result);
                    handled_custom_cmd = true;
                }
                continue;
            }

            if (stripped.has_suffix ("#filters")) {
                if (!handled_filter) {
                    append_filter_line_to (mango_juice, result);
                    handled_filter = true;
                }
                continue;
            }

            if (stripped == "horizontal" || stripped.has_prefix ("horizontal_stretch=")) {
                if (!handled_horizontal) {
                    append_horizontal_lines_to (mango_juice, result);
                    handled_horizontal = true;
                }
                continue;
            }

            if (stripped.has_prefix ("pci_dev=")) {
                if (!handled_pci_dev) {
                    append_pci_dev_line_to (mango_juice, result);
                    handled_pci_dev = true;
                }
                continue;
            }

            if (stripped.has_prefix ("font_glyph_ranges=")) {
                if (!handled_font_glyph) {
                    append_font_glyph_ranges_to (mango_juice, result);
                    handled_font_glyph = true;
                }
                continue;
            }

            if (stripped.has_prefix ("#Advances=")) {
                result.add (mango_juice.custom_order_changed ? "#Advances=1" : "#Advances=0");
                handled_advances = true;
                continue;
            }

            if (all_known_bare.contains (stripped)) {
                if (active_bare.contains (stripped)) {
                    result.add (stripped);
                    kept_bare.add (stripped);
                }
                continue;
            }

            bool kv_handled = false;
            foreach (string prefix in desired_kv.keys) {
                if (stripped.has_prefix (prefix)) {
                    result.add (prefix + "=" + desired_kv[prefix]);
                    written_prefixes.add (prefix);
                    kv_handled = true;
                    break;
                }
            }
            if (kv_handled) continue;

            result.add (stripped);
        }

        if (!handled_custom_cmd) append_custom_commands_to (mango_juice, result);
        if (!handled_filter) append_filter_line_to (mango_juice, result);
        if (!handled_horizontal) append_horizontal_lines_to (mango_juice, result);
        if (!handled_pci_dev) append_pci_dev_line_to (mango_juice, result);
        if (!handled_font_glyph) append_font_glyph_ranges_to (mango_juice, result);
        if (!handled_advances) result.add (mango_juice.custom_order_changed ? "#Advances=1" : "#Advances=0");

        foreach (string bare in active_bare) {
            if (!kept_bare.contains (bare)) {
                result.add (bare);
            }
        }

        foreach (string prefix in desired_kv.keys) {
            if (!written_prefixes.contains (prefix)) {
                result.add (prefix + "=" + desired_kv[prefix]);
            }
        }

        try {
            var output = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (string l in result) {
                output.put_string (l + "\n");
            }
            output.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    static void collect_all_bare_states (MangoJuice mango_juice, HashSet<string> all_known, HashSet<string> active) {
        add_bare_states (mango_juice.gpu_switches, mango_juice.gpu_config_vars, all_known, active);
        add_bare_states (mango_juice.cpu_switches, mango_juice.cpu_config_vars, all_known, active);
        add_bare_states (mango_juice.memory_switches, mango_juice.memory_config_vars, all_known, active);
        add_bare_states (mango_juice.system_switches, mango_juice.system_config_vars, all_known, active);
        add_bare_states (mango_juice.wine_switches, mango_juice.wine_config_vars, all_known, active);
        add_bare_states (mango_juice.options_switches, mango_juice.options_config_vars, all_known, active);
        add_bare_states (mango_juice.battery_switches, mango_juice.battery_config_vars, all_known, active);
        add_bare_states (mango_juice.other_extra_switches, mango_juice.other_extra_config_vars, all_known, active);
        add_bare_states (mango_juice.inform_switches, mango_juice.inform_config_vars, all_known, active);
        if (Config.IS_DEVEL) {
            add_bare_states (mango_juice.git_switches, mango_juice.git_config_vars, all_known, active);
        }
    }

    static void add_bare_states (Switch[] switches, string[] config_vars, HashSet<string> all_known, HashSet<string> active) {
        for (int i = 0; i < config_vars.length; i++) {
            all_known.add (config_vars[i]);
            if (i < switches.length && switches[i] != null && switches[i].active) {
                active.add (config_vars[i]);
            }
        }
    }

    static void maybe_add_kv (HashMap<string, string> kv, string name, string value) {
        if (value == "" ||
            (name == "round_corners" && value == "0") ||
            (name == "font_size" && value == "24") ||
            (name == "log_duration" && value == "30") ||
            (name == "log_interval" && value == "100") ||
            (name == "table_columns" && value == "3") ||
            (name == "fps_sampling_period" && value == "500") ||
            (name == "offset_x" && value == "0") ||
            (name == "offset_y" && value == "0")) {
            return;
        }
        kv[name] = value;
    }

    static void collect_kv_desired (MangoJuice mango_juice, HashMap<string, string> kv) {
        bool is_horizontal = mango_juice.custom_switch.active;

        maybe_add_kv (kv, "blacklist", mango_juice.blacklist_entry.text);
        maybe_add_kv (kv, "gpu_list", mango_juice.gpu_entry.text);

        if (mango_juice.offset_x_scale != null) {
            maybe_add_kv (kv, "offset_x", ((int)mango_juice.offset_x_scale.get_value ()).to_string ());
        }
        if (mango_juice.offset_y_scale != null) {
            maybe_add_kv (kv, "offset_y", ((int)mango_juice.offset_y_scale.get_value ()).to_string ());
        }

        if (is_horizontal) {
            maybe_add_kv (kv, "custom_text", mango_juice.custom_text_center_entry.text);
        } else {
            maybe_add_kv (kv, "custom_text_center", mango_juice.custom_text_center_entry.text);
        }

        if (mango_juice.logs_key_recorder.shortcut != null && mango_juice.logs_key_recorder.shortcut != "") {
            maybe_add_kv (kv, "toggle_logging", mango_juice.logs_key_recorder.shortcut);
        }
        if (mango_juice.toggle_hud_key_recorder.shortcut != null && mango_juice.toggle_hud_key_recorder.shortcut != "") {
            maybe_add_kv (kv, "toggle_hud_position", mango_juice.toggle_hud_key_recorder.shortcut);
        }

        if (mango_juice.duracion_scale != null && (int)mango_juice.duracion_scale.get_value () != 0) {
            maybe_add_kv (kv, "log_duration", ((int)mango_juice.duracion_scale.get_value ()).to_string ());
        }
        if (mango_juice.autostart_scale != null && (int)mango_juice.autostart_scale.get_value () != 0) {
            maybe_add_kv (kv, "autostart_log", ((int)mango_juice.autostart_scale.get_value ()).to_string ());
        }
        if (mango_juice.interval_scale != null && (int)mango_juice.interval_scale.get_value () != 0) {
            maybe_add_kv (kv, "log_interval", ((int)mango_juice.interval_scale.get_value ()).to_string ());
        }

        maybe_add_kv (kv, "output_folder", mango_juice.custom_logs_path_entry.text);

        if (mango_juice.fps_limit_method.selected_item != null) {
            var fps_limit_method_value = (
                mango_juice.fps_limit_method.selected_item as StringObject
            )?.get_string () ?? "";
            maybe_add_kv (kv, "fps_limit_method", fps_limit_method_value);
        }

        if (mango_juice.toggle_fps_limit_recorder != null && mango_juice.toggle_fps_limit_recorder.shortcut != null) {
            maybe_add_kv (kv, "toggle_fps_limit", mango_juice.toggle_fps_limit_recorder.shortcut);
        }

        var fps_limit_1 = mango_juice.fps_limit_entry_1.text;
        var fps_limit_2 = mango_juice.fps_limit_entry_2.text;
        var fps_limit_3 = mango_juice.fps_limit_entry_3.text;
        if (fps_limit_1 != "" || fps_limit_2 != "" || fps_limit_3 != "") {
            kv["fps_limit"] = "%s,%s,%s".printf (fps_limit_1, fps_limit_2, fps_limit_3);
        }

        if (mango_juice.vulkan_dropdown.selected_item != null) {
            var vulkan_value = (mango_juice.vulkan_dropdown.selected_item as StringObject)?.get_string () ?? "";
            var vulkan_config_value = mango_juice.get_vulkan_config_value (vulkan_value);
            maybe_add_kv (kv, "vsync", vulkan_config_value);
        }

        if (mango_juice.opengl_dropdown.selected_item != null) {
            var opengl_value = (mango_juice.opengl_dropdown.selected_item as StringObject)?.get_string () ?? "";
            var opengl_config_value = mango_juice.get_opengl_config_value (opengl_value);
            maybe_add_kv (kv, "gl_vsync", opengl_config_value);
        }

        if (mango_juice.af != null && (int)mango_juice.af.get_value () != 0) {
            maybe_add_kv (kv, "af", ((int)mango_juice.af.get_value ()).to_string ());
        }
        if (mango_juice.picmip != null && (int)mango_juice.picmip.get_value () != 0) {
            maybe_add_kv (kv, "picmip", ((int)mango_juice.picmip.get_value ()).to_string ());
        }

        if (mango_juice.borders_scale != null) {
            maybe_add_kv (kv, "round_corners", ((int)mango_juice.borders_scale.get_value ()).to_string ());
        }
        if (mango_juice.alpha_scale != null) {
            double alpha_value = mango_juice.alpha_scale.get_value () / 10.0;
            string alpha_value_str = "%.1f".printf (alpha_value).replace (",", ".");
            maybe_add_kv (kv, "background_alpha", alpha_value_str);
        }

        if (mango_juice.position_dropdown.selected_item != null) {
            var position_label = (
                mango_juice.position_dropdown.selected_item as StringObject
            )?.get_string () ?? "";
            string position_value = position_label;
            if (position_label == _("Top Left")) position_value = "top-left";
            else if (position_label == _("Top Center")) position_value = "top-center";
            else if (position_label == _("Top Right")) position_value = "top-right";
            else if (position_label == _("Middle Left")) position_value = "middle-left";
            else if (position_label == _("Middle Right")) position_value = "middle-right";
            else if (position_label == _("Bottom Left")) position_value = "bottom-left";
            else if (position_label == _("Bottom Center")) position_value = "bottom-center";
            else if (position_label == _("Bottom Right")) position_value = "bottom-right";
            maybe_add_kv (kv, "position", position_value);
        }

        if (mango_juice.colums_scale != null) {
            maybe_add_kv (kv, "table_columns", ((int)mango_juice.colums_scale.get_value ()).to_string ());
        }
        maybe_add_kv (kv, "toggle_hud", mango_juice.toggle_hud_entry.text);

        if (mango_juice.font_size_scale != null) {
            maybe_add_kv (kv, "font_size", ((int)mango_juice.font_size_scale.get_value ()).to_string ());
        }
        if (mango_juice.font_size_secondary_scale != null) {
            maybe_add_kv (kv, "font_size_secondary", ((int)mango_juice.font_size_secondary_scale.get_value ()).to_string ());
        }

        if (mango_juice.font_button != null) {
            var font_name = mango_juice.font_button.label;
            if (font_name != _("Default") && font_name != _("Select Font")) {
                var font_path = mango_juice.find_font_path_by_name (font_name, mango_juice.find_fonts ());
                if (font_path != "") {
                    maybe_add_kv (kv, "font_file", font_path);
                }
            }
        }

        if (mango_juice.fps_sampling_period_scale != null) {
            maybe_add_kv (kv, "fps_sampling_period", ((int)mango_juice.fps_sampling_period_scale.get_value ()).to_string ());
        }

        maybe_add_kv (kv, "gpu_text", mango_juice.gpu_text_entry.text);
        maybe_add_kv (kv, "cpu_text", mango_juice.cpu_text_entry.text);

        add_color_kv (kv, "gpu_color", mango_juice.gpu_color_button, mango_juice);
        add_color_kv (kv, "cpu_color", mango_juice.cpu_color_button, mango_juice);

        if (mango_juice.fps_value_entry_1 != null && mango_juice.fps_value_entry_2 != null) {
            var fps_value_1 = mango_juice.fps_value_entry_1.text;
            var fps_value_2 = mango_juice.fps_value_entry_2.text;
            if (fps_value_1 != "" && fps_value_2 != "") {
                kv["fps_value"] = "%s,%s".printf (fps_value_1, fps_value_2);
            }
        }

        add_multi_color_kv (kv, "fps_color",
            mango_juice.fps_color_button_1, mango_juice.fps_color_button_2, mango_juice.fps_color_button_3, mango_juice);

        if (mango_juice.gpu_load_value_entry_1 != null && mango_juice.gpu_load_value_entry_2 != null) {
            var gpu_load_value_1 = mango_juice.gpu_load_value_entry_1.text;
            var gpu_load_value_2 = mango_juice.gpu_load_value_entry_2.text;
            if (gpu_load_value_1 != "" && gpu_load_value_2 != "") {
                kv["gpu_load_value"] = "%s,%s".printf (gpu_load_value_1, gpu_load_value_2);
            }
        }

        add_multi_color_kv (kv, "gpu_load_color",
            mango_juice.gpu_load_color_button_1, mango_juice.gpu_load_color_button_2, mango_juice.gpu_load_color_button_3, mango_juice);

        if (mango_juice.cpu_load_value_entry_1 != null && mango_juice.cpu_load_value_entry_2 != null) {
            var cpu_load_value_1 = mango_juice.cpu_load_value_entry_1.text;
            var cpu_load_value_2 = mango_juice.cpu_load_value_entry_2.text;
            if (cpu_load_value_1 != "" && cpu_load_value_2 != "") {
                kv["cpu_load_value"] = "%s,%s".printf (cpu_load_value_1, cpu_load_value_2);
            }
        }

        add_multi_color_kv (kv, "cpu_load_color",
            mango_juice.cpu_load_color_button_1, mango_juice.cpu_load_color_button_2, mango_juice.cpu_load_color_button_3, mango_juice);

        add_color_kv (kv, "background_color", mango_juice.background_color_button, mango_juice);
        add_color_kv (kv, "frametime_color", mango_juice.frametime_color_button, mango_juice);
        add_color_kv (kv, "vram_color", mango_juice.vram_color_button, mango_juice);
        add_color_kv (kv, "ram_color", mango_juice.ram_color_button, mango_juice);
        add_color_kv (kv, "wine_color", mango_juice.wine_color_button, mango_juice);
        add_color_kv (kv, "engine_color", mango_juice.engine_color_button, mango_juice);
        add_color_kv (kv, "text_color", mango_juice.text_color_button, mango_juice);
        add_color_kv (kv, "media_player_color", mango_juice.media_player_color_button, mango_juice);
        add_color_kv (kv, "network_color", mango_juice.network_color_button, mango_juice);
        add_color_kv (kv, "battery_color", mango_juice.battery_color_button, mango_juice);
        add_color_kv (kv, "horizontal_separator_color", mango_juice.horizontal_separator_color_button, mango_juice);

        const string[] FORMAT_VALUES = { "title", "artist", "album", "none" };
        if (mango_juice.media_format_dropdowns != null) {
            var active_values = new Gee.ArrayList<string> ();
            foreach (var dropdown in mango_juice.media_format_dropdowns) {
                int selected = (int)dropdown.selected;
                if (selected >= 0 && selected < FORMAT_VALUES.length) {
                    string english_value = FORMAT_VALUES[selected];
                    if (english_value != "none") {
                        active_values.add (english_value);
                    }
                }
            }
            string media_format = "";
            if (active_values.size > 0) {
                var sb = new StringBuilder ();
                sb.append ("{");
                bool first = true;
                foreach (string val in active_values) {
                    if (!first) sb.append ("};{");
                    sb.append (val);
                    first = false;
                }
                sb.append ("}");
                media_format = sb.str;
            }
            maybe_add_kv (kv, "media_player_format", media_format);
        }
    }

    static void add_color_kv (HashMap<string, string> kv, string name, Gtk.ColorDialogButton? button, MangoJuice mango_juice) {
        if (button != null) {
            var color = mango_juice.rgba_to_hex (button.get_rgba ());
            if (color != "") {
                maybe_add_kv (kv, name, color);
            }
        }
    }

    static void add_multi_color_kv (HashMap<string, string> kv, string name,
        Gtk.ColorDialogButton? b1, Gtk.ColorDialogButton? b2, Gtk.ColorDialogButton? b3, MangoJuice mango_juice) {
        if (b1 != null && b2 != null && b3 != null) {
            var c1 = mango_juice.rgba_to_hex (b1.get_rgba ());
            var c2 = mango_juice.rgba_to_hex (b2.get_rgba ());
            var c3 = mango_juice.rgba_to_hex (b3.get_rgba ());
            if (c1 != "" && c2 != "" && c3 != "") {
                kv[name] = "%s,%s,%s".printf (c1, c2, c3);
            }
        }
    }

    static void append_custom_commands_to (MangoJuice mango_juice, ArrayList<string> result) {
        var custom_command = mango_juice.custom_command_entry.text;
        if (custom_command == "") return;
        if (custom_command.contains (",")) {
            string[] commands = custom_command.split (",");
            foreach (string cmd in commands) {
                string trimmed_cmd = cmd.strip ();
                if (trimmed_cmd != "") {
                    result.add ("%s #custom_command".printf (trimmed_cmd));
                }
            }
        } else {
            result.add ("%s #custom_command".printf (custom_command));
        }
    }

    static void append_filter_line_to (MangoJuice mango_juice, ArrayList<string> result) {
        if (mango_juice.filter_dropdown.selected == Gtk.INVALID_LIST_POSITION) return;
        string[] filter_values = {"", "bicubic", "trilinear", "retro"};
        int selected = (int)mango_juice.filter_dropdown.selected;
        if (selected >= 0 && selected < filter_values.length) {
            string filter_value = filter_values[selected];
            if (filter_value.length > 0) {
                result.add ("%s #filters".printf (filter_value));
            }
        }
    }

    static void append_horizontal_lines_to (MangoJuice mango_juice, ArrayList<string> result) {
        if (mango_juice.custom_switch.active) {
            result.add ("horizontal");
            result.add ("horizontal_stretch=0");
        }
    }

    static void append_pci_dev_line_to (MangoJuice mango_juice, ArrayList<string> result) {
        if (mango_juice.gpu_dropdown.selected_item != null) {
            var selected_pci_address = (
                mango_juice.gpu_dropdown.selected_item as StringObject
            )?.get_string () ?? "";
            if (selected_pci_address != _("All video cards")) {
                result.add ("pci_dev=%s".printf (selected_pci_address));
            }
        }
    }

    static void append_font_glyph_ranges_to (MangoJuice mango_juice, ArrayList<string> result) {
        if (mango_juice.font_button != null) {
            var font_name = mango_juice.font_button.label;
            if (font_name != _("Default") && font_name != _("Select Font")) {
                var font_path = mango_juice.find_font_path_by_name (font_name, mango_juice.find_fonts ());
                if (font_path != "") {
                    result.add ("font_glyph_ranges=korean, chinese, chinese_simplified, japanese, cyrillic, thai, vietnamese, latin_ext_a, latin_ext_b");
                }
            }
        }
    }

    public static void save_switches_to_file (
        DataOutputStream data_stream, Switch[] switches,
        string[] config_vars, int[] order
    ) {
        for (int i = 0; i < order.length; i++) {
            int index = order[i];
            if (index < switches.length && switches[index].active) {
                try {
                    string config_var = config_vars[index];
                    data_stream.put_string ("%s\n".printf (config_var));
                } catch (Error e) {
                    stderr.printf ("Error writing to the file: %s\n", e.message);
                }
            }
        }
    }

}
