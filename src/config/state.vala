/* config/state.vala // License: GPL-3.0+ */
using Gtk;
using Gee;
using MangoJuice.UI;

namespace MangoJuice.Config {

public class State : GLib.Object {

    // UI Elements
    public Button reset_button;
    public Button logs_path_button;
    public Button intel_power_fix_button;
    public Switch[] gpu_switches;
    public Switch[] cpu_switches;
    public Switch[] memory_switches;
    public Switch[] git_switches;
    public Switch[] system_switches;
    public Switch[] wine_switches;
    public Switch[] options_switches;
    public Switch[] battery_switches;
    public Switch[] other_extra_switches;
    public Switch[] inform_switches;
    public Label[] gpu_labels;
    public Label[] cpu_labels;
    public Label[] memory_labels;
    public Label[] git_labels;
    public Label[] system_labels;
    public Label[] wine_labels;
    public Label[] options_labels;
    public Label[] battery_labels;
    public Label[] other_extra_labels;
    public Label[] inform_labels;
    public Entry custom_command_entry;
    public Entry custom_logs_path_entry;
    public DropDown fps_limit_method;
    public DropDown vulkan_dropdown;
    public DropDown opengl_dropdown;
    public Scale duracion_scale;
    public Scale autostart_scale;
    public Scale interval_scale;
    public Entry duracion_entry;
    public Entry autostart_entry;
    public Entry interval_entry;
    public DropDown filter_dropdown;
    public Scale af;
    public Scale picmip;
    public Entry picmip_entry;
    public Entry af_entry;
    public Entry fps_sampling_period_entry;
    public Entry fps_limit_entry_1;
    public Entry fps_limit_entry_2;
    public Entry fps_limit_entry_3;
    public Entry custom_text_center_entry;
    public Switch custom_switch;
    public Scale borders_scale;
    public Scale alpha_scale;
    public Entry borders_entry;
    public Entry alpha_entry;
    public Label alpha_value_label;
    public DropDown position_dropdown;
    public Scale colums_scale;
    public Entry colums_entry;
    public Entry toggle_hud_entry;
    public Scale font_size_scale;
    public Entry font_size_entry;
    public Scale font_size_secondary_scale;
    public Entry font_size_secondary_entry;
    public Button font_button;
    public Entry gpu_text_entry;
    public ColorDialogButton gpu_color_button;
    public Entry cpu_text_entry;
    public ColorDialogButton cpu_color_button;
    public Entry fps_value_entry_1;
    public Entry fps_value_entry_2;
    public ColorDialogButton fps_color_button_1;
    public ColorDialogButton fps_color_button_2;
    public ColorDialogButton fps_color_button_3;
    public Entry gpu_load_value_entry_1;
    public Entry gpu_load_value_entry_2;
    public ColorDialogButton gpu_load_color_button_1;
    public ColorDialogButton gpu_load_color_button_2;
    public ColorDialogButton gpu_load_color_button_3;
    public Entry cpu_load_value_entry_1;
    public Entry cpu_load_value_entry_2;
    public ColorDialogButton cpu_load_color_button_1;
    public ColorDialogButton cpu_load_color_button_2;
    public ColorDialogButton cpu_load_color_button_3;
    public ColorDialogButton background_color_button;
    public ColorDialogButton frametime_color_button;
    public ColorDialogButton vram_color_button;
    public ColorDialogButton ram_color_button;
    public ColorDialogButton wine_color_button;
    public ColorDialogButton engine_color_button;
    public ColorDialogButton text_color_button;
    public ColorDialogButton media_player_color_button;
    public ColorDialogButton network_color_button;
    public ColorDialogButton battery_color_button;
    public ColorDialogButton horizontal_separator_color_button;
    public Entry blacklist_entry;
    public Entry gpu_entry;
    public Scale offset_x_scale;
    public Scale offset_y_scale;
    public Label offset_x_value_label;
    public Label offset_y_value_label;
    public Entry offset_x_entry;
    public Entry offset_y_entry;
    public Scale fps_sampling_period_scale;
    public Label fps_sampling_period_value_label;
    public Button mangohud_global_button;
    public Gee.ArrayList<DropDown> media_format_dropdowns { get; set; }
    public ShortcutRecorder toggle_posic;
    public ShortcutRecorder toggle_hud_key_recorder;
    public ShortcutRecorder toggle_fps_limit_recorder;
    public ShortcutRecorder logs_key_recorder;
    public bool is_loading = false;
    public bool custom_order_changed { get; set; default = false; }
    public string[] gpu_config_vars = {
        "gpu_stats", "gpu_load_change", "vram", "gpu_core_clock", "gpu_mem_clock",
        "gpu_temp", "gpu_mem_temp", "gpu_junction_temp", "gpu_fan", "gpu_name",
        "gpu_power", "gpu_voltage", "throttling_status",
        "throttling_status_graph", "vulkan_driver",
        "gpu_efficiency", "engine_version",
        "gpu_power_limit", "proc_vram"
    };
    public string[] cpu_config_vars = {
        "cpu_stats", "cpu_load_change", "core_load", "core_load_change", "core_bars", "cpu_mhz", "cpu_temp",
        "cpu_power", "core_type", "cpu_efficiency", "flip_efficiency"
    };
    public string[] memory_config_vars = {
        "ram", "io_read", "io_write", "procmem", "procmem_shared", "procmem_virt", "swap", "ram_temp"
    };
    public string[] git_config_vars = {
        "hide_fsr_sharpness"
    };
    public string[] system_config_vars = {
        "refresh_rate", "fan", "resolution", "display_server", "engine_short_names", "time", "arch", "network"
    };
    public string[] wine_config_vars = {
        "wine", "winesync"
    };
    public string[] battery_config_vars = {
        "battery", "battery_watt", "battery_time", "battery_icon", "device_battery_icon", "device_battery=gamepad,mouse"
    };
    public string[] other_extra_config_vars = {
        "media_player", "full", "log_versioning", "upload_logs"
    };
    public string[] inform_config_vars = {
        "fps", "fps_color_change", "fps_metrics=avg,0.01",
        "fps_metrics=avg,0.001", "fps_metrics=avg,0.01,0.001",
        "show_fps_limit", "frame_timing", "frame_timing_detailed",
        "histogram", "frame_count", "temp_fahrenheit", "present_mode"
    };
    public string[] options_config_vars = {
        "version", "gamemode", "vkbasalt", "exec_name", "fcat", "fsr",
        "hdr", "hud_compact", "no_display", "text_outline=0",
        "no_small_font", "hud_no_margin"
    };
    public string[] vulkan_values = { _ ("Unset"), _ ("Adaptive"), _ ("OFF"), _ ("ON"), _ ("Mailbox") };
    public string[] vulkan_config_values = { "", "0", "1", "3", "2" };
    public string[] opengl_values = { _ ("Unset"), _ ("Adaptive"), _ ("OFF"), _ ("ON"), _ ("Mailbox") };
    public string[] opengl_config_values = { "", "-1", "0", "1", "n" };
    Gee.List<string>? font_cache = null;
    public Gtk.DropDown gpu_dropdown;


        // Conversion / lookup helpers
    public Gee.List<string> find_fonts () {
        if (font_cache != null) {
            return font_cache;
        }

        var fonts = new Gee.ArrayList<string> ();
        try {
            string[] argv = { "fc-list", ":", "file" };
            int exit_status;
            string standard_output;
            string standard_error;

            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null,
                                out standard_output, out standard_error, out exit_status);

            if (exit_status == 0 && standard_output != null) {
                string[] lines = standard_output.split ("\n");

                foreach (var line in lines) {
                    if (line == null || line.strip () == "") continue;

                    int colon_index = line.index_of_char (':');
                    if (colon_index <= 0) continue;

                    string font_path = line[0:colon_index].strip ();

                    if (font_path.has_suffix (".ttf") ||
                        font_path.has_suffix (".otf") ||
                        font_path.has_suffix (".ttc")) {
                        fonts.add (font_path);
                    }
                }
                font_cache = fonts;
            }
        } catch (Error e) {
            stderr.printf (_ ("Error when searching for fonts: %s\n"), e.message);
        }

        return fonts;
    }

    public void clear_font_cache () {
        font_cache = null;
    }

    public string find_font_path_by_name (string font_name, Gee.List<string> fonts) {
        foreach (var font_path in fonts) {
            if (Path.get_basename (font_path) == font_name) {
                return font_path;
            }
        }
        return "";
    }

    public string get_vulkan_config_value (string vulkan_value) {
        for (int i = 0; i < vulkan_values.length; i++) {
            if (vulkan_values[i] == vulkan_value) {
                return vulkan_config_values[i];
            }
        }
        return "0";
    }

    public string get_opengl_config_value (string opengl_value) {
        for (int i = 0; i < opengl_values.length; i++) {
            if (opengl_values[i] == opengl_value) {
                return opengl_config_values[i];
            }
        }
        return "-1";
    }

    public string get_vulkan_value_from_config (string vulkan_config_value) {
        for (int i = 0; i < vulkan_config_values.length; i++) {
            if (vulkan_config_values[i] == vulkan_config_value) {
                return vulkan_values[i];
            }
        }
        return "Unset";
    }

    public string get_opengl_value_from_config (string opengl_config_value) {
        for (int i = 0; i < opengl_config_values.length; i++) {
            if (opengl_config_values[i] == opengl_config_value) {
                return opengl_values[i];
            }
        }
        return "Unset";
    }

    public string rgba_to_hex (Gdk.RGBA rgba) {
        return "%02x%02x%02x".printf ((int) (rgba.red * 255), (int) (rgba.green * 255), (int) (rgba.blue * 255));
    }

}

}
