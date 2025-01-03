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
    public Label duracion_value_label;
    public Label autostart_value_label;
    public Label interval_value_label;
    public Gtk.StringList logs_key_model;
    public DropDown filter_dropdown;
    public Scale af;
    public Scale picmip;
    public Label af_label;
    public Label picmip_label;
    public Entry fps_limit_entry_1;
    public Entry fps_limit_entry_2;
    public Entry fps_limit_entry_3;
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
    public const int MAIN_BOX_SPACING = 12;
    public const int FLOW_BOX_ROW_SPACING = 12;
    public const int FLOW_BOX_COLUMN_SPACING = 12;
    public const int FLOW_BOX_MARGIN = 12;
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
        "wine", "engine_version", "engine_short_names", "winesync"
    };
    public string[] battery_config_vars = {
        "battery", "battery_watt", "battery_time", "device_battery_icon", "device_battery=gamepad,mouse"
    };
    public string[] other_extra_config_vars = {
        "media_player", "network", "full", "log_versioning", "upload_logs"
    };
    public string[] inform_config_vars = {
        "fps", "fps_color_change", "fps_metrics=avg,0.01", "fps_metrics=avg,0.001", "show_fps_limit", "frame_timing", "histogram", "frame_count", "temp_fahrenheit", "present_mode"
    };
    public string[] options_config_vars = {
        "version", "gamemode", "vkbasalt", "exec_name", "fcat", "fsr", "hdr", "hud_compact", "engine_short_names", "no_display"
    };
    public string[] gpu_label_texts = {
        "GPU", "Load Color", "VRAM", "Core Freq", "Mem Freq",
        "Temp", "Memory Temp", "Juntion", "Fans", "Model",
        "Power", "Voltage", "Throttling", "Throttling GRAPH", "Vulkan Driver"
    };
    public string[] cpu_label_texts = {
        "Load", "Load Color", "Core Load", "Core Bars", "Core Freq", "Temp",
        "Power"
    };
    public string[] other_label_texts = {
        "RAM", "Disk IO", "Persistent", "Swap", "Fan"
    };
    public string[] system_label_texts = {
        "Refresh rate", "Resolution", "Session", "Time", "Arch"
    };
    public string[] wine_label_texts = {
        "Version", "Engine Ver", "Short names", "Winesync"
    };
    public string[] options_label_texts = {
        "HUD Version", "Gamemode", "VKbasalt", "Name", "Fcat", "FSR", "HDR", "Compact HUD", "Compact API", "Hide HUD"
    };
    public string[] battery_label_texts = {
        "Percentage", "Wattage", "Time remain", "Battery icon", "Device"
    };
    public string[] other_extra_label_texts = {
        "Media", "Network", "Full ON", "Log Versioning", "Upload Results "
    };
    public string[] inform_label_texts = {
        "FPS", "FPS Color", "FPS low 1%", "FPS low 0.1%", "Frame limit", "Frame time", "Histogram", "Frame", "Temt °F", "VPS" 
    };
    public string[] gpu_label_texts_2 = {
        "Percentage load", "Color text", "Display system VRAM", "Display GPU core", "Display GPU memory",
        "GPU temperature", "GDDR temperatures", "Memory Temperature", "Fan in rpm", "Display GPU name",
        "Display draw in watts", "Display draw in voltage", "GPU is throttling?", "Trolling curve", "Driver Version"
    };
    public string[] cpu_label_texts_2 = {
        "Percentage load", "Color text", "Display all streams", "Streams in the graph", "Processor frequency", "Processor temperature", "CPU consumption watt"
    };
    public string[] other_label_texts_2 = {
        "Memory", "Input/Output", "Memory", "Memory", "Steam deck"
    };
    public string[] system_label_texts_2 = {
        "Only gamescope", "Window", "X11/Wayland", "Watch", "Processor"
    };
    public string[] wine_label_texts_2 = {
        "Wine or Proton version", "X11/Wayland", "Version used engin", "Wine sync method"
    };
    public string[] options_label_texts_2 = {
        "Mangohud", "Priority of game processes", "Enhance the visual graphics", "Launched process", "Visual updating frames", "Only gamescope", "Only gamescope", "Removes fields", "Only OpenGL", "Hide overlay"
    };
    public string[] battery_label_texts_2 = {
        "Display current battery", "Display wattage battery", "Time for battery ", "Icon of percent", "Wireless device battery"
    };
    public string[] other_extra_label_texts_2 = {
        "Show media player", "Show network interfaces", "Excludes histogram", "Adds information the log", "Automatic uploads of logs"
    };
    public string[] inform_label_texts_2 = {
        "Show FPS", "Color text", "Average worst frame", "Average worst frame", "Display FPS limit", "Display frametime", "Graph to histogram", "Display frame count", "Show temperature °F", "Present mode"
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

    public string[] vulkan_values = { "Unset", "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] vulkan_config_values = { "", "0", "1", "3", "2" };

    public string[] opengl_values = { "Unset", "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] opengl_config_values = { "", "-1", "0", "1", "n" };

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
    public Entry blacklist_entry;
    public Scale offset_x_scale;
    public Scale offset_y_scale;
    public Label offset_x_value_label;
    public Label offset_y_value_label;   
    public Scale fps_sampling_period_scale;
    public Label fps_sampling_period_value_label;
    public Button mangohud_global_button;
    public bool mangohud_global_enabled = false;

    public MangoJuice () {
        Object (application_id: "io.github.radiolamp.mangojuice", flags: ApplicationFlags.DEFAULT_FLAGS);
        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect (() => {
            if (is_vkcube_running ()) {
                try {
                    Process.spawn_command_line_sync ("pkill vkcube");
                } catch (Error e) {
                    stderr.printf ("Error closing vkcube: %s\n", e.message);
                }
            }
            if (is_glxgears_running ()) {
                try {
                    Process.spawn_command_line_sync ("pkill glxgears");
                } catch (Error e) {
                    stderr.printf ("Error closing glxgears: %s\n", e.message);
                }
            }
            this.quit ();
        });
        this.add_action (quit_action);
        this.set_accels_for_action ("app.quit", new string[] { "<Primary>Q" });

        var test_action_new = new SimpleAction ("test_new", null);
        test_action_new.activate.connect (() => {
            try {
                if (is_vkcube_available ()) {
                    Process.spawn_command_line_sync ("pkill vkcube");
                    Process.spawn_command_line_async ("mangohud vkcube");
                } else if (is_glxgears_available ()) {
                    Process.spawn_command_line_sync ("pkill glxgears");
                    Process.spawn_command_line_async ("mangohud glxgears");
                }
                test_button_pressed = true;
            } catch (Error e) {
                stderr.printf ("Error when running the command: %s\n", e.message);
            }
        });
        this.add_action (test_action_new);
        this.set_accels_for_action ("app.test_new", new string[] { "<Primary>T" });

        var mangohud_global_action = new SimpleAction ("mangohud_global", null);
        mangohud_global_action.activate.connect (on_mangohud_global_button_clicked);
        this.add_action (mangohud_global_action);
    }

    protected override void activate () {
        var window = new Adw.ApplicationWindow (this);
        window.set_default_size (1024, 700);
        window.set_title ("MangoJuice");
    
        var save_action = new SimpleAction ("save", null);
        save_action.activate.connect (() => SaveStates.save_states_to_file (this));
        window.add_action (save_action);
        this.set_accels_for_action ("win.save", { "<primary>s" });

        var main_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        main_box.set_homogeneous (true);

        var view_stack = new ViewStack ();
        var toolbar_view_switcher = new ViewSwitcher ();
        toolbar_view_switcher.stack = view_stack;
        toolbar_view_switcher.policy = ViewSwitcherPolicy.WIDE;

        var bottom_headerbar = new Gtk.HeaderBar ();
        bottom_headerbar.show_title_buttons = false;

        var bottom_view_switcher = new ViewSwitcher ();
        bottom_view_switcher.stack = view_stack;

        var center_box = new Box (Orientation.HORIZONTAL, 0);
        center_box.set_halign (Align.CENTER);
        center_box.append (bottom_view_switcher);
        bottom_headerbar.set_title_widget (center_box);

        bottom_headerbar.set_visible (false);
    
        window.notify["default-width"].connect (() => {
            int width = window.get_width ();
            toolbar_view_switcher.policy = (width < 800) ? ViewSwitcherPolicy.NARROW : ViewSwitcherPolicy.WIDE;
    
            if (width < 550) {
                bottom_headerbar.set_visible (true);
                toolbar_view_switcher.set_visible (false);
            } else {
                bottom_headerbar.set_visible (false);
                toolbar_view_switcher.set_visible (true);
            }
        });

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
        save_button.clicked.connect (() => {
            SaveStates.save_states_to_file (this);
            if (test_button_pressed) {
                if (is_vkcube_available ()) {
                    restart_vkcube ();
                } else if (is_glxgears_available ()) {
                    restart_glxgears ();
                }
            }
        });
        header_bar.pack_end (save_button);

        var test_button = new Button.with_label ("Test");
        test_button.clicked.connect (() => {
            try {
                if (is_vkcube_available ()) {
                    Process.spawn_command_line_sync ("pkill vkcube");
                    Process.spawn_command_line_async ("mangohud vkcube");
                } else if (is_glxgears_available ()) {
                    Process.spawn_command_line_sync ("pkill glxgears");
                    Process.spawn_command_line_async ("mangohud glxgears");
                }
                test_button_pressed = true;
            } catch (Error e) {
                stderr.printf ("Error when running the command: %s\n", e.message);
            }
        });
        header_bar.pack_start (test_button);

        var save_as_action = new SimpleAction ("save_as", null);
        save_as_action.activate.connect (on_save_as_button_clicked);
        this.add_action (save_as_action);

        var restore_config_action = new SimpleAction ("restore_config", null);
        restore_config_action.activate.connect (on_restore_config_button_clicked);
        this.add_action (restore_config_action);

        var menu_button = new MenuButton ();
        var menu_model = new GLib.Menu ();
        var save_as_item = new GLib.MenuItem ("Save As", "app.save_as");
        menu_model.append_item (save_as_item);
        var restore_config_item = new GLib.MenuItem ("Restore", "app.restore_config");
        menu_model.append_item (restore_config_item);
        var about_item = new GLib.MenuItem ("About", "app.about");
        menu_model.append_item (about_item);
        menu_button.set_menu_model (menu_model);
        menu_button.set_icon_name ("open-menu-symbolic");
        header_bar.pack_end (menu_button);

        var content_box = new Box (Orientation.VERTICAL, 0);
        content_box.append (header_bar);
        content_box.append (view_stack);

        content_box.append (bottom_headerbar);

        window.set_content (content_box);
        window.present ();

        check_mangohud_global_status ();

        LoadStates.load_states_from_file (this);
        SaveStates.save_states_to_file (this);

        window.close_request.connect (() => {
            if (is_vkcube_running ()) {
                try {
                    Process.spawn_command_line_sync ("pkill vkcube");
                } catch (Error e) {
                    stderr.printf ("Error closing vkcube: %s\n", e.message);
                }
            }
            if (is_glxgears_running ()) {
                try {
                    Process.spawn_command_line_sync ("pkill glxgears");
                } catch (Error e) {
                    stderr.printf ("Error closing glxgears: %s\n", e.message);
                }
            }
            return false;
        });

        inform_switches[2].notify["active"].connect (() => {
            if (inform_switches[2].active) inform_switches[3].active = false;
        });
        inform_switches[3].notify["active"].connect (() => {
            if (inform_switches[3].active) inform_switches[2].active = false;
        });
        inform_switches[1].notify["active"].connect (() => {
            if (inform_switches[1].active) inform_switches[0].active = true;
        });
        inform_switches[0].notify["active"].connect (() => {
            if (!inform_switches[0].active) inform_switches[1].active = false;
        });
        inform_switches[6].notify["active"].connect (() => {
            if (inform_switches[6].active) inform_switches[5].active = true;
        });
        inform_switches[5].notify["active"].connect (() => {
            if (!inform_switches[5].active) inform_switches[6].active = false;
        });
        cpu_switches[3].notify["active"].connect (() => {
            if (cpu_switches[3].active) cpu_switches[2].active = true;
        });
        cpu_switches[2].notify["active"].connect (() => {
            if (!cpu_switches[2].active) cpu_switches[3].active = false;
        });
        gpu_switches[4].notify["active"].connect (() => {
            if (gpu_switches[4].active) gpu_switches[2].active = true;
        });
        gpu_switches[2].notify["active"].connect (() => {
            if (!gpu_switches[2].active) gpu_switches[4].active = false;
        });

        var scales = new Scale[] {
            duracion_scale, autostart_scale, interval_scale, af, picmip, borders_scale, colums_scale, font_size_scale,
            offset_x_scale, offset_y_scale };
        
        foreach (var scale in scales) {
            add_scroll_event_handler (scale);
            add_value_changed_handler (scale);
        }

        toolbar_view_switcher.add_css_class ("viewswitcher");
        var style_manager = Adw.StyleManager.get_default ();
        style_manager.set_color_scheme (Adw.ColorScheme.DEFAULT);

        if (!is_vkcube_available () && !is_glxgears_available ()) {
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

    public void add_value_changed_handler (Scale scale) {
        scale.value_changed.connect (() => {
            SaveStates.save_states_to_file (this);
        });
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

        create_switches_and_labels (metrics_box, GPU_TITLE, gpu_switches, gpu_labels, gpu_config_vars, gpu_label_texts, gpu_label_texts_2);
        create_switches_and_labels (metrics_box, CPU_TITLE, cpu_switches, cpu_labels, cpu_config_vars, cpu_label_texts, cpu_label_texts_2);
        create_switches_and_labels (metrics_box, OTHER_TITLE, other_switches, other_labels, other_config_vars, other_label_texts, other_label_texts_2);
        create_switches_and_labels (extras_box, SYSTEM_TITLE, system_switches, system_labels, system_config_vars, system_label_texts, system_label_texts_2);
        create_switches_and_labels (extras_box, WINE_TITLE, wine_switches, wine_labels, wine_config_vars, wine_label_texts, wine_label_texts_2);
        create_switches_and_labels (extras_box, OPTIONS_TITLE, options_switches, options_labels, options_config_vars, options_label_texts, options_label_texts_2);
        create_switches_and_labels (extras_box, BATTERY_TITLE, battery_switches, battery_labels, battery_config_vars, battery_label_texts, battery_label_texts_2);
        create_switches_and_labels (extras_box, OTHER_EXTRA_TITLE, other_extra_switches, other_extra_labels, other_extra_config_vars, other_extra_label_texts, other_extra_label_texts_2);
        create_scales_and_labels (extras_box);
        create_switches_and_labels (performance_box, INFORM_TITLE, inform_switches, inform_labels, inform_config_vars, inform_label_texts, inform_label_texts_2);
        create_limiters_and_filters (performance_box);
        add_switch_handler (gpu_switches);
        add_switch_handler (cpu_switches);
        add_switch_handler (other_switches);
        add_switch_handler (system_switches);
        add_switch_handler (wine_switches);
        add_switch_handler (options_switches);
        add_switch_handler (battery_switches);
        add_switch_handler (other_extra_switches);
        add_switch_handler (inform_switches);

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

    public void add_switch_handler (Switch[] switches) {
        for (int i = 0; i < switches.length; i++) {
            switches[i].notify["active"].connect (() => {
                SaveStates.save_states_to_file (this);
            });
        }
    }

    public void update_gpu_stats_state () {
        bool any_gpu_switch_active = false;

        for (int i = 0; i < gpu_switches.length; i++) {
            if (gpu_switches[i].active && gpu_config_vars[i] != "vram" && gpu_config_vars[i] != "gpu_name"
                && gpu_config_vars[i] != "engine_version" && gpu_config_vars[i] != "gpu_mem_clock") {
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
        custom_logs_path_entry.hexpand = true;

        logs_path_button = new Button.with_label ("Folder logs");
        logs_path_button.clicked.connect ( () => open_folder_chooser_dialog ());

        intel_power_fix_button = new Button.with_label ("Intel Power Fix");
        intel_power_fix_button.clicked.connect ( () => {
            try {
                Process.spawn_command_line_sync ("pkexec chmod 0644 /sys/class/powercap/intel-rapl\\:0/energy_uj");
                check_file_permissions ();
                restart_vkcube_or_glxgears ();
            } catch (Error e) {
                stderr.printf ("Error when executing the command: %s\n", e.message);
            }
        });

        check_file_permissions ();

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

        blacklist_entry = new Entry ();
        blacklist_entry.placeholder_text = "Blacklist: (vkcube,WatchDogs2.exe)";
        blacklist_entry.hexpand = true;
        blacklist_entry.changed.connect (() => {
            update_blacklist_in_file (blacklist_entry.text);
            SaveStates.save_states_to_file (this);
        });

        var blacklist_flow_box = new FlowBox ();
        blacklist_flow_box.set_max_children_per_line (1);
        blacklist_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        blacklist_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        blacklist_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        blacklist_flow_box.set_selection_mode (SelectionMode.NONE);

        var blacklist_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        blacklist_pair.append (blacklist_entry);
        
        mangohud_global_button = new Button.with_label ("Mangohud Global");
        mangohud_global_button.clicked.connect (() => {
            on_mangohud_global_button_clicked ();
        });
        
        blacklist_pair.append (mangohud_global_button);
        blacklist_flow_box.insert (blacklist_pair, -1);
        
        extras_box.append (blacklist_flow_box);
    
        var custom_command_flow_box = new FlowBox ();
        custom_command_flow_box.set_max_children_per_line (2);
        custom_command_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        custom_command_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        custom_command_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        custom_command_flow_box.set_selection_mode (SelectionMode.NONE);
    
        var pair1 = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        pair1.append (custom_command_entry);
        pair1.append (new Label ("Logs key"));
        pair1.append (logs_key_combo);
        custom_command_flow_box.insert (pair1, -1);
    
        var pair2 = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        pair2.append (custom_logs_path_entry);
        pair2.append (logs_path_button);
        pair2.append (intel_power_fix_button);
        pair2.append (reset_button);
        custom_command_flow_box.insert (pair2, -1);
    
        extras_box.append (custom_command_flow_box);

        var customize_label = new Label ("Customize");
        customize_label.set_halign (Align.CENTER);
        customize_label.set_halign (Align.START);
        customize_label.set_markup ("<span size='14000'>%s</span>".printf ("Customize"));
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
        custom_text_center_entry.changed.connect (() => {
            SaveStates.save_states_to_file (this);
        });

        var customize_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        customize_box.set_margin_start (FLOW_BOX_MARGIN);
        customize_box.set_margin_end (FLOW_BOX_MARGIN);
        customize_box.set_margin_top (FLOW_BOX_MARGIN);
        customize_box.set_margin_bottom (FLOW_BOX_MARGIN);
        customize_box.append (custom_text_center_entry);
        visual_box.append (customize_box);

        var custom_switch_label = new Label ("Horizontal Hud");
        custom_switch_label.set_halign (Align.START);
        custom_switch_label.set_hexpand (true);

        custom_switch = new Switch ();
        custom_switch.set_valign (Align.START);
        custom_switch.set_margin_end (FLOW_BOX_MARGIN);
        custom_switch.notify["active"].connect (() => {
            SaveStates.save_states_to_file (this);
        });

        borders_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 15, -1);
        borders_scale.set_hexpand (true);
        borders_scale.set_size_request (250, -1);
        borders_value_label = new Label ("");
        borders_value_label.set_halign (Align.END);
        borders_scale.value_changed.connect ( () => borders_value_label.label = "%d".printf ( (int)borders_scale.get_value ()));

        alpha_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 100, 1);
        alpha_scale.set_hexpand (true);
        alpha_scale.set_size_request (250, -1);
        alpha_scale.set_value (50);
        alpha_value_label = new Label ("");
        alpha_scale.value_changed.connect ( () => {
            double value = alpha_scale.get_value ();
            alpha_value_label.label = "%.1f".printf (value / 100.0);
            SaveStates.save_states_to_file (this);
        });

        var custom_switch_flow_box = new FlowBox ();
        custom_switch_flow_box.set_max_children_per_line (3);
        custom_switch_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        custom_switch_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        custom_switch_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        custom_switch_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        custom_switch_flow_box.set_selection_mode (SelectionMode.NONE);

        var custom_switch_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        custom_switch_pair.append (custom_switch_label);
        custom_switch_pair.append (custom_switch);
        custom_switch_pair.set_size_request (50, -1);
        custom_switch_flow_box.insert (custom_switch_pair, -1);

        var borders_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        borders_pair.append (new Label ("Borders"));
        borders_pair.append (borders_scale);
        borders_pair.append (borders_value_label);
        custom_switch_flow_box.insert (borders_pair, -1);

        var alpha_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        alpha_pair.append (new Label ("Alpha"));
        alpha_pair.append (alpha_scale);
        alpha_pair.append (alpha_value_label);
        custom_switch_flow_box.insert (alpha_pair, -1);

        visual_box.append (custom_switch_flow_box);

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
        position_dropdown.set_hexpand (true);
        position_dropdown.notify["selected-item"].connect ( () => {
            update_position_in_file ( (position_dropdown.selected_item as StringObject)?.get_string () ?? "");
        });

        colums_scale = new Scale.with_range (Orientation.HORIZONTAL, 1, 6, -1);
        colums_scale.set_hexpand (true);
        colums_scale.set_value (3);
        colums_scale.set_size_request (350, -1);
        colums_value_label = new Label ("");
        colums_value_label.set_halign (Align.CENTER);
        colums_scale.value_changed.connect ( () => colums_value_label.label = "%d".printf ( (int)colums_scale.get_value ()));

        toggle_hud_entry = new Entry ();
        toggle_hud_entry.placeholder_text = "Key";
        toggle_hud_entry.text = "Shift_R+F12";
        toggle_hud_entry.set_hexpand (true);
        toggle_hud_entry.set_size_request (20, -1);
        toggle_hud_entry.set_margin_top (FLOW_BOX_MARGIN);
        toggle_hud_entry.set_margin_bottom (FLOW_BOX_MARGIN);
        toggle_hud_entry.changed.connect ( () => {
            update_toggle_hud_in_file (toggle_hud_entry.text);
            SaveStates.save_states_to_file (this);
        });

        var position_colums_flow_box = new FlowBox ();
        position_colums_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        position_colums_flow_box.set_max_children_per_line (3);
        position_colums_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        position_colums_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        position_colums_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        position_colums_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        position_colums_flow_box.set_selection_mode (SelectionMode.NONE);

        var position_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        position_pair.append (new Label ("Position"));
        position_pair.append (position_dropdown);
        position_colums_flow_box.insert (position_pair, -1);

        var colums_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        colums_pair.append (new Label ("Colums"));
        colums_pair.append (colums_scale);
        colums_pair.append (colums_value_label);
        position_colums_flow_box.insert (colums_pair, -1);

        var toggle_hud_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        toggle_hud_pair.append (new Label ("Toggle HUD"));
        toggle_hud_pair.set_hexpand (true);
        toggle_hud_pair.append (toggle_hud_entry);
        position_colums_flow_box.insert (toggle_hud_pair, -1);

        visual_box.append (position_colums_flow_box);

        offset_x_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 1500, 1);
        offset_x_scale.set_hexpand (true);
        offset_x_scale.set_size_request (250, -1);
        offset_x_value_label = new Label ("");
        offset_x_value_label.set_halign (Align.END);
        offset_x_scale.value_changed.connect (() => {
            offset_x_value_label.label = "%d".printf ((int)offset_x_scale.get_value ());
            update_offset_x_in_file ("%d".printf ((int)offset_x_scale.get_value ()));
        });

        offset_y_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 1500, 1);
        offset_y_scale.set_hexpand (true);
        offset_y_scale.set_size_request (250, -1);
        offset_y_value_label = new Label ("");
        offset_y_value_label.set_halign (Align.END);
        offset_y_scale.value_changed.connect (() => {
            offset_y_value_label.label = "%d".printf ((int)offset_y_scale.get_value ());
            update_offset_y_in_file ("%d".printf ((int)offset_y_scale.get_value ()));
        });

        var offset_flow_box = new FlowBox ();
        offset_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        offset_flow_box.set_max_children_per_line (2);
        offset_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        offset_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        offset_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        offset_flow_box.set_selection_mode (SelectionMode.NONE);

        var offset_x_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        offset_x_pair.append (new Label ("Offset X"));
        offset_x_pair.append (offset_x_scale);
        offset_x_pair.append (offset_x_value_label);
        offset_flow_box.insert (offset_x_pair, -1);
    
        var offset_y_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        offset_y_pair.append (new Label ("Offset Y"));
        offset_y_pair.append (offset_y_scale);
        offset_y_pair.append (offset_y_value_label);
        offset_flow_box.insert (offset_y_pair, -1);
 
        visual_box.append (offset_flow_box);

        var fonts_label = new Label ("Font");
        fonts_label.set_halign (Align.CENTER);
        fonts_label.set_halign (Align.START);
        fonts_label.set_markup ("<span size='14000'>%s</span>".printf ("Font"));
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
        font_size_scale.set_size_request (400, -1);
        font_size_value_label = new Label ("");
        font_size_value_label.set_halign (Align.END);
        font_size_scale.value_changed.connect ( () => {
            font_size_value_label.label = "%d".printf ( (int)font_size_scale.get_value ());
            update_font_size_in_file ("%d".printf ( (int)font_size_scale.get_value ()));
        });

        initialize_font_dropdown (visual_box);

        var fonts_flow_box = new FlowBox ();
        fonts_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        fonts_flow_box.set_hexpand (true);
        fonts_flow_box.set_max_children_per_line (2);
        fonts_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        fonts_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        fonts_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        fonts_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        fonts_flow_box.set_selection_mode (SelectionMode.NONE);

        var font_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        font_pair.append (new Label ("Font"));
        font_pair.append (font_dropdown);
        fonts_flow_box.insert (font_pair, -1);
 
        var size_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        size_pair.append (new Label ("Size"));
        size_pair.append (font_size_scale);
        size_pair.append (font_size_value_label);
        fonts_flow_box.insert (size_pair, -1);

        visual_box.append (fonts_flow_box);

        var color_label = new Label ("Color");
        color_label.set_halign (Align.CENTER);
        color_label.set_halign (Align.START);
        color_label.set_markup ("<span size='14000'>%s</span>".printf ("Color"));
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
        color_flow_box.set_min_children_per_line (2);
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
            SaveStates.save_states_to_file (this);
        });

        gpu_text_entry = new Entry ();
        gpu_text_entry.placeholder_text = "GPU custom name";
        gpu_text_entry.hexpand = true;
        gpu_text_entry.changed.connect ( () => {
            update_gpu_text_in_file (gpu_text_entry.text);
            SaveStates.save_states_to_file (this);
        });

        cpu_text_entry = new Entry ();
        cpu_text_entry.placeholder_text = "CPU custom name";
        cpu_text_entry.hexpand = true;
        cpu_text_entry.changed.connect ( () => {
            update_cpu_text_in_file (cpu_text_entry.text);
            SaveStates.save_states_to_file (this);
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
            SaveStates.save_states_to_file (this);
        });

        fps_value_entry_2 = new Entry ();
        fps_value_entry_2.placeholder_text = "High";
        fps_value_entry_2.text = "60";
        fps_value_entry_2.hexpand = true;
        fps_value_entry_2.changed.connect ( () => {
            update_fps_value_in_file (fps_value_entry_1.text, fps_value_entry_2.text);
            SaveStates.save_states_to_file (this);
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
            SaveStates.save_states_to_file (this);
        });

        gpu_load_value_entry_2 = new Entry ();
        gpu_load_value_entry_2.placeholder_text = "High";
        gpu_load_value_entry_2.text = "90";
        gpu_load_value_entry_2.hexpand = true;
        gpu_load_value_entry_2.changed.connect ( () => {
            update_gpu_load_value_in_file (gpu_load_value_entry_1.text, gpu_load_value_entry_2.text);
            SaveStates.save_states_to_file (this);
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
            SaveStates.save_states_to_file (this);
        });

        cpu_load_value_entry_2 = new Entry ();
        cpu_load_value_entry_2.placeholder_text = "High";
        cpu_load_value_entry_2.text = "90";
        cpu_load_value_entry_2.hexpand = true;
        cpu_load_value_entry_2.changed.connect ( () => {
            update_cpu_load_value_in_file (cpu_load_value_entry_1.text, cpu_load_value_entry_2.text);
            SaveStates.save_states_to_file (this);
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

        var fonts = find_fonts ();

        var font_names = new Gee.ArrayList<string> ();

        foreach (var font_path in fonts) {
            var font_name = Path.get_basename (font_path);
            font_names.add (font_name);
        }

        font_names.sort ((a, b) => {
            return a.collate (b);
        });

        foreach (var font_name in font_names) {
            font_model.append (font_name);
        }
    
        font_dropdown = new DropDown (font_model, null);
        font_dropdown.set_hexpand (true);
        font_dropdown.set_size_request (300, -1);
        font_dropdown.notify["selected-item"].connect (() => {
            var selected_font_name = (font_dropdown.selected_item as StringObject)?.get_string () ?? "";
            var selected_font_path = find_font_path_by_name (selected_font_name, fonts);
            update_font_file_in_file (selected_font_path);
            SaveStates.save_states_to_file (this);
        });
    
        var factory = new Gtk.SignalListItemFactory ();
        factory.setup.connect ((item) => {
            var list_item = item as Gtk.ListItem;
            var label = new Gtk.Label (null);
            label.set_ellipsize (Pango.EllipsizeMode.END);
            label.set_xalign (0.0f);
            list_item.set_child (label);
        });
        factory.bind.connect ((item) => {
            var list_item = item as Gtk.ListItem;
            var label = list_item.get_child () as Gtk.Label;
            label.label = (list_item.get_item () as StringObject)?.get_string () ?? "";
        });
        font_dropdown.set_factory (factory);
    }

    public Gee.List<string> find_fonts () {
        var fonts = new Gee.ArrayList<string> ();
    
        try {
            // Выполняем команду fc-list для получения списка шрифтов
            string[] argv = { "fc-list", ":", "file" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);
    
            if (exit_status == 0) {
                // Разделяем вывод на строки
                string[] lines = standard_output.split ("\n");
                foreach (var line in lines) {
                    // Каждая строка содержит путь к файлу шрифта и его имя
                    if (line.strip () != "") {
                        // Разделяем строку по двоеточию и берем первую часть (путь к шрифту)
                        string[] parts = line.split (":");
                        if (parts.length > 0) {
                            string font_path = parts[0].strip ();
                            // Проверяем расширение файла
                            if (font_path.has_suffix (".ttf") || font_path.has_suffix (".otf")) {
                                fonts.add (font_path);
                            }
                        }
                    }
                }
            } else {
                stderr.printf ("Error executing fc-list: %s\n", standard_error);
            }
        } catch (Error e) {
            stderr.printf ("Error when searching for fonts: %s\n", e.message);
        }
    
        return fonts;
    }

    public string find_font_path_by_name (string font_name, Gee.List<string> fonts) {
        foreach (var font_path in fonts) {
            if (Path.get_basename (font_path) == font_name) {
                return font_path;
            }
        }
        return "";
    }

    public void create_switches_and_labels (Box parent_box, string title, Switch[] switches, Label[] labels, string[] config_vars, string[] label_texts, string[] label_texts_2) {
        var label = new Label (title);
        label.add_css_class ("bold-label");
        label.set_margin_top (FLOW_BOX_MARGIN);
        label.set_margin_start (FLOW_BOX_MARGIN);
        label.set_margin_end (FLOW_BOX_MARGIN);
        label.set_halign (Align.START);
        label.set_markup ("<span size='14000'>%s</span>".printf (title));
    
        parent_box.append (label);
    
        var flow_box = new FlowBox ();
        flow_box.set_homogeneous (true);
        flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        flow_box.set_column_spacing (FLOW_BOX_COLUMN_SPACING);
        flow_box.set_margin_top (FLOW_BOX_MARGIN);
        flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        flow_box.set_margin_start (FLOW_BOX_MARGIN);
        flow_box.set_margin_end (FLOW_BOX_MARGIN);
        flow_box.set_selection_mode (SelectionMode.NONE);
    
        for (int i = 0; i < config_vars.length; i++) {
            var row_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            row_box.set_hexpand (true);
            row_box.set_valign (Align.CENTER);

            switches[i] = new Switch ();
            switches[i].set_valign (Align.CENTER);
    
            var text_box = new Box (Orientation.VERTICAL, 0);
            text_box.set_valign (Align.CENTER);
            text_box.set_halign (Align.START);
            text_box.set_size_request (160, -1); // Ширина 160 пикселей, нужна если не работает выравнивание.
    
            var label1 = new Label (null);
            label1.set_markup ("<b>%s</b>".printf (label_texts[i])); // Жирный текст
            label1.set_halign (Align.START);
            label1.set_hexpand (false);
    
            var label2 = new Label (label_texts_2[i]);
            label2.set_halign (Align.START);
            label2.set_hexpand (false);
            label2.add_css_class ("dim-label");

            label1.set_markup ("<b>%s</b>".printf (label_texts[i]));
            label2.set_markup ("<span size='9000'>%s</span>".printf (label_texts_2[i]));
    
            text_box.append (label1);
            text_box.append (label2);
    
            row_box.append (switches[i]);
            row_box.append (text_box); // Добавляем контейнер с двумя строками текста
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
        var logging_label = new Label ("Logging");
        logging_label.set_valign (Align.START);
        logging_label.set_halign (Align.START);
        logging_label.set_markup ("<span size='14000'>%s</span>".printf ("Logging"));
        logging_label.set_margin_top (FLOW_BOX_MARGIN);
        logging_label.set_margin_start (FLOW_BOX_MARGIN);
        logging_label.set_margin_end (FLOW_BOX_MARGIN);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        logging_label.set_attributes (attr_list);

        parent_box.append (logging_label);

        var scales_flow_box = new FlowBox ();
        scales_flow_box.set_homogeneous (true);
        scales_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        scales_flow_box.set_max_children_per_line (3);
        scales_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        scales_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        scales_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        scales_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        scales_flow_box.set_selection_mode (SelectionMode.NONE);

        duracion_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 200, 1);
        duracion_scale.set_value (30);
        duracion_scale.set_size_request (150, -1);
        duracion_scale.set_hexpand (true);
        duracion_value_label = new Label ("");
        duracion_value_label.set_halign (Align.END);
        duracion_scale.value_changed.connect (() => duracion_value_label.label = "%d s".printf ((int)duracion_scale.get_value ()));

        autostart_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 30, 1);
        autostart_scale.set_value (0);
        autostart_scale.set_hexpand (true);
        autostart_value_label = new Label ("");
        autostart_value_label.set_halign (Align.END);
        autostart_scale.value_changed.connect (() => autostart_value_label.label = "%d s".printf ((int)autostart_scale.get_value ()));

        interval_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 500, 1);
        interval_scale.set_value (100);
        interval_scale.set_hexpand (true);
        interval_value_label = new Label ("");
        interval_value_label.set_halign (Align.END);
        interval_scale.value_changed.connect (() => interval_value_label.label = "%d ms".printf ((int)interval_scale.get_value ()));

        var pair1 = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        pair1.append (new Label ("Duracion"));
        pair1.append (duracion_scale);
        pair1.append (duracion_value_label);
        scales_flow_box.insert (pair1, -1);

        var pair2 = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        pair2.append (new Label ("Autostart"));
        pair2.append (autostart_scale);
        pair2.append (autostart_value_label);
        scales_flow_box.insert (pair2, -1);

        var pair3 = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        pair3.append (new Label ("Interval"));
        pair3.append (interval_scale);
        pair3.append (interval_value_label);
        scales_flow_box.insert (pair3, -1);

        parent_box.append (scales_flow_box);
    }

    public void create_limiters_and_filters (Box performance_box) {
        var limiters_label = new Label (LIMITERS_TITLE);
        limiters_label.set_halign (Align.CENTER);
        limiters_label.set_halign (Align.START);
        limiters_label.set_markup ("<span size='14000'>%s</span>".printf ("Limiters FPS"));
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

        fps_limit_entry_1 = new Entry ();
        fps_limit_entry_1.placeholder_text = "Limit 1";
        fps_limit_entry_1.hexpand = true;
        fps_limit_entry_1.changed.connect ( () => {
            update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            SaveStates.save_states_to_file (this);
        });

        fps_limit_entry_2 = new Entry ();
        fps_limit_entry_2.placeholder_text = "Limit 2";
        fps_limit_entry_2.hexpand = true;
        fps_limit_entry_2.changed.connect ( () => {
            update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            SaveStates.save_states_to_file (this);
        });

        fps_limit_entry_3 = new Entry ();
        fps_limit_entry_3.placeholder_text = "Limit 3";
        fps_limit_entry_3.hexpand = true;
        fps_limit_entry_3.changed.connect ( () => {
            update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            SaveStates.save_states_to_file (this);
        });

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
        limiters_box.append (fps_limit_method);
        limiters_box.append (fps_limit_entry_1);
        limiters_box.append (fps_limit_entry_2);
        limiters_box.append (fps_limit_entry_3);
        limiters_box.append (toggle_fps_limit);
        performance_box.append (limiters_box);

        var vsync_label = new Label ("VSync");
        vsync_label.set_halign (Align.CENTER);
        vsync_label.set_halign (Align.START);
        vsync_label.set_markup ("<span size='14000'>%s</span>".printf ("VSync"));
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
        vulkan_dropdown.notify["selected-item"].connect (() => {
            save_and_restart ();
        });
    
        var opengl_model = new Gtk.StringList (null);
        foreach (var item in opengl_values) {
            opengl_model.append (item);
        }
        opengl_dropdown = new DropDown (opengl_model, null);
        opengl_dropdown.notify["selected-item"].connect (() => {
            save_and_restart ();
        });

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
        filters_label.set_halign (Align.START);
        filters_label.set_markup ("<span size='14000'>%s</span>".printf ("Filters"));
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
        filter_dropdown.set_valign (Align.START);
        filter_dropdown.set_hexpand (true);

        af = new Scale.with_range (Orientation.HORIZONTAL, 0, 16, 1);
        af.set_hexpand (true);
        af.set_size_request (200, -1);
        af_label = new Label ("");
        af_label.set_halign (Align.END);
        af.value_changed.connect (() => af_label.label = "%d".printf ((int)af.get_value ()));

        picmip = new Scale.with_range (Orientation.HORIZONTAL, -16, 16, 1);
        picmip.set_hexpand (true);
        picmip.set_size_request (200, -1);
        picmip.set_value (0);
        picmip_label = new Label ("");
        picmip_label.set_halign (Align.END);
        picmip.value_changed.connect (() => picmip_label.label = "%d".printf ((int)picmip.get_value ()));

        var filters_flow_box = new FlowBox ();
        filters_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        filters_flow_box.set_max_children_per_line (3);
        filters_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        filters_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        filters_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        filters_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        filters_flow_box.set_selection_mode (SelectionMode.NONE);

        var filter_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        filter_pair.append (new Label ("Filter"));
        filter_pair.append (filter_dropdown);
        filters_flow_box.insert (filter_pair, -1);

        var af_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        af_pair.append (new Label ("Anisotropic filtering"));
        af_pair.append (af);
        af_pair.append (af_label);
        filters_flow_box.insert (af_pair, -1);

        var picmip_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        picmip_pair.append (new Label ("Mipmap LoD bias"));
        picmip_pair.append (picmip);
        picmip_pair.append (picmip_label);
        filters_flow_box.insert (picmip_pair, -1);

        performance_box.append (filters_flow_box);

        var fps_sampling_period_label = new Label ("Other");
        fps_sampling_period_label.set_halign (Align.CENTER);
        fps_sampling_period_label.set_halign (Align.START);
        fps_sampling_period_label.set_markup ("<span size='14000'>%s</span>".printf ("Other"));
        fps_sampling_period_label.set_margin_top (FLOW_BOX_MARGIN);
        fps_sampling_period_label.set_margin_start (FLOW_BOX_MARGIN);
        fps_sampling_period_label.set_margin_end (FLOW_BOX_MARGIN);
    
        var fps_sampling_period_font_description = new Pango.FontDescription ();
        fps_sampling_period_font_description.set_weight (Pango.Weight.BOLD);
        var fps_sampling_period_attr_list = new Pango.AttrList ();
        fps_sampling_period_attr_list.insert (new Pango.AttrFontDesc (fps_sampling_period_font_description));
        fps_sampling_period_label.set_attributes (fps_sampling_period_attr_list);
    
        performance_box.append (fps_sampling_period_label);
    
        fps_sampling_period_scale = new Scale.with_range (Orientation.HORIZONTAL, 250, 2000, 1);
        fps_sampling_period_scale.set_hexpand (true);
        fps_sampling_period_scale.set_size_request (200, -1);
        fps_sampling_period_scale.set_value (500);
        fps_sampling_period_value_label = new Label ("");
        fps_sampling_period_value_label.set_halign (Align.END);
        fps_sampling_period_scale.value_changed.connect (() => {
            fps_sampling_period_value_label.label = "%d ms".printf ((int)fps_sampling_period_scale.get_value ());
            update_fps_sampling_period_in_file ("%d".printf ((int)fps_sampling_period_scale.get_value ()));
        });
    
        var fps_sampling_period_flow_box = new FlowBox ();
        fps_sampling_period_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        fps_sampling_period_flow_box.set_max_children_per_line (1);
        fps_sampling_period_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        fps_sampling_period_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        fps_sampling_period_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        fps_sampling_period_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        fps_sampling_period_flow_box.set_selection_mode (SelectionMode.NONE);
    
        var fps_sampling_period_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        fps_sampling_period_pair.append (new Label ("FPS Sampling"));
        fps_sampling_period_pair.append (fps_sampling_period_scale);
        fps_sampling_period_pair.append (fps_sampling_period_value_label);
        fps_sampling_period_flow_box.insert (fps_sampling_period_pair, -1);
    
        performance_box.append (fps_sampling_period_flow_box);
    }

    public void restart_vkcube () {
        try {
            Process.spawn_command_line_sync ("pkill vkcube");
            Process.spawn_command_line_async ("mangohud vkcube");
        } catch (Error e) {
            stderr.printf ("Error when restarting vkcube: %s\n", e.message);
        }
    }

    public void restart_glxgears () {
        try {
            Process.spawn_command_line_sync ("pkill glxgears");
            Process.spawn_command_line_async ("mangohud glxgears");
        } catch (Error e) {
            stderr.printf ("Error when restarting glxgears: %s\n", e.message);
        }
    }

    public void restart_vkcube_or_glxgears () {
        if (is_vkcube_running ()) {
            restart_vkcube ();
        } else if (is_glxgears_running ()) {
            restart_glxgears ();
        }
    }

    public void save_and_restart () {
        SaveStates.save_states_to_file (this);
        restart_vkcube_or_glxgears ();
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

    public bool is_glxgears_running () {
        try {
            string[] argv = { "pgrep", "glxgears" };
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
            while ( (line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("font_file=")) {
                    line = "font_file=%s".printf (font_file_value);
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

    public void update_fps_limit_in_file (string fps_limit_1, string fps_limit_2, string fps_limit_3) {
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
                if (line.has_prefix ("fps_limit=")) {
                    line = "fps_limit=%s,%s,%s".printf (fps_limit_1, fps_limit_2, fps_limit_3);
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

    public void update_offset_x_in_file (string offset_x_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }
    
        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("offset_x=")) {
                    line = "offset_x=%s".printf (offset_x_value);
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
    
    public void update_offset_y_in_file (string offset_y_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }
    
        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("offset_y=")) {
                    line = "offset_y=%s".printf (offset_y_value);
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

    public void update_fps_sampling_period_in_file (string fps_sampling_period_value) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            return;
        }
    
        try {
            var lines = new ArrayList<string> ();
            var file_stream = new DataInputStream (file.read ());
            string line;
            while ((line = file_stream.read_line ()) != null) {
                if (line.has_prefix ("fps_sampling_period=")) {
                    line = "fps_sampling_period=%s".printf (fps_sampling_period_value);
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

    public void update_blacklist_in_file (string blacklist_value) {
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
                if (line.has_prefix ("blacklist=")) {
                    line = "blacklist=%s".printf (blacklist_value);
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
    
    public void on_save_as_button_clicked () {
        var dialog = new Gtk.FileDialog ();
        dialog.set_title ("Save MangoHud.conf As");
        dialog.set_accept_label ("Save");
        dialog.set_initial_name ("MangoHud.conf");
    
        dialog.save.begin (this.active_window, null, (obj, res) => {
            try {
                var file = dialog.save.end (res);
                save_config_to_file (file.get_path ());
            } catch (Error e) {
                stderr.printf ("Error when saving the file: %s\n", e.message);
            }
        });
    }

    public void save_config_to_file (string file_path) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            stderr.printf ("MangoHud.conf does not exist.\n");
            return;
        }
    
        try {
            var input_stream = new DataInputStream (file.read ());
            var output_stream = new DataOutputStream (File.new_for_path (file_path).replace (null, false, FileCreateFlags.NONE));
    
            string line;
            while ((line = input_stream.read_line ()) != null) {
                output_stream.put_string (line + "\n");
            }
    
            output_stream.close ();
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
    }

    public void on_restore_config_button_clicked () {
        var dialog = new Gtk.FileDialog ();
        dialog.set_title ("Select Config File to Restore");
        dialog.set_accept_label ("Restore");
    
        dialog.open.begin (this.active_window, null, (obj, res) => {
            try {
                var file = dialog.open.end (res);
                restore_config_from_file (file.get_path ());
            } catch (Error e) {
                stderr.printf ("Error when selecting a file: %s\n", e.message);
            }
        });
    }

    public void restore_config_from_file (string file_path) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
    
        try {
            var input_stream = new DataInputStream (File.new_for_path (file_path).read ());
            var output_stream = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
    
            string line;
            while ((line = input_stream.read_line ()) != null) {
                output_stream.put_string (line + "\n");
            }
    
            output_stream.close ();
            stdout.printf ("Configuration restored from %s\n", file_path);
        } catch (Error e) {
            stderr.printf ("Error writing to the file: %s\n", e.message);
        }
        LoadStates.load_states_from_file (this);
    }

    public void check_file_permissions () {
        try {
            File file = File.new_for_path ("/sys/class/powercap/intel-rapl:0/energy_uj");
            if (!file.query_exists ()) {
                stderr.printf ("File does not exist: %s\n", file.get_path ());
                return;
            }

            string[] argv = { "stat", "-c", "%a", file.get_path () };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            if (exit_status == 0) {
                string permissions = standard_output.strip ();

                if (permissions == "644") {
                    intel_power_fix_button.add_css_class ("suggested-action");
                } else {
                    intel_power_fix_button.remove_css_class ("suggested-action");
                }
            } else {
                stderr.printf ("Error getting file permissions: %s\n", standard_error);
            }
        } catch (Error e) {
            stderr.printf ("Error checking file permissions: %s\n", e.message);
        }
    }

    public void on_mangohud_global_button_clicked () {
        if (mangohud_global_enabled) {
            try {
                Process.spawn_command_line_sync ("pkexec sed -i '/MANGOHUD=1/d' /etc/environment");
                mangohud_global_enabled = false;
                mangohud_global_button.remove_css_class ("suggested-action");
                check_mangohud_global_status ();
                show_restart_warning ();
            } catch (Error e) {
                stderr.printf ("Error deleting MANGOHUD from /etc/environment: %s\n", e.message);
            }
        } else {
            try {
                Process.spawn_command_line_sync ("pkexec sh -c 'echo \"MANGOHUD=1\" >> /etc/environment'");
                mangohud_global_enabled = true;
                mangohud_global_button.add_css_class ("suggested-action");
                check_mangohud_global_status ();
                show_restart_warning ();
            } catch (Error e) {
                stderr.printf ("Error restore MANGOHUD from /etc/environment: %s\n", e.message);
            }
        }
    }

    public void show_restart_warning () {
        var dialog = new Adw.AlertDialog ("Warning", "The changes will take effect only after the system is restarted.");
        dialog.add_response ("ok", "OK");
        dialog.add_response ("restart", "Restart");
        dialog.set_default_response ("ok");
        dialog.set_response_appearance ("restart", Adw.ResponseAppearance.SUGGESTED);

        dialog.present (this.active_window);

        dialog.response.connect ((response) => {
            if (response == "restart") {
                try {
                    Process.spawn_command_line_sync ("reboot");
                } catch (Error e) {
                    stderr.printf ("Error when restarting the system: %s\n", e.message);
                }
            }
            dialog.destroy ();
        });
    }

    public void check_mangohud_global_status () {
        try {
            string[] argv = { "grep", "MANGOHUD=1", "/etc/environment" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);
    
            if (exit_status == 0) {
                mangohud_global_enabled = true;
                mangohud_global_button.add_css_class ("suggested-action");
            } else {
                mangohud_global_enabled = false;
                mangohud_global_button.remove_css_class ("suggested-action");
            }
        } catch (Error e) {
            stderr.printf ("Error checking the MANGOHUD status: %s\n", e.message);
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
