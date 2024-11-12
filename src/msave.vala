// msave.vala

public class MangoJuice.MSave : Object {

    private File config_file;

    public MSave () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        config_file = config_dir.get_child ("MangoHud.conf");
    }

    public void save_metrics_values (MetricsValues metrics_values) {
        try {
            var data_stream = new DataOutputStream (config_file.replace (null, false, FileCreateFlags.NONE));

            data_stream.put_string ("legacy_layout=false\n");

            if (metrics_values.load_gpu) {
                data_stream.put_string ("gpu_stats\n");
            }
            if (metrics_values.load_color_gpu) {
                data_stream.put_string ("gpu_load_change\n");
            }
            if (metrics_values.vram) {
                data_stream.put_string ("vram\n");
            }
            if (metrics_values.core_freq_gpu) {
                data_stream.put_string ("gpu_core_clock\n");
            }
            if (metrics_values.mem_freq) {
                data_stream.put_string ("gpu_mem_clock\n");
            }
            if (metrics_values.temp_gpu) {
                data_stream.put_string ("gpu_temp\n");
            }
            if (metrics_values.memory_temp) {
                data_stream.put_string ("gpu_mem_temp\n");
            }
            if (metrics_values.juntion) {
                data_stream.put_string ("gpu_junction_temp\n");
            }
            if (metrics_values.fans) {
                data_stream.put_string ("gpu_fan\n");
            }
            if (metrics_values.model) {
                data_stream.put_string ("gpu_name\n");
            }
            if (metrics_values.power_gpu) {
                data_stream.put_string ("gpu_power\n");
            }
            if (metrics_values.voltage) {
                data_stream.put_string ("gpu_voltage\n");
            }
            if (metrics_values.throttling) {
                data_stream.put_string ("throttling_status\n");
            }
            if (metrics_values.throttling_graph) {
                data_stream.put_string ("throttling_status_graph\n");
            }
            if (metrics_values.vulkan_driver) {
                data_stream.put_string ("engine_version\n");
            }
            if (metrics_values.load_cpu) {
                data_stream.put_string ("cpu_stats\n");
            }
            if (metrics_values.load_color_cpu) {
                data_stream.put_string ("cpu_load_change\n");
            }
            if (metrics_values.core_load) {
                data_stream.put_string ("core_load\n");
            }
            if (metrics_values.core_bars) {
                data_stream.put_string ("core_bars\n");
            }
            if (metrics_values.core_freq_cpu) {
                data_stream.put_string ("cpu_mhz\n");
            }
            if (metrics_values.temp_cpu) {
                data_stream.put_string ("cpu_temp\n");
            }
            if (metrics_values.power_cpu) {
                data_stream.put_string ("cpu_power\n");
            }
            if (metrics_values.ram) {
                data_stream.put_string ("ram\n");
            }
            if (metrics_values.disk_io) {
                data_stream.put_string ("io_read\n");
                data_stream.put_string ("io_write\n");
            }
            if (metrics_values.process) {
                data_stream.put_string ("procmem\n");
            }
            if (metrics_values.swap) {
                data_stream.put_string ("swap\n");
            }
            if (metrics_values.fan_steamdeck) {
                data_stream.put_string ("fan\n");
            }
        } catch (Error e) {
            warning ("Error saving metrics values: %s", e.message);
        }
    }
    
}