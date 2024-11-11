// metric.vala

[GtkTemplate (ui = "/io/github/radiolamp/mangojuice/ui/metrics-page.ui")]
public sealed class MangoJuice.MetricsPage : Page {

    [GtkChild]
    unowned TitledSwitch load_gpu_switch;
    [GtkChild]
    unowned TitledSwitch load_color_gpu_switch;
    [GtkChild]
    unowned TitledSwitch vram_switch;
    [GtkChild]
    unowned TitledSwitch core_freq_gpu_switch;
    [GtkChild]
    unowned TitledSwitch mem_freq_switch;
    [GtkChild]
    unowned TitledSwitch temp_gpu_switch;
    [GtkChild]
    unowned TitledSwitch memory_temp_switch;
    [GtkChild]
    unowned TitledSwitch juntion_switch;
    [GtkChild]
    unowned TitledSwitch fans_switch;
    [GtkChild]
    unowned TitledSwitch model_switch;
    [GtkChild]
    unowned TitledSwitch power_gpu_switch;
    [GtkChild]
    unowned TitledSwitch voltage_switch;
    [GtkChild]
    unowned TitledSwitch throttling_switch;
    [GtkChild]
    unowned TitledSwitch throttling_graph_switch;
    [GtkChild]
    unowned TitledSwitch vulkan_driver_switch;
    [GtkChild]
    unowned TitledSwitch load_cpu_switch;
    [GtkChild]
    unowned TitledSwitch load_color_cpu_switch;
    [GtkChild]
    unowned TitledSwitch core_load_switch;
    [GtkChild]
    unowned TitledSwitch core_bars_switch;
    [GtkChild]
    unowned TitledSwitch core_freq_cpu_switch;
    [GtkChild]
    unowned TitledSwitch temp_cpu_switch;
    [GtkChild]
    unowned TitledSwitch power_cpu_switch;
    [GtkChild]
    unowned TitledSwitch ram_switch;
    [GtkChild]
    unowned TitledSwitch disk_io_switch;
    [GtkChild]
    unowned TitledSwitch process_switch;
    [GtkChild]
    unowned TitledSwitch swap_switch;
    [GtkChild]
    unowned TitledSwitch fan_steamdeck_switch;

    private MSave msave;
    private MLoad mload;

    construct {
        msave = new MSave ();
        mload = new MLoad ();

        // Загрузка состояния переключателей при создании страницы
        var metrics_values = mload.load_metrics_values ();
        set_values (metrics_values);
    }

    [GtkCallback]
    public void on_switch_changed (TitledSwitch obj, bool active) {
        application_inst.values_manager.trigger_changed ();
        save_values ();
    }

    public override MetricsValues get_values () {
        return {
            load_gpu: load_gpu_switch.active,
            load_color_gpu: load_color_gpu_switch.active,
            vram: vram_switch.active,
            core_freq_gpu: core_freq_gpu_switch.active,
            mem_freq: mem_freq_switch.active,
            temp_gpu: temp_gpu_switch.active,
            memory_temp: memory_temp_switch.active,
            juntion: juntion_switch.active,
            fans: fans_switch.active,
            model: model_switch.active,
            power_gpu: power_gpu_switch.active,
            voltage: voltage_switch.active,
            throttling: throttling_switch.active,
            throttling_graph: throttling_graph_switch.active,
            vulkan_driver: vulkan_driver_switch.active,
            load_cpu: load_cpu_switch.active,
            load_color_cpu: load_color_cpu_switch.active,
            core_load: core_load_switch.active,
            core_bars: core_bars_switch.active,
            core_freq_cpu: core_freq_cpu_switch.active,
            temp_cpu: temp_cpu_switch.active,
            power_cpu: power_cpu_switch.active,
            ram: ram_switch.active,
            disk_io: disk_io_switch.active,
            process: process_switch.active,
            swap: swap_switch.active,
            fan_steamdeck: fan_steamdeck_switch.active,
        };
    }

    public override void set_values (MetricsValues metrics_values) {
        load_gpu_switch.active = metrics_values.load_gpu;
        load_color_gpu_switch.active = metrics_values.load_color_gpu;
        vram_switch.active = metrics_values.vram;
        core_freq_gpu_switch.active = metrics_values.core_freq_gpu;
        mem_freq_switch.active = metrics_values.mem_freq;
        temp_gpu_switch.active = metrics_values.temp_gpu;
        memory_temp_switch.active = metrics_values.memory_temp;
        juntion_switch.active = metrics_values.juntion;
        fans_switch.active = metrics_values.fans;
        model_switch.active = metrics_values.model;
        power_gpu_switch.active = metrics_values.power_gpu;
        voltage_switch.active = metrics_values.voltage;
        throttling_switch.active = metrics_values.throttling;
        throttling_graph_switch.active = metrics_values.throttling_graph;
        vulkan_driver_switch.active = metrics_values.vulkan_driver;
        load_cpu_switch.active = metrics_values.load_cpu;
        load_color_cpu_switch.active = metrics_values.load_color_cpu;
        core_load_switch.active = metrics_values.core_load;
        core_bars_switch.active = metrics_values.core_bars;
        core_freq_cpu_switch.active = metrics_values.core_freq_cpu;
        temp_cpu_switch.active = metrics_values.temp_cpu;
        power_cpu_switch.active = metrics_values.power_cpu;
        ram_switch.active = metrics_values.ram;
        disk_io_switch.active = metrics_values.disk_io;
        process_switch.active = metrics_values.process;
        swap_switch.active = metrics_values.swap;
        fan_steamdeck_switch.active = metrics_values.fan_steamdeck;
    }

    private void save_values () {
        var metrics_values = get_values ();
        msave.save_metrics_values (metrics_values);
    }
}