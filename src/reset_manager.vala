/* reset_manager.vala // Licence:  GPL-v3.0 */
using Gtk;
using Adw;
using Gee;

public class ResetManager {
    MangoJuice app;

    const string DEFAULT_TOGGLE_HUD_SHORTCUT = "Shift_R+F11";
    const string DEFAULT_TOGGLE_POSIC_SHORTCUT = "Shift_R+F12";
    const string DEFAULT_TOGGLE_FPS_LIMIT_SHORTCUT = "Shift_L+F1";
    const string DEFAULT_LOGS_SHORTCUT = "Shift_L+F2";

    public ResetManager (MangoJuice app) {
        this.app = app;
    }

    public void reset_all_widgets () {
        reset_all_switches();
        reset_media_format_dropdowns();
        reset_entries();
        reset_dropdowns();
        reset_scales();
        reset_color_buttons();
        reset_custom_switch();
        reset_shortcut_recorders();
    }

    void reset_all_switches() {
        if (app.gpu_switches != null) reset_switches(app.gpu_switches);
        if (app.cpu_switches != null) reset_switches(app.cpu_switches);
        if (app.memory_switches != null) reset_switches(app.memory_switches);
        if (app.git_switches != null) reset_switches(app.git_switches);
        if (app.system_switches != null) reset_switches(app.system_switches);
        if (app.wine_switches != null) reset_switches(app.wine_switches);
        if (app.options_switches != null) reset_switches(app.options_switches);
        if (app.battery_switches != null) reset_switches(app.battery_switches);
        if (app.other_extra_switches != null) reset_switches(app.other_extra_switches);
        if (app.inform_switches != null) reset_switches(app.inform_switches);
    }

    void reset_switches (Switch[] switches) {
        if (switches == null) return;
        
        foreach (var sw in switches) {
            if (sw != null) {
                sw.active = false;
            }
        }
    }

    public void reset_shortcut_recorders() {
        if (app.toggle_hud_key_recorder != null) {
            app.toggle_hud_key_recorder.shortcut = DEFAULT_TOGGLE_HUD_SHORTCUT;
        }
        
        if (app.toggle_posic != null) {
            app.toggle_posic.shortcut = DEFAULT_TOGGLE_POSIC_SHORTCUT;
        }
    
        if (app.toggle_fps_limit_recorder != null) {
            app.toggle_fps_limit_recorder.shortcut = DEFAULT_TOGGLE_FPS_LIMIT_SHORTCUT;
        }

        if (app.logs_key_recorder != null) {
            app.logs_key_recorder.shortcut = DEFAULT_LOGS_SHORTCUT;
        }
        
        if (app.toggle_hud_entry != null) {
            app.toggle_hud_entry.text = DEFAULT_TOGGLE_POSIC_SHORTCUT;
        }
    }

    void reset_entries () {
        if (app.custom_command_entry != null) app.custom_command_entry.text = "";
        if (app.custom_logs_path_entry != null) app.custom_logs_path_entry.text = "";
        if (app.blacklist_entry != null) app.blacklist_entry.text = "";
        if (app.custom_text_center_entry != null) app.custom_text_center_entry.text = "";
        if (app.fps_value_entry_1 != null) app.fps_value_entry_1.text = "";
        if (app.fps_value_entry_2 != null) app.fps_value_entry_2.text = "";
        if (app.gpu_load_value_entry_1 != null) app.gpu_load_value_entry_1.text = "";
        if (app.gpu_load_value_entry_2 != null) app.gpu_load_value_entry_2.text = "";
        if (app.cpu_load_value_entry_1 != null) app.cpu_load_value_entry_1.text = "";
        if (app.cpu_load_value_entry_2 != null) app.cpu_load_value_entry_2.text = "";
        if (app.fps_limit_entry_1 != null) app.fps_limit_entry_1.text = "";
        if (app.fps_limit_entry_2 != null) app.fps_limit_entry_2.text = "";
        if (app.fps_limit_entry_3 != null) app.fps_limit_entry_3.text = "";
        if (app.toggle_hud_entry != null) app.toggle_hud_entry.text = "";
    }

    void reset_media_format_dropdowns() {
        if (app.media_format_dropdowns != null && app.media_format_dropdowns.size >= 3) {
            if (app.media_format_dropdowns[0] != null) app.media_format_dropdowns[0].selected = 0;
            if (app.media_format_dropdowns[1] != null) app.media_format_dropdowns[1].selected = 1;
            if (app.media_format_dropdowns[2] != null) app.media_format_dropdowns[2].selected = 2;
        }
    }

    void reset_custom_switch () {
        if (app.custom_switch != null) {
            app.custom_switch.active = false;
        }
    }

    void reset_dropdowns () {
        if (app.fps_limit_method != null) app.fps_limit_method.selected = 0;
        if (app.vulkan_dropdown != null) app.vulkan_dropdown.selected = 0;
        if (app.opengl_dropdown != null) app.opengl_dropdown.selected = 0;
        if (app.filter_dropdown != null) app.filter_dropdown.selected = 0;
        if (app.position_dropdown != null) app.position_dropdown.selected = 0;
        if (app.font_button != null) app.font_button.label = _("Default");
    }

    void reset_scales () {
        if (app.duracion_scale != null) app.duracion_scale.set_value(30);
        if (app.autostart_scale != null) app.autostart_scale.set_value(0);
        if (app.interval_scale != null) app.interval_scale.set_value(100);
        if (app.af != null) app.af.set_value(0);
        if (app.picmip != null) app.picmip.set_value(0);
        if (app.borders_scale != null) app.borders_scale.set_value(0);
        if (app.alpha_scale != null) app.alpha_scale.set_value(5);
        if (app.colums_scale != null) app.colums_scale.set_value(3);
        if (app.font_size_scale != null) app.font_size_scale.set_value(24);
        if (app.offset_x_scale != null) app.offset_x_scale.set_value(0);
        if (app.offset_y_scale != null) app.offset_y_scale.set_value(0);
        if (app.fps_sampling_period_scale != null) app.fps_sampling_period_scale.set_value(500);
    }

    void reset_color_buttons () {
        reset_color_button(app.gpu_color_button, "#2e9762");
        reset_color_button(app.cpu_color_button, "#2e97cb");
        reset_color_button(app.fps_color_button_1, "#cc0000");
        reset_color_button(app.fps_color_button_2, "#ffaa7f");
        reset_color_button(app.fps_color_button_3, "#92e79a");
        reset_color_button(app.gpu_load_color_button_1, "#92e79a");
        reset_color_button(app.gpu_load_color_button_2, "#ffaa7f");
        reset_color_button(app.gpu_load_color_button_3, "#cc0000");
        reset_color_button(app.cpu_load_color_button_1, "#92e79a");
        reset_color_button(app.cpu_load_color_button_2, "#ffaa7f");
        reset_color_button(app.cpu_load_color_button_3, "#cc0000");
        reset_color_button(app.background_color_button, "#000000");
        reset_color_button(app.frametime_color_button, "#00ff00");
        reset_color_button(app.vram_color_button, "#ad64c1");
        reset_color_button(app.ram_color_button, "#c26693");
        reset_color_button(app.wine_color_button, "#eb5b5b");
        reset_color_button(app.engine_color_button, "#eb5b5b");
        reset_color_button(app.text_color_button, "#FFFFFF");
        reset_color_button(app.media_player_color_button, "#FFFFFF");
        reset_color_button(app.network_color_button, "#e07b85");
        reset_color_button(app.battery_color_button, "#92e79a");
    }

    void reset_color_button(ColorDialogButton? button, string hex_color) {
        if (button != null) {
            var color = Gdk.RGBA();
            if (color.parse(hex_color)) {
                button.set_rgba(color);
            }
        }
    }
}