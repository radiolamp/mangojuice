using Gtk;
using Adw;
using Gee;

public class ResetManager {
    private MangoJuice app;

    public ResetManager (MangoJuice app) {
        this.app = app;
    }

    public void reset_all_widgets () {
        reset_switches (app.gpu_switches);
        reset_switches (app.cpu_switches);
        reset_switches (app.other_switches);
        reset_switches (app.system_switches);
        reset_switches (app.wine_switches);
        reset_switches (app.options_switches);
        reset_switches (app.battery_switches);
        reset_switches (app.other_extra_switches);
        reset_switches (app.inform_switches);

        reset_entries ();
        reset_dropdowns ();
        reset_scales ();
        reset_color_buttons ();
    }

    private void reset_switches (Switch[] switches) {
        foreach (var sw in switches) {
            sw.active = false;
        }
    }

    private void reset_entries () {
        app.custom_command_entry.text = "";
        app.custom_logs_path_entry.text = "";
        app.blacklist_entry.text = "";
        app.custom_text_center_entry.text = "";
        app.fps_value_entry_1.text = "";
        app.fps_value_entry_2.text = "";
        app.gpu_load_value_entry_1.text = "";
        app.gpu_load_value_entry_2.text = "";
        app.cpu_load_value_entry_1.text = "";
        app.cpu_load_value_entry_2.text = "";
        app.fps_limit_entry_1.text = "";
        app.fps_limit_entry_2.text = "";
        app.fps_limit_entry_3.text = "";
        app.toggle_hud_entry.text = "";
    }

    private void reset_dropdowns () {
        app.logs_key_combo.selected = 0;
        app.fps_limit_method.selected = 0;
        app.toggle_fps_limit.selected = 0;
        app.vulkan_dropdown.selected = 0;
        app.opengl_dropdown.selected = 0;
        app.filter_dropdown.selected = 0;
        app.position_dropdown.selected = 0;
        app.font_dropdown.selected = 0;
    }

    private void reset_scales () {
        app.duracion_scale.set_value (30);
        app.autostart_scale.set_value (0);
        app.interval_scale.set_value (100);
        app.af.set_value (0);
        app.picmip.set_value (0);
        app.borders_scale.set_value (0);
        app.alpha_scale.set_value (50);
        app.colums_scale.set_value (3);
        app.font_size_scale.set_value (24);
        app.offset_x_scale.set_value (0);
        app.offset_y_scale.set_value (0);
        app.fps_sampling_period_scale.set_value (500);
    }

    private void reset_color_buttons () {
        var default_gpu_color = Gdk.RGBA ();
        default_gpu_color.parse ("#2e9762");
        app.gpu_color_button.set_rgba (default_gpu_color);

        var default_cpu_color = Gdk.RGBA ();
        default_cpu_color.parse ("#2e97cb");
        app.cpu_color_button.set_rgba (default_cpu_color);

        var default_fps_color_1 = Gdk.RGBA ();
        default_fps_color_1.parse ("#cc0000");
        app.fps_color_button_1.set_rgba (default_fps_color_1);

        var default_fps_color_2 = Gdk.RGBA ();
        default_fps_color_2.parse ("#ffaa7f");
        app.fps_color_button_2.set_rgba (default_fps_color_2);

        var default_fps_color_3 = Gdk.RGBA ();
        default_fps_color_3.parse ("#92e79a");
        app.fps_color_button_3.set_rgba (default_fps_color_3);

        var default_gpu_load_color_1 = Gdk.RGBA ();
        default_gpu_load_color_1.parse ("#92e79a");
        app.gpu_load_color_button_1.set_rgba (default_gpu_load_color_1);

        var default_gpu_load_color_2 = Gdk.RGBA ();
        default_gpu_load_color_2.parse ("#ffaa7f");
        app.gpu_load_color_button_2.set_rgba (default_gpu_load_color_2);

        var default_gpu_load_color_3 = Gdk.RGBA ();
        default_gpu_load_color_3.parse ("#cc0000");
        app.gpu_load_color_button_3.set_rgba (default_gpu_load_color_3);

        var default_cpu_load_color_1 = Gdk.RGBA ();
        default_cpu_load_color_1.parse ("#92e79a");
        app.cpu_load_color_button_1.set_rgba (default_cpu_load_color_1);

        var default_cpu_load_color_2 = Gdk.RGBA ();
        default_cpu_load_color_2.parse ("#ffaa7f");
        app.cpu_load_color_button_2.set_rgba (default_cpu_load_color_2);

        var default_cpu_load_color_3 = Gdk.RGBA ();
        default_cpu_load_color_3.parse ("#cc0000");
        app.cpu_load_color_button_3.set_rgba (default_cpu_load_color_3);

        var default_background_color = Gdk.RGBA ();
        default_background_color.parse ("#000000");
        app.background_color_button.set_rgba (default_background_color);

        var default_frametime_color = Gdk.RGBA ();
        default_frametime_color.parse ("#00ff00");
        app.frametime_color_button.set_rgba (default_frametime_color);

        var default_vram_color = Gdk.RGBA ();
        default_vram_color.parse ("#ad64c1");
        app.vram_color_button.set_rgba (default_vram_color);

        var default_ram_color = Gdk.RGBA ();
        default_ram_color.parse ("#c26693");
        app.ram_color_button.set_rgba (default_ram_color);

        var default_wine_color = Gdk.RGBA ();
        default_wine_color.parse ("#eb5b5b");
        app.wine_color_button.set_rgba (default_wine_color);

        var default_engine_color = Gdk.RGBA ();
        default_engine_color.parse ("#eb5b5b");
        app.engine_color_button.set_rgba (default_engine_color);

        var default_text_color = Gdk.RGBA ();
        default_text_color.parse ("#FFFFFF");
        app.text_color_button.set_rgba (default_text_color);

        var default_media_player_color = Gdk.RGBA ();
        default_media_player_color.parse ("#FFFFFF");
        app.media_player_color_button.set_rgba (default_media_player_color);

        var default_network_color = Gdk.RGBA ();
        default_network_color.parse ("#e07b85");
        app.network_color_button.set_rgba (default_network_color);
    }
}