/* config/reset_manager.vala // License: GPL-3.0+ */
using Gtk;
using Adw;
using Gee;
using MangoJuice;

namespace MangoJuice.Config {

public class ResetManager {
    State state;

    const string DEFAULT_TOGGLE_HUD_SHORTCUT = "Shift_R+F11";
    const string DEFAULT_TOGGLE_POSIC_SHORTCUT = "Shift_R+F12";
    const string DEFAULT_TOGGLE_FPS_LIMIT_SHORTCUT = "Shift_L+F1";
    const string DEFAULT_LOGS_SHORTCUT = "Shift_L+F2";

    public ResetManager (State state) {
        this.state = state;
    }

    public void reset_all_widgets () {
        state.custom_order_changed = false;
        reset_all_switches ();
        reset_media_format_dropdowns ();
        reset_entries ();
        reset_dropdowns ();
        reset_scales ();
        reset_color_buttons ();
        reset_custom_switch ();
        reset_shortcut_recorders ();
    }

    void reset_all_switches () {
        if (state.gpu_switches != null) reset_switches (state.gpu_switches);
        if (state.cpu_switches != null) reset_switches (state.cpu_switches);
        if (state.memory_switches != null) reset_switches (state.memory_switches);
        if (state.git_switches != null) reset_switches (state.git_switches);
        if (state.system_switches != null) reset_switches (state.system_switches);
        if (state.wine_switches != null) reset_switches (state.wine_switches);
        if (state.options_switches != null) reset_switches (state.options_switches);
        if (state.battery_switches != null) reset_switches (state.battery_switches);
        if (state.other_extra_switches != null) reset_switches (state.other_extra_switches);
        if (state.inform_switches != null) reset_switches (state.inform_switches);
    }

    void reset_switches (Switch[] switches) {
        if (switches == null) return;

        foreach (var sw in switches) {
            if (sw != null) {
                sw.active = false;
            }
        }
    }

    public void reset_shortcut_recorders () {
        if (state.toggle_hud_key_recorder != null) {
            state.toggle_hud_key_recorder.shortcut = DEFAULT_TOGGLE_HUD_SHORTCUT;
        }

        if (state.toggle_posic != null) {
            state.toggle_posic.shortcut = DEFAULT_TOGGLE_POSIC_SHORTCUT;
        }

        if (state.toggle_fps_limit_recorder != null) {
            state.toggle_fps_limit_recorder.shortcut = DEFAULT_TOGGLE_FPS_LIMIT_SHORTCUT;
        }

        if (state.logs_key_recorder != null) {
            state.logs_key_recorder.shortcut = DEFAULT_LOGS_SHORTCUT;
        }

        if (state.toggle_hud_entry != null) {
            state.toggle_hud_entry.text = DEFAULT_TOGGLE_POSIC_SHORTCUT;
        }
    }

    void reset_entries () {
        if (state.custom_command_entry != null) state.custom_command_entry.text = "";
        if (state.custom_logs_path_entry != null) state.custom_logs_path_entry.text = "";
        if (state.blacklist_entry != null) state.blacklist_entry.text = "";
        if (state.custom_text_center_entry != null) state.custom_text_center_entry.text = "";
        if (state.fps_value_entry_1 != null) state.fps_value_entry_1.text = "";
        if (state.fps_value_entry_2 != null) state.fps_value_entry_2.text = "";
        if (state.gpu_load_value_entry_1 != null) state.gpu_load_value_entry_1.text = "";
        if (state.gpu_load_value_entry_2 != null) state.gpu_load_value_entry_2.text = "";
        if (state.cpu_load_value_entry_1 != null) state.cpu_load_value_entry_1.text = "";
        if (state.cpu_load_value_entry_2 != null) state.cpu_load_value_entry_2.text = "";
        if (state.fps_limit_entry_1 != null) state.fps_limit_entry_1.text = "";
        if (state.fps_limit_entry_2 != null) state.fps_limit_entry_2.text = "";
        if (state.fps_limit_entry_3 != null) state.fps_limit_entry_3.text = "";
        if (state.toggle_hud_entry != null) state.toggle_hud_entry.text = "";
    }

    void reset_media_format_dropdowns () {
        if (state.media_format_dropdowns != null && state.media_format_dropdowns.size >= 3) {
            if (state.media_format_dropdowns[0] != null) state.media_format_dropdowns[0].selected = 0;
            if (state.media_format_dropdowns[1] != null) state.media_format_dropdowns[1].selected = 1;
            if (state.media_format_dropdowns[2] != null) state.media_format_dropdowns[2].selected = 2;
        }
    }

    void reset_custom_switch () {
        if (state.custom_switch != null) {
            state.custom_switch.active = false;
        }
    }

    void reset_dropdowns () {
        if (state.fps_limit_method != null) state.fps_limit_method.selected = 0;
        if (state.vulkan_dropdown != null) state.vulkan_dropdown.selected = 0;
        if (state.opengl_dropdown != null) state.opengl_dropdown.selected = 0;
        if (state.filter_dropdown != null) state.filter_dropdown.selected = 0;
        if (state.position_dropdown != null) state.position_dropdown.selected = 0;
        if (state.font_button != null) state.font_button.label = _("Default");
    }

    void reset_scales () {
        if (state.duracion_scale != null) state.duracion_scale.set_value (30);
        if (state.autostart_scale != null) state.autostart_scale.set_value (0);
        if (state.interval_scale != null) state.interval_scale.set_value (100);
        if (state.af != null) state.af.set_value (0);
        if (state.picmip != null) state.picmip.set_value (0);
        if (state.borders_scale != null) state.borders_scale.set_value (0);
        if (state.alpha_scale != null) state.alpha_scale.set_value (5);
        if (state.colums_scale != null) state.colums_scale.set_value (3);
        if (state.font_size_scale != null) state.font_size_scale.set_value (24);
        if (state.font_size_secondary_scale != null) state.font_size_secondary_scale.set_value (12);
        if (state.offset_x_scale != null) state.offset_x_scale.set_value (0);
        if (state.offset_y_scale != null) state.offset_y_scale.set_value (0);
        if (state.fps_sampling_period_scale != null) state.fps_sampling_period_scale.set_value (500);
    }

    void reset_color_buttons () {
        reset_color_button (state.gpu_color_button, "#2e9762");
        reset_color_button (state.cpu_color_button, "#2e97cb");
        reset_color_button (state.fps_color_button_1, "#cc0000");
        reset_color_button (state.fps_color_button_2, "#ffaa7f");
        reset_color_button (state.fps_color_button_3, "#92e79a");
        reset_color_button (state.gpu_load_color_button_1, "#92e79a");
        reset_color_button (state.gpu_load_color_button_2, "#ffaa7f");
        reset_color_button (state.gpu_load_color_button_3, "#cc0000");
        reset_color_button (state.cpu_load_color_button_1, "#92e79a");
        reset_color_button (state.cpu_load_color_button_2, "#ffaa7f");
        reset_color_button (state.cpu_load_color_button_3, "#cc0000");
        reset_color_button (state.background_color_button, "#000000");
        reset_color_button (state.frametime_color_button, "#00ff00");
        reset_color_button (state.vram_color_button, "#ad64c1");
        reset_color_button (state.ram_color_button, "#c26693");
        reset_color_button (state.wine_color_button, "#eb5b5b");
        reset_color_button (state.engine_color_button, "#eb5b5b");
        reset_color_button (state.text_color_button, "#FFFFFF");
        reset_color_button (state.media_player_color_button, "#FFFFFF");
        reset_color_button (state.network_color_button, "#e07b85");
        reset_color_button (state.battery_color_button, "#92e79a");
        reset_color_button (state.horizontal_separator_color_button, "#FFFFFF");
    }

    void reset_color_button (ColorDialogButton? button, string hex_color) {
        if (button != null) {
            var color = Gdk.RGBA ();
            if (color.parse (hex_color)) {
                button.set_rgba (color);
            }
        }
    }
}

}
