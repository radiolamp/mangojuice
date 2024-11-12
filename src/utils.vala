//gpl-3.0 license
//utils.vala

namespace MangoJuice {

    public struct MetricsValues {
        public bool load_gpu;
        public bool load_color_gpu;
        public bool vram;
        public bool core_freq_gpu;
        public bool mem_freq;
        public bool temp_gpu;
        public bool memory_temp;
        public bool juntion;
        public bool fans;
        public bool model;
        public bool power_gpu;
        public bool voltage;
        public bool throttling;
        public bool throttling_graph;
        public bool vulkan_driver;
        public bool load_cpu;
        public bool load_color_cpu;
        public bool core_load;
        public bool core_bars;
        public bool core_freq_cpu;
        public bool temp_cpu;
        public bool power_cpu;
        public bool ram;
        public bool disk_io;
        public bool process;
        public bool swap;
        public bool fan_steamdeck;
    }

    public struct ExtrasValues {
        public bool refresh_rate_switch;
        public bool resolution_switch;
        public bool system_exec_switch;
        public bool time_switch;
        public bool arch_switch;
        public bool wine_switch;
        public bool engine_switch;
        public bool engine_short_names_switch;
        public bool winesync_switch;
        public bool version_switch;
        public bool gamemode_switch;
        public bool vkbasalt_switch;
        public bool exec_name_switch;
        public bool fcat_switch;
        public bool fsr_switch;
        public bool hdr_switch;
        public bool hud_compact_switch;
        public bool compact_api_switch;
        public bool no_display_switch;
        public bool battery_switch;
        public bool battery_watt_switch;
        public bool battery_time_switch;
        public bool device_battery_icon_switch;
        public bool device_battery_switch;
        public bool media_player_switch;
        public bool network_switch;
        public bool full_switch;
        public bool log_versioning_switch;
        public bool upload_logs_switch;
    }

    public struct AllValues {
        MetricsValues metrics;
        MetricsValues extras;
        MetricsValues performance;
        MetricsValues visual;
    }

    public enum Pages {
        METRICS,
        EXTRAS,
        PERFORMANCE,
        VISUAL,
    }

    public void run_test_command () {
        try {
            if (is_vkcube_available ()) {
                Process.spawn_command_line_sync ("pkill vkcube");
                Process.spawn_command_line_async ("mangohud vkcube");
            } else if (is_glxgears_available ()) {
                Process.spawn_command_line_sync ("pkill glxgears");
                Process.spawn_command_line_async ("mangohud glxgears");
            }
        } catch (Error e) {
            warning ("Ошибка при запуске команды: %s", e.message);
        }
    }

    public bool is_vkcube_available () {
        try {
            string[] argv = { "which", "vkcube" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);
            if (exit_status != 0) {
                stderr.printf ("vkcube not found. If you want a test button, install vulkan-tools.\n");
            }
            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Error checking vkcube availability: %s\n", e.message);
            return false;
        }
    }

    public bool is_glxgears_available () {
        try {
            string[] argv = { "which", "glxgears" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);
            if (exit_status != 0) {
                stderr.printf ("glxgears not found. If you want a test button, install mesa-utils.\n");
            }
            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Error checking glxgears availability: %s\n", e.message);
            return false;
        }
    }

    public string rgba_to_hex (Gdk.RGBA rgba) {
        return "%02x%02x%02x".printf ((int) (rgba.red * 255), (int) (rgba.green * 255), (int) (rgba.blue * 255));
    }

}