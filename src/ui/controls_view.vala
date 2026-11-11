/* ui/controls_view.vala // License: GPL-3.0+ */
using Gtk;
using Gee;
using MangoJuice;
using MangoJuice.Config;
using MangoJuice.System;

namespace MangoJuice.UI {

public class ControlsView : GLib.Object {

private MangoJuice.Application app { get; private set; }

public ControlsView (MangoJuice.Application app) {
    this.app = app;
}

public void add_value_changed_handler (Scale scale) {
    scale.value_changed.connect (() => {
        app.save_config ();
    });
}

public void initialize (Box metrics_box, Box extras_box, Box performance_box, Box visual_box) {
    unowned State state = app.state;
    state.gpu_switches = new Switch[state.gpu_config_vars.length];
    state.cpu_switches = new Switch[state.cpu_config_vars.length];
    state.memory_switches = new Switch[state.memory_config_vars.length];
    state.system_switches = new Switch[state.system_config_vars.length];
    state.wine_switches = new Switch[state.wine_config_vars.length];
    state.options_switches = new Switch[state.options_config_vars.length];
    state.battery_switches = new Switch[state.battery_config_vars.length];
    state.other_extra_switches = new Switch[state.other_extra_config_vars.length];
    state.inform_switches = new Switch[state.inform_config_vars.length];

    state.gpu_labels = new Label[app.labels.gpu_label_texts.length];
    state.cpu_labels = new Label[app.labels.cpu_label_texts.length];
    state.memory_labels = new Label[app.labels.memory_label_texts.length];
    state.system_labels = new Label[app.labels.system_label_texts.length];
    state.wine_labels = new Label[app.labels.wine_label_texts.length];
    state.options_labels = new Label[app.labels.options_label_texts.length];
    state.battery_labels = new Label[app.labels.battery_label_texts.length];
    state.other_extra_labels = new Label[app.labels.other_extra_label_texts.length];
    state.inform_labels = new Label[app.labels.inform_label_texts.length];

    create_switches_and_labels (metrics_box, "metrics_box", Common.GPU_TITLE,
                                state.gpu_switches, state.gpu_labels,
                                state.gpu_config_vars, app.labels.gpu_label_texts,
                                app.labels.gpu_label_texts_2);
    create_switches_and_labels (metrics_box, "metrics_box", Common.CPU_TITLE,
                                state.cpu_switches, state.cpu_labels,
                                state.cpu_config_vars, app.labels.cpu_label_texts,
                                app.labels.cpu_label_texts_2);
    create_switches_and_labels (metrics_box, "metrics_box", Common.MEMORY_TITLE,
                                state.memory_switches, state.memory_labels,
                                state.memory_config_vars, app.labels.memory_label_texts,
                                app.labels.memory_label_texts_2);
    create_switches_and_labels (extras_box, "extras_box", Common.SYSTEM_TITLE,
                                state.system_switches, state.system_labels,
                                state.system_config_vars, app.labels.system_label_texts,
                                app.labels.system_label_texts_2);
    create_switches_and_labels (extras_box, "extras_box", Common.OPTIONS_TITLE,
                                state.options_switches, state.options_labels,
                                state.options_config_vars, app.labels.options_label_texts,
                                app.labels.options_label_texts_2);
    create_switches_and_labels (extras_box, "extras_box", Common.BATTERY_TITLE,
                                state.battery_switches, state.battery_labels,
                                state.battery_config_vars, app.labels.battery_label_texts,
                                app.labels.battery_label_texts_2);
    create_switches_and_labels (extras_box, "extras_box", Common.WINE_TITLE, state.wine_switches,
                                state.wine_labels, state.wine_config_vars,
                                app.labels.wine_label_texts, app.labels.wine_label_texts_2);
    create_switches_and_labels (extras_box, "extras_box", Common.OTHER_TITLE,
                                state.other_extra_switches, state.other_extra_labels,
                                state.other_extra_config_vars,
                                app.labels.other_extra_label_texts,
                                app.labels.other_extra_label_texts_2);
    create_scales_and_labels (extras_box);
    create_switches_and_labels (performance_box, "performance_box", Common.INFORM_TITLE,
                                state.inform_switches, state.inform_labels,
                                state.inform_config_vars, app.labels.inform_label_texts,
                                app.labels.inform_label_texts_2);
    create_limiters_and_filters (performance_box);
    add_switch_handler (state.gpu_switches);
    add_switch_handler (state.cpu_switches);
    add_switch_handler (state.memory_switches);
    add_switch_handler (state.system_switches);
    add_switch_handler (state.options_switches);
    add_switch_handler (state.battery_switches);
    add_switch_handler (state.wine_switches);
    add_switch_handler (state.other_extra_switches);
    add_switch_handler (state.inform_switches);

    if (BuildConfig.IS_DEVEL) {
        state.git_switches = new Switch[state.git_config_vars.length];
        state.git_labels = new Label[app.labels.git_label_texts.length];
        create_switches_and_labels (metrics_box, "metrics_box", Common.GIT_TITLE, state.git_switches,
                                    state.git_labels, state.git_config_vars,
                                    app.labels.git_label_texts, app.labels.git_label_texts_2);
        add_switch_handler (state.git_switches);
    }

    app.gpu_selector.initialize (extras_box);

    apply_switch_rules ();

    bool updating = false;

    for (int i = 0; i < state.gpu_switches.length; i++) {
        int index = i;
        state.gpu_switches[i].notify["active"].connect (() => {
            if (updating) return;
            updating = true;

            if (index == 0 && !state.gpu_switches[0].active) {
                for (int j = 0; j < state.gpu_switches.length; j++) {
                    if (j != 2 && j != 14) {
                        state.gpu_switches[j].active = false;
                    }
                }
            }

            update_gpu_stats_state ();
            updating = false;
        });
    }

    for (int i = 0; i < state.cpu_switches.length; i++) {
        int index = i;
        state.cpu_switches[i].notify["active"].connect (() => {
            if (updating) return;
            updating = true;

            if (index == 0 && !state.cpu_switches[0].active) {
                for (int j = 0; j < state.cpu_switches.length; j++) {
                    if (j != 2 && j != 3) {
                        state.cpu_switches[j].active = false;
                    }
                }
            }

            update_cpu_stats_state ();
            updating = false;
        });
    }
}

public void add_switch_handler (Switch[] switches) {
    for (int i = 0; i < switches.length; i++) {
        switches[i].notify["active"].connect (() => {
            app.save_config ();
        });
    }
}

public class SwitchRule {
    public string source;
    public bool on_activation;
    public string[] enable;
    public string[] disable;

    public SwitchRule (string source, bool on_activation, string[] enable, string[] disable) {
        this.source = source;
        this.on_activation = on_activation;
        this.enable = enable;
        this.disable = disable;
    }
}

public void register_scale_handlers () {
    unowned State state = app.state;
    var scales = new Scale[] {
        state.duracion_scale, state.autostart_scale, state.interval_scale,
        state.af, state.picmip, state.borders_scale, state.colums_scale,
        state.font_size_scale, state.font_size_secondary_scale,
        state.offset_x_scale, state.offset_y_scale };
    foreach (var scale in scales) {
        add_value_changed_handler (scale);
    }
}

static int index_of_config_var (string[] config_vars, string name) {
    for (int i = 0; i < config_vars.length; i++) {
        if (config_vars[i] == name) {
            return i;
        }
    }
    return -1;
}

void bind_switch_rules (Switch[] switches, string[] config_vars, SwitchRule[] rules) {
    foreach (var rule in rules) {
        int source_index = index_of_config_var (config_vars, rule.source);
        if (source_index < 0 || source_index >= switches.length) {
            continue;
        }
        var source_switch = switches[source_index];
        source_switch.notify["active"].connect (() => {
            if (source_switch.active != rule.on_activation) {
                return;
            }
            foreach (var name in rule.enable) {
                int i = index_of_config_var (config_vars, name);
                if (i >= 0 && i < switches.length) {
                    switches[i].active = true;
                }
            }
            foreach (var name in rule.disable) {
                int i = index_of_config_var (config_vars, name);
                if (i >= 0 && i < switches.length) {
                    switches[i].active = false;
                }
            }
        });
    }
}

void apply_switch_rules () {
    unowned State state = app.state;

    SwitchRule[] inform_rules = {
        new SwitchRule ("fps_metrics=avg,0.01", true, new string[] {},
                        { "fps_metrics=avg,0.001", "fps_metrics=avg,0.01,0.001" }),
        new SwitchRule ("fps_metrics=avg,0.001", true, new string[] {},
                        { "fps_metrics=avg,0.01", "fps_metrics=avg,0.01,0.001" }),
        new SwitchRule ("fps_metrics=avg,0.01,0.001", true, new string[] {},
                        { "fps_metrics=avg,0.01", "fps_metrics=avg,0.001" }),
        new SwitchRule ("fps_color_change", true, { "fps" }, new string[] {}),
        new SwitchRule ("fps", false, new string[] {}, { "fps_color_change" }),
        new SwitchRule ("frame_timing_detailed", true, { "frame_timing" }, new string[] {}),
        new SwitchRule ("histogram", true, { "frame_timing" }, new string[] {}),
        new SwitchRule ("frame_timing", false, new string[] {}, { "histogram", "frame_timing_detailed" })
    };
    bind_switch_rules (state.inform_switches, state.inform_config_vars, inform_rules);

    SwitchRule[] cpu_rules = {
        new SwitchRule ("core_bars", true, { "core_load" }, { "core_load_change" }),
        new SwitchRule ("core_load", false, new string[] {},
                        { "core_bars", "core_load_change", "core_type" }),
        new SwitchRule ("core_type", true, { "core_load" }, new string[] {}),
        new SwitchRule ("core_load_change", true, { "core_load" }, { "core_bars" }),
        new SwitchRule ("flip_efficiency", true, { "cpu_efficiency" }, new string[] {}),
        new SwitchRule ("cpu_efficiency", false, new string[] {}, { "flip_efficiency" })
    };
    bind_switch_rules (state.cpu_switches, state.cpu_config_vars, cpu_rules);

    SwitchRule[] gpu_rules = {
        new SwitchRule ("gpu_mem_clock", true, { "vram" }, new string[] {}),
        new SwitchRule ("gpu_mem_temp", true, { "vram" }, new string[] {}),
        new SwitchRule ("vram", false, new string[] {}, { "gpu_mem_clock", "gpu_mem_temp" }),
        new SwitchRule ("gpu_power_limit", true, { "gpu_power" }, new string[] {}),
        new SwitchRule ("gpu_power", false, new string[] {}, { "gpu_power_limit" })
    };
    bind_switch_rules (state.gpu_switches, state.gpu_config_vars, gpu_rules);

    SwitchRule[] memory_rules = {
        new SwitchRule ("procmem_shared", true, { "procmem" }, new string[] {}),
        new SwitchRule ("procmem_virt", true, { "procmem" }, new string[] {}),
        new SwitchRule ("procmem", false, new string[] {}, { "procmem_shared", "procmem_virt" }),
        new SwitchRule ("swap", true, { "ram" }, new string[] {}),
        new SwitchRule ("ram_temp", true, { "ram" }, new string[] {}),
        new SwitchRule ("ram", false, new string[] {}, { "swap", "ram_temp" })
    };
    bind_switch_rules (state.memory_switches, state.memory_config_vars, memory_rules);
}

public void update_gpu_stats_state () {
    unowned State state = app.state;
    bool any_gpu_switch_active = false;

    for (int i = 0; i < state.gpu_switches.length; i++) {
        if (state.gpu_switches[i].active && state.gpu_config_vars[i] != "vram" && state.gpu_config_vars[i] != "gpu_name"
            && state.gpu_config_vars[i] != "vulkan_driver"
            && state.gpu_config_vars[i] != "gpu_mem_clock"
            && state.gpu_config_vars[i] != "engine_version") {
            any_gpu_switch_active = true;
            break;
        }
    }

    state.gpu_switches[0].active = any_gpu_switch_active;
}

public void update_cpu_stats_state () {
    unowned State state = app.state;
    bool any_cpu_switch_active = false;

    for (int i = 0; i < state.cpu_switches.length; i++) {
        if (state.cpu_switches[i].active
            && state.cpu_config_vars[i] != "core_load"
            && state.cpu_config_vars[i] != "core_bars"
            && state.cpu_config_vars[i] != "core_type") {
            any_cpu_switch_active = true;
            break;
        }
    }

    state.cpu_switches[0].active = any_cpu_switch_active;
}

public void create_switches_and_labels (Box parent_box, string page_id, string title, Switch[] switches, Label[] labels, string[] config_vars, string[] label_texts, string[] label_texts_2) {
    var label = Common.create_label (title, Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN, Common.FLOW_BOX_MARGIN, Common.FLOW_BOX_MARGIN);
    parent_box.append (label);

    var flow_box = new FlowBox ();
    flow_box.set_homogeneous (true);
    flow_box.set_row_spacing (Common.FLOW_BOX_ROW_SPACING);
    flow_box.set_column_spacing (Common.FLOW_BOX_COLUMN_SPACING);
    flow_box.set_margin_top (Common.FLOW_BOX_MARGIN);
    flow_box.set_margin_bottom (Common.FLOW_BOX_MARGIN);
    flow_box.set_margin_start (Common.FLOW_BOX_MARGIN);
    flow_box.set_margin_end (Common.FLOW_BOX_MARGIN);
    flow_box.set_selection_mode (SelectionMode.NONE);

    for (int i = 0; i < config_vars.length; i++) {
        var row_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        row_box.set_hexpand (true);
        row_box.set_valign (Align.CENTER);
        switches[i] = new Switch ();
        switches[i].set_valign (Align.CENTER);

        var text_box = new Box (Orientation.VERTICAL, 0);
        text_box.set_valign (Align.CENTER);
        text_box.set_halign (Align.START);
        text_box.set_size_request (170, -1);

        var label1 = new Label (null);
        label1.set_markup ("<b>%s</b>".printf (label_texts[i]));
        label1.set_halign (Align.START);
        label1.set_ellipsize (Pango.EllipsizeMode.END);
        label1.set_max_width_chars (18);

        if (label_texts[i].char_count () > 20) {
            label1.set_tooltip_text (label_texts[i]);
        }

        var label2 = new Label (null);
        label2.set_markup ("<span size='8500'>%s</span>".printf (label_texts_2[i]));
        label2.set_halign (Align.START);
        label2.add_css_class ("dim-label");
        label2.set_ellipsize (Pango.EllipsizeMode.END);
        label2.set_max_width_chars (18);

        if (label_texts_2[i].char_count () > 20) {
            label2.set_tooltip_text (label_texts_2[i]);
        }

        text_box.append (label1);
        text_box.append (label2);

        row_box.append (switches[i]);
        row_box.append (text_box);
        flow_box.insert (row_box, -1);

        app.search.add_setting (page_id, title, label_texts[i], label_texts_2[i],
                                new string[] { config_vars[i] },
                                switches[i], row_box);
    }

    parent_box.append (flow_box);
}

public void create_scales_and_labels (Box parent_box) {
    unowned State state = app.state;
    var logging_label = Common.create_label (_ ("Logging"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    parent_box.append (logging_label);

    var scales_flow_box = new FlowBox ();
    scales_flow_box.set_homogeneous (true);
    scales_flow_box.set_row_spacing (Common.FLOW_BOX_ROW_SPACING);
    scales_flow_box.set_max_children_per_line (3);
    scales_flow_box.set_margin_start (Common.FLOW_BOX_MARGIN);
    scales_flow_box.set_margin_end (Common.FLOW_BOX_MARGIN);
    scales_flow_box.set_margin_top (Common.FLOW_BOX_MARGIN);
    scales_flow_box.set_margin_bottom (Common.FLOW_BOX_MARGIN);
    scales_flow_box.set_selection_mode (SelectionMode.NONE);

    string[] label_texts = { _ ("Duration"), _ ("Autostart"), _ ("Interval") };
    string[] label_texts_2 = { _ ("Seconds"), _ ("Seconds"), _ ("Milliseconds") };

    var duracion_widget = app.create_scale_entry_widget(label_texts[0], label_texts_2[0], 0, 200, 30);
    state.duracion_scale = duracion_widget.scale;
    scales_flow_box.insert (duracion_widget.widget, -1);
    app.search.add_setting ("extras_box", _ ("Logging"), label_texts[0], label_texts_2[0],
                            new string[] { "log_duration" },
                            duracion_widget.scale, duracion_widget.widget);

    var autostart_widget = app.create_scale_entry_widget(label_texts[1], label_texts_2[1], 0, 30, 0);
    state.autostart_scale = autostart_widget.scale;
    scales_flow_box.insert (autostart_widget.widget, -1);
    app.search.add_setting ("extras_box", _ ("Logging"), label_texts[1], label_texts_2[1],
                            new string[] { "autostart_log" },
                            autostart_widget.scale, autostart_widget.widget);

    var interval_widget = app.create_scale_entry_widget(label_texts[2], label_texts_2[2], 0, 500, 100);
    state.interval_scale = interval_widget.scale;
    scales_flow_box.insert (interval_widget.widget, -1);
    app.search.add_setting ("extras_box", _ ("Logging"), label_texts[2], label_texts_2[2],
                            new string[] { "log_interval" },
                            interval_widget.scale, interval_widget.widget);

    parent_box.append (scales_flow_box);
}

public void create_limiters_and_filters (Box performance_box) {
    unowned State state = app.state;
    var limiters_label = Common.create_label (_ ("Limiters FPS"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    performance_box.append (limiters_label);

    var fps_limit_method_model = new Gtk.StringList (null);
    foreach (var item in new string[] { "late", "early" }) {
        fps_limit_method_model.append (item);
    }
    state.fps_limit_method = new DropDown (fps_limit_method_model, null);
    state.fps_limit_method.notify["selected-item"].connect (app.save_config);

    state.fps_limit_entry_1 = new Entry ();
    state.fps_limit_entry_1.input_purpose = InputPurpose.NUMBER;
    var fps_limit_entry_1_box = Common.create_entry_with_clear_button (state.fps_limit_entry_1, _ ("Limit 1"), "");
    state.fps_limit_entry_1.changed.connect (() => {
        app.validate_numeric_entry (state.fps_limit_entry_1, 0, 1000);
        app.saver.update_fps_limit_in_file (state.fps_limit_entry_1.text,
                                            state.fps_limit_entry_2.text,
                                            state.fps_limit_entry_3.text);
        app.save_config ();
    });

    state.fps_limit_entry_2 = new Entry ();
    state.fps_limit_entry_2.input_purpose = InputPurpose.NUMBER;
    var fps_limit_entry_2_box = Common.create_entry_with_clear_button (state.fps_limit_entry_2, _ ("Limit 2"), "");
    state.fps_limit_entry_2.changed.connect (() => {
        app.validate_numeric_entry (state.fps_limit_entry_2, 0, 1000);
        app.saver.update_fps_limit_in_file (state.fps_limit_entry_1.text,
                                            state.fps_limit_entry_2.text,
                                            state.fps_limit_entry_3.text);
        app.save_config ();
    });

    state.fps_limit_entry_3 = new Entry ();
    state.fps_limit_entry_3.input_purpose = InputPurpose.NUMBER;
    var fps_limit_entry_3_box = Common.create_entry_with_clear_button (state.fps_limit_entry_3, _ ("Limit 3"), "");
    state.fps_limit_entry_3.changed.connect (() => {
        app.validate_numeric_entry (state.fps_limit_entry_3, 0, 1000);
        app.saver.update_fps_limit_in_file (state.fps_limit_entry_1.text,
                                            state.fps_limit_entry_2.text,
                                            state.fps_limit_entry_3.text);
        app.save_config ();
    });

    state.toggle_fps_limit_recorder = new ShortcutRecorder () {
        tooltip_text = _ ("Click to record FPS limit toggle shortcut"),
        hexpand = true,
        shortcut = "Shift_L+F1"
    };

    var key_controller = new Gtk.EventControllerKey ();
    key_controller.key_pressed.connect ((keyval, keycode, mod_state) => {
        if (state.toggle_fps_limit_recorder.is_recording) {
            return state.toggle_fps_limit_recorder.handle_key_event_with_code (keyval, 0, mod_state);
        }
        return false;
    });
    state.toggle_fps_limit_recorder.add_controller (key_controller);

    state.toggle_fps_limit_recorder.shortcut_changed.connect ((shortcut_value) => {
        app.save_config ();
    });

    var toggle_fps_limit_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    toggle_fps_limit_box.append (state.toggle_fps_limit_recorder);

    var limiters_box = new FlowBox ();
    limiters_box.set_max_children_per_line (5);
    limiters_box.set_homogeneous (true);
    limiters_box.set_margin_start (Common.FLOW_BOX_MARGIN);
    limiters_box.set_margin_end (Common.FLOW_BOX_MARGIN);
    limiters_box.set_margin_top (Common.FLOW_BOX_MARGIN);
    limiters_box.set_margin_bottom (Common.FLOW_BOX_MARGIN);
    limiters_box.set_selection_mode (SelectionMode.NONE);
    limiters_box.append (state.fps_limit_method);
    limiters_box.append (fps_limit_entry_1_box);
    limiters_box.append (fps_limit_entry_2_box);
    limiters_box.append (fps_limit_entry_3_box);
    limiters_box.append (toggle_fps_limit_box);
    performance_box.append (limiters_box);

    app.search.add_setting ("performance_box", _ ("Limiters FPS"), _ ("FPS limit method"),
                            _ ("late or early"), new string[] { "fps_limit_method" },
                            state.fps_limit_method, state.fps_limit_method);
    app.search.add_setting ("performance_box", _ ("Limiters FPS"), _ ("Limit 1"),
                            _ ("FPS limitation"), new string[] { "fps_limit" },
                            state.fps_limit_entry_1, fps_limit_entry_1_box);
    app.search.add_setting ("performance_box", _ ("Limiters FPS"), _ ("Limit 2"),
                            _ ("FPS limitation"), new string[] { "fps_limit" },
                            state.fps_limit_entry_2, fps_limit_entry_2_box);
    app.search.add_setting ("performance_box", _ ("Limiters FPS"), _ ("Limit 3"),
                            _ ("FPS limitation"), new string[] { "fps_limit" },
                            state.fps_limit_entry_3, fps_limit_entry_3_box);
    app.search.add_setting ("performance_box", _ ("Limiters FPS"), _ ("Toggle FPS limit"),
                            _ ("Keyboard shortcut"), new string[] { "toggle_fps_limit" },
                            state.toggle_fps_limit_recorder, toggle_fps_limit_box);

    var vsync_label = Common.create_label (_ ("VSync"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    performance_box.append (vsync_label);

    var vulkan_model = new Gtk.StringList (null);
    foreach (var item in state.vulkan_values) {
        vulkan_model.append (item);
    }
    state.vulkan_dropdown = new DropDown (vulkan_model, null);
    state.vulkan_dropdown.notify["selected-item"].connect (() => {
        app.save_and_restart ();
    });

    var opengl_model = new Gtk.StringList (null);
    foreach (var item in state.opengl_values) {
        opengl_model.append (item);
    }
    state.opengl_dropdown = new DropDown (opengl_model, null);
    state.opengl_dropdown.notify["selected-item"].connect (() => {
        app.save_and_restart ();
    });

    var vulkan_label = new Label ("Vulkan");
    vulkan_label.set_halign (Align.END);
    vulkan_label.set_ellipsize (Pango.EllipsizeMode.END);

    var opengl_label = new Label ("OpenGL");
    opengl_label.set_halign (Align.END);
    opengl_label.set_ellipsize (Pango.EllipsizeMode.END);

    var vsync_box = new FlowBox ();
    vsync_box.set_max_children_per_line (5);
    vsync_box.set_min_children_per_line (4);
    vsync_box.set_margin_start (Common.FLOW_BOX_MARGIN);
    vsync_box.set_margin_end (Common.FLOW_BOX_MARGIN);
    vsync_box.set_margin_top (Common.FLOW_BOX_MARGIN);
    vsync_box.set_margin_bottom (Common.FLOW_BOX_MARGIN);
    vsync_box.set_selection_mode (SelectionMode.NONE);
    vsync_box.append (vulkan_label);
    vsync_box.append (state.vulkan_dropdown);
    vsync_box.append (opengl_label);
    vsync_box.append (state.opengl_dropdown);
    performance_box.append (vsync_box);

    app.search.add_setting ("performance_box", _ ("VSync"), "Vulkan",
                            _ ("VSync mode"), new string[] { "vsync" },
                            state.vulkan_dropdown, state.vulkan_dropdown);
    app.search.add_setting ("performance_box", _ ("VSync"), "OpenGL",
                            _ ("VSync mode"), new string[] { "gl_vsync" },
                            state.opengl_dropdown, state.opengl_dropdown);

    var filters_label = Common.create_label (_ ("Filters"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    performance_box.append (filters_label);

    var filter_labels = new string[] {
        _ ("None"), _ ("Bicubic"), _ ("Trilinear"), _ ("Retro")
    };

    var filter_model = new Gtk.StringList (null);
    foreach (var label in filter_labels) {
        filter_model.append (label);
    }

    state.filter_dropdown = new DropDown (filter_model, null) {
        valign = Align.START,
        hexpand = true
    };

    state.filter_dropdown.notify["selected-item"].connect (() => {
        int selected = (int)state.filter_dropdown.selected;
        if (selected >= 0 && selected < Common.FILTER_VALUES.length) {
            app.save_config ();
        }
    });

    var af_widget = app.create_scale_entry_widget(_ ("Anisotropic"), _ ("Filtering"), 0, 16, 0);
    state.af = af_widget.scale;
    state.af_entry = af_widget.entry;

    var picmip_widget = app.create_scale_entry_widget(_ ("Mipmap"), _ ("Aliasing"), -16, 16, 0);
    state.picmip = picmip_widget.scale;
    state.picmip_entry = picmip_widget.entry;

    var filters_flow_box = new FlowBox ();
    filters_flow_box.set_row_spacing (Common.FLOW_BOX_ROW_SPACING);
    filters_flow_box.set_max_children_per_line (3);
    filters_flow_box.set_margin_start (Common.FLOW_BOX_MARGIN);
    filters_flow_box.set_margin_end (Common.FLOW_BOX_MARGIN);
    filters_flow_box.set_margin_top (Common.FLOW_BOX_MARGIN);
    filters_flow_box.set_margin_bottom (Common.FLOW_BOX_MARGIN);
    filters_flow_box.set_selection_mode (SelectionMode.NONE);

    var filter_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    filter_pair.append (state.filter_dropdown);
    filters_flow_box.insert (filter_pair, -1);
    var af_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    af_pair.append (af_widget.widget);
    filters_flow_box.insert (af_pair, -1);

    var picmip_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    picmip_pair.append (picmip_widget.widget);
    filters_flow_box.insert (picmip_pair, -1);

    performance_box.append (filters_flow_box);

    app.search.add_setting ("performance_box", _ ("Filters"), _ ("Filter"),
                            _ ("Texture filtering"), new string[] { "filter" },
                            state.filter_dropdown, filter_pair);
    app.search.add_setting ("performance_box", _ ("Filters"), _ ("Anisotropic"),
                            _ ("Filtering"), new string[] { "af" },
                            state.af, af_widget.widget);
    app.search.add_setting ("performance_box", _ ("Filters"), _ ("Mipmap"),
                            _ ("Aliasing"), new string[] { "picmip" },
                            state.picmip, picmip_widget.widget);

    var fps_sampling_period_label = Common.create_label (_ ("Other"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    performance_box.append (fps_sampling_period_label);

    var fps_sampling_period_widget = app.create_scale_entry_widget(
        _ ("FPS Sampling"), _ ("Milliseconds"), 250, 2000, 500);
    state.fps_sampling_period_scale = fps_sampling_period_widget.scale;
    state.fps_sampling_period_entry = fps_sampling_period_widget.entry;

    bool is_updating = false;

    state.fps_sampling_period_scale.value_changed.connect (() => {
        if (!is_updating) {
            is_updating = true;
            int value = (int)state.fps_sampling_period_scale.get_value ();
            state.fps_sampling_period_entry.text = "%d".printf (value);
            app.saver.update_fps_sampling_period_in_file ("%d".printf (value));
            is_updating = false;
        }
    });

    state.fps_sampling_period_entry.changed.connect (() => {
        if (!is_updating) {
            is_updating = true;
            int value;
            if (int.try_parse (state.fps_sampling_period_entry.text.strip (), out value)) {
                if (value >= 250 && value <= 2000 && value != (int)state.fps_sampling_period_scale.get_value ()) {
                    state.fps_sampling_period_scale.set_value (value);
                    app.saver.update_fps_sampling_period_in_file ("%d".printf (value));
                }
            }
            is_updating = false;
        }
    });

    var fps_sampling_period_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    fps_sampling_period_box.set_margin_start (Common.FLOW_BOX_MARGIN);
    fps_sampling_period_box.set_margin_end (Common.FLOW_BOX_MARGIN);
    fps_sampling_period_box.set_margin_top (Common.FLOW_BOX_MARGIN);
    fps_sampling_period_box.set_margin_bottom (Common.FLOW_BOX_MARGIN);
    fps_sampling_period_box.append (fps_sampling_period_widget.widget);
    performance_box.append (fps_sampling_period_box);

    app.search.add_setting ("performance_box", _ ("Other"), _ ("FPS Sampling"),
                            _ ("Milliseconds"), new string[] { "fps_sampling_period" },
                            state.fps_sampling_period_scale, fps_sampling_period_widget.widget);
}
}

}
