// load_states.vala

using Gtk;
using Gee;

public class LoadStates {
    public static void load_states_from_file (MangoJuice mango_juice) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                load_switch_from_file (line, mango_juice.gpu_switches, mango_juice.gpu_config_vars);
                load_switch_from_file (line, mango_juice.cpu_switches, mango_juice.cpu_config_vars);
                load_switch_from_file (line, mango_juice.other_switches, mango_juice.other_config_vars);
                load_switch_from_file (line, mango_juice.system_switches, mango_juice.system_config_vars);
                load_switch_from_file (line, mango_juice.wine_switches, mango_juice.wine_config_vars);
                load_switch_from_file (line, mango_juice.battery_switches, mango_juice.battery_config_vars);
                load_switch_from_file (line, mango_juice.other_extra_switches, mango_juice.other_extra_config_vars);
                load_switch_from_file (line, mango_juice.inform_switches, mango_juice.inform_config_vars);
                load_switch_from_file (line, mango_juice.options_switches, mango_juice.options_config_vars);

                if (line.has_prefix ("custom_command=")) {
                    mango_juice.custom_command_entry.text = line.substring ("custom_command=".length);
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

                if (line.has_prefix ("log_duration=")) {
                    if (mango_juice.duracion_scale != null) {
                        mango_juice.duracion_scale.set_value (int.parse (line.substring ("log_duration=".length)));
                        if (mango_juice.duracion_value_label != null) {
                            mango_juice.duracion_value_label.label = "%d s".printf ( (int)mango_juice.duracion_scale.get_value ());
                        }
                    }
                }
                if (line.has_prefix ("autostart_log=")) {
                    if (mango_juice.autostart_scale != null) {
                        mango_juice.autostart_scale.set_value (int.parse (line.substring ("autostart_log=".length)));
                        if (mango_juice.autostart_value_label != null) {
                            mango_juice.autostart_value_label.label = "%d s".printf ( (int)mango_juice.autostart_scale.get_value ());
                        }
                    }
                }
                if (line.has_prefix ("log_interval=")) {
                    if (mango_juice.interval_scale != null) {
                        mango_juice.interval_scale.set_value (int.parse (line.substring ("log_interval=".length)));
                        if (mango_juice.interval_value_label != null) {
                            mango_juice.interval_value_label.label = "%d ms".printf ( (int)mango_juice.interval_scale.get_value ());
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

                if (line.has_prefix ("filter=")) {
                    var filter_value = line.substring ("filter=".length);
                    for (uint i = 0; i < mango_juice.filter_dropdown.model.get_n_items (); i++) {
                        var item = mango_juice.filter_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == filter_value) {
                            mango_juice.filter_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("af=")) {
                    if (mango_juice.af != null) {
                        mango_juice.af.set_value (int.parse (line.substring ("af=".length)));
                        if (mango_juice.af_label != null) {
                            mango_juice.af_label.label = "%d".printf ( (int)mango_juice.af.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("picmip=")) {
                    if (mango_juice.picmip != null) {
                        mango_juice.picmip.set_value (int.parse (line.substring ("picmip=".length)));
                        if (mango_juice.picmip_label != null) {
                            mango_juice.picmip_label.label = "%d".printf ( (int)mango_juice.picmip.get_value ());
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
                        mango_juice.borders_scale.set_value (int.parse (line.substring ("round_corners=".length)));
                        if (mango_juice.borders_value_label != null) {
                            mango_juice.borders_value_label.label = "%d".printf ( (int)mango_juice.borders_scale.get_value ());
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

                if (line.has_prefix ("position=")) {
                    var position_value = line.substring ("position=".length);
                    for (uint i = 0; i < mango_juice.position_dropdown.model.get_n_items (); i++) {
                        var item = mango_juice.position_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == position_value) {
                            mango_juice.position_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("table_columns=")) {
                    if (mango_juice.colums_scale != null) {
                        mango_juice.colums_scale.set_value (int.parse (line.substring ("table_columns=".length)));
                        if (mango_juice.colums_value_label != null) {
                            mango_juice.colums_value_label.label = "%d".printf ( (int)mango_juice.colums_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("toggle_hud=")) {
                    var toggle_hud_value = line.substring ("toggle_hud=".length);
                    mango_juice.toggle_hud_entry.text = toggle_hud_value;
                }

                if (line.has_prefix ("font_size=")) {
                    if (mango_juice.font_size_scale != null) {
                        mango_juice.font_size_scale.set_value (int.parse (line.substring ("font_size=".length)));
                        if (mango_juice.font_size_value_label != null) {
                            mango_juice.font_size_value_label.label = "%d".printf ( (int)mango_juice.font_size_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("font_file=")) {
                    var font_file = line.substring ("font_file=".length);
                    var font_name = Path.get_basename (font_file);
                    for (uint i = 0; i < mango_juice.font_dropdown.model.get_n_items (); i++) {
                        var item = mango_juice.font_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == font_name) {
                            mango_juice.font_dropdown.selected = i;
                            break;
                        }
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
            }
        } catch (Error e) {
            stderr.printf ("Error reading the file: %s\n", e.message);
        }
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