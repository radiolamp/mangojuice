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
            warning ("Config file does not exist: %s", config_file.get_path ());
            return metrics_values;
        }

        try {
            var dis = new DataInputStream (config_file.read ());
            string line;
            while ((line = dis.read_line (null)) != null) {
                if (line.strip ().length == 0) {
                    continue; // Пропускаем пустые строки
                }

                if (line.has_prefix ("load_gpu")) {
                    metrics_values.load_gpu = true;
                } else if (line.has_prefix ("load_color_gpu")) {
                    metrics_values.load_color_gpu = true;
                } else if (line.has_prefix ("vram")) {
                    metrics_values.vram = true;
                } else if (line.has_prefix ("core_freq_gpu")) {
                    metrics_values.core_freq_gpu = true;
                } else if (line.has_prefix ("mem_freq")) {
                    metrics_values.mem_freq = true;
                } else if (line.has_prefix ("temp_gpu")) {
                    metrics_values.temp_gpu = true;
                } else if (line.has_prefix ("memory_temp")) {
                    metrics_values.memory_temp = true;
                } else if (line.has_prefix ("juntion")) {
                    metrics_values.juntion = true;
                } else if (line.has_prefix ("fans")) {
                    metrics_values.fans = true;
                } else if (line.has_prefix ("model")) {
                    metrics_values.model = true;
                } else if (line.has_prefix ("power_gpu")) {
                    metrics_values.power_gpu = true;
                } else if (line.has_prefix ("voltage")) {
                    metrics_values.voltage = true;
                } else if (line.has_prefix ("throttling")) {
                    metrics_values.throttling = true;
                } else if (line.has_prefix ("throttling_graph")) {
                    metrics_values.throttling_graph = true;
                } else if (line.has_prefix ("vulkan_driver")) {
                    metrics_values.vulkan_driver = true;
                } else if (line.has_prefix ("load_cpu")) {
                    metrics_values.load_cpu = true;
                } else if (line.has_prefix ("load_color_cpu")) {
                    metrics_values.load_color_cpu = true;
                } else if (line.has_prefix ("core_load")) {
                    metrics_values.core_load = true;
                } else if (line.has_prefix ("core_bars")) {
                    metrics_values.core_bars = true;
                } else if (line.has_prefix ("core_freq_cpu")) {
                    metrics_values.core_freq_cpu = true;
                } else if (line.has_prefix ("temp_cpu")) {
                    metrics_values.temp_cpu = true;
                } else if (line.has_prefix ("power_cpu")) {
                    metrics_values.power_cpu = true;
                } else if (line.has_prefix ("ram")) {
                    metrics_values.ram = true;
                } else if (line.has_prefix ("disk_io")) {
                    metrics_values.disk_io = true;
                } else if (line.has_prefix ("process")) {
                    metrics_values.process = true;
                } else if (line.has_prefix ("swap")) {
                    metrics_values.swap = true;
                } else if (line.has_prefix ("fan_steamdeck")) {
                    metrics_values.fan_steamdeck = true;
                }
            }
        } catch (Error e) {
            warning ("Error loading metrics values: %s", e.message);
        }

        return metrics_values;
    }
}