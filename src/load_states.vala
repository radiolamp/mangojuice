/* load_states.vala // License: GPL-3.0+ */

using Gtk;
using Gee;

delegate void LoadFunc (MangoJuice app, string line);

abstract class LineLoader {
    public abstract void load (MangoJuice app, string line);
}

class SimpleLoader : LineLoader {
    private LoadFunc _func;
    public SimpleLoader (owned LoadFunc func) { _func = (owned) func; }
    public override void load (MangoJuice app, string line) { _func (app, line); }
}

public class LoadStates {

    static HashMap<string, LineLoader>? _loaders = null;

    delegate Scale? ScaleGetter (MangoJuice app);
    delegate Entry? EntryGetter (MangoJuice app);
    delegate Label? LabelGetter (MangoJuice app);
    delegate ColorDialogButton? ColorGetter (MangoJuice app);

    static void add_loader (string prefix, owned LoadFunc func) {
        _loaders[prefix] = new SimpleLoader ((owned) func);
    }

    static void add_scale_entry_loader (string prefix, ScaleGetter sg, EntryGetter eg) {
        add_loader (prefix, (app, line) => {
            var scale = sg (app);
            if (scale == null) return;
            int val = int.parse (line.substring (prefix.length));
            scale.set_value (val);
            var entry = eg (app);
            if (entry != null) entry.text = "%d".printf (val);
        });
    }

    static void add_scale_label_loader (string prefix, ScaleGetter sg, LabelGetter lg, string suffix = "") {
        add_loader (prefix, (app, line) => {
            var scale = sg (app);
            if (scale == null) return;
            int val = int.parse (line.substring (prefix.length));
            scale.set_value (val);
            var label = lg (app);
            if (label != null) label.label = "%d %s".printf (val, suffix).strip ();
        });
    }

    static void add_color_loader (string prefix, ColorGetter cg) {
        add_loader (prefix, (app, line) => {
            var color = line.substring (prefix.length);
            var rgba = Gdk.RGBA ();
            rgba.parse ("#" + color);
            cg (app).set_rgba (rgba);
        });
    }

    static void add_triple_color_loader (string prefix, ColorGetter c1, ColorGetter c2, ColorGetter c3) {
        add_loader (prefix, (app, line) => {
            var parts = line.substring (prefix.length).split (",");
            if (parts.length != 3) return;
            var rgba = Gdk.RGBA ();
            rgba.parse ("#" + parts[0]); c1 (app).set_rgba (rgba);
            rgba.parse ("#" + parts[1]); c2 (app).set_rgba (rgba);
            rgba.parse ("#" + parts[2]); c3 (app).set_rgba (rgba);
        });
    }

    static HashMap<string, LineLoader> get_loaders () {
        if (_loaders != null) return _loaders;
        _loaders = new HashMap<string, LineLoader> ();

        add_loader ("toggle_logging=", (app, line) => {
            app.logs_key_recorder.shortcut = line.substring ("toggle_logging=".length);
        });
        add_loader ("toggle_hud_position=", (app, line) => {
            app.toggle_hud_key_recorder.shortcut = line.substring ("toggle_hud_position=".length);
        });
        add_loader ("toggle_fps_limit=", (app, line) => {
            var val = line.substring ("toggle_fps_limit=".length).strip ();
            if (app.toggle_fps_limit_recorder != null)
                app.toggle_fps_limit_recorder.shortcut = val;
        });
        add_loader ("output_folder=", (app, line) => {
            app.custom_logs_path_entry.text = line.substring ("output_folder=".length);
        });
        add_loader ("custom_text_center=", (app, line) => {
            app.custom_text_center_entry.text = line.substring ("custom_text_center=".length);
        });
        add_loader ("blacklist=", (app, line) => {
            app.blacklist_entry.text = line.substring ("blacklist=".length);
        });
        add_loader ("gpu_list=", (app, line) => {
            app.gpu_entry.text = line.substring ("gpu_list=".length);
        });
        add_loader ("gpu_text=", (app, line) => {
            app.gpu_text_entry.text = line.substring ("gpu_text=".length);
        });
        add_loader ("cpu_text=", (app, line) => {
            app.cpu_text_entry.text = line.substring ("cpu_text=".length);
        });
        add_loader ("toggle_hud=", (app, line) => {
            var val = line.substring ("toggle_hud=".length);
            app.toggle_hud_entry.text = val;
            if (app.toggle_posic != null) app.toggle_posic.shortcut = val;
        });
        add_loader ("font_file=", (app, line) => {
            var val = line.substring ("font_file=".length);
            if (val.strip () == "")
                app.font_button.label = _("Default");
            else
                app.font_button.label = Path.get_basename (val);
        });

        add_scale_entry_loader ("log_duration=", (app) => app.duracion_scale, (app) => app.duracion_entry);
        add_scale_entry_loader ("autostart_log=", (app) => app.autostart_scale, (app) => app.autostart_entry);
        add_scale_entry_loader ("log_interval=", (app) => app.interval_scale, (app) => app.interval_entry);
        add_scale_entry_loader ("round_corners=", (app) => app.borders_scale, (app) => app.borders_entry);
        add_scale_entry_loader ("table_columns=", (app) => app.colums_scale, (app) => app.colums_entry);
        add_scale_entry_loader ("font_size=", (app) => app.font_size_scale, (app) => app.font_size_entry);
        add_scale_entry_loader ("font_size_secondary=", (app) => app.font_size_secondary_scale, (app) => app.font_size_secondary_entry);
        add_scale_entry_loader ("af=", (app) => app.af, (app) => app.af_entry);
        add_scale_entry_loader ("picmip=", (app) => app.picmip, (app) => app.picmip_entry);

        add_scale_label_loader ("offset_x=", (app) => app.offset_x_scale, (app) => app.offset_x_value_label);
        add_scale_label_loader ("offset_y=", (app) => app.offset_y_scale, (app) => app.offset_y_value_label);
        add_scale_label_loader ("fps_sampling_period=", (app) => app.fps_sampling_period_scale, (app) => app.fps_sampling_period_value_label, "ms");

        add_color_loader ("gpu_color=", (app) => app.gpu_color_button);
        add_color_loader ("cpu_color=", (app) => app.cpu_color_button);
        add_color_loader ("background_color=", (app) => app.background_color_button);
        add_color_loader ("frametime_color=", (app) => app.frametime_color_button);
        add_color_loader ("vram_color=", (app) => app.vram_color_button);
        add_color_loader ("ram_color=", (app) => app.ram_color_button);
        add_color_loader ("wine_color=", (app) => app.wine_color_button);
        add_color_loader ("engine_color=", (app) => app.engine_color_button);
        add_color_loader ("text_color=", (app) => app.text_color_button);
        add_color_loader ("media_player_color=", (app) => app.media_player_color_button);
        add_color_loader ("network_color=", (app) => app.network_color_button);
        add_color_loader ("battery_color=", (app) => app.battery_color_button);
        add_color_loader ("horizontal_separator_color=", (app) => app.horizontal_separator_color_button);

        add_loader ("fps_limit=", (app, line) => {
            var parts = line.substring ("fps_limit=".length).split (",");
            if (parts.length == 3) {
                app.fps_limit_entry_1.text = parts[0];
                app.fps_limit_entry_2.text = parts[1];
                app.fps_limit_entry_3.text = parts[2];
            }
        });
        add_loader ("fps_value=", (app, line) => {
            var parts = line.substring ("fps_value=".length).split (",");
            if (parts.length == 2) {
                app.fps_value_entry_1.text = parts[0];
                app.fps_value_entry_2.text = parts[1];
            }
        });
        add_loader ("gpu_load_value=", (app, line) => {
            var parts = line.substring ("gpu_load_value=".length).split (",");
            if (parts.length == 2) {
                app.gpu_load_value_entry_1.text = parts[0];
                app.gpu_load_value_entry_2.text = parts[1];
            }
        });
        add_loader ("cpu_load_value=", (app, line) => {
            var parts = line.substring ("cpu_load_value=".length).split (",");
            if (parts.length == 2) {
                app.cpu_load_value_entry_1.text = parts[0];
                app.cpu_load_value_entry_2.text = parts[1];
            }
        });

        add_triple_color_loader ("fps_color=", (app) => app.fps_color_button_1, (app) => app.fps_color_button_2, (app) => app.fps_color_button_3);
        add_triple_color_loader ("gpu_load_color=", (app) => app.gpu_load_color_button_1, (app) => app.gpu_load_color_button_2, (app) => app.gpu_load_color_button_3);
        add_triple_color_loader ("cpu_load_color=", (app) => app.cpu_load_color_button_1, (app) => app.cpu_load_color_button_2, (app) => app.cpu_load_color_button_3);

        add_loader ("fps_limit_method=", (app, line) => {
            var val = line.substring ("fps_limit_method=".length);
            for (uint i = 0; i < app.fps_limit_method.model.get_n_items (); i++) {
                var item = app.fps_limit_method.model.get_item (i) as StringObject;
                if (item != null && item.get_string () == val) { app.fps_limit_method.selected = i; break; }
            }
        });
        add_loader ("vsync=", (app, line) => {
            var val = line.substring ("vsync=".length);
            var label = app.get_vulkan_value_from_config (val);
            for (uint i = 0; i < app.vulkan_dropdown.model.get_n_items (); i++) {
                var item = app.vulkan_dropdown.model.get_item (i) as StringObject;
                if (item != null && item.get_string () == label) { app.vulkan_dropdown.selected = i; break; }
            }
        });
        add_loader ("gl_vsync=", (app, line) => {
            var val = line.substring ("gl_vsync=".length);
            var label = app.get_opengl_value_from_config (val);
            for (uint i = 0; i < app.opengl_dropdown.model.get_n_items (); i++) {
                var item = app.opengl_dropdown.model.get_item (i) as StringObject;
                if (item != null && item.get_string () == label) { app.opengl_dropdown.selected = i; break; }
            }
        });

        add_loader ("pci_dev=", (app, line) => {
            if (app.gpu_dropdown == null) return;
            var addr = line.substring ("pci_dev=".length).strip ().replace ("0000:", "");
            var model = app.gpu_dropdown.model;
            for (uint i = 0; i < model.get_n_items (); i++) {
                var item = model.get_item (i) as Gtk.StringObject;
                if (item != null && item.get_string ().contains (addr)) {
                    app.gpu_dropdown.selected = i;
                    break;
                }
            }
        });

        add_loader ("background_alpha=", (app, line) => {
            if (app.alpha_scale == null) return;
            double v = double.parse (line.substring ("background_alpha=".length));
            app.alpha_scale.set_value (v * 10);
            if (app.alpha_value_label != null)
                app.alpha_value_label.label = "%.1f".printf (v);
        });

        add_loader ("position=", (app, line) => {
            var val = line.substring ("position=".length);
            var map = new Gee.HashMap<string, string> ();
            map["top-left"] = _("Top Left"); map["top-center"] = _("Top Center");
            map["top-right"] = _("Top Right"); map["middle-left"] = _("Middle Left");
            map["middle-right"] = _("Middle Right"); map["bottom-left"] = _("Bottom Left");
            map["bottom-center"] = _("Bottom Center"); map["bottom-right"] = _("Bottom Right");
            string? label = map[val];
            if (label != null && app.position_dropdown != null) {
                var model = app.position_dropdown.model as Gtk.StringList;
                for (uint i = 0; i < model.get_n_items (); i++) {
                    if (model.get_string (i) == label) { app.position_dropdown.selected = i; break; }
                }
            }
        });

        add_loader ("horizontal", (app, line) => {
            app.custom_switch.active = true;
        });

        add_loader ("#filters", (app, line) => {
            var val = line.split ("#filters")[0].strip ();
            string[] vals = {"none", "bicubic", "trilinear", "retro"};
            for (uint i = 0; i < vals.length; i++) {
                if (vals[i] == val) { app.filter_dropdown.selected = i; break; }
            }
        });

        add_loader ("media_player_format=", (app, line) => {
            var val = line.substring ("media_player_format=".length).strip ();
            if (val.has_prefix ("{") && val.has_suffix ("}"))
                val = val.substring (1, val.length - 2);
            string[] parts = val.split ("};{");
            const string[] fv = { "title", "artist", "album", "none" };
            for (int i = 0; i < 3 && i < app.media_format_dropdowns.size; i++) {
                string part = "none";
                if (i < parts.length) part = parts[i].strip ();
                int idx = -1;
                for (int j = 0; j < fv.length; j++) { if (fv[j] == part) { idx = j; break; } }
                if (idx == -1) { for (int j = 0; j < fv.length; j++) { if (fv[j] == "none") { idx = j; break; } } }
                if (idx != -1) app.media_format_dropdowns.get (i).selected = idx;
            }
        });

        return _loaders;
    }

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
            var custom_commands = new Gee.ArrayList<string> ();
            var loaders = get_loaders ();

            while ((line = yield data_stream.read_line_async ()) != null) {
                load_switch_from_file (line, mango_juice.gpu_switches, mango_juice.gpu_config_vars);
                load_switch_from_file (line, mango_juice.cpu_switches, mango_juice.cpu_config_vars);
                load_switch_from_file (line, mango_juice.memory_switches, mango_juice.memory_config_vars);
                if (Config.IS_DEVEL) {
                    load_switch_from_file (line, mango_juice.git_switches, mango_juice.git_config_vars);
                }
                load_switch_from_file (line, mango_juice.system_switches, mango_juice.system_config_vars);
                load_switch_from_file (line, mango_juice.wine_switches, mango_juice.wine_config_vars);
                load_switch_from_file (line, mango_juice.battery_switches, mango_juice.battery_config_vars);
                load_switch_from_file (line, mango_juice.other_extra_switches, mango_juice.other_extra_config_vars);
                load_switch_from_file (line, mango_juice.inform_switches, mango_juice.inform_config_vars);
                load_switch_from_file (line, mango_juice.options_switches, mango_juice.options_config_vars);

                if (line.contains ("#custom_command")) {
                    var val = line.split ("#custom_command")[0].strip ();
                    if (val != "") custom_commands.add (val);
                    continue;
                }

                string stripped = line.strip ();

                if (loaders.has_key (stripped)) {
                    loaders[stripped].load (mango_juice, stripped);
                    continue;
                }

                foreach (var entry in loaders.entries) {
                    if (entry.key.has_suffix ("=") && stripped.has_prefix (entry.key)) {
                        entry.value.load (mango_juice, stripped);
                        break;
                    }
                }
            }

            if (custom_commands.size > 0) {
                mango_juice.custom_command_entry.text = string.joinv (", ", (string[]) custom_commands.to_array ());
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
