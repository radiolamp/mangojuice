using Gtk;
using Adw;
using Gee;

public class MangoJuice : Adw.Application {
    public Button save_button;
    public Button reset_button;
    public Button logs_path_button;
    public Button intel_power_fix_button;
    public Switch[] gpu_switches;
    public Switch[] cpu_switches;
    public Switch[] other_switches;
    public Switch[] system_switches;
    public Switch[] wine_switches;
    public Switch[] options_switches;
    public Switch[] battery_switches;
    public Switch[] other_extra_switches;
    public Switch[] inform_switches;
    public Label[] gpu_labels;
    public Label[] cpu_labels;
    public Label[] other_labels;
    public Label[] system_labels;
    public Label[] wine_labels;
    public Label[] options_labels;
    public Label[] battery_labels;
    public Label[] other_extra_labels;
    public Label[] inform_labels;
    public Entry custom_command_entry;
    public Entry custom_logs_path_entry;
    public DropDown logs_key_combo;
    public DropDown fps_limit_method;
    public DropDown toggle_fps_limit;
    public DropDown vulkan_dropdown;
    public DropDown opengl_dropdown;
    public Scale duracion_scale;
    public Scale autostart_scale;
    public Scale interval_scale;
    public Scale scale;
    public Label duracion_value_label;
    public Label autostart_value_label;
    public Label interval_value_label;
    public Label fps_limit_label;
    public Gtk.StringList logs_key_model;
    public DropDown filter_dropdown;
    public Scale af;
    public Scale picmip;
    public Label af_label;
    public Label picmip_label;
    public const string GPU_TITLE = "GPU";
    public const string CPU_TITLE = "CPU";
    public const string OTHER_TITLE = "Other";
    public const string SYSTEM_TITLE = "System";
    public const string WINE_TITLE = "Wine";
    public const string OPTIONS_TITLE = "Options";
    public const string BATTERY_TITLE = "Battery";
    public const string OTHER_EXTRA_TITLE = "Other";
    public const string INFORM_TITLE = "Information";
    public const string LIMITERS_TITLE = "Limiters FPS";
    public const string FILTERS_TITLE = "Filters";
    public const int MAIN_BOX_SPACING = 10;
    public const int FLOW_BOX_ROW_SPACING = 10;
    public const int FLOW_BOX_COLUMN_SPACING = 10;
    public const int FLOW_BOX_MARGIN = 10;
    public string[] gpu_config_vars = {
        "gpu_stats", "gpu_load_change", "vram", "gpu_core_clock", "gpu_mem_clock",
        "gpu_temp", "gpu_mem_temp", "gpu_junction_temp", "gpu_fan", "gpu_name",
        "gpu_power", "gpu_voltage", "throttling_status", "throttling_status_graph", "engine_version"
    };
    public string[] cpu_config_vars = {
        "cpu_stats", "cpu_load_change", "core_load", "core_bars", "cpu_mhz", "cpu_temp",
        "cpu_power"
    };
    public string[] other_config_vars = {
        "ram", "io_read \n io_write", "procmem", "swap", "fan"
    };
    public string[] system_config_vars = {
        "refresh_rate", "resolution", "exec=echo $XDG_SESSION_TYPE",
        "time", "arch"
    };
    public string[] wine_config_vars = {
        "wine", "engine", "engine_short_names", "winesync"
    };
    public string[] battery_config_vars = {
        "battery", "battery_watt", "battery_time", "device_battery"
    };
    public string[] other_extra_config_vars = {
        "media_player", "network", "full", "log_versioning", "upload_logs"
    };
    public string[] inform_config_vars = {
        "fps", "fps_color_change", "fps_metrics=avg,0.01", "fps_metrics=avg,0.001", "show_fps_limit", "frame_timing", "histogram", "frame_count", "present_mode"
    };
    public string[] options_config_vars = {
        "version", "gamemode", "vkbasalt", "exec_name", "fcat", "fsr", "hdr", "hud_compact", "no_display"
    };
    public string[] gpu_label_texts = {
        "Load", "Load Color", "VRAM", "Core Freq", "Mem Freq",
        "Temp", "Memory Temp", "Juntion", "Fans", "Model",
        "Power", "Voltage", "Throttling", "Throttling GRAPH", "Vulkan Driver"
    };
    public string[] cpu_label_texts = {
        "Load", "Load Color", "Core Load", "Core Bars", "Core Freq", "Temp",
        "Power                       "
    };
    public string[] other_label_texts = {
        "RAM", "Disk IO", "Procces", "Swap", "Fan SteamDeck    "
    };
    public string[] system_label_texts = {
        "Refresh rate*", "Resolution", "Session", "Time", "Arch                      "
    };
    public string[] wine_label_texts = {
        "Version", "Engine Ver", "Short names", "Winesync           "
    };
    public string[] options_label_texts = {
        "HUD Version", "Gamemode", "VKbasalt", "Name", "Fcat", "FSR*", "HDR*", "Compact HUD", "Hide HUD           "
    };
    public string[] battery_label_texts = {
        "Percentage", "Wattage", "Time remain", "Device                 "
    };
    public string[] other_extra_label_texts = {
        "Media", "Network", "Full ON", "Log Versioning", "Upload Results "
    };
    public string[] inform_label_texts = {
        "FPS", "FPS Color", "FPS low 1%", "FPS low 0.1%", "Frame limit", "Frame time", "Histogram/Curve", "Frame", "VPS"
    };
    public bool test_button_pressed = false;
    public Entry custom_text_center_entry;
    public Switch custom_switch;
    public Scale borders_scale;
    public Scale alpha_scale;
    public Label borders_value_label;
    public Label alpha_value_label;
    public DropDown position_dropdown;
    public Scale colums_scale;
    public Label colums_value_label;
    public Entry toggle_hud_entry;
    public Scale font_size_scale;
    public Label font_size_value_label;
    public DropDown font_dropdown;

    public string[] vulkan_values = { "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] vulkan_config_values = { "0", "1", "3", "2" };

    public string[] opengl_values = { "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] opengl_config_values = { "-1", "0", "1", "n" };

    public Entry gpu_text_entry;
    public ColorDialogButton gpu_color_button;
    public Entry cpu_text_entry;
    public ColorDialogButton cpu_color_button;

    public Gee.ArrayList<Box> box_pool = new Gee.ArrayList<Box> ();
    public Gee.ArrayList<Label> label_pool = new Gee.ArrayList<Label> ();

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

    public MangoJuice () {
        Object (application_id: "io.github.radiolamp.mangojuice", flags: ApplicationFlags.DEFAULT_FLAGS);
    }

    protected override void activate () {
        var window = new Adw.ApplicationWindow (this);
        window.set_default_size (955, 600);
        window.set_title ("MangoJuice");

        var main_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        main_box.set_homogeneous (true);

        var view_stack = new ViewStack ();
        var toolbar_view_switcher = new ViewSwitcher ();
        toolbar_view_switcher.stack = view_stack;

        var metrics_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var extras_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var performance_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var visual_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);

        initialize_switches_and_labels (metrics_box, extras_box, performance_box, visual_box);
        initialize_custom_controls (extras_box, visual_box);

        var metrics_scrolled_window = new ScrolledWindow ();
        metrics_scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        metrics_scrolled_window.set_vexpand (true);
        metrics_scrolled_window.set_child (metrics_box);

        var extras_scrolled_window = new ScrolledWindow ();
        extras_scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        extras_scrolled_window.set_vexpand (true);
        extras_scrolled_window.set_child (extras_box);

        var performance_scrolled_window = new ScrolledWindow ();
        performance_scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        performance_scrolled_window.set_vexpand (true);
        performance_scrolled_window.set_child (performance_box);

        var visual_scrolled_window = new ScrolledWindow ();
        visual_scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        visual_scrolled_window.set_vexpand (true);
        visual_scrolled_window.set_child (visual_box);

        view_stack.add_titled (metrics_scrolled_window, "metrics_box", "Metrics").icon_name = "io.github.radiolamp.mangojuice-metrics-symbolic";
        view_stack.add_titled (extras_scrolled_window, "extras_box", "Extras").icon_name = "io.github.radiolamp.mangojuice-extras-symbolic";
        view_stack.add_titled (performance_scrolled_window, "performance_box", "Performance").icon_name = "io.github.radiolamp.mangojuice-performance-symbolic";
        view_stack.add_titled (visual_scrolled_window, "visual_box", "Visual").icon_name = "io.github.radiolamp.mangojuice-visual-symbolic";

        var header_bar = new Adw.HeaderBar ();
        header_bar.set_title_widget (toolbar_view_switcher);

        save_button = new Button.with_label ("Save");
        save_button.add_css_class ("suggested-action");
        header_bar.pack_end (save_button);
        save_button.clicked.connect ( () => {
            SaveStates.save_states_to_file (this);
            if (test_button_pressed) restart_vkcube ();
        });

        var test_button = new Button.with_label ("Test");
        test_button.clicked.connect ( () => {
            try {
                Process.spawn_command_line_sync ("pkill vkcube");
                Process.spawn_command_line_async ("mangohud vkcube");
                test_button_pressed = true;
            } catch (Error e) {
                stderr.printf ("Error when running the command: %s\n", e.message);
            }
        });
        header_bar.pack_start (test_button);

        var menu_button = new MenuButton ();
        var menu_model = new GLib.Menu ();
        var about_item = new GLib.MenuItem ("About", "app.about");
        menu_model.append_item (about_item);
        menu_button.set_menu_model (menu_model);
        menu_button.set_icon_name ("open-menu-symbolic"); 
        header_bar.pack_end (menu_button);

        var content_box = new Box (Orientation.VERTICAL, 0);
        content_box.append (header_bar);
        content_box.append (view_stack);
        window.set_content (content_box);

        window.present ();
        load_states_from_file ();

        window.close_request.connect ( () => {
            if (is_vkcube_running ()) {
                try {
                    Process.spawn_command_line_sync ("pkill vkcube");
                } catch (Error e) {
                    stderr.printf ("Error closing vkcube: %s\n", e.message);
                }
            }
            return false;
        });

        inform_switches[2].notify["active"].connect ( () => {
            if (inform_switches[2].active) inform_switches[3].active = false;
        });

        inform_switches[3].notify["active"].connect ( () => {
            if (inform_switches[3].active) inform_switches[2].active = false;
        });

        inform_switches[1].notify["active"].connect ( () => {
            if (inform_switches[1].active) {
                inform_switches[0].active = true;
            }
        });

        inform_switches[0].notify["active"].connect ( () => {
            if (!inform_switches[0].active) {
                inform_switches[1].active = false;
            }
        });

        inform_switches[6].notify["active"].connect ( () => {
            if (inform_switches[6].active) {
                inform_switches[5].active = true;
            }
        });
        inform_switches[5].notify["active"].connect ( () => {
            if (!inform_switches[5].active) {
                inform_switches[6].active = false;
            }
        });

        cpu_switches[3].notify["active"].connect ( () => {
            if (cpu_switches[3].active) {
                cpu_switches[2].active = true;
            }
        });
        cpu_switches[3].notify["active"].connect ( () => {
            if (!cpu_switches[3].active) {
                cpu_switches[2].active = false;
            }
        });

        add_scroll_event_handler (duracion_scale);
        add_scroll_event_handler (autostart_scale);
        add_scroll_event_handler (interval_scale);
        add_scroll_event_handler (scale);
        add_scroll_event_handler (af);
        add_scroll_event_handler (picmip);
        add_scroll_event_handler (borders_scale);
        add_scroll_event_handler (colums_scale);
        add_scroll_event_handler (font_size_scale);

        toolbar_view_switcher.add_css_class ("viewswitcher");
        var style_manager = Adw.StyleManager.get_default ();
        style_manager.set_color_scheme (Adw.ColorScheme.DEFAULT);

        if (!is_vkcube_available ()) {
            test_button.set_visible (false);
        }

        var about_action = new SimpleAction ("about", null);
        about_action.activate.connect (on_about_button_clicked);
        this.add_action (about_action);

    }

    public void add_scroll_event_handler (Scale scale) {
        var controller = new EventControllerScroll (EventControllerScrollFlags.VERTICAL);
        var motion_controller = new EventControllerMotion ();
        uint timeout_id = 0;

        motion_controller.enter.connect ( () => {
            timeout_id = Timeout.add (500, () => {
                controller.scroll.disconnect (ignore_scroll);
                timeout_id = 0;
                return false;
            });
        });

        motion_controller.leave.connect ( () => {
            if (timeout_id != 0) {
                Source.remove (timeout_id);
                timeout_id = 0;
            }
            controller.scroll.connect (ignore_scroll);
        });

        controller.scroll.connect (ignore_scroll);

        scale.add_controller (controller);
        scale.add_controller (motion_controller);

        scale.set_increments (1, 1);
    }

    private bool ignore_scroll (double dx, double dy) {
        return true;
    }

    public void initialize_switches_and_labels (Box metrics_box, Box extras_box, Box performance_box, Box visual_box) {
        gpu_switches = new Switch[gpu_config_vars.length];
        cpu_switches = new Switch[cpu_config_vars.length];
        other_switches = new Switch[other_config_vars.length];
        system_switches = new Switch[system_config_vars.length];
        wine_switches = new Switch[wine_config_vars.length];
        options_switches = new Switch[options_config_vars.length];
        battery_switches = new Switch[battery_config_vars.length];
        other_extra_switches = new Switch[other_extra_config_vars.length];
        inform_switches = new Switch[inform_config_vars.length];

        gpu_labels = new Label[gpu_label_texts.length];
        cpu_labels = new Label[cpu_label_texts.length];
        other_labels = new Label[other_label_texts.length];
        system_labels = new Label[system_label_texts.length];
        wine_labels = new Label[wine_label_texts.length];
        options_labels = new Label[options_label_texts.length];
        battery_labels = new Label[battery_label_texts.length];
        other_extra_labels = new Label[other_extra_label_texts.length];
        inform_labels = new Label[inform_label_texts.length];

        create_switches_and_labels (metrics_box, GPU_TITLE, gpu_switches, gpu_labels, gpu_config_vars, gpu_label_texts);
        create_switches_and_labels (metrics_box, CPU_TITLE, cpu_switches, cpu_labels, cpu_config_vars, cpu_label_texts);
        create_switches_and_labels (metrics_box, OTHER_TITLE, other_switches, other_labels, other_config_vars, other_label_texts);
        create_switches_and_labels (extras_box, SYSTEM_TITLE, system_switches, system_labels, system_config_vars, system_label_texts);
        create_switches_and_labels (extras_box, WINE_TITLE, wine_switches, wine_labels, wine_config_vars, wine_label_texts);
        create_switches_and_labels (extras_box, OPTIONS_TITLE, options_switches, options_labels, options_config_vars, options_label_texts);
        create_switches_and_labels (extras_box, BATTERY_TITLE, battery_switches, battery_labels, battery_config_vars, battery_label_texts);
        create_switches_and_labels (extras_box, OTHER_EXTRA_TITLE, other_extra_switches, other_extra_labels, other_extra_config_vars, other_extra_label_texts);
        create_scales_and_labels (extras_box);
        create_switches_and_labels (performance_box, INFORM_TITLE, inform_switches, inform_labels, inform_config_vars, inform_label_texts);
        create_limiters_and_filters (performance_box);


        for (int i = 1; i < gpu_switches.length; i++) {
            gpu_switches[i].notify["active"].connect ( () => {
                update_gpu_stats_state ();
            });
        }

        for (int i = 1; i < cpu_switches.length; i++) {
            cpu_switches[i].notify["active"].connect ( () => {
                update_cpu_stats_state ();
            });
        }
    }

    public void update_gpu_stats_state () {
        bool any_gpu_switch_active = false;

        for (int i = 0; i < gpu_switches.length; i++) {
            if (gpu_switches[i].active && gpu_config_vars[i] != "vram" && gpu_config_vars[i] != "gpu_name") {
                any_gpu_switch_active = true;
                break;
            }
        }

        gpu_switches[0].active = any_gpu_switch_active;
    }

    public void update_cpu_stats_state () {
        bool any_cpu_switch_active = false;

        for (int i = 0; i < cpu_switches.length; i++) {
            if (cpu_switches[i].active && cpu_config_vars[i] != "core_load" && cpu_config_vars[i] != "core_bars") {
                any_cpu_switch_active = true;
                break;
            }
        }

        cpu_switches[0].active = any_cpu_switch_active;
    }

    public void initialize_custom_controls (Box extras_box, Box visual_box) {
        custom_command_entry = new Entry ();
        custom_command_entry.placeholder_text = "Mangohud variable";
        custom_command_entry.hexpand = true;

        custom_logs_path_entry = new Entry ();
        custom_logs_path_entry.placeholder_text = "Home";

        logs_path_button = new Button.with_label ("Folder logs");
        logs_path_button.clicked.connect ( () => open_folder_chooser_dialog ());

        intel_power_fix_button = new Button.with_label ("Intel Power Fix");
        intel_power_fix_button.clicked.connect ( () => {
            try {
                Process.spawn_command_line_sync ("pkexec chmod 0644 /sys/class/powercap/intel-rapl\\:0/energy_uj");
            } catch (Error e) {
                stderr.printf ("Error when executing the command: %s\n", e.message);
            }
        });

        logs_key_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "Shift_L+F2", "Shift_L+F3", "Shift_L+F4", "Shift_L+F5" }) {
            logs_key_model.append (item);
        }
        logs_key_combo = new DropDown (logs_key_model, null);
        logs_key_combo.notify["selected-item"].connect ( () => {
            update_logs_key_in_file ( (logs_key_combo.selected_item as StringObject)?.get_string () ?? "");
        });

        reset_button = new Button.with_label ("Reset Config");
        reset_button.add_css_class ("destructive-action");
        reset_button.clicked.connect ( () => {
            delete_mangohub_conf ();
            restart_application ();
        });

        var custom_command_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        custom_command_box.set_margin_start (FLOW_BOX_MARGIN);
        custom_command_box.set_margin_end (FLOW_BOX_MARGIN);
        custom_command_box.set_margin_top (FLOW_BOX_MARGIN);
        custom_command_box.set_margin_bottom (FLOW_BOX_MARGIN);
        custom_command_box.append (custom_command_entry);
        custom_command_box.append (new Label ("Logs key"));
        custom_command_box.append (logs_key_combo);
        custom_command_box.append (new Label (""));
        custom_command_box.append (custom_logs_path_entry);
        custom_command_box.append (logs_path_button);
        custom_command_box.append (intel_power_fix_button);
        custom_command_box.append (reset_button);
        extras_box.append (custom_command_box);

        var customize_label = new Label ("Customize");
        customize_label.set_halign (Align.CENTER);
        customize_label.set_margin_top (FLOW_BOX_MARGIN);
        customize_label.set_margin_start (FLOW_BOX_MARGIN);
        customize_label.set_margin_end (FLOW_BOX_MARGIN);
        var customize_font_description = new Pango.FontDescription ();
        customize_font_description.set_weight (Pango.Weight.BOLD);
        var customize_attr_list = new Pango.AttrList ();
        customize_attr_list.insert (new Pango.AttrFontDesc (customize_font_description));
        customize_label.set_attributes (customize_attr_list);
        visual_box.append (customize_label);

        custom_text_center_entry = new Entry ();
        custom_text_center_entry.placeholder_text = "You text";
        custom_text_center_entry.hexpand = true;

        var customize_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        customize_box.set_margin_start (FLOW_BOX_MARGIN);
        customize_box.set_margin_end (FLOW_BOX_MARGIN);
        customize_box.set_margin_top (FLOW_BOX_MARGIN);
        customize_box.set_margin_bottom (FLOW_BOX_MARGIN);
        customize_box.append (custom_text_center_entry);
        visual_box.append (customize_box);

        var custom_switch_label = new Label ("Horizontal Hud");
        custom_switch_label.set_halign (Align.CENTER);

        custom_switch = new Switch ();
        custom_switch.set_valign (Align.CENTER);
        custom_switch.set_margin_end (FLOW_BOX_MARGIN);

        borders_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 15, -1);
        borders_scale.set_hexpand (true);
        borders_value_label = new Label ("");
        borders_value_label.set_halign (Align.END);
        borders_scale.value_changed.connect ( () => borders_value_label.label = "%d".printf ( (int)borders_scale.get_value ()));

        alpha_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 100, 1);
        alpha_scale.set_hexpand (true);
        alpha_scale.set_value (50);
        alpha_value_label = new Label ("");
        alpha_value_label.set_halign (Align.END);
        alpha_scale.value_changed.connect ( () => {
            double value = alpha_scale.get_value ();
            alpha_value_label.label = "%.1f".printf (value / 100.0);
        });

        var custom_switch_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        custom_switch_box.set_margin_start (FLOW_BOX_MARGIN);
        custom_switch_box.set_margin_end (FLOW_BOX_MARGIN);
        custom_switch_box.set_margin_top (FLOW_BOX_MARGIN);
        custom_switch_box.set_margin_bottom (FLOW_BOX_MARGIN);
        custom_switch_box.append (custom_switch_label);
        custom_switch_box.append (custom_switch);
        custom_switch_box.append (new Label ("Borders"));
        custom_switch_box.append (borders_scale);
        custom_switch_box.append (borders_value_label);
        custom_switch_box.append (new Label ("Alpha"));
        custom_switch_box.append (alpha_scale);
        custom_switch_box.append (alpha_value_label);
        visual_box.append (custom_switch_box);

        var position_model = new Gtk.StringList (null);
        foreach (var item in new string[] {
            "top-left", "top-center", "top-right",
            "middle-left", "middle-right",
            "bottom-left", "bottom-center", "bottom-right"
        }) {
            position_model.append (item);
        }
        position_dropdown = new DropDown (position_model, null);
        position_dropdown.set_size_request (100, -1);
        position_dropdown.set_valign (Align.CENTER);
        position_dropdown.notify["selected-item"].connect ( () => {
            update_position_in_file ( (position_dropdown.selected_item as StringObject)?.get_string () ?? "");
        });

        colums_scale = new Scale.with_range (Orientation.HORIZONTAL, 1, 6, -1);
        colums_scale.set_hexpand (true);
        colums_scale.set_value (3);
        colums_value_label = new Label ("");
        colums_value_label.set_halign (Align.END);
        colums_scale.value_changed.connect ( () => colums_value_label.label = "%d".printf ( (int)colums_scale.get_value ()));

        toggle_hud_entry = new Entry ();
        toggle_hud_entry.placeholder_text = "Key";
        toggle_hud_entry.text = "Shift_R+F12";
        toggle_hud_entry.set_size_request (20, -1);
        toggle_hud_entry.set_margin_top (FLOW_BOX_MARGIN);
        toggle_hud_entry.set_margin_bottom (FLOW_BOX_MARGIN);
        toggle_hud_entry.changed.connect ( () => {
            update_toggle_hud_in_file (toggle_hud_entry.text);
        });

        var position_colums_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        position_colums_box.set_margin_start (FLOW_BOX_MARGIN);
        position_colums_box.set_margin_end (FLOW_BOX_MARGIN);
        position_colums_box.set_margin_top (FLOW_BOX_MARGIN);
        position_colums_box.set_margin_bottom (FLOW_BOX_MARGIN);
        position_colums_box.append (new Label ("Position"));
        position_colums_box.append (position_dropdown);
        position_colums_box.append (new Label ("Colums"));
        position_colums_box.append (colums_scale);
        position_colums_box.append (colums_value_label);
        position_colums_box.append (new Label ("Toggle HUD"));
        position_colums_box.append (toggle_hud_entry);
        visual_box.append (position_colums_box);

        var fonts_label = new Label ("Font");
        fonts_label.set_halign (Align.CENTER);
        fonts_label.set_margin_top (FLOW_BOX_MARGIN);
        fonts_label.set_margin_start (FLOW_BOX_MARGIN);
        fonts_label.set_margin_end (FLOW_BOX_MARGIN);
        var fonts_font_description = new Pango.FontDescription ();
        fonts_font_description.set_weight (Pango.Weight.BOLD);
        var fonts_attr_list = new Pango.AttrList ();
        fonts_attr_list.insert (new Pango.AttrFontDesc (fonts_font_description));
        fonts_label.set_attributes (fonts_attr_list);
        visual_box.append (fonts_label);

        font_size_scale = new Scale.with_range (Orientation.HORIZONTAL, 8, 64, 1);
        font_size_scale.set_hexpand (true);
        font_size_scale.set_value (24);
        font_size_value_label = new Label ("");
        font_size_value_label.set_halign (Align.END);
        font_size_scale.value_changed.connect ( () => {
            font_size_value_label.label = "%d".printf ( (int)font_size_scale.get_value ());
            update_font_size_in_file ("%d".printf ( (int)font_size_scale.get_value ()));
        });

        initialize_font_dropdown (visual_box);

        var fonts_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        fonts_box.set_margin_start (FLOW_BOX_MARGIN);
        fonts_box.set_margin_end (FLOW_BOX_MARGIN);
        fonts_box.set_margin_top (FLOW_BOX_MARGIN);
        fonts_box.set_margin_bottom (FLOW_BOX_MARGIN);
        fonts_box.append (new Label ("Font"));
        fonts_box.append (font_dropdown);
        fonts_box.append (new Label ("Size"));
        fonts_box.append (font_size_scale);
        fonts_box.append (font_size_value_label);
        visual_box.append (fonts_box);

        var color_label = new Label ("Color");
        color_label.set_halign (Align.CENTER);
        color_label.set_margin_top (FLOW_BOX_MARGIN);
        color_label.set_margin_bottom (FLOW_BOX_MARGIN);
        color_label.set_margin_start (FLOW_BOX_MARGIN);
        color_label.set_margin_end (FLOW_BOX_MARGIN);
        var color_font_description = new Pango.FontDescription ();
        color_font_description.set_weight (Pango.Weight.BOLD);
        var color_attr_list = new Pango.AttrList ();
        color_attr_list.insert (new Pango.AttrFontDesc (color_font_description));
        color_label.set_attributes (color_attr_list);
        visual_box.append (color_label);

        var color_flow_box = new FlowBox ();
        color_flow_box.set_homogeneous (true);
        color_flow_box.set_max_children_per_line (9);
        color_flow_box.set_min_children_per_line (3);
        color_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        color_flow_box.set_column_spacing (FLOW_BOX_COLUMN_SPACING);
        color_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        color_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        color_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        color_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        color_flow_box.set_selection_mode (SelectionMode.NONE);

        var color_dialog = new ColorDialog ();
        gpu_color_button = new ColorDialogButton (color_dialog);
        var default_gpu_color = Gdk.RGBA ();
        default_gpu_color.parse ("#2e9762");
        gpu_color_button.set_rgba (default_gpu_color);
        gpu_color_button.notify["rgba"].connect ( () => {
            var rgba = gpu_color_button.get_rgba ().copy ();
            update_gpu_color_in_file (rgba_to_hex (rgba));
        });

        cpu_color_button = new ColorDialogButton (color_dialog);
        var default_cpu_color = Gdk.RGBA ();
        default_cpu_color.parse ("#2e97cb");
        cpu_color_button.set_rgba (default_cpu_color);
        cpu_color_button.notify["rgba"].connect ( () => {
            var rgba = cpu_color_button.get_rgba ().copy ();
            update_cpu_color_in_file (rgba_to_hex (rgba));
        });

        gpu_text_entry = new Entry ();
        gpu_text_entry.placeholder_text = "GPU custom name";
        gpu_text_entry.hexpand = true;
        gpu_text_entry.changed.connect ( () => {
            update_gpu_text_in_file (gpu_text_entry.text);
        });

        cpu_text_entry = new Entry ();
        cpu_text_entry.placeholder_text = "CPU custom name";
        cpu_text_entry.hexpand = true;
        cpu_text_entry.changed.connect ( () => {
            update_cpu_text_in_file (cpu_text_entry.text);
        });

        var color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        color_box.set_margin_start (FLOW_BOX_MARGIN);
        color_box.set_margin_end (FLOW_BOX_MARGIN);
        color_box.set_margin_top (FLOW_BOX_MARGIN);
        color_box.set_margin_bottom (FLOW_BOX_MARGIN);
        color_box.append (gpu_text_entry);
        color_box.append (gpu_color_button);
        color_box.append (cpu_text_entry);
        color_box.append (cpu_color_button);
        visual_box.append (color_box);

        fps_value_entry_1 = new Entry ();
        fps_value_entry_1.placeholder_text = "Medium";
        fps_value_entry_1.text = "30";
        fps_value_entry_1.hexpand = true;
        fps_value_entry_1.changed.connect ( () => {
            update_fps_value_in_file (fps_value_entry_1.text, fps_value_entry_2.text);
        });

        fps_value_entry_2 = new Entry ();
        fps_value_entry_2.placeholder_text = "High";
        fps_value_entry_2.text = "60";
        fps_value_entry_2.hexpand = true;
        fps_value_entry_2.changed.connect ( () => {
            update_fps_value_in_file (fps_value_entry_1.text, fps_value_entry_2.text);
        });

        var fps_clarge_label = new Label ("Charge FPS");
        fps_clarge_label.set_halign (Align.START);

        var color_dialog_fps = new ColorDialog ();
        fps_color_button_1 = new ColorDialogButton (color_dialog_fps);
        var default_fps_color_1 = Gdk.RGBA ();
        default_fps_color_1.parse ("#cc0000");
        fps_color_button_1.set_rgba (default_fps_color_1);
        fps_color_button_1.notify["rgba"].connect ( () => {
            var rgba = fps_color_button_1.get_rgba ().copy ();
            update_fps_color_in_file (rgba_to_hex (rgba), rgba_to_hex (fps_color_button_2.get_rgba ()), rgba_to_hex (fps_color_button_3.get_rgba ()));
        });

        fps_color_button_2 = new ColorDialogButton (color_dialog_fps);
        var default_fps_color_2 = Gdk.RGBA ();
        default_fps_color_2.parse ("#ffaa7f");
        fps_color_button_2.set_rgba (default_fps_color_2);
        fps_color_button_2.notify["rgba"].connect ( () => {
            var rgba = fps_color_button_2.get_rgba ().copy ();
            update_fps_color_in_file (rgba_to_hex (fps_color_button_1.get_rgba ()), rgba_to_hex (rgba), rgba_to_hex (fps_color_button_3.get_rgba ()));
        });

        fps_color_button_3 = new ColorDialogButton (color_dialog_fps);
        var default_fps_color_3 = Gdk.RGBA ();
        default_fps_color_3.parse ("#92e79a");
        fps_color_button_3.set_rgba (default_fps_color_3);
        fps_color_button_3.notify["rgba"].connect ( () => {
            var rgba = fps_color_button_3.get_rgba ().copy ();
            update_fps_color_in_file (rgba_to_hex (fps_color_button_1.get_rgba ()), rgba_to_hex (fps_color_button_2.get_rgba ()), rgba_to_hex (rgba));
        });

        var fps_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        fps_color_box.set_margin_start (FLOW_BOX_MARGIN);
        fps_color_box.set_margin_end (FLOW_BOX_MARGIN);
        fps_color_box.set_margin_top (FLOW_BOX_MARGIN);
        fps_color_box.set_margin_bottom (FLOW_BOX_MARGIN);
        fps_color_box.append (fps_clarge_label);
        fps_color_box.append (fps_value_entry_1);
        fps_color_box.append (fps_value_entry_2);
        fps_color_box.append (fps_color_button_1);
        fps_color_box.append (fps_color_button_2);
        fps_color_box.append (fps_color_button_3);
        visual_box.append (fps_color_box);

        gpu_load_value_entry_1 = new Entry ();
        gpu_load_value_entry_1.placeholder_text = "Medium";
        gpu_load_value_entry_1.text = "60";
        gpu_load_value_entry_1.hexpand = true;
        gpu_load_value_entry_1.changed.connect ( () => {
            update_gpu_load_value_in_file (gpu_load_value_entry_1.text, gpu_load_value_entry_2.text);
        });

        gpu_load_value_entry_2 = new Entry ();
        gpu_load_value_entry_2.placeholder_text = "High";
        gpu_load_value_entry_2.text = "90";
        gpu_load_value_entry_2.hexpand = true;
        gpu_load_value_entry_2.changed.connect ( () => {
            update_gpu_load_value_in_file (gpu_load_value_entry_1.text, gpu_load_value_entry_2.text);
        });

        var gpu_load_clarge_label = new Label ("GPU Load %");
        gpu_load_clarge_label.set_halign (Align.START);

        var color_dialog_gpu_load = new ColorDialog ();
        gpu_load_color_button_1 = new ColorDialogButton (color_dialog_gpu_load);
        var default_gpu_load_color_1 = Gdk.RGBA ();
        default_gpu_load_color_1.parse ("#92e79a");
        gpu_load_color_button_1.set_rgba (default_gpu_load_color_1);
        gpu_load_color_button_1.notify["rgba"].connect ( () => {
            var rgba = gpu_load_color_button_1.get_rgba ().copy ();
            update_gpu_load_color_in_file (rgba_to_hex (rgba), rgba_to_hex (gpu_load_color_button_2.get_rgba ()), rgba_to_hex (gpu_load_color_button_3.get_rgba ()));
        });

        gpu_load_color_button_2 = new ColorDialogButton (color_dialog_gpu_load);
        var default_gpu_load_color_2 = Gdk.RGBA ();
        default_gpu_load_color_2.parse ("#ffaa7f");
        gpu_load_color_button_2.set_rgba (default_gpu_load_color_2);
        gpu_load_color_button_2.notify["rgba"].connect ( () => {
            var rgba = gpu_load_color_button_2.get_rgba ().copy ();
            update_gpu_load_color_in_file (rgba_to_hex (gpu_load_color_button_1.get_rgba ()), rgba_to_hex (rgba), rgba_to_hex (gpu_load_color_button_3.get_rgba ()));
        });

        gpu_load_color_button_3 = new ColorDialogButton (color_dialog_gpu_load);
        var default_gpu_load_color_3 = Gdk.RGBA ();
        default_gpu_load_color_3.parse ("#cc0000");
        gpu_load_color_button_3.set_rgba (default_gpu_load_color_3);
        gpu_load_color_button_3.notify["rgba"].connect ( () => {
            var rgba = gpu_load_color_button_3.get_rgba ().copy ();
            update_gpu_load_color_in_file (rgba_to_hex (gpu_load_color_button_1.get_rgba ()), rgba_to_hex (gpu_load_color_button_2.get_rgba ()), rgba_to_hex (rgba));
        });

        var gpu_load_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        gpu_load_color_box.set_margin_start (FLOW_BOX_MARGIN);
        gpu_load_color_box.set_margin_end (FLOW_BOX_MARGIN);
        gpu_load_color_box.set_margin_top (FLOW_BOX_MARGIN);
        gpu_load_color_box.set_margin_bottom (FLOW_BOX_MARGIN);
        gpu_load_color_box.append (gpu_load_clarge_label);
        gpu_load_color_box.append (gpu_load_value_entry_1);
        gpu_load_color_box.append (gpu_load_value_entry_2);
        gpu_load_color_box.append (gpu_load_color_button_1);
        gpu_load_color_box.append (gpu_load_color_button_2);
        gpu_load_color_box.append (gpu_load_color_button_3);
        visual_box.append (gpu_load_color_box);

        cpu_load_value_entry_1 = new Entry ();
        cpu_load_value_entry_1.placeholder_text = "Medium";
        cpu_load_value_entry_1.text = "60";
        cpu_load_value_entry_1.hexpand = true;
        cpu_load_value_entry_1.changed.connect ( () => {
            update_cpu_load_value_in_file (cpu_load_value_entry_1.text, cpu_load_value_entry_2.text);
        });

        cpu_load_value_entry_2 = new Entry ();
        cpu_load_value_entry_2.placeholder_text = "High";
        cpu_load_value_entry_2.text = "90";
        cpu_load_value_entry_2.hexpand = true;
        cpu_load_value_entry_2.changed.connect ( () => {
            update_cpu_load_value_in_file (cpu_load_value_entry_1.text, cpu_load_value_entry_2.text);
        });

        var cpu_load_clarge_label = new Label ("CPU Load %");
        cpu_load_clarge_label.set_halign (Align.START);

        var color_dialog_cpu_load = new ColorDialog ();
        cpu_load_color_button_1 = new ColorDialogButton (color_dialog_cpu_load);
        var default_cpu_load_color_1 = Gdk.RGBA ();
        default_cpu_load_color_1.parse ("#92e79a");
        cpu_load_color_button_1.set_rgba (default_cpu_load_color_1);
        cpu_load_color_button_1.notify["rgba"].connect ( () => {
            var rgba = cpu_load_color_button_1.get_rgba ().copy ();
            update_cpu_load_color_in_file (rgba_to_hex (rgba), rgba_to_hex (cpu_load_color_button_2.get_rgba ()), rgba_to_hex (cpu_load_color_button_3.get_rgba ()));
        });

        cpu_load_color_button_2 = new ColorDialogButton (color_dialog_cpu_load);
        var default_cpu_load_color_2 = Gdk.RGBA ();
        default_cpu_load_color_2.parse ("#ffaa7f");
        cpu_load_color_button_2.set_rgba (default_cpu_load_color_2);
        cpu_load_color_button_2.notify["rgba"].connect ( () => {
            var rgba = cpu_load_color_button_2.get_rgba ().copy ();
            update_cpu_load_color_in_file (rgba_to_hex (cpu_load_color_button_1.get_rgba ()), rgba_to_hex (rgba), rgba_to_hex (cpu_load_color_button_3.get_rgba ()));
        });

        cpu_load_color_button_3 = new ColorDialogButton (color_dialog_cpu_load);
        var default_cpu_load_color_3 = Gdk.RGBA ();
        default_cpu_load_color_3.parse ("#cc0000");
        cpu_load_color_button_3.set_rgba (default_cpu_load_color_3);
        cpu_load_color_button_3.notify["rgba"].connect ( () => {
            var rgba = cpu_load_color_button_3.get_rgba ().copy ();
            update_cpu_load_color_in_file (rgba_to_hex (cpu_load_color_button_1.get_rgba ()), rgba_to_hex (cpu_load_color_button_2.get_rgba ()), rgba_to_hex (rgba));
        });

        var cpu_load_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        cpu_load_color_box.set_margin_start (FLOW_BOX_MARGIN);
        cpu_load_color_box.set_margin_end (FLOW_BOX_MARGIN);
        cpu_load_color_box.set_margin_top (FLOW_BOX_MARGIN);
        cpu_load_color_box.set_margin_bottom (FLOW_BOX_MARGIN);
        cpu_load_color_box.append (cpu_load_clarge_label);
        cpu_load_color_box.append (cpu_load_value_entry_1);
        cpu_load_color_box.append (cpu_load_value_entry_2);
        cpu_load_color_box.append (cpu_load_color_button_1);
        cpu_load_color_box.append (cpu_load_color_button_2);
        cpu_load_color_box.append (cpu_load_color_button_3);
        visual_box.append (cpu_load_color_box);

        background_color_button = new ColorDialogButton (color_dialog);
        var default_background_color = Gdk.RGBA ();
        default_background_color.parse ("#000000");
        background_color_button.set_rgba (default_background_color);
        background_color_button.notify["rgba"].connect ( () => {
            var rgba = background_color_button.get_rgba ().copy ();
            update_background_color_in_file (rgba_to_hex (rgba));
        });

        frametime_color_button = new ColorDialogButton (color_dialog);
        var default_frametime_color = Gdk.RGBA ();
        default_frametime_color.parse ("#00ff00");
        frametime_color_button.set_rgba (default_frametime_color);
        frametime_color_button.notify["rgba"].connect ( () => {
            var rgba = frametime_color_button.get_rgba ().copy ();
            update_frametime_color_in_file (rgba_to_hex (rgba));
        });

        vram_color_button = new ColorDialogButton (color_dialog);
        var default_vram_color = Gdk.RGBA ();
        default_vram_color.parse ("#ad64c1");
        vram_color_button.set_rgba (default_vram_color);
        vram_color_button.notify["rgba"].connect ( () => {
            var rgba = vram_color_button.get_rgba ().copy ();
            update_vram_color_in_file (rgba_to_hex (rgba));
        });

        ram_color_button = new ColorDialogButton (color_dialog);
        var default_ram_color = Gdk.RGBA ();
        default_ram_color.parse ("#c26693");
        ram_color_button.set_rgba (default_ram_color);
        ram_color_button.notify["rgba"].connect ( () => {
            var rgba = ram_color_button.get_rgba ().copy ();
            update_ram_color_in_file (rgba_to_hex (rgba));
        });

        wine_color_button = new ColorDialogButton (color_dialog);
        var default_wine_color = Gdk.RGBA ();
        default_wine_color.parse ("#eb5b5b");
        wine_color_button.set_rgba (default_wine_color);
        wine_color_button.notify["rgba"].connect ( () => {
            var rgba = wine_color_button.get_rgba ().copy ();
            update_wine_color_in_file (rgba_to_hex (rgba));
        });

        engine_color_button = new ColorDialogButton (color_dialog);
        var default_engine_color = Gdk.RGBA ();
        default_engine_color.parse ("#eb5b5b");
        engine_color_button.set_rgba (default_engine_color);
        engine_color_button.notify["rgba"].connect ( () => {
            var rgba = engine_color_button.get_rgba ().copy ();
            update_engine_color_in_file (rgba_to_hex (rgba));
        });

        text_color_button = new ColorDialogButton (color_dialog);
        var default_text_color = Gdk.RGBA ();
        default_text_color.parse ("#FFFFFF");
        text_color_button.set_rgba (default_text_color);
        text_color_button.notify["rgba"].connect ( () => {
            var rgba = text_color_button.get_rgba ().copy ();
            update_text_color_in_file (rgba_to_hex (rgba));
        });

        media_player_color_button = new ColorDialogButton (color_dialog);
        var default_media_player_color = Gdk.RGBA ();
        default_media_player_color.parse ("#FFFFFF");
        media_player_color_button.set_rgba (default_media_player_color);
        media_player_color_button.notify["rgba"].connect ( () => {
            var rgba = media_player_color_button.get_rgba ().copy ();
            update_media_player_color_in_file (rgba_to_hex (rgba));
        });

        network_color_button = new ColorDialogButton (color_dialog);
        var default_network_color = Gdk.RGBA ();
        default_network_color.parse ("#e07b85");
        network_color_button.set_rgba (default_network_color);
        network_color_button.notify["rgba"].connect ( () => {
            var rgba = network_color_button.get_rgba ().copy ();
            update_network_color_in_file (rgba_to_hex (rgba));
        });

        var background_color_label = new Label ("Background");
        background_color_label.set_halign (Align.START);
        background_color_label.hexpand = true;
        var background_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        background_color_box.append (background_color_button);
        background_color_box.append (background_color_label);
        color_flow_box.insert (background_color_box, -1);

        var frametime_color_label = new Label ("Frametime");
        frametime_color_label.set_halign (Align.START);
        frametime_color_label.hexpand = true;
        var frametime_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        frametime_color_box.append (frametime_color_button);
        frametime_color_box.append (frametime_color_label);
        color_flow_box.insert (frametime_color_box, -1);

        var vram_color_label = new Label ("VRAM");
        vram_color_label.set_halign (Align.START);
        vram_color_label.hexpand = true;
        var vram_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        vram_color_box.append (vram_color_button);
        vram_color_box.append (vram_color_label);
        color_flow_box.insert (vram_color_box, -1);

        var ram_color_label = new Label ("RAM");
        ram_color_label.set_halign (Align.START);
        ram_color_label.hexpand = true;
        var ram_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        ram_color_box.append (ram_color_button);
        ram_color_box.append (ram_color_label);
        color_flow_box.insert (ram_color_box, -1);

        var wine_color_label = new Label ("Wine");
        wine_color_label.set_halign (Align.START);
        wine_color_label.hexpand = true;
        var wine_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        wine_color_box.append (wine_color_button);
        wine_color_box.append (wine_color_label);
        color_flow_box.insert (wine_color_box, -1);

        var engine_color_label = new Label ("Engine");
        engine_color_label.set_halign (Align.START);
        engine_color_label.hexpand = true;
        var engine_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        engine_color_box.append (engine_color_button);
        engine_color_box.append (engine_color_label);
        color_flow_box.insert (engine_color_box, -1);

        var media_player_color_label = new Label ("Media");
        media_player_color_label.set_halign (Align.START);
        media_player_color_label.hexpand = true;
        var media_player_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        media_player_color_box.append (media_player_color_button);
        media_player_color_box.append (media_player_color_label);
        color_flow_box.insert (media_player_color_box, -1);

        var network_color_label = new Label ("Network");
        network_color_label.set_halign (Align.START);
        network_color_label.hexpand = true;
        var network_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        network_color_box.append (network_color_button);
        network_color_box.append (network_color_label);
        color_flow_box.insert (network_color_box, -1);

        var text_color_label = new Label ("Text");
        text_color_label.set_halign (Align.START);
        text_color_label.hexpand = true;
        var text_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        text_color_box.append (text_color_button);
        text_color_box.append (text_color_label);
        color_flow_box.insert (text_color_box, -1);

        visual_box.append (color_flow_box);

    }

    public void initialize_font_dropdown (Box visual_box) {
        var font_model = new Gtk.StringList (null);
        font_model.append ("Default");

        var fonts = new Gee.ArrayList<string> ();

        fonts.add_all (find_fonts ("/usr/share/fonts"));

        var local_fonts_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".local/share/fonts");
        if (!local_fonts_dir.query_exists ()) {
            try {
                local_fonts_dir.make_directory_with_parents ();
            } catch (Error e) {
                stderr.printf ("Error creating the directory: %s\n", e.message);
            }
        }
        fonts.add_all (find_fonts (local_fonts_dir.get_path ()));

        foreach (var font in fonts) {
            font_model.append (font);
        }

        font_dropdown = new DropDown (font_model, null);
        font_dropdown.set_size_request (100, -1);
        font_dropdown.set_valign (Align.CENTER);
        font_dropdown.notify["selected-item"].connect ( () => {
            update_font_file_in_file ( (font_dropdown.selected_item as StringObject)?.get_string () ?? "");
        });
    }

    public Gee.List<string> find_fonts (string directory) {
        var fonts = new Gee.ArrayList<string> ();
        var dir = File.new_for_path (directory);

        try {
            var enumerator = dir.enumerate_children (FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ( (file_info = enumerator.next_file ()) != null) {
                var file = dir.get_child (file_info.get_name ());
                if (file_info.get_file_type () == FileType.DIRECTORY) {
                    fonts.add_all (find_fonts (file.get_path ()));
                } else if (file_info.get_name ().has_suffix (".ttf")) {
                    fonts.add (file.get_path ());
                }
            }
        } catch (Error e) {
            stderr.printf ("Error when searching for fonts: %s\n", e.message);
        }

        return fonts;
    }

    public void create_switches_and_labels (Box parent_box, string title, Switch[] switches, Label[] labels, string[] config_vars, string[] label_texts) {
        var label = new Label (title);
        label.add_css_class ("bold-label");
        label.set_margin_top (FLOW_BOX_MARGIN);
        label.set_margin_start (FLOW_BOX_MARGIN);
        label.set_margin_end (FLOW_BOX_MARGIN);

        parent_box.append (label);

        var flow_box = new FlowBox ();
        flow_box.set_homogeneous (true);
        flow_box.set_max_children_per_line (5);
        flow_box.set_min_children_per_line (3);
        flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        flow_box.set_column_spacing (FLOW_BOX_COLUMN_SPACING);
        flow_box.set_margin_top (FLOW_BOX_MARGIN);
        flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        flow_box.set_margin_start (FLOW_BOX_MARGIN);
        flow_box.set_margin_end (FLOW_BOX_MARGIN);
        flow_box.set_selection_mode (SelectionMode.NONE);

        for (int i = 0; i < config_vars.length; i++) {
            var row_box = get_box ();
            switches[i] = new Switch ();
            labels[i] = get_label ();
            labels[i].label = label_texts[i];
            labels[i].set_halign (Align.START);
            row_box.append (switches[i]);
            row_box.append (labels[i]);
            flow_box.insert (row_box, -1);
        }

        parent_box.append (flow_box);
    }

    public Box get_box () {
        if (box_pool.size > 0) {
            return box_pool.remove_at (box_pool.size - 1);
        } else {
            return new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        }
    }

    public Label get_label () {
        if (label_pool.size > 0) {
            return label_pool.remove_at (label_pool.size - 1);
        } else {
            return new Label ("");
        }
    }

    public void create_scales_and_labels (Box parent_box) {
        duracion_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 200, 1);
        duracion_scale.set_value (30);
        duracion_scale.set_hexpand (true);
        duracion_scale.set_margin_start (FLOW_BOX_MARGIN);
        duracion_scale.set_margin_end (FLOW_BOX_MARGIN);
        duracion_scale.set_margin_top (FLOW_BOX_MARGIN);
        duracion_scale.set_margin_bottom (FLOW_BOX_MARGIN);
        duracion_value_label = new Label ("");
        duracion_value_label.set_halign (Align.END);
        duracion_scale.value_changed.connect ( () => duracion_value_label.label = "%d s".printf ( (int)duracion_scale.get_value ()));

        autostart_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 30, 1);
        autostart_scale.set_value (0);
        autostart_scale.set_hexpand (true);
        autostart_scale.set_margin_start (FLOW_BOX_MARGIN);
        autostart_scale.set_margin_end (FLOW_BOX_MARGIN);
        autostart_scale.set_margin_top (FLOW_BOX_MARGIN);
        autostart_scale.set_margin_bottom (FLOW_BOX_MARGIN);
        autostart_value_label = new Label ("");
        autostart_value_label.set_halign (Align.END);
        autostart_scale.value_changed.connect ( () => autostart_value_label.label = "%d s".printf ( (int)autostart_scale.get_value ()));

        interval_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 500, 1);
        interval_scale.set_value (100);
        interval_scale.set_hexpand (true);
        interval_scale.set_margin_start (FLOW_BOX_MARGIN);
        interval_scale.set_margin_end (FLOW_BOX_MARGIN);
        interval_scale.set_margin_top (FLOW_BOX_MARGIN);
        interval_scale.set_margin_bottom (FLOW_BOX_MARGIN);
        interval_value_label = new Label ("");
        interval_value_label.set_halign (Align.END);
        interval_scale.value_changed.connect ( () => interval_value_label.label = "%d ms".printf ( (int)interval_scale.get_value ()));

        var scales_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        scales_box.set_margin_start (FLOW_BOX_MARGIN);
        scales_box.set_margin_end (FLOW_BOX_MARGIN);
        scales_box.set_margin_top (FLOW_BOX_MARGIN);
        scales_box.set_margin_bottom (FLOW_BOX_MARGIN);
        scales_box.append (new Label ("Duracion"));
        scales_box.append (duracion_scale);
        scales_box.append (duracion_value_label);
        scales_box.append (new Label ("Autostart"));
        scales_box.append (autostart_scale);
        scales_box.append (autostart_value_label);
        scales_box.append (new Label ("Interval"));
        scales_box.append (interval_scale);
        scales_box.append (interval_value_label);

        var logging_label = new Label ("Logging");
        logging_label.set_valign (Align.CENTER);
        logging_label.set_margin_top (FLOW_BOX_MARGIN);
        logging_label.set_margin_start (FLOW_BOX_MARGIN);
        logging_label.set_margin_end (FLOW_BOX_MARGIN);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        logging_label.set_attributes (attr_list);

        parent_box.append (logging_label);
        parent_box.append (scales_box);
    }

    public void create_limiters_and_filters (Box performance_box) {
        var limiters_label = new Label (LIMITERS_TITLE);
        limiters_label.set_halign (Align.CENTER);
        limiters_label.set_margin_top (FLOW_BOX_MARGIN);
        limiters_label.set_margin_start (FLOW_BOX_MARGIN);
        limiters_label.set_margin_end (FLOW_BOX_MARGIN);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        limiters_label.set_attributes (attr_list);

        performance_box.append (limiters_label);

        var fps_limit_method_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "late", "early" }) {
            fps_limit_method_model.append (item);
        }
        fps_limit_method = new DropDown (fps_limit_method_model, null);

        scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 240, 1);
        fps_limit_label = new Label ("");
        scale.value_changed.connect ( () => fps_limit_label.label = "%d".printf ( (int)scale.get_value ()));

        var toggle_fps_limit_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "Shift_L+F1", "Shift_L+F2", "Shift_L+F3", "Shift_L+F4" }) {
            toggle_fps_limit_model.append (item);
        }
        toggle_fps_limit = new DropDown (toggle_fps_limit_model, null);

        var limiters_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        limiters_box.set_margin_start (FLOW_BOX_MARGIN);
        limiters_box.set_margin_end (FLOW_BOX_MARGIN);
        limiters_box.set_margin_top (FLOW_BOX_MARGIN);
        limiters_box.set_margin_bottom (FLOW_BOX_MARGIN);
        scale.set_hexpand (true);

        limiters_box.append (fps_limit_method);
        limiters_box.append (scale);
        limiters_box.append (fps_limit_label);
        limiters_box.append (toggle_fps_limit);
        performance_box.append (limiters_box);

        var vsync_label = new Label ("VSync");
        vsync_label.set_halign (Align.CENTER);
        vsync_label.set_margin_top (FLOW_BOX_MARGIN);
        vsync_label.set_margin_start (FLOW_BOX_MARGIN);
        vsync_label.set_margin_end (FLOW_BOX_MARGIN);

        font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        vsync_label.set_attributes (attr_list);

        performance_box.append (vsync_label);

        var vulkan_model = new Gtk.StringList (null);
        foreach (var item in vulkan_values) {
            vulkan_model.append (item);
        }
        vulkan_dropdown = new DropDown (vulkan_model, null);

        var opengl_model = new Gtk.StringList (null);
        foreach (var item in opengl_values) {
            opengl_model.append (item);
        }
        opengl_dropdown = new DropDown (opengl_model, null);

        var vulkan_label = new Label ("Vulkan");
        vulkan_label.set_halign (Align.START);
        vulkan_label.set_margin_start (FLOW_BOX_MARGIN);
        vulkan_label.set_margin_end (FLOW_BOX_MARGIN);

        var opengl_label = new Label ("OpenGL");
        opengl_label.set_halign (Align.START);
        opengl_label.set_margin_start (FLOW_BOX_MARGIN);
        opengl_label.set_margin_end (FLOW_BOX_MARGIN);

        var vsync_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        vsync_box.set_halign (Align.CENTER);
        vsync_box.set_margin_start (FLOW_BOX_MARGIN);
        vsync_box.set_margin_end (FLOW_BOX_MARGIN);
        vsync_box.set_margin_top (FLOW_BOX_MARGIN);
        vsync_box.set_margin_bottom (FLOW_BOX_MARGIN);
        vsync_box.append (vulkan_dropdown);
        vsync_box.append (vulkan_label);
        vsync_box.append (opengl_dropdown);
        vsync_box.append (opengl_label);
        performance_box.append (vsync_box);

        var filters_label = new Label (FILTERS_TITLE);
        filters_label.set_halign (Align.CENTER);
        filters_label.set_margin_top (FLOW_BOX_MARGIN);
        filters_label.set_margin_start (FLOW_BOX_MARGIN);
        filters_label.set_margin_end (FLOW_BOX_MARGIN);

        font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        filters_label.set_attributes (attr_list);

        performance_box.append (filters_label);

        var filter_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "none", "bicubic", "trilinear", "retro" }) {
            filter_model.append (item);
        }
        filter_dropdown = new DropDown (filter_model, null);
        filter_dropdown.set_size_request (100, -1);
        filter_dropdown.set_valign (Align.CENTER);

        af = new Scale.with_range (Orientation.HORIZONTAL, 0, 16, 1);
        af.set_hexpand (true);
        af_label = new Label ("");
        af_label.set_halign (Align.END);
        af.value_changed.connect ( () => af_label.label = "%d".printf ( (int)af.get_value ()));

        picmip = new Scale.with_range (Orientation.HORIZONTAL, -16, 16, 1);
        picmip.set_hexpand (true);
        picmip.set_value (0);
        picmip_label = new Label ("");
        picmip_label.set_halign (Align.END);
        picmip.value_changed.connect ( () => picmip_label.label = "%d".printf ( (int)picmip.get_value ()));

        var filters_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        filters_box.set_margin_start (FLOW_BOX_MARGIN);
        filters_box.set_margin_end (FLOW_BOX_MARGIN);
        filters_box.set_margin_top (FLOW_BOX_MARGIN);
        filters_box.set_margin_bottom (FLOW_BOX_MARGIN);
        filters_box.append (filter_dropdown);
        filters_box.append (new Label ("Anisotropic filtering"));
        filters_box.append (af);
        filters_box.append (af_label);
        filters_box.append (new Label ("Mipmap LoD bias"));
        filters_box.append (picmip);
        filters_box.append (picmip_label);
        performance_box.append (filters_box);
    }

    public void load_states_from_file () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                load_switch_from_file (line, gpu_switches, gpu_config_vars);
                load_switch_from_file (line, cpu_switches, cpu_config_vars);
                load_switch_from_file (line, other_switches, other_config_vars);
                load_switch_from_file (line, system_switches, system_config_vars);
                load_switch_from_file (line, wine_switches, wine_config_vars);
                load_switch_from_file (line, battery_switches, battery_config_vars);
                load_switch_from_file (line, other_extra_switches, other_extra_config_vars);
                load_switch_from_file (line, inform_switches, inform_config_vars);
                load_switch_from_file (line, options_switches, options_config_vars);

                if (line.has_prefix ("custom_command=")) {
                    custom_command_entry.text = line.substring ("custom_command=".length);
                }

                if (line.has_prefix ("toggle_logging=")) {
                    var logs_key = line.substring ("toggle_logging=".length);
                    for (uint i = 0; i < logs_key_model.get_n_items (); i++) {
                        var item = logs_key_model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == logs_key) {
                            logs_key_combo.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("log_duration=")) {
                    if (duracion_scale != null) {
                        duracion_scale.set_value (int.parse (line.substring ("log_duration=".length)));
                        if (duracion_value_label != null) {
                            duracion_value_label.label = "%d s".printf ( (int)duracion_scale.get_value ());
                        }
                    }
                }
                if (line.has_prefix ("autostart_log=")) {
                    if (autostart_scale != null) {
                        autostart_scale.set_value (int.parse (line.substring ("autostart_log=".length)));
                        if (autostart_value_label != null) {
                            autostart_value_label.label = "%d s".printf ( (int)autostart_scale.get_value ());
                        }
                    }
                }
                if (line.has_prefix ("log_interval=")) {
                    if (interval_scale != null) {
                        interval_scale.set_value (int.parse (line.substring ("log_interval=".length)));
                        if (interval_value_label != null) {
                            interval_value_label.label = "%d ms".printf ( (int)interval_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("output_folder=")) {
                    custom_logs_path_entry.text = line.substring ("output_folder=".length);
                }

                if (line.has_prefix ("fps_limit_method=")) {
                    var fps_limit_method_value = line.substring ("fps_limit_method=".length);
                    for (uint i = 0; i < fps_limit_method.model.get_n_items (); i++) {
                        var item = fps_limit_method.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == fps_limit_method_value) {
                            fps_limit_method.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("toggle_fps_limit=")) {
                    var toggle_fps_limit_value = line.substring ("toggle_fps_limit=".length);
                    for (uint i = 0; i < toggle_fps_limit.model.get_n_items (); i++) {
                        var item = toggle_fps_limit.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == toggle_fps_limit_value) {
                            toggle_fps_limit.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("fps_limit=")) {
                    if (scale != null) {
                        scale.set_value (int.parse (line.substring ("fps_limit=".length)));
                        if (fps_limit_label != null) {
                            fps_limit_label.label = "%d".printf ( (int)scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("vsync=")) {
                    var vulkan_config_value = line.substring ("vsync=".length);
                    var vulkan_value = get_vulkan_value_from_config (vulkan_config_value);
                    for (uint i = 0; i < vulkan_dropdown.model.get_n_items (); i++) {
                        var item = vulkan_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == vulkan_value) {
                            vulkan_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("gl_vsync=")) {
                    var opengl_config_value = line.substring ("gl_vsync=".length);
                    var opengl_value = get_opengl_value_from_config (opengl_config_value);
                    for (uint i = 0; i < opengl_dropdown.model.get_n_items (); i++) {
                        var item = opengl_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == opengl_value) {
                            opengl_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("filter=")) {
                    var filter_value = line.substring ("filter=".length);
                    for (uint i = 0; i < filter_dropdown.model.get_n_items (); i++) {
                        var item = filter_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == filter_value) {
                            filter_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("af=")) {
                    if (af != null) {
                        af.set_value (int.parse (line.substring ("af=".length)));
                        if (af_label != null) {
                            af_label.label = "%d".printf ( (int)af.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("picmip=")) {
                    if (picmip != null) {
                        picmip.set_value (int.parse (line.substring ("picmip=".length)));
                        if (picmip_label != null) {
                            picmip_label.label = "%d".printf ( (int)picmip.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("custom_text_center=")) {
                    custom_text_center_entry.text = line.substring ("custom_text_center=".length);
                }

                if (line.has_prefix ("horizontal")) {
                    custom_switch.active = true;
                }

                if (line.has_prefix ("round_corners=")) {
                    if (borders_scale != null) {
                        borders_scale.set_value (int.parse (line.substring ("round_corners=".length)));
                        if (borders_value_label != null) {
                            borders_value_label.label = "%d".printf ( (int)borders_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("background_alpha=")) {
                    if (alpha_scale != null) {
                        double alpha_value = double.parse (line.substring ("background_alpha=".length));
                        alpha_scale.set_value (alpha_value * 100);
                        if (alpha_value_label != null) {
                            alpha_value_label.label = "%.1f".printf (alpha_value);
                        }
                    }
                }

                if (line.has_prefix ("position=")) {
                    var position_value = line.substring ("position=".length);
                    for (uint i = 0; i < position_dropdown.model.get_n_items (); i++) {
                        var item = position_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == position_value) {
                            position_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("table_columns=")) {
                    if (colums_scale != null) {
                        colums_scale.set_value (int.parse (line.substring ("table_columns=".length)));
                        if (colums_value_label != null) {
                            colums_value_label.label = "%d".printf ( (int)colums_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("toggle_hud=")) {
                    var toggle_hud_value = line.substring ("toggle_hud=".length);
                    toggle_hud_entry.text = toggle_hud_value;
                }

                if (line.has_prefix ("font_size=")) {
                    if (font_size_scale != null) {
                        font_size_scale.set_value (int.parse (line.substring ("font_size=".length)));
                        if (font_size_value_label != null) {
                            font_size_value_label.label = "%d".printf ( (int)font_size_scale.get_value ());
                        }
                    }
                }

                if (line.has_prefix ("font_file=")) {
                    var font_file = line.substring ("font_file=".length);
                    for (uint i = 0; i < font_dropdown.model.get_n_items (); i++) {
                        var item = font_dropdown.model.get_item (i) as StringObject;
                        if (item != null && item.get_string () == font_file) {
                            font_dropdown.selected = i;
                            break;
                        }
                    }
                }

                if (line.has_prefix ("gpu_text=")) {
                    gpu_text_entry.text = line.substring ("gpu_text=".length);
                }

                if (line.has_prefix ("gpu_color=")) {
                    var gpu_color = line.substring ("gpu_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + gpu_color);
                    gpu_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("cpu_text=")) {
                    cpu_text_entry.text = line.substring ("cpu_text=".length);
                }

                if (line.has_prefix ("cpu_color=")) {
                    var cpu_color = line.substring ("cpu_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + cpu_color);
                    cpu_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("fps_value=")) {
                    var fps_values = line.substring ("fps_value=".length).split (",");
                    if (fps_values.length == 2) {
                        fps_value_entry_1.text = fps_values[0];
                        fps_value_entry_2.text = fps_values[1];
                    }
                }

                if (line.has_prefix ("fps_color=")) {
                    var fps_colors = line.substring ("fps_color=".length).split (",");
                    if (fps_colors.length == 3) {
                        var rgba_1 = Gdk.RGBA ();
                        rgba_1.parse ("#" + fps_colors[0]);
                        fps_color_button_1.set_rgba (rgba_1);

                        var rgba_2 = Gdk.RGBA ();
                        rgba_2.parse ("#" + fps_colors[1]);
                        fps_color_button_2.set_rgba (rgba_2);

                        var rgba_3 = Gdk.RGBA ();
                        rgba_3.parse ("#" + fps_colors[2]);
                        fps_color_button_3.set_rgba (rgba_3);
                    }
                }

                if (line.has_prefix ("gpu_load_value=")) {
                    var gpu_load_values = line.substring ("gpu_load_value=".length).split (",");
                    if (gpu_load_values.length == 2) {
                        gpu_load_value_entry_1.text = gpu_load_values[0];
                        gpu_load_value_entry_2.text = gpu_load_values[1];
                    }
                }

                if (line.has_prefix ("gpu_load_color=")) {
                    var gpu_load_colors = line.substring ("gpu_load_color=".length).split (",");
                    if (gpu_load_colors.length == 3) {
                        var rgba_1 = Gdk.RGBA ();
                        rgba_1.parse ("#" + gpu_load_colors[0]);
                        gpu_load_color_button_1.set_rgba (rgba_1);

                        var rgba_2 = Gdk.RGBA ();
                        rgba_2.parse ("#" + gpu_load_colors[1]);
                        gpu_load_color_button_2.set_rgba (rgba_2);

                        var rgba_3 = Gdk.RGBA ();
                        rgba_3.parse ("#" + gpu_load_colors[2]);
                        gpu_load_color_button_3.set_rgba (rgba_3);
                    }
                }

                if (line.has_prefix ("cpu_load_value=")) {
                    var cpu_load_values = line.substring ("cpu_load_value=".length).split (",");
                    if (cpu_load_values.length == 2) {
                        cpu_load_value_entry_1.text = cpu_load_values[0];
                        cpu_load_value_entry_2.text = cpu_load_values[1];
                    }
                }

                if (line.has_prefix ("cpu_load_color=")) {
                    var cpu_load_colors = line.substring ("cpu_load_color=".length).split (",");
                    if (cpu_load_colors.length == 3) {
                        var rgba_1 = Gdk.RGBA ();
                        rgba_1.parse ("#" + cpu_load_colors[0]);
                        cpu_load_color_button_1.set_rgba (rgba_1);

                        var rgba_2 = Gdk.RGBA ();
                        rgba_2.parse ("#" + cpu_load_colors[1]);
                        cpu_load_color_button_2.set_rgba (rgba_2);

                        var rgba_3 = Gdk.RGBA ();
                        rgba_3.parse ("#" + cpu_load_colors[2]);
                        cpu_load_color_button_3.set_rgba (rgba_3);
                    }
                }

                if (line.has_prefix ("background_color=")) {
                    var background_color = line.substring ("background_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + background_color);
                    background_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("frametime_color=")) {
                    var frametime_color = line.substring ("frametime_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + frametime_color);
                    frametime_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("vram_color=")) {
                    var vram_color = line.substring ("vram_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + vram_color);
                    vram_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("ram_color=")) {
                    var ram_color = line.substring ("ram_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + ram_color);
                    ram_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("wine_color=")) {
                    var wine_color = line.substring ("wine_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + wine_color);
                    wine_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("engine_color=")) {
                    var engine_color = line.substring ("engine_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + engine_color);
                    engine_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("text_color=")) {
                    var text_color = line.substring ("text_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + text_color);
                    text_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("media_player_color=")) {
                    var media_player_color = line.substring ("media_player_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + media_player_color);
                    media_player_color_button.set_rgba (rgba);
                }

                if (line.has_prefix ("network_color=")) {
                    var network_color = line.substring ("network_color=".length);
                    var rgba = Gdk.RGBA ();
                    rgba.parse ("#" + network_color);
                    network_color_button.set_rgba (rgba);
                }

            }
        } catch (Error e) {
            stderr.printf ("Error reading the file: %s\n", e.message);
        }
    }

    public void load_switch_from_file (string line, Switch[] switches, string[] config_vars) {
        for (int i = 0; i < config_vars.length; i++) {
            string config_var = config_vars[i];
            if (config_var == "io_read \n io_write") {
                if (line == "io_read" || line == "io_write") {
                    switches[i].active = true;
                }
            } else if (line == config_var) {
                switches[i].active = true;
            }
        }
    }

    public void restart_vkcube () {
        try {
            Process.spawn_command_line_sync ("pkill vkcube");
            Process.spawn_command_line_async ("mangohud vkcube");
        } catch (Error e) {
            stderr.printf ("Error when restarting vkcube: %s\n", e.message);
        }
    }

    public bool is_vkcube_running () {
        try {
            string[] argv = { "pgrep", "vkcube" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Error checking running processes: %s\n", e.message);
            return false;
        }
    }

    public void delete_mangohub_conf () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (file.query_exists ()) {
            try {
                file.delete ();
                warning ("MangoHud.conf file deleted.");
            } catch (Error e) {
                stderr.printf ("Error deleting a file: %s\n", e.message);
            }
        } else {
            warning ("MangoHud.conf file does not exist.");
        }
    }

    public void update_logs_key_in_file (string logs_key) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("toggle_logging=")) {
                    line = "toggle_logging=%s".printf (logs_key);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_position_in_file (string position_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("position=")) {
                    line = "position=%s".printf (position_value);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_toggle_hud_in_file (string toggle_hud_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("toggle_hud=")) {
                    line = "toggle_hud=%s".printf (toggle_hud_value);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_font_size_in_file (string font_size_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("font_size=")) {
                    line = "font_size=%s".printf (font_size_value);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_font_file_in_file (string font_file_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            bool glyph_ranges_added = false;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("font_file=")) {
                    line = "font_file=%s".printf (font_file_value);
                }
                if (line.has_prefix ("font_glyph_ranges=")) {
                    glyph_ranges_added = true;
                }
                lines.add (line);
            }

            if (font_file_value != "Default" && !glyph_ranges_added) {
                lines.add ("font_glyph_ranges=korean, chinese, chinese_simplified, japanese, cyrillic, thai, vietnamese, latin_ext_a, latin_ext_b");
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void open_folder_chooser_dialog () {
        var dialog = new Gtk.FileDialog ();
        dialog.select_folder.begin (this.active_window, null, (obj, res) => {
            try {
                var folder = dialog.select_folder.end (res);
                custom_logs_path_entry.text = folder.get_path ();
            } catch (Error e) {
                stderr.printf ("Error when selecting a folder: %s\n", e.message);
            }
        });
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

    public void restart_application () {
        this.quit ();
        string mangojuice_path = Environment.find_program_in_path ("mangojuice");
        if (mangojuice_path != null) {
            try {
                Process.spawn_command_line_async (mangojuice_path);
            } catch (Error e) {
                stderr.printf ("Error when restarting the application: %s\n", e.message);
            }
        } else {
            stderr.printf ("The mangojuice executable was not found in the PATH.\n");
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

    public void update_gpu_text_in_file (string gpu_text) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("gpu_text=")) {
                    line = "gpu_text=%s".printf (gpu_text);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_gpu_color_in_file (string gpu_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("gpu_color=")) {
                    line = "gpu_color=%s".printf (gpu_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_cpu_text_in_file (string cpu_text) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("cpu_text=")) {
                    line = "cpu_text=%s".printf (cpu_text);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_cpu_color_in_file (string cpu_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("cpu_color=")) {
                    line = "cpu_color=%s".printf (cpu_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_fps_value_in_file (string fps_value_1, string fps_value_2) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("fps_value=")) {
                    line = "fps_value=%s,%s".printf (fps_value_1, fps_value_2);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_fps_color_in_file (string fps_color_1, string fps_color_2, string fps_color_3) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("fps_color=")) {
                    line = "fps_color=%s,%s,%s".printf (fps_color_1, fps_color_2, fps_color_3);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_gpu_load_value_in_file (string gpu_load_value_1, string gpu_load_value_2) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("gpu_load_value=")) {
                    line = "gpu_load_value=%s,%s".printf (gpu_load_value_1, gpu_load_value_2);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_gpu_load_color_in_file (string gpu_load_color_1, string gpu_load_color_2, string gpu_load_color_3) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("gpu_load_color=")) {
                    line = "gpu_load_color=%s,%s,%s".printf (gpu_load_color_1, gpu_load_color_2, gpu_load_color_3);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_cpu_load_value_in_file (string cpu_load_value_1, string cpu_load_value_2) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("cpu_load_value=")) {
                    line = "cpu_load_value=%s,%s".printf (cpu_load_value_1, cpu_load_value_2);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_cpu_load_color_in_file (string cpu_load_color_1, string cpu_load_color_2, string cpu_load_color_3) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("cpu_load_color=")) {
                    line = "cpu_load_color=%s,%s,%s".printf (cpu_load_color_1, cpu_load_color_2, cpu_load_color_3);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_background_color_in_file (string background_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("background_color=")) {
                    line = "background_color=%s".printf (background_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_frametime_color_in_file (string frametime_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("frametime_color=")) {
                    line = "frametime_color=%s".printf (frametime_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_vram_color_in_file (string vram_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("vram_color=")) {
                    line = "vram_color=%s".printf (vram_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_ram_color_in_file (string ram_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("ram_color=")) {
                    line = "ram_color=%s".printf (ram_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_wine_color_in_file (string wine_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("wine_color=")) {
                    line = "wine_color=%s".printf (wine_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_engine_color_in_file (string engine_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("engine_color=")) {
                    line = "engine_color=%s".printf (engine_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_text_color_in_file (string text_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("text_color=")) {
                    line = "text_color=%s".printf (text_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_media_player_color_in_file (string media_player_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("media_player_color=")) {
                    line = "media_player_color=%s".printf (media_player_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void update_network_color_in_file (string network_color) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }

        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("network_color=")) {
                    line = "network_color=%s".printf (network_color);
                }
                lines.add (line);
            }

            var file_stream_write = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            foreach (var l in lines) {
                file_stream_write.put_string (l + "\n");
            }
            file_stream_write.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void on_about_button_clicked () {
        AboutDialog.show_about_dialog (this.active_window);
    }

    public string rgba_to_hex (Gdk.RGBA rgba) {
        return "%02x%02x%02x".printf ((int) (rgba.red * 255), (int) (rgba.green * 255), (int) (rgba.blue * 255));
    }

    public static int main (string[] args) {
        var app = new MangoJuice ();
        return app.run (args);
    }
}
