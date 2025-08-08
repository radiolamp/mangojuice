/* load_states.vala // Licence:  GPL-v3.0 */

using Gtk;
using Gee;

public class LoadStates {
    public static async void load_states_from_file (MangoJuice mango_juice) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");

        mango_juice.is_loading = true;

        if (!file.query_exists ()) {
            try {
                if (!config_dir.query_exists ()) {
                    config_dir.make_directory_with_parents ();
                }
                file.create (FileCreateFlags.NONE);
            } catch (Error e) {
                stderr.printf ("Error creating the file: %s\n", e.message);
                mango_juice.is_loading = false;
                return;
            }
        }

        try {
            var file_stream = yield file.read_async ();

            var data_stream = new DataInputStream (file_stream);
            string line;

            while ((line = yield data_stream.read_line_async ()) != null) {
                load_switch_from_file (line, mango_juice.gpu_switches,         mango_juice.gpu_config_vars);
                load_switch_from_file (line, mango_juice.cpu_switches,         mango_juice.cpu_config_vars);
                load_switch_from_file (line, mango_juice.memory_switches,      mango_juice.memory_config_vars);
                if (Config.IS_DEVEL) {
                load_switch_from_file (line, mango_juice.git_switches,         mango_juice.git_config_vars);
                }
                load_switch_from_file (line, mango_juice.system_switches,      mango_juice.system_config_vars);
                load_switch_from_file (line, mango_juice.wine_switches,        mango_juice.wine_config_vars);
                load_switch_from_file (line, mango_juice.battery_switches,     mango_juice.battery_config_vars);
                load_switch_from_file (line, mango_juice.other_extra_switches, mango_juice.other_extra_config_vars);
                load_switch_from_file (line, mango_juice.inform_switches,      mango_juice.inform_config_vars);
                load_switch_from_file (line, mango_juice.options_switches,     mango_juice.options_config_vars);

                if (line.contains("#custom_command")) {
                    var custom_command_value = line.split(" #custom_command")[0].strip();
                    mango_juice.custom_command_entry.text = custom_command_value;
                }

                if (line.has_prefix ("toggle_logging=")) {
                    var logs_key = line.substring ("toggle_logging=".length);
                    for (uint i = 0; i < mango_juice.logs_key_model.get_n_items (); i++) {
                        var item = mango_juice.logs_key_model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == logs_key) {
                            mango_juice.logs_key_combo.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("toggle_hud_position=")) {
                    var toggle_hud_position = line.substring ("toggle_hud_position=".length);
                    for (uint i = 0; i < mango_juice.toggle_hud_key_model.get_n_items (); i++) {
                        var item = mango_juice.toggle_hud_key_model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == toggle_hud_position) {
                            mango_juice.toggle_hud_key_combo.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("pci_dev=")) {
                    if (mango_juice.gpu_dropdown != null) {
                        string selected_pci_address = line.substring ("pci_dev=".length).strip ();

                        selected_pci_address = selected_pci_address.replace ("0000:", "");

                        var model = mango_juice.gpu_dropdown.model;

                        uint index = 0;
                        bool found = false;
                        for (uint i = 0; i < model.get_n_items (); i++) {
                            var item = model.get_item (i) as Gtk.StringObject;
                            if (item != null) {
                                string item_text = item.get_string ();
                                if (item_text.contains (selected_pci_address)) {
                                    index = i;
                                    found = true;
                                    break;
                                }
                            }
                        }

                        if (found) {
                            mango_juice.gpu_dropdown.selected = index;
                        }
                    }
                }

                if (line.has_prefix ("log_duration=")) {
                    if (mango_juice.duracion_scale != null) {
                        int duracion_value = int.parse (line.substring ("log_duration=".length));
                        mango_juice.duracion_scale.set_value (duracion_value);
                        if (mango_juice.duracion_entry != null) {
                            mango_juice.duracion_entry.text = "%d".printf (duracion_value);
                        }
                    }
                }

                if (line.has_prefix ("autostart_log=")) {
                    if (mango_juice.autostart_scale != null) {
                        int autostart_value = int.parse (line.substring ("autostart_log=".length));
                        mango_juice.autostart_scale.set_value (autostart_value);
                        if (mango_juice.autostart_entry != null) {
                            mango_juice.autostart_entry.text = "%d".printf (autostart_value);
                        }
                    }
                }

                if (line.has_prefix ("log_interval=")) {
                    if (mango_juice.interval_scale != null) {
                        int interval_value = int.parse (line.substring ("log_interval=".length));
                        mango_juice.interval_scale.set_value (interval_value);
                        if (mango_juice.interval_entry != null) {
                            mango_juice.interval_entry.text = "%d".printf (interval_value);
                        }
                    }
                }

                if (line.has_prefix ("output_folder=")) {
                    mango_juice.custom_logs_path_entry.text = line.substring ("output_folder=".length);
                }

                if (line.has_prefix ("fps_limit_method=")) {
                    var fps_limit_method_value = line.substring ("fps_limit_method=".length);
                    for (uint i = 0; i < mango_juice.fps_limit_method.model.get_n_items (); i++) {
                        var item = mango_juice.fps_limit_method.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == fps_limit_method_value) {
                            mango_juice.fps_limit_method.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("toggle_fps_limit=")) {
                    var toggle_fps_limit_value = line.substring ("toggle_fps_limit=".length);
                    for (uint i = 0; i < mango_juice.toggle_fps_limit.model.get_n_items (); i++) {
                        var item = mango_juice.toggle_fps_limit.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == toggle_fps_limit_value) {
                            mango_juice.toggle_fps_limit.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("fps_limit=")) {
                    var fps_limits = line.substring ("fps_limit=".length).split (",");
                    if (fps_limits.length == 3) {
                        mango_juice.fps_limit_entry_1.text = fps_limits[0];
                        mango_juice.fps_limit_entry_2.text = fps_limits[1];
                        mango_juice.fps_limit_entry_3.text = fps_limits[2];
                    }
                }

                if (line.has_prefix ("vsync=")) {
                    var vulkan_config_value = line.substring ("vsync=".length);
                    var vulkan_value = mango_juice.get_vulkan_value_from_config (vulkan_config_value);
                    for (uint i = 0; i < mango_juice.vulkan_dropdown.model.get_n_items (); i++) {
                        var item = mango_juice.vulkan_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == vulkan_value) {
                            mango_juice.vulkan_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("gl_vsync=")) {
                    var opengl_config_value = line.substring ("gl_vsync=".length);
                    var opengl_value = mango_juice.get_opengl_value_from_config (opengl_config_value);
                    for (uint i = 0; i < mango_juice.opengl_dropdown.model.get_n_items (); i++) {
                        var item = mango_juice.opengl_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == opengl_value) {
                            mango_juice.opengl_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.contains("#filters")) {
                    var filter_value = line.split("#filters")[0].strip();
                
                    string[] filter_values = {"none", "bicubic", "trilinear", "retro"};
                
                    for (uint i = 0; i < filter_values.length; i++) {
                        if (filter_values[i] == filter_value) {
                            mango_juice.filter_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("af=")) {
                    if (mango_juice.af != null) {
                        int af_value = int.parse (line.substring ("af=".length));
                        mango_juice.af.set_value (af_value);
                        if (mango_juice.af_entry != null) {
                            mango_juice.af_entry.text = "%d".printf (af_value);
                        }
                    }
                }

                if (line.has_prefix ("picmip=")) {
                    if (mango_juice.picmip != null) {
                        int picmip_value = int.parse (line.substring ("picmip=".length));
                        mango_juice.picmip.set_value (picmip_value);
                        if (mango_juice.picmip_entry != null) {
                            mango_juice.picmip_entry.text = "%d".printf (picmip_value);
                        }
                    }
                }

                if (line.has_prefix ("custom_text_center=")) {
                    mango_juice.custom_text_center_entry.text = line.substring ("custom_text_center=".length);
                }

                if (line.has_prefix ("horizontal")) {
                    mango_juice.custom_switch.active = true;
                }

                if (line.has_prefix ("round_corners=")) {
                    if (mango_juice.borders_scale != null) {
                        int borders_value = int.parse (line.substring ("round_corners=".length));
                        mango_juice.borders_scale.set_value (borders_value);
                        if (mango_juice.borders_entry != null) {
                            mango_juice.borders_entry.text = "%d".printf (borders_value);
                        }
                    }
                }

                if (line.has_prefix ("background_alpha=")) {
                    if (mango_juice.alpha_scale != null) {
                        double alpha_value = double.parse (line.substring ("background_alpha=".length));
                        mango_juice.alpha_scale.set_value (alpha_value * 100);
                        if (mango_juice.alpha_value_label != null) {
                            mango_juice.alpha_value_label.label = "%.1f".printf (alpha_value);
                        }
                    }
                }


                if (line.has_prefix("position=")) {
                    var position_value = line.substring("position=".length);
                    var position_mapping = new Gee.HashMap<string, string>();
                    position_mapping["top-left"] = _("Top Left");
                    position_mapping["top-center"] = _("Top Center");
                    position_mapping["top-right"] = _("Top Right");
                    position_mapping["middle-left"] = _("Middle Left");
                    position_mapping["middle-right"] = _("Middle Right");
                    position_mapping["bottom-left"] = _("Bottom Left");
                    position_mapping["bottom-center"] = _("Bottom Center");
                    position_mapping["bottom-right"] = _("Bottom Right");
                    string? translated_label = position_mapping[position_value];
                    if (translated_label != null && mango_juice.position_dropdown != null) {
                        var model = mango_juice.position_dropdown.model as Gtk.StringList;
                        for (uint i = 0; i < model.get_n_items(); i++) {
                            string? item = model.get_string(i);
                            if (item == translated_label) {
                                mango_juice.position_dropdown.selected = i;
                                break;
                            }
                        }
                    }
                }

                if (line.has_prefix ("table_columns=")) {
                    if (mango_juice.colums_scale != null) {
                        int colums_value = int.parse (line.substring ("table_columns=".length));
                        mango_juice.colums_scale.set_value (colums_value);
                        if (mango_juice.colums_entry != null) {
                            mango_juice.colums_entry.text = "%d".printf (colums_value);
                        }
                    }
                }

                if (line.has_prefix ("toggle_hud=")) {
                    var toggle_hud_value = line.substring ("toggle_hud=".length);
                    mango_juice.toggle_hud_entry.text = toggle_hud_value;
                }

                if (line.has_prefix ("font_size=")) {
                    if (mango_juice.font_size_scale != null) {
                        int font_size_value = int.parse (line.substring ("font_size=".length));
                        mango_juice.font_size_scale.set_value (font_size_value);
                        if (mango_juice.font_size_entry != null) {
                            mango_juice.font_size_entry.text = "%d".printf (font_size_value);
                        }
                    }
                }
               
               if (line.has_prefix ("font_file=")) {
                var font_file = line.substring ("font_file=".length);
                if (font_file.strip() == "") {
                    mango_juice.font_button.label = _("Default");
                    } else {
                        var font_name = Path.get_basename (font_file);
                        mango_juice.font_button.label = font_name;
                    }
                }

                if (line.has_prefix ("gpu_text=")) {
                    mango_juice.gpu_text_entry.text = line.substring ("gpu_text=".length);
                }

                if (line.has_prefix ("gpu_color=")) {
                    var gpu_color = line.substring ("gpu_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + gpu_color);
                    mango_juice.gpu_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("cpu_text=")) {
                    mango_juice.cpu_text_entry.text = line.substring ("cpu_text=".length);
                }

                if (line.has_prefix ("cpu_color=")) {
                    var cpu_color = line.substring ("cpu_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + cpu_color);
                    mango_juice.cpu_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("fps_value=")) {
                    var fps_values = line.substring ("fps_value=".length).split (",");
                    if (fps_values.length == 2) {
                        mango_juice.fps_value_entry_1.text = fps_values[0];
                        mango_juice.fps_value_entry_2.text = fps_values[1];
                    }
                }

                if (line.has_prefix ("fps_color=")) {
                    var fps_colors = line.substring ("fps_color=".length).split (",");
                    if (fps_colors.length == 3) {
                        var rgba_1 = Gdk.RGBA ();
                        rgba_1.parse ("#" + fps_colors[0]);
                        mango_juice.fps_color_button_1.set_rgba (rgba_1);

                        var rgba_2 = Gdk.RGBA ();
                        rgba_2.parse ("#" + fps_colors[1]);
                        mango_juice.fps_color_button_2.set_rgba (rgba_2);

                        var rgba_3 = Gdk.RGBA ();
                        rgba_3.parse ("#" + fps_colors[2]);
                        mango_juice.fps_color_button_3.set_rgba (rgba_3);
                    }
                }

                if (line.has_prefix ("gpu_load_value=")) {
                    var gpu_load_values = line.substring ("gpu_load_value=".length).split (",");
                    if (gpu_load_values.length == 2) {
                        mango_juice.gpu_load_value_entry_1.text = gpu_load_values[0];
                        mango_juice.gpu_load_value_entry_2.text = gpu_load_values[1];
                    }
                }

                if (line.has_prefix ("gpu_load_color=")) {
                    var gpu_load_colors = line.substring ("gpu_load_color=".length).split (",");
                    if (gpu_load_colors.length == 3) {
                        var rgba_1 = Gdk.RGBA ();
                        rgba_1.parse ("#" + gpu_load_colors[0]);
                        mango_juice.gpu_load_color_button_1.set_rgba (rgba_1);

                        var rgba_2 = Gdk.RGBA ();
                        rgba_2.parse ("#" + gpu_load_colors[1]);
                        mango_juice.gpu_load_color_button_2.set_rgba (rgba_2);

                        var rgba_3 = Gdk.RGBA ();
                        rgba_3.parse ("#" + gpu_load_colors[2]);
                        mango_juice.gpu_load_color_button_3.set_rgba (rgba_3);
                    }
                }

                if (line.has_prefix ("cpu_load_value=")) {
                    var cpu_load_values = line.substring ("cpu_load_value=".length).split (",");
                    if (cpu_load_values.length == 2) {
                        mango_juice.cpu_load_value_entry_1.text = cpu_load_values[0];
                        mango_juice.cpu_load_value_entry_2.text = cpu_load_values[1];
                    }
                }

                if (line.has_prefix ("cpu_load_color=")) {
                    var cpu_load_colors = line.substring ("cpu_load_color=".length).split (",");
                    if (cpu_load_colors.length == 3) {
                        var rgba_1 = Gdk.RGBA ();
                        rgba_1.parse ("#" + cpu_load_colors[0]);
                        mango_juice.cpu_load_color_button_1.set_rgba (rgba_1);

                        var rgba_2 = Gdk.RGBA ();
                        rgba_2.parse ("#" + cpu_load_colors[1]);
                        mango_juice.cpu_load_color_button_2.set_rgba (rgba_2);

                        var rgba_3 = Gdk.RGBA ();
                        rgba_3.parse ("#" + cpu_load_colors[2]);
                        mango_juice.cpu_load_color_button_3.set_rgba (rgba_3);
                    }
                }

                if (line.has_prefix ("background_color=")) {
                    var background_color = line.substring ("background_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + background_color);
                    mango_juice.background_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("frametime_color=")) {
                    var frametime_color = line.substring ("frametime_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + frametime_color);
                    mango_juice.frametime_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("vram_color=")) {
                    var vram_color = line.substring ("vram_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + vram_color);
                    mango_juice.vram_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("ram_color=")) {
                    var ram_color = line.substring ("ram_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + ram_color);
                    mango_juice.ram_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("wine_color=")) {
                    var wine_color = line.substring ("wine_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + wine_color);
                    mango_juice.wine_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("engine_color=")) {
                    var engine_color = line.substring ("engine_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + engine_color);
                    mango_juice.engine_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("text_color=")) {
                    var text_color = line.substring ("text_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + text_color);
                    mango_juice.text_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("media_player_color=")) {
                    var media_player_color = line.substring ("media_player_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + media_player_color);
                    mango_juice.media_player_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("network_color=")) {
                    var network_color = line.substring ("network_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + network_color);
                    mango_juice.network_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("battery_color=")) {
                    var battery_color = line.substring ("battery_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + battery_color);
                    mango_juice.battery_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("offset_x=")) {
                    if (mango_juice.offset_x_scale != null) {
                        mango_juice.offset_x_scale.set_value (int.parse (line.substring ("offset_x=".length)));
                        if (mango_juice.offset_x_value_label != null) {
                            mango_juice.offset_x_value_label.label = "%d".printf ((int)mango_juice.offset_x_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("offset_y=")) {
                    if (mango_juice.offset_y_scale != null) {
                        mango_juice.offset_y_scale.set_value (int.parse (line.substring ("offset_y=".length)));
                        if (mango_juice.offset_y_value_label != null) {
                            mango_juice.offset_y_value_label.label = "%d".printf ((int)mango_juice.offset_y_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("fps_sampling_period=")) {
                    if (mango_juice.fps_sampling_period_scale != null) {
                        mango_juice.fps_sampling_period_scale.set_value (int.parse (line.substring ("fps_sampling_period=".length)));
                        if (mango_juice.fps_sampling_period_value_label != null) {
                            mango_juice.fps_sampling_period_value_label.label = "%d ms".printf ((int)mango_juice.fps_sampling_period_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("blacklist=")) {
                    mango_juice.blacklist_entry.text = line.substring ("blacklist=".length);
                }

                if (line.has_prefix ("gpu_list=")) {
                    mango_juice.gpu_entry.text = line.substring ("gpu_list=".length);
                }

                const string[] FORMAT_VALUES = { "title", "artist", "album", "none" };
                
                if (line.has_prefix("media_player_format=")) {
                    var format_str = line.substring("media_player_format=".length).strip();
                    if (format_str.has_prefix("{") && format_str.has_suffix("}")) {
                        format_str = format_str.substring(1, format_str.length-2);
                    }
                    string[] format_parts = format_str.split("};{");
                    
                    for (int i = 0; i < 3 && i < mango_juice.media_format_dropdowns.size; i++) {
                        string part = "none";
                        if (i < format_parts.length) {
                            part = format_parts[i].strip();
                        }
                        
                        var dropdown = mango_juice.media_format_dropdowns.get(i);

                        int selected_index = -1;
                        for (int j = 0; j < FORMAT_VALUES.length; j++) {
                            if (FORMAT_VALUES[j] == part) {
                                selected_index = j;
                                break;
                            }
                        }

                        if (selected_index == -1) {
                            for (int j = 0; j < FORMAT_VALUES.length; j++) {
                                if (FORMAT_VALUES[j] == "none") {
                                    selected_index = j;
                                    break;
                                }
                            }
                        }
                        
                        if (selected_index != -1) {
                            dropdown.selected = selected_index;
                        }
                    }
                }
            }
        } catch (Error e) {
            stderr.printf ("Error reading the file: %s\n", e.message);
        }
        mango_juice.is_loading = false;
    }
    public static void load_switch_from_file (string line, Switch[] switches, string[] config_vars) {
        for (int i = 0; i < config_vars.length; i++) {
            string config_var = config_vars[i];
            if (config_var == "io_read \n io_write") {
                if (line == "io_read" || line == "io_write") {
                    switches[i].active = true;
                }
            } else if (line == config_var) {
                switches[i].active = true;
            }
        }
    }
}
