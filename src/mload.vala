// mload.vala

public class MangoJuice.MLoad : Object {

    private File config_file;

    public MLoad () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        config_file = config_dir.get_child ("MangoHud.conf");
    }

    public MetricsValues load_metrics_values () {
        var metrics_values = MetricsValues ();

        if (!config_file.query_exists ()) {
            warning ("Файл конфигурации не существует: %s", config_file.get_path ());
            return metrics_values;
        }

        try {
            var dis = new DataInputStream (config_file.read ());
            string line;
            while ((line = dis.read_line (null)) != null) {
                if (line.strip ().length == 0) {
                    continue; // Пропускаем пустые строки
                }

                if (line.has_prefix ("gpu_stats")) {
                    metrics_values.load_gpu = true;
                } else if (line.has_prefix ("gpu_load_change")) {
                    metrics_values.load_color_gpu = true;
                } else if (line.has_prefix ("vram")) {
                    metrics_values.vram = true;
                } else if (line.has_prefix ("gpu_core_clock")) {
                    metrics_values.core_freq_gpu = true;
                } else if (line.has_prefix ("gpu_mem_clock")) {
                    metrics_values.mem_freq = true;
                } else if (line.has_prefix ("gpu_temp")) {
                    metrics_values.temp_gpu = true;
                } else if (line.has_prefix ("gpu_mem_temp")) {
                    metrics_values.memory_temp = true;
                } else if (line.has_prefix ("gpu_junction_temp")) {
                    metrics_values.juntion = true;
                } else if (line.has_prefix ("gpu_fan")) {
                    metrics_values.fans = true;
                } else if (line.has_prefix ("gpu_name")) {
                    metrics_values.model = true;
                } else if (line.has_prefix ("gpu_power")) {
                    metrics_values.power_gpu = true;
                } else if (line.has_prefix ("gpu_voltage")) {
                    metrics_values.voltage = true;
                } else if (line.has_prefix ("throttling_status")) {
                    metrics_values.throttling = true;
                } else if (line.has_prefix ("throttling_status_graph")) {
                    metrics_values.throttling_graph = true;
                } else if (line.has_prefix ("engine_version")) {
                    metrics_values.vulkan_driver = true;
                } else if (line.has_prefix ("cpu_stats")) {
                    metrics_values.load_cpu = true;
                } else if (line.has_prefix ("cpu_load_change")) {
                    metrics_values.load_color_cpu = true;
                } else if (line.has_prefix ("core_load")) {
                    metrics_values.core_load = true;
                } else if (line.has_prefix ("core_bars")) {
                    metrics_values.core_bars = true;
                } else if (line.has_prefix ("cpu_mhz")) {
                    metrics_values.core_freq_cpu = true;
                } else if (line.has_prefix ("cpu_temp")) {
                    metrics_values.temp_cpu = true;
                } else if (line.has_prefix ("cpu_power")) {
                    metrics_values.power_cpu = true;
                } else if (line.has_prefix ("ram")) {
                    metrics_values.ram = true;
                } else if (line.has_prefix ("io_read") || line.has_prefix ("io_write")) {
                    metrics_values.disk_io = true;
                } else if (line.has_prefix ("procmem")) {
                    metrics_values.process = true;
                } else if (line.has_prefix ("swap")) {
                    metrics_values.swap = true;
                } else if (line.has_prefix ("fan")) {
                    metrics_values.fan_steamdeck = true;
                }
            }
        } catch (Error e) {
            warning ("Ошибка загрузки значений метрик: %s", e.message);
        }

        return metrics_values;
    }
}