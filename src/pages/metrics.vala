/*
 * Copyright (C) 2024 Radiolamp
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

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

    [GtkCallback]
    public void on_switch_changed (TitledSwitch obj, bool active) {
        application_inst.values_manager.trigger_changed ();
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
    }
}
 