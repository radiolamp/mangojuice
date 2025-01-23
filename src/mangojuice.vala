using Gtk;
using Adw;
using Gee;

public class MangoJuice : Adw.Application {
    // UI Elements
    public OtherBox other_box;
    Button reset_button;
    Button logs_path_button;
    Button intel_power_fix_button;
    public Switch[] gpu_switches;
    public Switch[] cpu_switches;
    public Switch[] other_switches;
    public Switch[] system_switches;
    public Switch[] wine_switches;
    public Switch[] options_switches;
    public Switch[] battery_switches;
    public Switch[] other_extra_switches;
    public Switch[] inform_switches;
    Label[] gpu_labels;
    Label[] cpu_labels;
    Label[] other_labels;
    Label[] system_labels;
    Label[] wine_labels;
    Label[] options_labels;
    Label[] battery_labels;
    Label[] other_extra_labels;
    Label[] inform_labels;
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
    public Entry duracion_entry;
    public Entry autostart_entry;
    public Entry interval_entry;
    public Gtk.StringList logs_key_model;
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
    public DropDown font_dropdown;
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
    public Entry blacklist_entry;
    public Scale offset_x_scale;
    public Scale offset_y_scale;
    public Label offset_x_value_label;
    public Label offset_y_value_label;
    public Entry offset_x_entry;
    public Entry offset_y_entry;
    public Scale fps_sampling_period_scale;
    public Label fps_sampling_period_value_label;
    public Button mangohud_global_button;
    bool mangohud_global_enabled = false;
    ScrolledWindow other_scrolled_window;
    ViewStack view_stack;

    // Constants
    const string GPU_TITLE = _("GPU");
    const string CPU_TITLE = _("CPU");
    const string OTHER_TITLE = _("Other");
    const string SYSTEM_TITLE = _("System");
    const string WINE_TITLE = _("Wine");
    const string OPTIONS_TITLE = _("Options");
    const string BATTERY_TITLE = _("Battery");
    const string INFORM_TITLE = _("Information");
    const int MAIN_BOX_SPACING = 12;
    const int FLOW_BOX_ROW_SPACING = 12;
    const int FLOW_BOX_COLUMN_SPACING = 12;
    const int FLOW_BOX_MARGIN = 12;

    // Configuration Variables
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
        "refresh_rate", "resolution", "exec=echo \n exec=echo $XDG_SESSION_TYPE",
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
        "version", "gamemode", "vkbasalt", "exec_name", "fcat", "fsr", "hdr", "hud_compact", "engine_short_names", "no_display", "text_outline=0"
    };

    // Label Texts
    string[] gpu_label_texts = {
        _("Load GPU"), _("Load Color"), _("VRAM"), _("Core Freq"), _("Mem Freq"),
        _("Temp"), _("Memory Temp"), _("Junction"), _("Fans"), _("Model"),
        _("Power"), _("Voltage"), _("Throttling"), _("Throttling GRAPH"), _("Vulkan Driver")
    };
    string[] cpu_label_texts = {
        _("Load CPU"), _("Load Color"), _("Core Load"), _("Core Bars"), _("Core Freq"), _("Temp"),
        _("Power")
    };
    string[] other_label_texts = {
        _("RAM"), _("Disk IO"), _("Resident mem"), _("Swap"), _("Fan")
    };
    string[] system_label_texts = {
        _("Refresh rate"), _("Resolution"), _("Session"), _("Time"), _("Arch")
    };
    string[] wine_label_texts = {
        _("Version"), _("Engine Ver"), _("Short names"), _("Winesync")
    };
    string[] options_label_texts = {
        _("HUD Version"), _("Gamemode"), _("VKbasalt"), _("Name"), _("Fcat"), _("FSR"), _("HDR"), _("Compact HUD"),
        _("Compact API"), _("Hide HUD"), _("Turn off the shadow")
    };
    string[] battery_label_texts = {
        _("Percentage"), _("Wattage"), _("Time remain"), _("Battery icon"), _("Device")
    };
    string[] other_extra_label_texts = {
        _("Media"), _("Network"), _("Full ON"), _("Log Versioning"), _("Upload Results")
    };
    string[] inform_label_texts = {
        _("FPS"), _("FPS Color"), _("FPS low 1%"), _("FPS low 0.1%"), _("Frame limit"), _("Frame time"), _("Histogram"), _("Frame"), _("Temt °F"), _("VPS")
    };
    string[] gpu_label_texts_2 = {
        _("Percentage load"), _("Color text"), _("Display system VRAM"), _("Display GPU core"), _("Display GPU memory"),
        _("GPU temperature"), _("GDDR temperatures"), _("Memory Temperature"), _("Fan in rpm"), _("Display GPU name"),
        _("Display draw in watts"), _("Display voltage"), _("GPU is throttling?"), _("Trolling curve"), _("Driver Version")
    };
    string[] cpu_label_texts_2 = {
        _("Percentage load"), _("Color text"), _("Display all streams"), _("Streams in the graph"), _("Processor frequency"), _("Processor temperature"), _("CPU consumption watt")
    };
    string[] other_label_texts_2 = {
        _("RAM Memory"), _("Input/Output"), _("RAM Memory"), _("RAM Memory"), _("Steam deck")
    };
    string[] system_label_texts_2 = {
        _("Only gamescope"), _("Window"), _("X11/Wayland"), _("Watch"), _("Processor")
    };
    string[] wine_label_texts_2 = {
        _("Wine or Proton version"), _("X11/Wayland"), _("Version used engin"), _("Wine sync method")
    };
    string[] options_label_texts_2 = {
        _("Mangohud"), _("Game process priority"), _("Improve graphics"), _("Launched process"), _("Visual updating frames"),
        _("Only gamescope"), _("Only gamescope"), _("Removes fields"), _("Only OpenGL"), _("Hide overlay"), _("Turn off font shadow")
    };
    string[] battery_label_texts_2 = {
        _("Check battery"), _("Show battery wattage"), _("Time for battery"), _("Icon of percent"), _("Wireless batt")
    };
    string[] other_extra_label_texts_2 = {
        _("Show media player"), _("Display network"), _("Excludes histogram"), _("Log information"), _("Auto upload logs")
    };
    string[] inform_label_texts_2 = {
        _("Show FPS"), _("Color text"), _("Average worst frame"), _("Average worst frame"), _("Display FPS limit"), _("Display frametime"),
        _("Graph to histogram"), _("Display frame count"), _("Show temperature °F"), _("Present mode")
    };

    // Vulkan and OpenGL Values
    public string[] vulkan_values = { "Unset", "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] vulkan_config_values = { "", "0", "1", "3", "2" };
    public string[] opengl_values = { "Unset", "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] opengl_config_values = { "", "-1", "0", "1", "n" };

    // Other Variables
    bool test_button_pressed = false;
    public Gee.ArrayList<Label> label_pool = new Gee.ArrayList<Label> ();

    public MangoJuice () {
        Object (application_id: "io.github.radiolamp.mangojuice", flags: ApplicationFlags.DEFAULT_FLAGS);

        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect (() => {
            this.quit ();
        });
        this.add_action (quit_action);
        this.set_accels_for_action ("app.quit", { "<Control>Q" });

        var test_action_new = new SimpleAction ("test_new", null);
        test_action_new.activate.connect (run_test);
        this.add_action (test_action_new);
        const string[] test_new_accels = { "<Primary>T" };
        this.set_accels_for_action ("app.test_new", test_new_accels);

        var restore_config_action = new SimpleAction ("restore_config", null);
        restore_config_action.activate.connect (() => {
            on_restore_config_button_clicked ();
        });
        this.add_action (restore_config_action);
        this.set_accels_for_action ("app.restore_config", new string[] { "<Primary>R" });

        var mangohud_global_action = new SimpleAction ("mangohud_global", null);
        mangohud_global_action.activate.connect (on_mangohud_global_button_clicked);
        this.add_action (mangohud_global_action);

        var save_action = new SimpleAction ("save", null);
        save_action.activate.connect (() => {
            SaveStates.save_states_to_file (this);
        });
        this.add_action (save_action);
        this.set_accels_for_action ("app.save", new string[] { "<Primary>S" });

        var save_as_action = new SimpleAction ("save_as", null);
        save_as_action.activate.connect (() => {
            on_save_as_button_clicked ();
        });
        this.add_action (save_as_action);
        this.set_accels_for_action ("app.save_as", new string[] { "<Primary>E" });
    }

    protected override void activate () {
        var window = new Adw.ApplicationWindow (this);
        window.set_default_size (1024, 700);
        window.set_title ("MangoJuice");

        if (Config.IS_DEVEL) {
            window.add_css_class ("devel");
        }

        var main_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        main_box.set_homogeneous (true);

        view_stack = new ViewStack ();

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

        var breakpoint_800px = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 800px"));
        var breakpoint_550px = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 550px"));

        breakpoint_800px.add_setter (toolbar_view_switcher, "policy", ViewSwitcherPolicy.NARROW);
        breakpoint_550px.add_setter (toolbar_view_switcher, "policy", ViewSwitcherPolicy.NARROW);
        breakpoint_550px.add_setter (bottom_headerbar, "visible", true);
        breakpoint_550px.add_setter (toolbar_view_switcher, "visible", false);

        window.add_breakpoint (breakpoint_800px);
        window.add_breakpoint (breakpoint_550px);

        var metrics_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var extras_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var performance_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var visual_box = new Box (Orientation.VERTICAL, MAIN_BOX_SPACING);
        var other_box = new OtherBox ();

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

        other_scrolled_window = new ScrolledWindow ();
        other_scrolled_window.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
        other_scrolled_window.set_vexpand (true);
        other_scrolled_window.set_child (other_box);

        string? current_desktop = Environment.get_variable ("XDG_CURRENT_DESKTOP");
        bool is_gnome = (current_desktop != null && current_desktop.contains ("GNOME"));

        if (is_gnome) {
            view_stack.add_titled (metrics_scrolled_window, "metrics_box", _("Metrics")).icon_name = "view-continuous-symbolic";
            view_stack.add_titled (extras_scrolled_window, "extras_box", _("Extras")).icon_name = "application-x-addon-symbolic";
            view_stack.add_titled (performance_scrolled_window, "performance_box", _("Performance")).icon_name = "emblem-system-symbolic";
            view_stack.add_titled (visual_scrolled_window, "visual_box", _("Visual")).icon_name = "preferences-desktop-appearance-symbolic";
        } else {
            view_stack.add_titled (metrics_scrolled_window, "metrics_box", _("Metrics")).icon_name = "io.github.radiolamp.mangojuice-metrics-symbolic";
            view_stack.add_titled (extras_scrolled_window, "extras_box", _("Extras")).icon_name = "io.github.radiolamp.mangojuice-extras-symbolic";
            view_stack.add_titled (performance_scrolled_window, "performance_box", _("Performance")).icon_name = "io.github.radiolamp.mangojuice-performance-symbolic";
            view_stack.add_titled (visual_scrolled_window, "visual_box", _("Visual")).icon_name = "io.github.radiolamp.mangojuice-visual-symbolic";
        }

        add_other_box_if_needed.begin ();

        var header_bar = new Adw.HeaderBar ();
        header_bar.set_title_widget (toolbar_view_switcher);

        var test_button = new Button.with_label (_("Test"));
        test_button.clicked.connect (run_test);
        header_bar.pack_start (test_button);

        var menu_button = new MenuButton ();
        var menu_model = new GLib.Menu ();
        var save_item = new GLib.MenuItem (_("Save"), "app.save");
        menu_model.append_item (save_item);
        var save_as_item = new GLib.MenuItem (_("Save As"), "app.save_as");
        menu_model.append_item (save_as_item);
        var restore_config_item = new GLib.MenuItem (_("Restore"), "app.restore_config");
        menu_model.append_item (restore_config_item);
        var about_item = new GLib.MenuItem (_("About"), "app.about");
        menu_model.append_item (about_item);
        menu_button.set_menu_model (menu_model);
        menu_button.set_icon_name ("open-menu-symbolic");
        header_bar.pack_end (menu_button);

        var save_action = new SimpleAction ("save", null);
        save_action.activate.connect (() => {
            SaveStates.save_states_to_file (this);
            if (test_button_pressed) {
                if (is_vkcube_available ()) {
                    restart_vkcube ();
                } else if (is_glxgears_available ()) {
                    restart_glxgears ();
                }
            }
        });

        this.add_action (save_action);

        var content_box = new Box (Orientation.VERTICAL, 0);
        content_box.append (header_bar);
        content_box.append (view_stack);

        window.set_content (content_box);
        window.present ();

        GLib.Idle.add (() => {
            content_box.append (bottom_headerbar);
            initialize_rest_of_ui (view_stack);
            return false;
        });

        check_mangohud_global_status ();
        LoadStates.load_states_from_file.begin (this);

        if (!is_vkcube_available () && !is_glxgears_available ()) {
            test_button.set_visible (false);
        }
    }

    void initialize_rest_of_ui (ViewStack view_stack) {

        var save_as_action = new SimpleAction ("save_as", null);
        save_as_action.activate.connect (on_save_as_button_clicked);
        this.add_action (save_as_action);

        var restore_config_action = new SimpleAction ("restore_config", null);
        restore_config_action.activate.connect (on_restore_config_button_clicked);
        this.add_action (restore_config_action);

        var about_action = new SimpleAction ("about", null);
        about_action.activate.connect (on_about_button_clicked);
        this.add_action (about_action);

        var scales = new Scale[] {
            duracion_scale, autostart_scale, interval_scale, af, picmip, borders_scale, colums_scale, font_size_scale,
            offset_x_scale, offset_y_scale };
        foreach (var scale in scales) {
            add_scroll_event_handler (scale);
            add_value_changed_handler (scale);
        }

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
    }

    protected override void shutdown () {
        try {
            Process.spawn_command_line_async ("pkill vkcube");
            Process.spawn_command_line_async ("pkill glxgears");
        } catch (Error e) {
            stderr.printf ("Error closing test apps: %s\n", e.message);
        }

        base.shutdown ();
    }

    public void add_scroll_event_handler (Scale scale) {
        var controller = new EventControllerScroll (EventControllerScrollFlags.VERTICAL);
        var motion_controller = new EventControllerMotion ();
        uint timeout_id = 0;

        motion_controller.enter.connect ( () => {
            timeout_id = Timeout.add (300, () => {
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

    bool ignore_scroll (double dx, double dy) {
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
        create_switches_and_labels (extras_box, OTHER_TITLE, other_extra_switches, other_extra_labels, other_extra_config_vars, other_extra_label_texts, other_extra_label_texts_2);
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

        for (int i = 0; i < gpu_switches.length; i++) {
            int index = i;
            gpu_switches[i].notify["active"].connect (() => {
                if (index == 0 && !gpu_switches[0].active) {
                    for (int j = 1; j < gpu_switches.length; j++) {
                        gpu_switches[j].active = false;
                    }
                }
                update_gpu_stats_state ();
            });
        }

        for (int i = 0; i < cpu_switches.length; i++) {
            int index = i;
            cpu_switches[i].notify["active"].connect (() => {
                if (index == 0 && !cpu_switches[0].active) {
                    for (int j = 1; j < cpu_switches.length; j++) {
                        cpu_switches[j].active = false;
                    }
                }
                update_cpu_stats_state ();
            });
        }
    }

    void add_switch_handler (Switch[] switches) {
        for (int i = 0; i < switches.length; i++) {
            switches[i].notify["active"].connect (() => {
                new Thread<void> ("save-config", () => {
                    SaveStates.save_states_to_file (this);
                });
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

    public Box create_entry_with_clear_button (Entry entry, string placeholder_text, string default_value) {
        entry.placeholder_text = placeholder_text;
        entry.text = default_value;
        entry.hexpand = true;

        var clear_button = new Button.from_icon_name ("edit-clear-symbolic");
        clear_button.tooltip_text = _("Clear");
        clear_button.visible = false;
        clear_button.add_css_class ("flat");
        clear_button.clicked.connect (() => {
            entry.text = default_value;
            clear_button.visible = false;
        });
    
        entry.changed.connect (() => {
            clear_button.visible = entry.text != default_value;
        });

        var entry_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        entry_box.append (entry);
        entry_box.append (clear_button);

        return entry_box;
    }

    void initialize_custom_controls (Box extras_box, Box visual_box) {
        custom_command_entry = new Entry ();
        var custom_command_box = create_entry_with_clear_button (custom_command_entry, _("Mangohud variable"), "");
        custom_command_entry.changed.connect (() => {
            SaveStates.save_states_to_file (this);
        });

        custom_logs_path_entry = new Entry ();
        var custom_logs_path_box = create_entry_with_clear_button (custom_logs_path_entry, _("Home"), "");
        custom_logs_path_entry.changed.connect (() => {
            SaveStates.save_states_to_file (this);
        });

        logs_path_button = new Button () {
            icon_name = "folder-symbolic",
            tooltip_text = _("The directory for saving the logging")
        };
        logs_path_button.clicked.connect (() => open_folder_chooser_dialog ());

        intel_power_fix_button = new Button () {
            hexpand = true,
            child = new Label (_("Intel Power Fix")) {
                ellipsize = Pango.EllipsizeMode.END,
                halign = Align.CENTER,
                hexpand = true
            }
        };
        intel_power_fix_button.clicked.connect (() => {
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
        logs_key_combo.notify["selected-item"].connect (() => {
            SaveStates.update_logs_key_in_file ((logs_key_combo.selected_item as StringObject)?.get_string () ?? "");
        });

        reset_button = new Button () {
            hexpand = true,
            child = new Label (_("Reset Config")) {
                ellipsize = Pango.EllipsizeMode.END,
                halign = Align.CENTER,
                hexpand = true
            }
        };
        reset_button.add_css_class ("destructive-action");
        reset_button.clicked.connect (() => {
            delete_mangohub_conf ();
            delete_vkbasalt_conf ();
            shutdown ();
            restart_application ();
        });

        blacklist_entry = new Entry ();
        var blacklist_box = create_entry_with_clear_button (blacklist_entry, _("Blacklist: (vkcube,WatchDogs2.exe)"), "");
        blacklist_entry.changed.connect (() => {
            SaveStates.update_blacklist_in_file (blacklist_entry.text);
            SaveStates.save_states_to_file (this);
        });

        if (!is_flatpak ()) {
            mangohud_global_button = new Button.with_label (_("Mangohud Global"));
            mangohud_global_button.clicked.connect (on_mangohud_global_button_clicked);
            blacklist_box.append (mangohud_global_button);
        }

        var blacklist_flow_box = new FlowBox () {
            max_children_per_line = 1,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };
        blacklist_flow_box.insert (blacklist_box, -1);
        extras_box.append (blacklist_flow_box);

        var custom_command_flow_box = new FlowBox () {
            max_children_per_line = 3,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var pair1 = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        var logs_key_label = new Label (_("Logs key")) {
            ellipsize = Pango.EllipsizeMode.END,
            halign = Align.START,
            hexpand = false
        };
        pair1.append (custom_command_box);
        pair1.append (logs_key_label);
        pair1.append (logs_key_combo);
        custom_command_flow_box.insert (pair1, -1);
    
        var pair2 = new Box (Orientation.HORIZONTAL, 5);
        pair2.append (custom_logs_path_box);
        pair2.append (logs_path_button);
        custom_command_flow_box.insert (pair2, -1);

        var pair3 = new Box (Orientation.HORIZONTAL, 5);
        if (!is_flatpak ()) {
            pair3.append (intel_power_fix_button);
        }
        pair3.append (reset_button);
        custom_command_flow_box.insert (pair3, -1);

        extras_box.append (custom_command_flow_box);

        var customize_label = create_label (_("Customize"), Align.START, { "title-4" }, FLOW_BOX_MARGIN, FLOW_BOX_MARGIN, FLOW_BOX_MARGIN);
        visual_box.append (customize_label);

        custom_text_center_entry = new Entry ();
        var custom_text_center_box = create_entry_with_clear_button (custom_text_center_entry, _("Your text"), "");
        custom_text_center_entry.changed.connect (() => {
            SaveStates.save_states_to_file (this);
        });

        var custom_text_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING) {
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN
        };
        custom_text_box.append (custom_text_center_box);
        visual_box.append (custom_text_box);

        var button_flow_box = new FlowBox () {
            max_children_per_line = 4,
            homogeneous = true,
            margin_start = 10,
            margin_end = 10,
            selection_mode = SelectionMode.NONE
        };

        var button1 = new Button.with_label (_("Profile 1"));
        button1.set_size_request (160, -1);
        button1.clicked.connect (() => {
            set_preset (1);
            restart_vkcube_or_glxgears ();
        });

        var button2 = new Button.with_label (_("Profile 2"));
        button2.clicked.connect (() => {
            set_preset (-1);
            restart_vkcube_or_glxgears ();
        });

        var button3 = new Button.with_label (_("Profile 3"));
        button3.clicked.connect (() => {
            set_preset (4);
            restart_vkcube_or_glxgears ();
        });

        var button4 = new Button.with_label (_("Restore profile"));
        button4.clicked.connect (() => {
            SaveStates.save_states_to_file (this);
        });

        button_flow_box.insert (button1, -1);
        button_flow_box.insert (button2, -1);
        button_flow_box.insert (button3, -1);
        button_flow_box.insert (button4, -1);

        visual_box.append (button_flow_box);

        var combined_flow_box = new FlowBox () {
            row_spacing = FLOW_BOX_ROW_SPACING,
            column_spacing = FLOW_BOX_COLUMN_SPACING,
            max_children_per_line = 3,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var custom_switch_label = new Label (_("Horizontal Hud")) {
            halign = Align.START,
            hexpand = true
        };
        custom_switch = new Switch () {
            valign = Align.START,
            margin_end = FLOW_BOX_MARGIN
        };
        custom_switch.notify["active"].connect (() => {
            SaveStates.save_states_to_file (this);
        });
    
        var custom_switch_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        custom_switch_pair.append (custom_switch_label);
        custom_switch_pair.append (custom_switch);
        custom_switch_pair.set_size_request (50, -1);
        combined_flow_box.insert (custom_switch_pair, -1);

        var borders_widget = create_scale_entry_widget (_("Borders"), _("Round"), 0, 15, 0);
        borders_scale = borders_widget.scale;
        borders_entry = borders_widget.entry;
        borders_scale.value_changed.connect (() => {
            if (borders_entry != null) {
                int cursor_position = borders_entry.cursor_position;
                borders_entry.text = "%d".printf ((int)borders_scale.get_value ());
                borders_entry.set_position (cursor_position);
            }
        });
        combined_flow_box.insert (borders_widget.widget, -1);

        var alpha_widget = create_scale_entry_widget (_("Alpha"), _("Transparency"), 0, 100, 50);
        alpha_scale = alpha_widget.scale;
        alpha_entry = alpha_widget.entry;
        alpha_value_label = new Label ("50") {
            width_chars = 3
        };
        alpha_scale.value_changed.connect (() => {
            double value = alpha_scale.get_value ();
            alpha_value_label.label = "%.1f".printf (value / 100.0);
            SaveStates.save_states_to_file (this);
        });
        combined_flow_box.insert (alpha_widget.widget, -1);

        var position_model = new Gtk.StringList (null);
        foreach (var item in new string[] {
            "top-left", "top-center", "top-right",
            "middle-left", "middle-right",
            "bottom-left", "bottom-center", "bottom-right"
        }) {
            position_model.append (item);
        }
        position_dropdown = new DropDown (position_model, null) {
            valign = Align.CENTER,
            hexpand = true
        };
        position_dropdown.notify["selected-item"].connect (() => {
            SaveStates.update_position_in_file ((position_dropdown.selected_item as StringObject)?.get_string () ?? "");
        });

        var position_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        position_pair.append (new Label (_("Position")));
        position_pair.append (position_dropdown);
        combined_flow_box.insert (position_pair, -1);

        var colums_widget = create_scale_entry_widget (_("Columns"), _("Number of columns"), 1, 6, 3);
        colums_scale = colums_widget.scale;
        colums_entry = colums_widget.entry;
        colums_entry.valign = Align.CENTER;
        colums_scale.value_changed.connect (() => {
            if (colums_entry != null) {
                colums_entry.text = "%d".printf ((int)colums_scale.get_value ());
            }
        });
        combined_flow_box.insert (colums_widget.widget, -1);

        toggle_hud_entry = new Entry () {
            placeholder_text = _("Key shortcuts"),
            text = "Shift_R+F12",
            hexpand = true,
            valign = Align.CENTER,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN
        };
        toggle_hud_entry.set_size_request (20, -1);
        toggle_hud_entry.changed.connect (() => {
            SaveStates.update_toggle_hud_in_file (toggle_hud_entry.text);
            SaveStates.save_states_to_file (this);
        });

        var toggle_hud_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        toggle_hud_pair.append (new Label (_("Hide the HUD")));
        toggle_hud_pair.append (toggle_hud_entry);
        combined_flow_box.insert (toggle_hud_pair, -1);

        visual_box.append (combined_flow_box);

        var offset_x_widget = create_scale_entry_widget (_("Offset X"), _("Horizontal offset"), 0, 1500, 0);
        offset_x_scale = offset_x_widget.scale;
        offset_x_entry = offset_x_widget.entry;
        offset_x_value_label = new Label ("0") {
            width_chars = 5,
            halign = Align.END
        };
        offset_x_scale.value_changed.connect (() => {
            offset_x_value_label.label = "%d".printf ((int)offset_x_scale.get_value ());
            SaveStates.update_offset_x_in_file ("%d".printf ((int)offset_x_scale.get_value ()));
        });

        var offset_y_widget = create_scale_entry_widget (_("Offset Y"), _("Vertical offset"), 0, 1500, 0);
        offset_y_scale = offset_y_widget.scale;
        offset_y_entry = offset_y_widget.entry;
        offset_y_value_label = new Label ("0") {
            width_chars = 5,
            halign = Align.END
        };
        offset_y_scale.value_changed.connect (() => {
            offset_y_value_label.label = "%d".printf ((int)offset_y_scale.get_value ());
            SaveStates.update_offset_y_in_file ("%d".printf ((int)offset_y_scale.get_value ()));
        });

        var offset_flow_box = new FlowBox () {
            row_spacing = FLOW_BOX_ROW_SPACING,
            max_children_per_line = 2,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var offset_x_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        offset_x_pair.append (offset_x_widget.widget);
        offset_flow_box.insert (offset_x_pair, -1);

        var offset_y_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        offset_y_pair.append (offset_y_widget.widget);
        offset_flow_box.insert (offset_y_pair, -1);

        visual_box.append (offset_flow_box);

        var fonts_label = create_label (_("Font"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        visual_box.append (fonts_label);

        var font_size_widget = create_scale_entry_widget (_("Size"), _("Size in pixels"), 8, 64, 24);
        font_size_scale = font_size_widget.scale;
        font_size_entry = font_size_widget.entry;
        font_size_scale.value_changed.connect (() => {
            if (font_size_entry != null) {
                font_size_entry.text = "%d".printf ((int)font_size_scale.get_value ());
            }
        });

        initialize_font_dropdown (visual_box);

        var fonts_flow_box = new FlowBox () {
            row_spacing = FLOW_BOX_ROW_SPACING,
            hexpand = true,
            max_children_per_line = 2,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var font_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        font_pair.append (font_dropdown);
        fonts_flow_box.insert (font_pair, -1);

        var size_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        size_pair.append (font_size_widget.widget);
        fonts_flow_box.insert (size_pair, -1);

        visual_box.append (fonts_flow_box);

        initialize_color_controls (visual_box);
    }

    void initialize_color_controls (Box visual_box) {
        var color_label = create_label (_("Color"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        visual_box.append (color_label);

        var color_flow_box = new FlowBox () {
            homogeneous = true,
            max_children_per_line = 9,
            row_spacing = FLOW_BOX_ROW_SPACING,
            column_spacing = FLOW_BOX_COLUMN_SPACING,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var color_dialog = new ColorDialog ();

        gpu_color_button = new ColorDialogButton (color_dialog);
        var default_gpu_color = Gdk.RGBA ();
        default_gpu_color.parse ("#2e9762");
        gpu_color_button.set_rgba (default_gpu_color);
        gpu_color_button.notify["rgba"].connect (() => {
            var rgba = gpu_color_button.get_rgba ().copy ();
            SaveStates.update_gpu_color_in_file (rgba_to_hex (rgba));
        });

        cpu_color_button = new ColorDialogButton (color_dialog);
        var default_cpu_color = Gdk.RGBA ();
        default_cpu_color.parse ("#2e97cb");
        cpu_color_button.set_rgba (default_cpu_color);
        cpu_color_button.notify["rgba"].connect (() => {
            var rgba = cpu_color_button.get_rgba ().copy ();
            SaveStates.update_cpu_color_in_file (rgba_to_hex (rgba));
        });

        gpu_text_entry = new Entry ();
        var gpu_text_entry_box = create_entry_with_clear_button (gpu_text_entry, _("GPU custom name"), "");
        gpu_text_entry.changed.connect (() => {
            SaveStates.update_gpu_text_in_file (gpu_text_entry.text);
            SaveStates.save_states_to_file (this);
        });

        cpu_text_entry = new Entry ();
        var cpu_text_entry_box = create_entry_with_clear_button (cpu_text_entry, _("CPU custom name"), "");
        cpu_text_entry.changed.connect (() => {
            SaveStates.update_cpu_text_in_file (cpu_text_entry.text);
            SaveStates.save_states_to_file (this);
        });

        var color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING) {
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN
        };
        color_box.append (gpu_text_entry_box);
        color_box.append (gpu_color_button);
        color_box.append (cpu_text_entry_box);
        color_box.append (cpu_color_button);
        visual_box.append (color_box);

        var clear_fps_button = new Button.from_icon_name ("edit-clear-symbolic") {
            tooltip_text = _("Reset to default"),
            visible = false
        };
        clear_fps_button.add_css_class ("flat");

        clear_fps_button.clicked.connect (() => {
            fps_value_entry_1.text = "30";
            fps_value_entry_2.text = "60";
            clear_fps_button.visible = false;
        });

        fps_value_entry_1 = new Entry () {
            placeholder_text = _("Medium"),
            text = "30",
            hexpand = true
        };
        validate_numeric_entry (fps_value_entry_1, 0, 1000);
        fps_value_entry_1.changed.connect (() => {
            clear_fps_button.visible = (fps_value_entry_1.text != "30" || fps_value_entry_2.text != "60");
            SaveStates.update_fps_value_in_file (fps_value_entry_1.text, fps_value_entry_2.text);
        });

        fps_value_entry_2 = new Entry () {
            placeholder_text = _("High"),
            text = "60",
            hexpand = true
        };
        validate_numeric_entry (fps_value_entry_2, 0, 1000);
        fps_value_entry_2.changed.connect (() => {
            clear_fps_button.visible = (fps_value_entry_1.text != "30" || fps_value_entry_2.text != "60");
            SaveStates.update_fps_value_in_file (fps_value_entry_1.text, fps_value_entry_2.text);
        });

        var fps_entry_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        fps_entry_box.append (fps_value_entry_1);
        fps_entry_box.append (fps_value_entry_2);
        fps_entry_box.append (clear_fps_button);

        var fps_clarge_label = create_label (_("FPS color levels"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        visual_box.append (fps_clarge_label);

        var color_dialog_fps = new ColorDialog ();
        fps_color_button_1 = new ColorDialogButton (color_dialog_fps);
        var default_fps_color_1 = Gdk.RGBA ();
        default_fps_color_1.parse ("#cc0000");
        fps_color_button_1.set_rgba (default_fps_color_1);
        fps_color_button_1.notify["rgba"].connect (() => {
            var rgba = fps_color_button_1.get_rgba ().copy ();
            SaveStates.update_fps_color_in_file (rgba_to_hex (rgba), rgba_to_hex (fps_color_button_2.get_rgba ()), rgba_to_hex (fps_color_button_3.get_rgba ()));
        });

        fps_color_button_2 = new ColorDialogButton (color_dialog_fps);
        var default_fps_color_2 = Gdk.RGBA ();
        default_fps_color_2.parse ("#ffaa7f");
        fps_color_button_2.set_rgba (default_fps_color_2);
        fps_color_button_2.notify["rgba"].connect (() => {
            var rgba = fps_color_button_2.get_rgba ().copy ();
            SaveStates.update_fps_color_in_file (rgba_to_hex (fps_color_button_1.get_rgba ()), rgba_to_hex (rgba), rgba_to_hex (fps_color_button_3.get_rgba ()));
        });

        fps_color_button_3 = new ColorDialogButton (color_dialog_fps);
        var default_fps_color_3 = Gdk.RGBA ();
        default_fps_color_3.parse ("#92e79a");
        fps_color_button_3.set_rgba (default_fps_color_3);
        fps_color_button_3.notify["rgba"].connect (() => {
            var rgba = fps_color_button_3.get_rgba ().copy ();
            SaveStates.update_fps_color_in_file (rgba_to_hex (fps_color_button_1.get_rgba ()), rgba_to_hex (fps_color_button_2.get_rgba ()), rgba_to_hex (rgba));
        });

        var fps_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING) {
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN
        };
        fps_color_box.append (fps_entry_box);
        fps_color_box.append (fps_color_button_1);
        fps_color_box.append (fps_color_button_2);
        fps_color_box.append (fps_color_button_3);
        visual_box.append (fps_color_box);

        var gpu_load_clarge_label = create_label (_("The color of GPU levels"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        visual_box.append (gpu_load_clarge_label);

        var clear_gpu_load_button = new Button.from_icon_name ("edit-clear-symbolic") {
            tooltip_text = _("Reset to default"),
            visible = false
        };
        clear_gpu_load_button.add_css_class ("flat");
        clear_gpu_load_button.clicked.connect (() => {
            gpu_load_value_entry_1.text = "60";
            gpu_load_value_entry_2.text = "90";
            clear_gpu_load_button.visible = false;
        });

        gpu_load_value_entry_1 = new Entry () {
            placeholder_text = _("Medium"),
            text = "60",
            hexpand = true
        };
        validate_numeric_entry (gpu_load_value_entry_1, 0, 100);
        gpu_load_value_entry_1.changed.connect (() => {
            clear_gpu_load_button.visible = (gpu_load_value_entry_1.text != "60" || gpu_load_value_entry_2.text != "90");
            SaveStates.update_gpu_load_value_in_file (gpu_load_value_entry_1.text, gpu_load_value_entry_2.text);
        });
    
        gpu_load_value_entry_2 = new Entry () {
            placeholder_text = _("High"),
            text = "90",
            hexpand = true
        };
        validate_numeric_entry (gpu_load_value_entry_2, 0, 100);
        gpu_load_value_entry_2.changed.connect (() => {
            clear_gpu_load_button.visible = (gpu_load_value_entry_1.text != "60" || gpu_load_value_entry_2.text != "90");
            SaveStates.update_gpu_load_value_in_file (gpu_load_value_entry_1.text, gpu_load_value_entry_2.text);
        });
    
        var gpu_load_entry_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        gpu_load_entry_box.append (gpu_load_value_entry_1);
        gpu_load_entry_box.append (gpu_load_value_entry_2);
        gpu_load_entry_box.append (clear_gpu_load_button);

        var color_dialog_gpu_load = new ColorDialog ();
        gpu_load_color_button_1 = new ColorDialogButton (color_dialog_gpu_load);
        var default_gpu_load_color_1 = Gdk.RGBA ();
        default_gpu_load_color_1.parse ("#92e79a");
        gpu_load_color_button_1.set_rgba (default_gpu_load_color_1);
        gpu_load_color_button_1.notify["rgba"].connect (() => {
            var rgba = gpu_load_color_button_1.get_rgba ().copy ();
            SaveStates.update_gpu_load_color_in_file (rgba_to_hex (rgba), rgba_to_hex (gpu_load_color_button_2.get_rgba ()), rgba_to_hex (gpu_load_color_button_3.get_rgba ()));
        });

        gpu_load_color_button_2 = new ColorDialogButton (color_dialog_gpu_load);
        var default_gpu_load_color_2 = Gdk.RGBA ();
        default_gpu_load_color_2.parse ("#ffaa7f");
        gpu_load_color_button_2.set_rgba (default_gpu_load_color_2);
        gpu_load_color_button_2.notify["rgba"].connect (() => {
            var rgba = gpu_load_color_button_2.get_rgba ().copy ();
            SaveStates.update_gpu_load_color_in_file (rgba_to_hex (gpu_load_color_button_1.get_rgba ()), rgba_to_hex (rgba), rgba_to_hex (gpu_load_color_button_3.get_rgba ()));
        });

        gpu_load_color_button_3 = new ColorDialogButton (color_dialog_gpu_load);
        var default_gpu_load_color_3 = Gdk.RGBA ();
        default_gpu_load_color_3.parse ("#cc0000");
        gpu_load_color_button_3.set_rgba (default_gpu_load_color_3);
        gpu_load_color_button_3.notify["rgba"].connect (() => {
            var rgba = gpu_load_color_button_3.get_rgba ().copy ();
            SaveStates.update_gpu_load_color_in_file (rgba_to_hex (gpu_load_color_button_1.get_rgba ()), rgba_to_hex (gpu_load_color_button_2.get_rgba ()), rgba_to_hex (rgba));
        });

        var gpu_load_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING) {
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN
        };
        gpu_load_color_box.append (gpu_load_entry_box);
        gpu_load_color_box.append (gpu_load_color_button_1);
        gpu_load_color_box.append (gpu_load_color_button_2);
        gpu_load_color_box.append (gpu_load_color_button_3);
        visual_box.append (gpu_load_color_box);
    
        var cpu_load_clarge_label = create_label (_("The color of CPU levels"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        visual_box.append (cpu_load_clarge_label);
    
        var clear_cpu_load_button = new Button.from_icon_name ("edit-clear-symbolic") {
            tooltip_text = _("Reset to default"),
            visible = false,
        };
        clear_cpu_load_button.add_css_class ("flat");
        clear_cpu_load_button.clicked.connect (() => {
            cpu_load_value_entry_1.text = "60";
            cpu_load_value_entry_2.text = "90";
            clear_cpu_load_button.visible = false;
        });

        cpu_load_value_entry_1 = new Entry () {
            placeholder_text = _("Medium"),
            text = "60",
            hexpand = true
        };
        validate_numeric_entry (cpu_load_value_entry_1, 0, 100);
        cpu_load_value_entry_1.changed.connect (() => {
            clear_cpu_load_button.visible = (cpu_load_value_entry_1.text != "60" || cpu_load_value_entry_2.text != "90");
            SaveStates.update_cpu_load_value_in_file (cpu_load_value_entry_1.text, cpu_load_value_entry_2.text);
        });

        cpu_load_value_entry_2 = new Entry () {
            placeholder_text = _("High"),
            text = "90",
            hexpand = true
        };
        validate_numeric_entry (cpu_load_value_entry_2, 0, 100);
        cpu_load_value_entry_2.changed.connect (() => {
            clear_cpu_load_button.visible = (cpu_load_value_entry_1.text != "60" || cpu_load_value_entry_2.text != "90");
            SaveStates.update_cpu_load_value_in_file (cpu_load_value_entry_1.text, cpu_load_value_entry_2.text);
        });

        var cpu_load_entry_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        cpu_load_entry_box.append (cpu_load_value_entry_1);
        cpu_load_entry_box.append (cpu_load_value_entry_2);
        cpu_load_entry_box.append (clear_cpu_load_button);

        var color_dialog_cpu_load = new ColorDialog ();
        cpu_load_color_button_1 = new ColorDialogButton (color_dialog_cpu_load);
        var default_cpu_load_color_1 = Gdk.RGBA ();
        default_cpu_load_color_1.parse ("#92e79a");
        cpu_load_color_button_1.set_rgba (default_cpu_load_color_1);
        cpu_load_color_button_1.notify["rgba"].connect (() => {
            var rgba = cpu_load_color_button_1.get_rgba ().copy ();
            SaveStates.update_cpu_load_color_in_file (rgba_to_hex (rgba), rgba_to_hex (cpu_load_color_button_2.get_rgba ()), rgba_to_hex (cpu_load_color_button_3.get_rgba ()));
        });

        cpu_load_color_button_2 = new ColorDialogButton (color_dialog_cpu_load);
        var default_cpu_load_color_2 = Gdk.RGBA ();
        default_cpu_load_color_2.parse ("#ffaa7f");
        cpu_load_color_button_2.set_rgba (default_cpu_load_color_2);
        cpu_load_color_button_2.notify["rgba"].connect (() => {
            var rgba = cpu_load_color_button_2.get_rgba ().copy ();
            SaveStates.update_cpu_load_color_in_file (rgba_to_hex (cpu_load_color_button_1.get_rgba ()), rgba_to_hex (rgba), rgba_to_hex (cpu_load_color_button_3.get_rgba ()));
        });

        cpu_load_color_button_3 = new ColorDialogButton (color_dialog_cpu_load);
        var default_cpu_load_color_3 = Gdk.RGBA ();
        default_cpu_load_color_3.parse ("#cc0000");
        cpu_load_color_button_3.set_rgba (default_cpu_load_color_3);
        cpu_load_color_button_3.notify["rgba"].connect (() => {
            var rgba = cpu_load_color_button_3.get_rgba ().copy ();
            SaveStates.update_cpu_load_color_in_file (rgba_to_hex (cpu_load_color_button_1.get_rgba ()), rgba_to_hex (cpu_load_color_button_2.get_rgba ()), rgba_to_hex (rgba));
        });

        var cpu_load_color_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING) {
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN
        };
        cpu_load_color_box.append (cpu_load_entry_box);
        cpu_load_color_box.append (cpu_load_color_button_1);
        cpu_load_color_box.append (cpu_load_color_button_2);
        cpu_load_color_box.append (cpu_load_color_button_3);
        visual_box.append (cpu_load_color_box);

        if (color_flow_box.get_parent () == null) {
            visual_box.append (color_flow_box);
        }

        background_color_button = new ColorDialogButton (color_dialog);
        var default_background_color = Gdk.RGBA ();
        default_background_color.parse ("#000000");
        background_color_button.set_rgba (default_background_color);
        background_color_button.notify["rgba"].connect ( () => {
            var rgba = background_color_button.get_rgba ().copy ();
            SaveStates.update_background_color_in_file (rgba_to_hex (rgba));
        });

        frametime_color_button = new ColorDialogButton (color_dialog);
        var default_frametime_color = Gdk.RGBA ();
        default_frametime_color.parse ("#00ff00");
        frametime_color_button.set_rgba (default_frametime_color);
        frametime_color_button.notify["rgba"].connect ( () => {
            var rgba = frametime_color_button.get_rgba ().copy ();
            SaveStates.update_frametime_color_in_file (rgba_to_hex (rgba));
        });

        vram_color_button = new ColorDialogButton (color_dialog);
        var default_vram_color = Gdk.RGBA ();
        default_vram_color.parse ("#ad64c1");
        vram_color_button.set_rgba (default_vram_color);
        vram_color_button.notify["rgba"].connect ( () => {
            var rgba = vram_color_button.get_rgba ().copy ();
            SaveStates.update_vram_color_in_file (rgba_to_hex (rgba));
        });

        ram_color_button = new ColorDialogButton (color_dialog);
        var default_ram_color = Gdk.RGBA ();
        default_ram_color.parse ("#c26693");
        ram_color_button.set_rgba (default_ram_color);
        ram_color_button.notify["rgba"].connect ( () => {
            var rgba = ram_color_button.get_rgba ().copy ();
            SaveStates.update_ram_color_in_file (rgba_to_hex (rgba));
        });

        wine_color_button = new ColorDialogButton (color_dialog);
        var default_wine_color = Gdk.RGBA ();
        default_wine_color.parse ("#eb5b5b");
        wine_color_button.set_rgba (default_wine_color);
        wine_color_button.notify["rgba"].connect ( () => {
            var rgba = wine_color_button.get_rgba ().copy ();
            SaveStates.update_wine_color_in_file (rgba_to_hex (rgba));
        });

        engine_color_button = new ColorDialogButton (color_dialog);
        var default_engine_color = Gdk.RGBA ();
        default_engine_color.parse ("#eb5b5b");
        engine_color_button.set_rgba (default_engine_color);
        engine_color_button.notify["rgba"].connect ( () => {
            var rgba = engine_color_button.get_rgba ().copy ();
            SaveStates.update_engine_color_in_file (rgba_to_hex (rgba));
        });

        text_color_button = new ColorDialogButton (color_dialog);
        var default_text_color = Gdk.RGBA ();
        default_text_color.parse ("#FFFFFF");
        text_color_button.set_rgba (default_text_color);
        text_color_button.notify["rgba"].connect ( () => {
            var rgba = text_color_button.get_rgba ().copy ();
            SaveStates.update_text_color_in_file (rgba_to_hex (rgba));
        });

        media_player_color_button = new ColorDialogButton (color_dialog);
        var default_media_player_color = Gdk.RGBA ();
        default_media_player_color.parse ("#FFFFFF");
        media_player_color_button.set_rgba (default_media_player_color);
        media_player_color_button.notify["rgba"].connect ( () => {
            var rgba = media_player_color_button.get_rgba ().copy ();
            SaveStates.update_media_player_color_in_file (rgba_to_hex (rgba));
        });

        network_color_button = new ColorDialogButton (color_dialog);
        var default_network_color = Gdk.RGBA ();
        default_network_color.parse ("#e07b85");
        network_color_button.set_rgba (default_network_color);
        network_color_button.notify["rgba"].connect ( () => {
            var rgba = network_color_button.get_rgba ().copy ();
            SaveStates.update_network_color_in_file (rgba_to_hex (rgba));
        });

        ColorDialogButton[] color_buttons = { background_color_button, frametime_color_button, vram_color_button, ram_color_button, wine_color_button, engine_color_button, media_player_color_button, network_color_button, text_color_button };
        string[] color_labels = { _("Background"), _("Frametime"), _("VRAM"), _("RAM"), _("Wine"), _("Engine"), _("Media"), _("Network"), _("Text") };

        assert (color_buttons.length == color_labels.length);

        for (int i = 0; i < color_buttons.length; i++) {
            var label = new Label (color_labels[i]);
            label.set_halign (Align.START);
            label.set_ellipsize (Pango.EllipsizeMode.END);
            label.hexpand = true;
           
            var box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            box.append (color_buttons[i]);
            box.append (label);

            color_flow_box.insert (box, -1);
        }
    }

    void initialize_font_dropdown (Box visual_box) {
        var font_model = new Gtk.StringList (null);
        font_model.append (_("Default"));

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
        font_dropdown.set_size_request (100, -1);
        font_dropdown.set_tooltip_text (_("If you are going to play through wine, then you need to select fonts from the home directory, the system fonts will not work."));

        font_dropdown.notify["selected-item"].connect (() => {
            var selected_font_name = (font_dropdown.selected_item as StringObject)?.get_string () ?? "";
            var selected_font_path = find_font_path_by_name (selected_font_name, fonts);
            SaveStates.update_font_file_in_file (selected_font_path);
            SaveStates.save_states_to_file (this);
        });

        var factory = new Gtk.SignalListItemFactory ();
        factory.setup.connect ((item) => {
            var list_item = item as Gtk.ListItem;
            var box = new Box (Orientation.HORIZONTAL, 5);
            var label = new Label (null);
            label.set_ellipsize (Pango.EllipsizeMode.END);
            label.set_xalign (0.0f);
            label.set_ellipsize (Pango.EllipsizeMode.END);
            label.set_hexpand (true);

            var wine_label = new Label (_("Support Wine"));
            wine_label.set_halign (Align.END);
            wine_label.add_css_class ("dim-label");
            wine_label.set_visible (false);
            wine_label.set_halign (Align.END);

            box.append (label);
            box.append (wine_label);
            list_item.set_child (box);
        });

        factory.bind.connect ((item) => {
            var list_item = item as Gtk.ListItem;
            var box = list_item.get_child () as Box;
            var label = box.get_first_child () as Label;
            var wine_label = label.get_next_sibling () as Label;

            var font_name = (list_item.get_item () as StringObject)?.get_string () ?? "";
            label.label = font_name;

            var font_path = find_font_path_by_name (font_name, fonts);
            if (font_path != null && font_path.has_prefix (Environment.get_home_dir ())) {
                wine_label.set_visible (true);
            } else {
                wine_label.set_visible (false);
            }
        });
    
        font_dropdown.set_factory (factory);
    }

    public Gee.List<string> find_fonts () {
        var fonts = new Gee.ArrayList<string> ();
        try {
            string[] argv = { "fc-list", ":", "file" };
            int exit_status;
            string standard_output;
            string standard_error;

            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);
    
            if (exit_status == 0) {
                string[] lines = standard_output.split ("\n");

                var regex = new Regex (".*\\.(ttf|otf|ttc)$", RegexCompileFlags.OPTIMIZE);

                foreach (var line in lines) {
                    if (line.strip () != "") {
                        string[] parts = line.split (":");
                        if (parts.length > 0) {
                            string font_path = parts[0].strip ();

                            if (regex.match (font_path)) {
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

    void create_switches_and_labels (Box parent_box, string title, Switch[] switches, Label[] labels, string[] config_vars, string[] label_texts, string[] label_texts_2) {

        var label = create_label (title, Align.START, { "title-4" }, FLOW_BOX_MARGIN, FLOW_BOX_MARGIN, FLOW_BOX_MARGIN);
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
            text_box.set_size_request (160, -1); // Ширина 160 пикселей

            var label1 = new Label (null);
            label1.set_markup ("<b>%s</b>".printf (label_texts[i]));
            label1.set_halign (Align.START);
            label1.set_hexpand (false);
            label1.set_ellipsize (Pango.EllipsizeMode.END);

            string truncated_text = label_texts_2[i];
            if (label_texts_2[i].char_count () > 22) {
                truncated_text = label_texts_2[i].substring (0, label_texts_2[i].index_of_nth_char (22)) + "…";
            }

            var label2 = new Label (null);
            label2.set_markup ("<span size='9000'>%s</span>".printf (truncated_text));
            label2.set_halign (Align.START);
            label2.set_hexpand (false);
            label2.add_css_class ("dim-label");
            label2.set_ellipsize (Pango.EllipsizeMode.END); 

            text_box.append (label1);
            text_box.append (label2);

            row_box.append (switches[i]);
            row_box.append (text_box);
            flow_box.insert (row_box, -1);
        }

        parent_box.append (flow_box);
    }

    public Label get_label () {
        if (label_pool.size > 0) {
            return label_pool.remove_at (label_pool.size - 1);
        } else {
            return new Label ("");
        }
    }

    void create_scales_and_labels (Box parent_box) {
        var logging_label = create_label (_("Logging"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
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

        string[] label_texts = { _("Duracion"), _("Autostart"), _("Interval") };
        string[] label_texts_2 = { _("Seconds"), _("Seconds"), _("Milliseconds") };

        var duracion_widget = create_scale_entry_widget (label_texts[0], label_texts_2[0], 0, 200, 30);
        duracion_scale = duracion_widget.scale;
        scales_flow_box.insert (duracion_widget.widget, -1);

        var autostart_widget = create_scale_entry_widget (label_texts[1], label_texts_2[1], 0, 30, 0);
        autostart_scale = autostart_widget.scale;
        scales_flow_box.insert (autostart_widget.widget, -1);

        var interval_widget = create_scale_entry_widget (label_texts[2], label_texts_2[2], 0, 500, 100);
        interval_scale = interval_widget.scale;
        scales_flow_box.insert (interval_widget.widget, -1);

        parent_box.append (scales_flow_box);
    }

    void create_limiters_and_filters (Box performance_box) {
        var limiters_label = create_label (_("Limiters FPS"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        performance_box.append (limiters_label);

        var fps_limit_method_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "late", "early" }) {
            fps_limit_method_model.append (item);
        }
        fps_limit_method = new DropDown (fps_limit_method_model, null);

        fps_limit_entry_1 = new Entry ();
        var fps_limit_entry_1_box = create_entry_with_clear_button (fps_limit_entry_1, _("Limit 1"), "");
        fps_limit_entry_1.changed.connect (() => {
            validate_numeric_entry (fps_limit_entry_1, 0, 1000);
            SaveStates.update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            SaveStates.save_states_to_file (this);
        });

        fps_limit_entry_2 = new Entry ();
        var fps_limit_entry_2_box = create_entry_with_clear_button (fps_limit_entry_2, _("Limit 2"), "");
        fps_limit_entry_2.changed.connect (() => {
            validate_numeric_entry (fps_limit_entry_2, 0, 1000);
            SaveStates.update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            SaveStates.save_states_to_file (this);
        });

        fps_limit_entry_3 = new Entry ();
        var fps_limit_entry_3_box = create_entry_with_clear_button (fps_limit_entry_3, _("Limit 3"), "");
        fps_limit_entry_3.changed.connect (() => {
            validate_numeric_entry (fps_limit_entry_3, 0, 1000);
            SaveStates.update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            SaveStates.save_states_to_file (this);
        });

        var toggle_fps_limit_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "Shift_L+F1", "Shift_L+F2", "Shift_L+F3", "Shift_L+F4" }) {
            toggle_fps_limit_model.append (item);
        }
        toggle_fps_limit = new DropDown (toggle_fps_limit_model, null);

        var limiters_box = new FlowBox ();
        limiters_box.set_max_children_per_line (5);
        limiters_box.set_margin_start (FLOW_BOX_MARGIN);
        limiters_box.set_margin_end (FLOW_BOX_MARGIN);
        limiters_box.set_margin_top (FLOW_BOX_MARGIN);
        limiters_box.set_margin_bottom (FLOW_BOX_MARGIN);
        limiters_box.append (fps_limit_method);
        limiters_box.append (fps_limit_entry_1_box);
        limiters_box.append (fps_limit_entry_2_box);
        limiters_box.append (fps_limit_entry_3_box);
        limiters_box.append (toggle_fps_limit);
        performance_box.append (limiters_box);

        var vsync_label = create_label (_("VSync"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
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
        vulkan_label.set_halign (Align.END);

        var opengl_label = new Label ("OpenGL");
        opengl_label.set_halign (Align.END);

        var vsync_box = new FlowBox ();
        vsync_box.set_max_children_per_line (5);
        vsync_box.set_margin_start (FLOW_BOX_MARGIN);
        vsync_box.set_margin_end (FLOW_BOX_MARGIN);
        vsync_box.set_margin_top (FLOW_BOX_MARGIN);
        vsync_box.set_margin_bottom (FLOW_BOX_MARGIN);
        vsync_box.append (vulkan_label);
        vsync_box.append (vulkan_dropdown);
        vsync_box.append (opengl_label);
        vsync_box.append (opengl_dropdown);
        performance_box.append (vsync_box); 

        var filters_label = create_label (_("Filters"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        performance_box.append (filters_label);

        var filter_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "none", "bicubic", "trilinear", "retro" }) {
            filter_model.append (item);
        }
        filter_dropdown = new DropDown (filter_model, null);
        filter_dropdown.set_valign (Align.START);
        filter_dropdown.set_hexpand (true);

        var af_widget = create_scale_entry_widget (_("Anisotropic"), _("Filtering"), 0, 16, 0);
        af = af_widget.scale;
        af_entry = af_widget.entry;

        var picmip_widget = create_scale_entry_widget (_("Mipmap"), _("Aliasing"), -16, 16, 0);
        picmip = picmip_widget.scale;
        picmip_entry = picmip_widget.entry;

        var filters_flow_box = new FlowBox ();
        filters_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        filters_flow_box.set_max_children_per_line (3);
        filters_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        filters_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        filters_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        filters_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        filters_flow_box.set_selection_mode (SelectionMode.NONE);

        var filter_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        filter_pair.append (filter_dropdown);
        filters_flow_box.insert (filter_pair, -1);
        var af_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        af_pair.append (af_widget.widget);
        filters_flow_box.insert (af_pair, -1);

        var picmip_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        picmip_pair.append (picmip_widget.widget);
        filters_flow_box.insert (picmip_pair, -1);

        performance_box.append (filters_flow_box);

        var fps_sampling_period_label = create_label (_("Other"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        performance_box.append (fps_sampling_period_label);

        var fps_sampling_period_widget = create_scale_entry_widget (_("FPS Sampling"), _("Milliseconds"), 250, 2000, 500);
        fps_sampling_period_scale = fps_sampling_period_widget.scale;
        fps_sampling_period_entry = fps_sampling_period_widget.entry;
        
        bool is_updating = false;

        fps_sampling_period_scale.value_changed.connect (() => {
            if (!is_updating) {
                is_updating = true;
                int value = (int)fps_sampling_period_scale.get_value ();
                fps_sampling_period_entry.text = "%d".printf (value);
                SaveStates.update_fps_sampling_period_in_file ("%d".printf (value));
                is_updating = false;
            }
        });

        fps_sampling_period_entry.changed.connect (() => {
            if (!is_updating) {
                is_updating = true;
                int value = int.parse (fps_sampling_period_entry.text);
                if (value >= 250 && value <= 2000 && value != (int)fps_sampling_period_scale.get_value ()) {
                    fps_sampling_period_scale.set_value (value);
                    SaveStates.update_fps_sampling_period_in_file ("%d".printf (value));
                }
                is_updating = false;
            }
        });

        var fps_sampling_period_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        fps_sampling_period_box.set_margin_start (FLOW_BOX_MARGIN);
        fps_sampling_period_box.set_margin_end (FLOW_BOX_MARGIN);
        fps_sampling_period_box.set_margin_top (FLOW_BOX_MARGIN);
        fps_sampling_period_box.set_margin_bottom (FLOW_BOX_MARGIN);
        fps_sampling_period_box.append (fps_sampling_period_widget.widget);
        performance_box.append (fps_sampling_period_box);
    }

    void restart_vkcube () {
        try {
            Process.spawn_command_line_sync ("pkill vkcube");
            Process.spawn_command_line_async ("mangohud vkcube");
        } catch (Error e) {
            stderr.printf ("Error when restarting vkcube: %s\n", e.message);
        }
    }

    void restart_glxgears () {
        try {
            Process.spawn_command_line_sync ("pkill glxgears");
            Process.spawn_command_line_async ("mangohud glxgears");
        } catch (Error e) {
            stderr.printf ("Error when restarting glxgears: %s\n", e.message);
        }
    }

    void restart_vkcube_or_glxgears () {
        if (is_vkcube_running ()) {
            restart_vkcube ();
        } else if (is_glxgears_running ()) {
            restart_glxgears ();
        }
    }

    void save_and_restart () {
        SaveStates.save_states_to_file (this);
        restart_vkcube_or_glxgears ();
    }

    bool is_vkcube_running () {
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

    bool is_glxgears_running () {
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

    void run_test () {
        new Thread<void>("run-test", () => {
            try {
                var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
                var config_file = config_dir.get_child ("MangoHud.conf");

                if (!config_file.query_exists ()) {
                    SaveStates.save_states_to_file (this);
                }

                if (is_vkcube_available ()) {
                    Process.spawn_command_line_sync ("pkill vkcube");
                    Process.spawn_command_line_async ("mangohud vkcube");
                } else if (is_glxgears_available ()) {
                    Process.spawn_command_line_sync ("pkill glxgears");
                    Process.spawn_command_line_async ("mangohud glxgears");
                }

                Idle.add (() => {
                    test_button_pressed = true;
                    return false;
                });
            } catch (Error e) {
                stderr.printf ("Ошибка при выполнении команды: %s\n", e.message);
            }
        });
    }

    void delete_mangohub_conf () {
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

    void delete_vkbasalt_conf () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("vkBasalt");
        var file = config_dir.get_child ("vkBasalt.conf");
        if (file.query_exists ()) {
            try {
                file.delete ();
                warning ("vkBasalt.conf file deleted.");
            } catch (Error e) {
                stderr.printf ("Error deleting vkBasalt.conf: %s\n", e.message);
            }
        } else {
            warning ("vkBasalt.conf file does not exist.");
        }
    }

    void open_folder_chooser_dialog () {
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

    void restart_application () {
        string mangojuice_path = Environment.find_program_in_path ("mangojuice");
        if (mangojuice_path != null) {
            try {
                Process.spawn_command_line_async (mangojuice_path);
            } catch (Error e) {
                stderr.printf ("Ошибка при перезапуске приложения: %s\n", e.message);
            }
        } else {
            stderr.printf ("Исполняемый файл mangojuice не найден в PATH.\n");
        }
        Process.exit (0);
    }

    bool is_vkcube_available () {
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

    bool is_glxgears_available () {
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

    void on_save_as_button_clicked () {
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

    void save_config_to_file (string file_path) {
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

    void on_restore_config_button_clicked () {
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

    void restore_config_from_file (string file_path) {
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
        LoadStates.load_states_from_file.begin (this);
    }

    struct ScaleEntryWidget {
        public Scale scale;
        public Entry entry;
        public Box widget;
    }

    void validate_entry_value (Entry entry, int min, int max) {
        int value = 0;
        if (int.try_parse (entry.text, out value)) {
            if (value < min || value > max) {
                entry.add_css_class ("error");
            } else {
                entry.remove_css_class ("error");
            }
        } else {
            entry.add_css_class ("error");
        }
    }

    ScaleEntryWidget create_scale_entry_widget (string title, string description, int min, int max, int initial_value) {
        ScaleEntryWidget result = ScaleEntryWidget ();

        result.scale = new Scale.with_range (Orientation.HORIZONTAL, min, max, 1);
        result.scale.set_value (initial_value);
        result.scale.set_size_request (140, -1);
        result.scale.set_hexpand (true);

        result.entry = new Entry ();
        result.entry.text = "%d".printf (initial_value);
        result.entry.set_width_chars (3);
        result.entry.set_max_width_chars (4);
        result.entry.set_halign (Align.END);

       validate_numeric_entry (result.entry, min, max);

        bool is_updating = false;

        result.scale.value_changed.connect (() => {
            if (!is_updating) {
                is_updating = true;
                GLib.Idle.add (() => {
                    result.entry.text = "%d".printf ((int)result.scale.get_value ());
                    validate_entry_value (result.entry, min, max);
                    is_updating = false;
                    return false;
                });
            }
        });

        result.entry.changed.connect (() => {
            if (!is_updating) {
                int value = 0;
                if (int.try_parse (result.entry.text, out value)) {
                    if (value >= min && value <= max && value != (int)result.scale.get_value ()) {
                        is_updating = true;
                        GLib.Idle.add (() => {
                            result.scale.set_value (value);
                            validate_entry_value (result.entry, min, max);
                            is_updating = false;
                            return false;
                        });
                    }
                }
                validate_entry_value (result.entry, min, max);
            }
        });

        var text_box = new Box (Orientation.VERTICAL, 0);
        text_box.set_valign (Align.CENTER);
        text_box.set_halign (Align.START);

        var label1 = new Label (null);
        label1.set_markup ("<b>%s</b>".printf (title));
        label1.set_halign (Align.START);
        label1.set_hexpand (false);
        label1.set_ellipsize (Pango.EllipsizeMode.END);

        var label2 = new Label (null);
        label2.set_markup ("<span size='9000'>%s</span>".printf (description));
        label2.set_halign (Align.START);
        label2.set_hexpand (false);
        label2.add_css_class ("dim-label");
        label2.set_ellipsize (Pango.EllipsizeMode.END);

        text_box.append (label1);
        text_box.append (label2);

        result.widget = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        result.widget.append (text_box);
        result.widget.append (result.scale);
        result.widget.append (result.entry);

        return result;
    }

    Label create_label (string text, Align halign = Align.START, string[] css_classes = {}, int margin_start = 0, int margin_end = 0, int margin_top = 0, int margin_bottom = 0) {
        var label = new Label (text);
        label.set_halign (halign);

        foreach (var css_class in css_classes) {
            label.add_css_class (css_class);
        }

        label.set_margin_start (margin_start);
        label.set_margin_end (margin_end);
        label.set_margin_top (margin_top);
        label.set_margin_bottom (margin_bottom);
    
        return label;
    }

    void check_file_permissions () {
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

    void on_mangohud_global_button_clicked () {
        bool success = false;

        if (mangohud_global_enabled) {
            try {
                Process.spawn_command_line_sync ("pkexec sed -i '/MANGOHUD=1/d' /etc/environment");
                string file_contents;
                FileUtils.get_contents ("/etc/environment", out file_contents);
                if (!file_contents.contains ("MANGOHUD=1")) {
                    success = true;
                    mangohud_global_enabled = false;
                    mangohud_global_button.remove_css_class ("suggested-action");
                }
            } catch (Error e) {
                stderr.printf ("Error deleting MANGOHUD from /etc/environment: %s\n", e.message);
            }
        } else {
            try {
                Process.spawn_command_line_sync ("pkexec sh -c 'echo \"MANGOHUD=1\" >> /etc/environment'");
                string file_contents;
                FileUtils.get_contents ("/etc/environment", out file_contents);
                if (file_contents.contains ("MANGOHUD=1")) {
                    success = true;
                    mangohud_global_enabled = true;
                    mangohud_global_button.add_css_class ("suggested-action");
                }
            } catch (Error e) {
                stderr.printf ("Error adding MANGOHUD to /etc/environment: %s\n", e.message);
            }
        }

        if (success) {
            check_mangohud_global_status ();
            show_restart_warning ();
        } else {
            stderr.printf ("Failed to modify /etc/environment.\n");
        }
    }

    void set_preset(int preset_value) {
        if (preset_value < -1 || preset_value > 5) {
            stderr.printf("Invalid preset value: %d. Allowed range is -1 to 5.\n", preset_value);
            return;
        }

        var file = File.new_for_path(Environment.get_home_dir()).get_child(".config").get_child("MangoHud").get_child("MangoHud.conf");
    
        try {
            if (!file.get_parent().query_exists()) file.get_parent().make_directory_with_parents();
            var output_stream = new DataOutputStream(file.replace(null, false, FileCreateFlags.NONE));
            output_stream.put_string("preset=%d\n".printf(preset_value));
            stdout.printf("Preset set to %d in MangoHud.conf\n", preset_value);
        } catch (Error e) {
            stderr.printf("Error: %s\n", e.message);
        }
    }

    void show_restart_warning () {
        var dialog = new Adw.AlertDialog (
            _("Warning"),
            _("The changes will take effect only after the system is restarted.")
        );
        dialog.add_response ("ok", _("OK"));
        dialog.add_response ("restart", _("Restart"));
    
        dialog.set_default_response ("ok");
        dialog.set_response_appearance ("restart", Adw.ResponseAppearance.SUGGESTED);
        dialog.present (this.active_window);
    
        dialog.response.connect ((response) => {
            if (response == "restart") {
                try {
                    Process.spawn_command_line_sync ("reboot");
                } catch (Error e) {
                    stderr.printf (_("Error when restarting the system: %s\n"), e.message);
                }
            }
            dialog.destroy ();
        }); 
    }

    void check_mangohud_global_status () {
        new Thread<void>("check-mangohud-status", () => {
            try {
                string[] argv = { "grep", "MANGOHUD=1", "/etc/environment" };
                int exit_status;
                string standard_output;
                string standard_error;
                Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

                bool enabled = (exit_status == 0);

                Idle.add(() => {
                    mangohud_global_enabled = enabled;
                    if (enabled) {
                        mangohud_global_button.add_css_class ("suggested-action");
                    } else {
                        mangohud_global_button.remove_css_class ("suggested-action");
                    }
                    return false;
                });
            } catch (Error e) {
                stderr.printf ("Error checking the MANGOHUD status: %s\n", e.message);
            }
        });
    }

    async void add_other_box_if_needed () {
        if (!is_flatpak () && yield check_vkbasalt_installed_async ()) {
            view_stack.add_titled (other_scrolled_window, "other_box", _("Other")).icon_name = "view-grid-symbolic";
        }
    }

    async bool check_vkbasalt_installed_async () {
        string[] paths = { "/usr/lib/libvkbasalt.so", "/usr/lib/x86_64-linux-gnu/libvkbasalt.so", "/usr/local/lib/libvkbasalt.so" };
        foreach (var path in paths) {
            if (FileUtils.test (path, FileTest.EXISTS)) {
                return true;
            }
        }
        return false;
    }

    void validate_numeric_entry (Entry entry, int min_value = int.MIN, int max_value = int.MAX) {
        entry.input_purpose = Gtk.InputPurpose.NUMBER;
        entry.set_max_length (4);
        entry.insert_text.connect ((new_text, new_text_length, ref position) => {
            foreach (var c in new_text.to_utf8 ()) {
                if (!c.isdigit () && c != '-') {
                    Signal.stop_emission_by_name (entry, "insert-text");
                    break;
                }
            }
        });
        entry.changed.connect (() => {
            string text = entry.text;
            bool is_valid = true;
            foreach (var c in text.to_utf8 ()) {
                if (!c.isdigit () && c != '-') {
                    is_valid = false;
                    break;
                }
            }
            if (is_valid) {
                int value = int.parse (text);
                if (value < min_value || value > max_value) {
                    is_valid = false;
                }
            }
            if (is_valid) {
                entry.remove_css_class ("error");
            } else {
                entry.add_css_class ("error");
            }
        });
    }

    public void on_about_button_clicked () {
        AboutDialog.show_about_dialog (this.active_window);
    }

    public string rgba_to_hex (Gdk.RGBA rgba) {
        return "%02x%02x%02x".printf ((int) (rgba.red * 255), (int) (rgba.green * 255), (int) (rgba.blue * 255));
    }

    bool is_flatpak () {
        return Environment.get_variable ("FLATPAK_ID") != null;
    }

    static int main (string[] args) {
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.textdomain ("mangojuice");
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.GNOMELOCALEDIR);
        Intl.bind_textdomain_codeset ("mangojuice", "UTF-8");

        var app = new MangoJuice ();
        return app.run (args);
    }
}