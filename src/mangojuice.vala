/* Mangojuice.vala // Licence:  GPL-v3.0 */
using Gtk;
using Adw;
using Gee;

public class MangoJuice : Adw.Application {
    // UI Elements
    public  OtherBox other_box;
    Button  reset_button;
    Button  logs_path_button;
    Button  intel_power_fix_button;
    public  Switch[] gpu_switches;
    public  Switch[] cpu_switches;
    public  Switch[] memory_switches;
    public  Switch[] git_switches;
    public  Switch[] system_switches;
    public  Switch[] wine_switches;
    public  Switch[] options_switches;
    public  Switch[] battery_switches;
    public  Switch[] other_extra_switches;
    public  Switch[] inform_switches;
    Label[] gpu_labels;
    Label[] cpu_labels;
    Label[] memory_labels;
    Label[] git_labels;
    Label[] system_labels;
    Label[] wine_labels;
    Label[] options_labels;
    Label[] battery_labels;
    Label[] other_extra_labels;
    Label[] inform_labels;
    public  Entry             custom_command_entry;
    public  Entry             custom_logs_path_entry;
    public  DropDown          logs_key_combo;
    public  DropDown          toggle_hud_key_combo;
    public  DropDown          fps_limit_method;
    public  DropDown          toggle_fps_limit;
    public  DropDown          vulkan_dropdown;
    public  DropDown          opengl_dropdown;
    public  Scale             duracion_scale;
    public  Scale             autostart_scale;
    public  Scale             interval_scale;
    public  Entry             duracion_entry;
    public  Entry             autostart_entry;
    public  Entry             interval_entry;
    public  Gtk.StringList    logs_key_model;
    public  DropDown          filter_dropdown;
    public  Scale             af;
    public  Scale             picmip;
    public  Entry             picmip_entry;
    public  Entry             af_entry;
    public  Entry             fps_sampling_period_entry;
    public  Entry             fps_limit_entry_1;
    public  Entry             fps_limit_entry_2;
    public  Entry             fps_limit_entry_3;
    public  Entry             custom_text_center_entry;
    public  Switch            custom_switch;
    public  Scale             borders_scale;
    public  Scale             alpha_scale;
    public  Entry             borders_entry;
    public  Entry             alpha_entry;
    public  Label             alpha_value_label;
    public  DropDown          position_dropdown;
    public  Scale             colums_scale;
    public  Entry             colums_entry;
    public  Entry             toggle_hud_entry;
    public  Scale             font_size_scale;
    public  Entry             font_size_entry;
    public  Button            font_button;
    public  Entry             gpu_text_entry;
    public  ColorDialogButton gpu_color_button;
    public  Entry             cpu_text_entry;
    public  ColorDialogButton cpu_color_button;
    public  Entry             fps_value_entry_1;
    public  Entry             fps_value_entry_2;
    public  ColorDialogButton fps_color_button_1;
    public  ColorDialogButton fps_color_button_2;
    public  ColorDialogButton fps_color_button_3;
    public  Entry             gpu_load_value_entry_1;
    public  Entry             gpu_load_value_entry_2;
    public  ColorDialogButton gpu_load_color_button_1;
    public  ColorDialogButton gpu_load_color_button_2;
    public  ColorDialogButton gpu_load_color_button_3;
    public  Entry             cpu_load_value_entry_1;
    public  Entry             cpu_load_value_entry_2;
    public  ColorDialogButton cpu_load_color_button_1;
    public  ColorDialogButton cpu_load_color_button_2;
    public  ColorDialogButton cpu_load_color_button_3;
    public  ColorDialogButton background_color_button;
    public  ColorDialogButton frametime_color_button;
    public  ColorDialogButton vram_color_button;
    public  ColorDialogButton ram_color_button;
    public  ColorDialogButton wine_color_button;
    public  ColorDialogButton engine_color_button;
    public  ColorDialogButton text_color_button;
    public  ColorDialogButton media_player_color_button;
    public  ColorDialogButton network_color_button;
    public  ColorDialogButton battery_color_button;
    public  Entry             blacklist_entry;
    public  Entry             gpu_entry;
    public  Scale             offset_x_scale;
    public  Scale             offset_y_scale;
    public  Label             offset_x_value_label;
    public  Label             offset_y_value_label;
    public  Entry             offset_x_entry;
    public  Entry             offset_y_entry;
    public  Scale             fps_sampling_period_scale;
    public  Label             fps_sampling_period_value_label;
    public  Button            mangohud_global_button;
    public  Gee.ArrayList<DropDown> media_format_dropdowns { get; private set; }

    bool        mangohud_global_enabled = false;
    public bool is_loading              = false;

    ScrolledWindow  other_scrolled_window;
    ViewStack       view_stack;

    // Constants
    const string GPU_TITLE               = _("GPU");
    const string CPU_TITLE               = _("CPU");
    const string MEMORY_TITLE            = _("Memory");
    const string GIT_TITLE               = _("Git");
    const string OTHER_TITLE             = _("Other");
    const string SYSTEM_TITLE            = _("System");
    const string WINE_TITLE              = _("Wine");
    const string OPTIONS_TITLE           = _("Options");
    const string BATTERY_TITLE           = _("Battery");
    const string INFORM_TITLE            = _("Information");
    const int    MAIN_BOX_SPACING        = 12;
    const int    FLOW_BOX_ROW_SPACING    = 12;
    const int    FLOW_BOX_COLUMN_SPACING = 12;
    const int    FLOW_BOX_MARGIN         = 12;

    // Configuration Variables
    public string[] gpu_config_vars = {
        "gpu_stats", "gpu_load_change", "vram", "gpu_core_clock", "gpu_mem_clock",
        "gpu_temp", "gpu_mem_temp", "gpu_junction_temp", "gpu_fan", "gpu_name",
        "gpu_power", "gpu_voltage", "throttling_status", "throttling_status_graph", "engine_version"
    };
    public string[] cpu_config_vars = {
        "cpu_stats", "cpu_load_change", "core_load", "core_bars", "cpu_mhz", "cpu_temp",
        "cpu_power", "core_type"
    };
    public string[] memory_config_vars = {
        "ram", "io_read \n io_write", "procmem", "swap"
    };
    public string[] git_config_vars = {
        "gpu_efficiency", "flip_efficiency", "hide_fsr_sharpness"
    };
    public string[] system_config_vars = {
        "refresh_rate", "fan", "resolution", "display_server", "engine_short_names", "time", "arch", "network"
    };
    public string[] wine_config_vars = {
        "wine", "winesync"
    };
    public string[] battery_config_vars = {
        "battery", "battery_watt", "battery_time", "device_battery_icon", "device_battery=gamepad,mouse"
    };
    public string[] other_extra_config_vars = {
        "media_player", "full", "log_versioning", "upload_logs"
    };
    public string[] inform_config_vars = {
        "fps", "fps_color_change", "fps_metrics=avg,0.01", "fps_metrics=avg,0.001", "show_fps_limit", "frame_timing", "frame_timing_detailed", "histogram", "frame_count", "temp_fahrenheit", "present_mode"
    };
    public string[] options_config_vars = {
        "version", "gamemode", "vkbasalt", "exec_name", "fcat", "fsr", "hdr", "hud_compact", "no_display", "text_outline=0", "no_small_font", "hud_no_margin"
    };

    /*
     * Labels
     */

    // Metrics
    string[] gpu_label_texts = {
        _("Load GPU"),         _("Color load"),       _("VRAM"),               _("Core frequency"),
        _("Memory frequency"), _("Temperature"),      _("Memory temperature"), _("Max temperature"),
        _("Fans"),             _("Model"),            _("Power"),              _("Voltage"),
        _("Throttling"),       _("Throttling graph"), _("Vulkan Driver")
    };
    string[] cpu_label_texts = {
        _("Load CPU"),          _("Color load"),  _("Load per core"), _("Diagram"),
        _("Maximum frequency"), _("Temperature"), _("Power"),  _("Core type")
    };
    string[] memory_label_texts = {
        _("RAM"),             _("Disk"),
        _("Resident memory"), _("Swap")
    };

    string[] git_label_texts = {
        _("GPU efficiency (F/J)"),             _("GPU energy (J/F)"),
        _("Hide FSR sharpness")
    };

    // Extras
    string[] system_label_texts = {
        _("Refresh rate"), _("Fan"),   _("Resolution"),   _("Session type"),
        _("Compact API"),  _("Watch"), _("Architecture"), _("Network")
    };
    string[] options_label_texts = {
        _("HUD Version"), _("Gamemode"),       _("vkBasalt"),           _("Exe name"),
        _("Fcat"),        _("FSR"),            _("HDR"),                _("Remove paddings"),
        _("Hide HUD"),    _("Remove shadows"), _("Font normalization"), _("Remove margins")
    };
    string[] battery_label_texts = {
        _("Battery charge"), _("Battery power"),  _("Time remain"),
        _("Battery icon"),   _("Other batteries")
    };
    string[] wine_label_texts = {
        _("Version"), _("Winesync")
    };
    string[] other_extra_label_texts = {
        _("Media"),    _("Full ON"),
        _("Full log"), _("Upload logs")
    };

    // Performance
    string[] inform_label_texts = {
        _("FPS"),           _("Color FPS"),   _("Lowest 1%"),
        _("Lowest 0.1%"),   _("Frame limit"), _("Frame graph"), _("Detailed Frametime") , _("Histogram"),
        _("Frame Counter"), _("°C to °F"),    _("VPS")
    };

    /*
     * Descriptions
     */

    // Metrics
    string[] gpu_label_texts_2 = {
        _("Percentage load"),    _("Color text"),      _("Amount of video memory"), _("Frequency, MHz"),
        _("Frequency, MHz"),     _("GPU temperature"), _("GDDR temperature"),       _("Temperature peak"),
        _("Speed, RPM"),     _("GPU name"),        _("Consumption, W" ),        _("Consumption, V"),
        _("Trolling parametrs"), _("Curve"),           _("Driver Version")
    };
    string[] cpu_label_texts_2 = {
        _("Percentage load"),      _("Color text"),      _("All cores"),     _("Load per core"),
        _("Peak among all cores"), _("CPU temperature"), _("Consumption, W"), _("For new Intel and ARM")
    };
    string[] memory_label_texts_2 = {
        _("Size, GiB"), _("Input/Output, MiB/s"),
        _("Size, GiB"), _("Size, GiB")
    };

    string[] git_label_texts_2 = {
        _("GPU"), _("GPU"),
        _("Gamescope")
    };

    // Extras
    string[] system_label_texts_2 = {
        _("Gamescope only"),    _("Steam Deck only"), _("Window size"),    _("X11/Wayland"),
        _("Shortens the name"), _("Current time"),    _("Processor base"), _("Adapters speed")
    };
    string[] options_label_texts_2 = {
        _("MangoHud version"),       _("Gamemode state"),     _("vkBasalt state"), _("Proccess name"),
        _("Updating visualization"), _("Gamescope only"),     _("Gamescope only"), _("Internal offsets"),
        _("Hide overlay"),           _("Shadows under text"), _("Same font size"), _("External offsets")
    };
    string[] battery_label_texts_2 = {
        _("Power level, %"),  _("Consumption, W"), _("Battery life"),
        _("Wireless devices"), _("Wireless battries")
    };
    string[] wine_label_texts_2 = {
        _("Wine or Proton version"), _("Wine sync method")
    };
    string[] other_extra_label_texts_2 = {
        _("Current playback"), _("All but histograms"),
        _("Log information"),  _("flightlessmango.com")
    };

    // Performance
    string[] inform_label_texts_2 = {
        _("Frames per second"),   _("Color text"),        _("1% is lower then"),
        _("0.1% is lower then"),  _("FPS limitation"),    _("Frametime"),           _("Detailed frame time"),  _("Graph to histogram"),
        _("Display frame count"), _("Temperature in °F"), _("Present mode")
    };

    // Vulkan and OpenGL Values
    public string[] vulkan_values = { "Unset", "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] vulkan_config_values = { "", "0", "1", "3", "2" };
    public string[] opengl_values = { "Unset", "Adaptive", "OFF", "ON", "Mailbox" };
    public string[] opengl_config_values = { "", "-1", "0", "1", "n" };


    // Other Variables
    bool test_button_pressed = false;
    public ResetManager reset_manager;
    public Gee.ArrayList<Label> label_pool = new Gee.ArrayList<Label> ();
    public Gtk.StringList toggle_hud_key_model;

    public MangoJuice () {
        Object (application_id: "io.github.radiolamp.mangojuice", flags: ApplicationFlags.DEFAULT_FLAGS);
    
        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect (() => {
            this.quit ();
        });
        this.add_action (quit_action);
        const string[] quit_accels = { "<Control>Q", null };
        this.set_accels_for_action ("app.quit", quit_accels);
    
        var test_action_new = new SimpleAction ("test_new", null);
        test_action_new.activate.connect (run_test);
        this.add_action (test_action_new);
        const string[] test_new_accels = { "<Primary>T", null };
        this.set_accels_for_action ("app.test_new", test_new_accels);
    
        var restore_config_action = new SimpleAction ("restore_config", null);
        restore_config_action.activate.connect (() => {
            on_restore_config_button_clicked ();
        });
        this.add_action (restore_config_action);
        const string[] restore_config_accels = { "<Primary>R", null };
        this.set_accels_for_action ("app.restore_config", restore_config_accels);
    
        var save_action = new SimpleAction ("save", null);
        save_action.activate.connect (() => {
            save_config ();
        });
        this.add_action (save_action);
        const string[] save_accels = { "<Primary>S", null };
        this.set_accels_for_action ("app.save", save_accels);
    
        var save_as_action = new SimpleAction ("save_as", null);
        save_as_action.activate.connect (() => {
            on_save_as_button_clicked ();
        });
        this.add_action (save_as_action);
        const string[] save_as_accels = { "<Primary>E", null };
        this.set_accels_for_action ("app.save_as", save_as_accels);
    }

    protected override void activate () {
        var window = new Adw.ApplicationWindow (this);
        window.set_default_size (1024, 700);
        window.set_title ("MangoJuice");

        if (Config.IS_DEVEL) {
            window.add_css_class ("devel");
        }

        var toast_overlay = new Adw.ToastOverlay ();
        var content_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        toast_overlay.set_child (content_box);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, MAIN_BOX_SPACING);
        main_box.set_homogeneous (true);

        view_stack = new Adw.ViewStack ();

        var toolbar_view_switcher = new Adw.ViewSwitcher ();
        toolbar_view_switcher.stack = view_stack;
        toolbar_view_switcher.policy = Adw.ViewSwitcherPolicy.WIDE;

        var bottom_headerbar = new Gtk.HeaderBar ();
        bottom_headerbar.show_title_buttons = false;

        var bottom_view_switcher = new Adw.ViewSwitcher ();
        bottom_view_switcher.stack = view_stack;

        var center_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        center_box.set_halign (Gtk.Align.CENTER);
        center_box.append (bottom_view_switcher);
        bottom_headerbar.set_title_widget (center_box);
    
        bottom_headerbar.set_visible (false);

        var breakpoint_800px = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 800px"));
        var breakpoint_550px = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 550px"));
    
        breakpoint_800px.add_setter (toolbar_view_switcher, "policy", Adw.ViewSwitcherPolicy.NARROW);
        breakpoint_550px.add_setter (toolbar_view_switcher, "policy", Adw.ViewSwitcherPolicy.NARROW);
        breakpoint_550px.add_setter (bottom_headerbar, "visible", true);
        breakpoint_550px.add_setter (toolbar_view_switcher, "visible", false);
    
        window.add_breakpoint (breakpoint_800px);
        window.add_breakpoint (breakpoint_550px);

        var metrics_box = new Gtk.Box (Gtk.Orientation.VERTICAL, MAIN_BOX_SPACING);
        var extras_box = new Gtk.Box (Gtk.Orientation.VERTICAL, MAIN_BOX_SPACING);
        var performance_box = new Gtk.Box (Gtk.Orientation.VERTICAL, MAIN_BOX_SPACING);
        var visual_box = new Gtk.Box (Gtk.Orientation.VERTICAL, MAIN_BOX_SPACING);
        var other_box = new OtherBox ();

        initialize_switches_and_labels (metrics_box, extras_box, performance_box, visual_box);
        initialize_custom_controls (extras_box, visual_box);

        var metrics_scrolled_window = new Gtk.ScrolledWindow ();
        metrics_scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        metrics_scrolled_window.set_vexpand (true);
        metrics_scrolled_window.set_child (metrics_box);
    
        var extras_scrolled_window = new Gtk.ScrolledWindow ();
        extras_scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        extras_scrolled_window.set_vexpand (true);
        extras_scrolled_window.set_child (extras_box);
    
        var performance_scrolled_window = new Gtk.ScrolledWindow ();
        performance_scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        performance_scrolled_window.set_vexpand (true);
        performance_scrolled_window.set_child (performance_box);
    
        var visual_scrolled_window = new Gtk.ScrolledWindow ();
        visual_scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        visual_scrolled_window.set_vexpand (true);
        visual_scrolled_window.set_child (visual_box);
    
        other_scrolled_window = new Gtk.ScrolledWindow ();
        other_scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
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

        var test_button = new Gtk.Button.with_label (_("Test"));
        test_button.clicked.connect (run_test);
        header_bar.pack_start (test_button);

        var menu_button = new Gtk.MenuButton ();
        var menu_model = new GLib.Menu ();
        var save_item = new GLib.MenuItem (_("Save"), "app.save");
        menu_model.append_item (save_item);
        var save_as_item = new GLib.MenuItem (_("Save As"), "app.save_as");
        menu_model.append_item (save_as_item);
        var restore_config_item = new GLib.MenuItem (_("Restore"), "app.restore_config");
        menu_model.append_item (restore_config_item);
        var advanced_item = new GLib.MenuItem (_("Change order"), "app.advanced");
        menu_model.append_item (advanced_item);
        var about_item = new GLib.MenuItem (_("About"), "app.about");
        menu_model.append_item (about_item);
        menu_button.set_menu_model (menu_model);
        menu_button.set_icon_name ("open-menu-symbolic");
        header_bar.pack_end (menu_button);

        var heart_button = new Gtk.Button ();
        heart_button.set_icon_name ("io.github.radiolamp.mangojuice.donate-symbolic");
        heart_button.set_tooltip_text (_("Donate"));
    
        var motion_controller = new Gtk.EventControllerMotion ();
        motion_controller.enter.connect (() => {
            heart_button.add_css_class ("pink-on-hover");
        });
        motion_controller.leave.connect (() => {
            heart_button.remove_css_class ("pink-on-hover");
        });
        heart_button.add_controller (motion_controller);
        heart_button.clicked.connect (() => {
            try {
                Process.spawn_async (null, {"xdg-open", "https://radiolamp.github.io/mangojuice-donate/"}, null, SpawnFlags.SEARCH_PATH, null, null);
            } catch (Error e) {
                stderr.printf ("Error when opening the site: %s\n", e.message);
            }
        });
        header_bar.pack_end (heart_button);

        var save_action = new GLib.SimpleAction ("save", null);
        save_action.activate.connect (() => {
            save_config ();
            if (test_button_pressed) {
                if (is_vkcube_available ()) {
                    restart_vkcube ();
                } else if (is_glxgears_available ()) {
                    restart_glxgears ();
                }
            }
        });
        this.add_action (save_action);

        content_box.append (header_bar);
        content_box.append (view_stack);
        content_box.append (bottom_headerbar);
    
        window.set_content (toast_overlay);
        window.present ();
    
        Idle.add (() => {
            bool mangohud_available = is_mangohud_available ();
            bool vkcube_available = is_vkcube_available ();
            bool glxgears_available = is_glxgears_available ();
        
            if (!mangohud_available && is_flatpak()) {
                show_mangohud_install_dialog(window, test_button);
            }

            if (!mangohud_available && !is_flatpak ()) {
                stderr.printf (_("MangoHud not found. Please install MangoHud to enable full functionality.\n"));
                var toast_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
                var toast_label = new Gtk.Label(_("MangoHud is not installed. Please install it."));
                toast_label.set_ellipsize(Pango.EllipsizeMode.END);
                toast_label.set_halign(Gtk.Align.START);
                var install_button = new Gtk.Button.with_label(_("Install"));
                
                toast_box.append(toast_label);
                toast_box.append(install_button);
                
                var toast = new Adw.Toast("");
                toast.set_custom_title(toast_box);
                toast.set_timeout(0);
                
                bool appstream_available = check_appstream_available();
                install_button.visible = appstream_available;
                
                if (appstream_available) {
                    install_button.clicked.connect(() => {
                        try {
                            Process.spawn_command_line_async("xdg-open appstream://io.github.flightlessmango.mangohud");
                            toast.dismiss();
                        } catch (Error e) {
                            var error_toast = new Adw.Toast(_("Failed to launch AppStream: %s").printf(e.message));
                            error_toast.timeout = 15;
                            toast_overlay.add_toast(error_toast);
                        }
                    });
                }
                toast.dismissed.connect(() => {
                    if (mangohud_available || (vkcube_available && glxgears_available)) {
                        test_button?.set_visible(true);
                    }
                });
                toast_overlay.add_toast(toast);
            }
    
            if (!mangohud_available || (!vkcube_available && !glxgears_available)) {
                test_button?.set_visible (false);
                if (!vkcube_available && !glxgears_available) {
                    stderr.printf (_("vkcube not found. If you want a test button, install vulkan-tools.\n") +
                                  _("glxgears not found. If you want a test button, install mesa-utils.\n"));
    
                    var toast = new Adw.Toast (_("Vkcube and glxgears not found. Install vulkan-tools and mesa-utils to enable the test button."));
                    toast.set_timeout (15);
                    toast.dismissed.connect(() => {
                        if (mangohud_available || (vkcube_available && glxgears_available)) {
                            test_button?.set_visible(true);
                        }
                    });
                    toast_overlay.add_toast (toast);
                }
            }
    
            var advanced_action = new GLib.SimpleAction ("advanced", null);
            advanced_action.activate.connect (() => {
                var advanced_dialog = new AdvancedDialog (window);
                int max_width = 800;
                int max_height = 600;
                int new_width = (int) (window.get_width () * 0.6);
                int new_height = (int) (window.get_height () * 0.8);
                if (new_width > max_width) new_width = max_width;
                if (new_height > max_height) new_height = max_height;
                advanced_dialog.set_size_request (new_width, new_height);
                window.notify["default-width"].connect (() => {
                    int updated_width = (int) (window.get_width () * 0.6);
                    int updated_height = (int) (window.get_height () * 0.8);
    
                    if (updated_width > max_width) updated_width = max_width;
                    if (updated_height > max_height) updated_height = max_height;
                    advanced_dialog.set_size_request (updated_width, updated_height);
                });
                window.notify["default-height"].connect (() => {
                    int updated_width = (int) (window.get_width () * 0.6);
                    int updated_height = (int) (window.get_height () * 0.8);
    
                    if (updated_width > max_width) updated_width = max_width;
                    if (updated_height > max_height) updated_height = max_height;
                    advanced_dialog.set_size_request (updated_width, updated_height);
                });
                advanced_dialog.present (window);
            });
            this.add_action (advanced_action);
    
            reset_manager = new ResetManager (this);
            initialize_rest_of_ui (view_stack);
            check_mangohud_global_status ();
            return false;
        });
    
        LoadStates.load_states_from_file.begin (this);
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
        inform_switches[7].notify["active"].connect (() => {
            if (inform_switches[7].active) inform_switches[5].active = true;
        });
        inform_switches[5].notify["active"].connect (() => {
            if (!inform_switches[5].active) inform_switches[7].active = false;
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
            Process.spawn_command_line_sync ("pkill vkcube");
            Process.spawn_command_line_sync ("pkill glxgears");
        } catch (Error e) {
            stderr.printf (_("Error closing test apps: %s\n"), e.message);
        }

        base.shutdown ();
    }

    public void add_value_changed_handler (Scale scale) {
        scale.value_changed.connect (() => {
            save_config ();
        });
    }

    public void initialize_switches_and_labels (Box metrics_box, Box extras_box, Box performance_box, Box visual_box) {
        gpu_switches = new Switch[gpu_config_vars.length];
        cpu_switches = new Switch[cpu_config_vars.length];
        memory_switches = new Switch[memory_config_vars.length];
        system_switches = new Switch[system_config_vars.length];
        wine_switches = new Switch[wine_config_vars.length];
        options_switches = new Switch[options_config_vars.length];
        battery_switches = new Switch[battery_config_vars.length];
        other_extra_switches = new Switch[other_extra_config_vars.length];
        inform_switches = new Switch[inform_config_vars.length];

        gpu_labels = new Label[gpu_label_texts.length];
        cpu_labels = new Label[cpu_label_texts.length];
        memory_labels = new Label[memory_label_texts.length];
        system_labels = new Label[system_label_texts.length];
        wine_labels = new Label[wine_label_texts.length];
        options_labels = new Label[options_label_texts.length];
        battery_labels = new Label[battery_label_texts.length];
        other_extra_labels = new Label[other_extra_label_texts.length];
        inform_labels = new Label[inform_label_texts.length];

        create_switches_and_labels (metrics_box, GPU_TITLE, gpu_switches, gpu_labels, gpu_config_vars, gpu_label_texts, gpu_label_texts_2);
        create_switches_and_labels (metrics_box, CPU_TITLE, cpu_switches, cpu_labels, cpu_config_vars, cpu_label_texts, cpu_label_texts_2);
        create_switches_and_labels (metrics_box, MEMORY_TITLE, memory_switches, memory_labels, memory_config_vars, memory_label_texts, memory_label_texts_2);
        create_switches_and_labels (extras_box, SYSTEM_TITLE, system_switches, system_labels, system_config_vars, system_label_texts, system_label_texts_2);
        create_switches_and_labels (extras_box, OPTIONS_TITLE, options_switches, options_labels, options_config_vars, options_label_texts, options_label_texts_2);
        create_switches_and_labels (extras_box, BATTERY_TITLE, battery_switches, battery_labels, battery_config_vars, battery_label_texts, battery_label_texts_2);
        create_switches_and_labels (extras_box, WINE_TITLE, wine_switches, wine_labels, wine_config_vars, wine_label_texts, wine_label_texts_2);
        create_switches_and_labels (extras_box, OTHER_TITLE, other_extra_switches, other_extra_labels, other_extra_config_vars, other_extra_label_texts, other_extra_label_texts_2);
        create_scales_and_labels (extras_box);
        create_switches_and_labels (performance_box, INFORM_TITLE, inform_switches, inform_labels, inform_config_vars, inform_label_texts, inform_label_texts_2);
        create_limiters_and_filters (performance_box);
        add_switch_handler (gpu_switches);
        add_switch_handler (cpu_switches);
        add_switch_handler (memory_switches);
        add_switch_handler (system_switches);
        add_switch_handler (options_switches);
        add_switch_handler (battery_switches);
        add_switch_handler (wine_switches);
        add_switch_handler (other_extra_switches);
        add_switch_handler (inform_switches);

        if (Config.IS_DEVEL) {
            git_switches = new Switch[git_config_vars.length];
            git_labels = new Label[git_label_texts.length];
            create_switches_and_labels (metrics_box, GIT_TITLE, git_switches, git_labels, git_config_vars, git_label_texts, git_label_texts_2);
            add_switch_handler (git_switches);
        }

        initialize_gpu_entry (extras_box);

        bool updating = false;

        for (int i = 0; i < gpu_switches.length; i++) {
            int index = i;
            gpu_switches[i].notify["active"].connect (() => {
                if (updating) return;
                updating = true;

                if (index == 0 && !gpu_switches[0].active) {
                    for (int j = 0; j < gpu_switches.length; j++) {
                        if (j != 2 && j != 14) {
                            gpu_switches[j].active = false;
                        }
                    }
                }

                update_gpu_stats_state ();
                updating = false;
            });
        }

        for (int i = 0; i < cpu_switches.length; i++) {
            int index = i;
            cpu_switches[i].notify["active"].connect (() => {
                if (updating) return;
                updating = true;

                if (index == 0 && !cpu_switches[0].active) {
                    for (int j = 0; j < cpu_switches.length; j++) {
                        if (j != 2 && j != 3) {
                            cpu_switches[j].active = false;
                        }
                    }
                }

                update_cpu_stats_state ();
                updating = false;
            });
        }
    }

    void add_switch_handler (Switch[] switches) {
        for (int i = 0; i < switches.length; i++) {
            switches[i].notify["active"].connect (() => {
                new Thread<void> ("save-config", () => {
                    save_config ();
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
        var custom_command_box = create_entry_with_clear_button (custom_command_entry, _("MangoHud variable"), "");
        custom_command_entry.changed.connect (() => {
            save_config ();
        });

        custom_logs_path_entry = new Entry ();
        var custom_logs_path_box = create_entry_with_clear_button (custom_logs_path_entry, _("Home"), "");
        custom_logs_path_entry.changed.connect (() => {
            save_config ();
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
            on_intel_power_fix_button_clicked.begin(intel_power_fix_button);
        });
        check_file_permissions_async.begin (intel_power_fix_button);
        restart_vkcube_or_glxgears ();

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
            delete_vkbasalt_conf ();
            delete_mangohud_backup ();
            reset_manager.reset_all_widgets ();
        });

        blacklist_entry = new Entry ();
        var blacklist_box = create_entry_with_clear_button (blacklist_entry, _("Blacklist: (vkcube, WatchDogs2.exe)"), "");
        blacklist_entry.changed.connect (() => {
            SaveStates.update_blacklist_in_file (blacklist_entry.text);
            save_config ();
        });

            mangohud_global_button = new Button.with_label (_("MangoHud Global"));
            mangohud_global_button.clicked.connect (on_mangohud_global_button_clicked);
        if (!is_flatpak ()) {
            blacklist_box.append (mangohud_global_button);
        }

        var blacklist_flow_box = new FlowBox () {
            max_children_per_line = 1,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
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
            save_config ();
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

        var button1 = new Button.with_label (_("Only FPS"));
        button1.set_size_request (160, -1);
        button1.clicked.connect (() => {
            string[] profile1_vars = { "fps_only", "background_alpha=0" };
            set_preset (profile1_vars);
            LoadStates.load_states_from_file.begin (this);
            reset_manager.reset_all_widgets ();
        });

        var button2 = new Button.with_label (_("Horizontal"));
        button2.clicked.connect (() => {
            string[] profile2_vars = {"horizontal", "horizontal_stretch=0" , "gpu_stats", "position=top-center",
            "gpu_load_change" ,"cpu_stats" , "cpu_load_change" , "ram", "fps", "fps_color_change" , "round_corners=8" };
            set_preset (profile2_vars);
            LoadStates.load_states_from_file.begin (this);
            reset_manager.reset_all_widgets ();
        });

        var button3 = new Button.with_label (_("Full"));
        button3.clicked.connect (() => {
            string[] profile3_vars = { "hud_compact", "gpu_stats", "gpu_load_change", "gpu_voltage", "throttling_status",
            "gpu_core_clock", "gpu_mem_clock", "gpu_temp", "gpu_mem_temp", "gpu_junction_temp", "gpu_fan", "gpu_power", "cpu_stats", "core_load",
            "cpu_load_change", "cpu_mhz", "cpu_temp", "cpu_power", "io_stats", "io_read", "io_write", "swap", "vram", "ram", "procmem", "battery",
            "battery_watt", "battery_time", "fps", "fps_metrics=avg,0.01", "engine_version", "gpu_name", "vulkan_driver", "arch", "wine",
            "frame_timing", "throttling_status_graph", "frame_count", "fps_limit_method=late", "show_fps_limit", "fps_limit=0", "resolution",
            "fsr", "hdr", "winesync", "present_mode", "refresh_rate", "gamemode", "vkbasalt", "device_battery=gamepad,mouse", "device_battery_icon",
            "exec=lsb_release -a | grep Release | uniq | cut -c 10-26", "custom_text=Kernel", "exec=uname -r", "custom_text=Session:",
            "display_server", "fps_color_change", "time#", "version", "media_player", "media_player_color=FFFF00" };
            set_preset (profile3_vars);
            LoadStates.load_states_from_file.begin (this);
            reset_manager.reset_all_widgets ();
        });

        var button4 = new Button.with_label(_("Restore profile"));
        button4.clicked.connect (() => {
            try {
                var backup_file = File.new_for_path (Environment.get_home_dir())
                                      .get_child (".config")
                                      .get_child ("MangoHud")
                                      .get_child (".MangoHud.backup");
                restore_config_from_file(backup_file.get_path ());
                backup_file.delete();
            } catch (Error e) {
                stderr.printf ("Error: %s\n", e.message);
            }
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

        var custom_switch_label = new Label (_("Horizontal HUD")) {
            halign = Align.START,
            hexpand = true
        };
        custom_switch = new Switch () {
            valign = Align.CENTER
        };
        custom_switch.notify["active"].connect (() => {
            save_config ();
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
            save_config ();
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

        var attrs = new Pango.AttrList ();
        attrs.insert (Pango.attr_weight_new (Pango.Weight.BOLD));

        toggle_hud_entry.attributes = attrs;

        toggle_hud_entry.set_size_request (20, -1);
        toggle_hud_entry.changed.connect (() => {
            SaveStates.update_toggle_hud_in_file (toggle_hud_entry.text);
            save_config ();
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

        toggle_hud_key_model = new Gtk.StringList (null);
        foreach (var item in new string[] { "Shift_R+F11", "Shift_R+F10", "Shift_R+F9", "Shift_R+F8" }) {
            toggle_hud_key_model.append (item);
        }

        toggle_hud_key_combo = new DropDown (toggle_hud_key_model, null) {
            hexpand = true
        };

        toggle_hud_key_combo.notify["selected-item"].connect (() => {
            SaveStates.update_toggle_hud_key_in_file ((toggle_hud_key_combo.selected_item as StringObject)?.get_string () ?? "");
            save_config ();
        });

        var toggle_position_label = new Label (_("Toggle position")) {
            halign = Align.START
        };

        var toggle_position_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        toggle_position_pair.append (toggle_position_label);
        toggle_position_pair.append (toggle_hud_key_combo);

        combined_flow_box.insert (toggle_position_pair, -1);

        var offset_x_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        offset_x_pair.append (offset_x_widget.widget);
        combined_flow_box.insert (offset_x_pair, -1);

        var offset_y_pair = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
        offset_y_pair.append (offset_y_widget.widget);
        combined_flow_box.insert (offset_y_pair, -1);

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

        var fonts_flow_box = new FlowBox () {
            row_spacing = FLOW_BOX_ROW_SPACING,
            column_spacing = FLOW_BOX_COLUMN_SPACING,
            max_children_per_line = 2,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var font_selector_widget = new Box(Orientation.HORIZONTAL, 0);
        initialize_font_selector(font_selector_widget);

        fonts_flow_box.insert (font_selector_widget, -1);
        fonts_flow_box.insert (font_size_widget.widget, -1);
        
        visual_box.append (fonts_flow_box);

        var media_label = create_label (_("Media"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        visual_box.append (media_label);
        
        var format_options = new Gtk.StringList (null);
        string[] options = { "title", "artist", "album", "none" };
        foreach (var option in options) {
            format_options.append (option);
        }
        
        media_format_dropdowns = new Gee.ArrayList<DropDown>();

        for (int i = 0; i < 3; i++) {
            var dropdown = new DropDown (format_options, null) {
                hexpand = true,
                selected = i < options.length - 1 ? i : 0
            };
            dropdown.notify["selected"].connect (() => {
                var values = new string[3];
                for (int j = 0; j < 3 && j < media_format_dropdowns.size; j++) {
                    values[j] = (media_format_dropdowns.get(j).selected_item as StringObject)?.get_string() ?? "";
                }

                string media_format = "{%s};{%s};{%s}".printf(values[0], values[1], values[2]);
                SaveStates.update_media_player_format_in_file(media_format);
                save_config();
            });
            
            media_format_dropdowns.add(dropdown);
        }
        
        var media_flow_box = new FlowBox () {
            max_children_per_line = 3,
            margin_start = FLOW_BOX_MARGIN,
            margin_end = FLOW_BOX_MARGIN,
            margin_top = FLOW_BOX_MARGIN,
            margin_bottom = FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE,
            hexpand = true,
            homogeneous = true
        };

        foreach (var dropdown in media_format_dropdowns) {
            media_flow_box.insert (dropdown, -1);
        }
        
        visual_box.append (media_flow_box);

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
            save_config ();
        });

        cpu_text_entry = new Entry ();
        var cpu_text_entry_box = create_entry_with_clear_button (cpu_text_entry, _("CPU custom name"), "");
        cpu_text_entry.changed.connect (() => {
            SaveStates.update_cpu_text_in_file (cpu_text_entry.text);
            save_config ();
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

        var gpu_load_clarge_label = create_label (_("GPU level colors"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
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

        var cpu_load_clarge_label = create_label (_("CPU level colors"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
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

        battery_color_button = new ColorDialogButton (color_dialog);
        var default_battery_color = Gdk.RGBA ();
        default_battery_color.parse ("#92e79a");
        battery_color_button.set_rgba (default_battery_color);
        battery_color_button.notify["rgba"].connect ( () => {
            var rgba = battery_color_button.get_rgba ().copy ();
            SaveStates.update_battery_color_in_file (rgba_to_hex (rgba));
        });

        ColorDialogButton[] color_buttons = { background_color_button, frametime_color_button, vram_color_button, ram_color_button, wine_color_button, engine_color_button, media_player_color_button, network_color_button, text_color_button, battery_color_button };
        string[] color_labels = { _("Background"), _("Frametime"), _("VRAM"), _("RAM"), _("Wine"), _("Engine"), _("Media"), _("Network"), _("Text"), _("Battery") };

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

    void initialize_font_selector(Box visual_box) {
        this.font_button = new Button.with_label(_("Default"));
        font_button.set_tooltip_text(_("If you are going to play through Wine, then you need to select fonts from the home directory, the system fonts will not work."));
        font_button.set_hexpand(true);
        font_button.set_size_request(100, -1);

        var popover = new Popover();
        popover.set_autohide(true);
        popover.set_has_arrow(false);
        popover.set_parent(font_button);

        var popover_box = new Box(Orientation.VERTICAL, 5);
        popover_box.set_margin_top(5);
        popover_box.set_margin_bottom(5);
        popover_box.set_margin_start(5);
        popover_box.set_margin_end(5);
        popover.set_child(popover_box);

        var search_entry = new SearchEntry();
        search_entry.set_placeholder_text(_("Search font"));
        popover_box.append(search_entry);

        var scroll = new ScrolledWindow();
        scroll.set_policy(PolicyType.NEVER, PolicyType.AUTOMATIC);
        scroll.set_size_request(-1 , 300);
        popover_box.append(scroll);
    
        var list_box = new ListBox();
        scroll.set_child(list_box);

        var fonts = find_fonts();
        var font_items = new Gee.HashMap<string, string>();
    
        foreach (var font_path in fonts) {
            var font_name = Path.get_basename(font_path);
            font_items[font_name] = font_path;
        }

        var sorted_fonts = new Gee.ArrayList<string>();
        sorted_fonts.add_all(font_items.keys);
        sorted_fonts.sort((a, b) => a.collate(b));

        sorted_fonts.insert(0, _("Default"));

        search_entry.search_changed.connect(() => {
            while (list_box.get_first_child() != null) {
                list_box.remove(list_box.get_first_child());
            }

            foreach (var font_name in sorted_fonts) {
                if (search_entry.text == "" || font_name.down().contains(search_entry.text.down())) {
                    var row = new ListBoxRow();
                    var box = new Box(Orientation.HORIZONTAL, 5);
                    var label = new Label(font_name);
                    label.set_xalign(0);
                    label.set_hexpand(true);
    
                    var wine_label = new Label(_("Wine"));
                    wine_label.add_css_class("dim-label");
                    wine_label.set_visible(false);
                    wine_label.set_halign(Align.END);

                    if (font_name != _("Default") && font_items.has_key(font_name)) {
                        var font_path = font_items[font_name];
                        if (font_path.has_prefix(Environment.get_home_dir())) {
                            wine_label.set_visible(true);
                        }
                    }
    
                    box.append(label);
                    box.append(wine_label);
                    row.set_child(box);
                    list_box.append(row);
                }
            }
        });

        search_entry.search_changed();

        list_box.row_activated.connect((row) => {
            var box = row.get_child() as Box;
            var label = box.get_first_child() as Label;
            var font_name = label.label;
    
            if (font_name == _("Default")) {
                SaveStates.update_font_file_in_file("");
            } else if (font_items.has_key(font_name)) {
                SaveStates.update_font_file_in_file(font_items[font_name]);
            }
    
            font_button.label = font_name;
            popover.popdown();
            save_config();
        });

        font_button.clicked.connect(() => {
            popover.popup();
            search_entry.grab_focus();
        });

        visual_box.append(font_button);
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
                            if (regex.match (font_path) && !font_path.contains ("/run/host/user-fonts/")) {
                                fonts.add (font_path);
                            }
                        }
                    }
                }
            } else {
                stderr.printf (_("Error executing fc-list: %s\n"), standard_error);
            }
        } catch (Error e) {
            stderr.printf (_("Error when searching for fonts: %s\n"), e.message);
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
            text_box.set_size_request (175, -1);
    
            var label1 = new Label (null);
            label1.set_markup ("<b>%s</b>".printf (label_texts[i]));
            label1.set_halign (Align.START);
            label1.set_ellipsize (Pango.EllipsizeMode.END);
            label1.set_max_width_chars (18);
            
            if (label_texts[i].char_count() > 20) {
                label1.set_tooltip_text (label_texts[i]);
            }

            var label2 = new Label (null);
            label2.set_markup ("<span size='8500'>%s</span>".printf (label_texts_2[i]));
            label2.set_halign (Align.START);
            label2.add_css_class ("dim-label");
            label2.set_ellipsize (Pango.EllipsizeMode.END);
            label2.set_max_width_chars (19);
            
            if (label_texts_2[i].char_count() > 21) {
                label2.set_tooltip_text (label_texts_2[i]);
            }

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

        string[] label_texts = { _("Duration"), _("Autostart"), _("Interval") };
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
        fps_limit_entry_1.input_purpose = InputPurpose.NUMBER;
        var fps_limit_entry_1_box = create_entry_with_clear_button (fps_limit_entry_1, _("Limit 1"), "");
        fps_limit_entry_1.changed.connect (() => {
            validate_numeric_entry (fps_limit_entry_1, 0, 1000);
            SaveStates.update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            save_config ();
        });
        
        fps_limit_entry_2 = new Entry ();
        fps_limit_entry_2.input_purpose = InputPurpose.NUMBER;
        var fps_limit_entry_2_box = create_entry_with_clear_button (fps_limit_entry_2, _("Limit 2"), "");
        fps_limit_entry_2.changed.connect (() => {
            validate_numeric_entry (fps_limit_entry_2, 0, 1000);
            SaveStates.update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            save_config ();
        });
        
        fps_limit_entry_3 = new Entry ();
        fps_limit_entry_3.input_purpose = InputPurpose.NUMBER;
        var fps_limit_entry_3_box = create_entry_with_clear_button (fps_limit_entry_3, _("Limit 3"), "");
        fps_limit_entry_3.changed.connect (() => {
            validate_numeric_entry (fps_limit_entry_3, 0, 1000);
            SaveStates.update_fps_limit_in_file (fps_limit_entry_1.text, fps_limit_entry_2.text, fps_limit_entry_3.text);
            save_config ();
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
        limiters_box.set_selection_mode (SelectionMode.NONE);
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
        vsync_box.set_selection_mode (SelectionMode.NONE);
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
        filter_dropdown.notify["selected"].connect (() => {
            save_config ();
        });

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
            if (is_flatpak()) {
                Process.spawn_command_line_async ("mangohud vkcube-wayland");
            } else {
                Process.spawn_command_line_async ("mangohud vkcube");
            }
        } catch (Error e) {
            stderr.printf (_("Error when restarting vkcube: %s\n"), e.message);
        }
    }

    void restart_glxgears () {
        try {
            Process.spawn_command_line_sync ("pkill glxgears");
            Process.spawn_command_line_async ("mangohud glxgears");
        } catch (Error e) {
            stderr.printf (_("Error when restarting glxgears: %s\n"), e.message);
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
        save_config ();
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
            stderr.printf (_("Error checking running processes: %s\n"), e.message);
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
            stderr.printf (_("Error checking running processes: %s\n"), e.message);
            return false;
        }
    }

    void run_test () {
        new Thread<void>("run-test", () => {
            try {
                var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
                var config_file = config_dir.get_child ("MangoHud.conf");

                string? wayland_display = Environment.get_variable("WAYLAND_DISPLAY");
                bool is_wayland = (wayland_display != null && wayland_display != "");

                if (!config_file.query_exists ()) {
                    save_config ();
                }

                if (is_flatpak ()) {
                    Process.spawn_command_line_sync ("pkill vkcube");
                    if (is_wayland) {
                        Process.spawn_command_line_async ("mangohud vkcube-wayland");
                    } else {
                        Process.spawn_command_line_async ("mangohud vkcube");
                    }
                } else if (is_vkcube_available ()) {
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
                stderr.printf (_("Error when executing the command: %s\n"), e.message);
            }
        });
    }

    void delete_vkbasalt_conf () {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("vkBasalt");
        var file = config_dir.get_child ("vkBasalt.conf");
        if (file.query_exists ()) {
            try {
                file.delete ();
                warning (_("vkBasalt.conf file deleted."));
            } catch (Error e) {
                stderr.printf (_("Error deleting vkBasalt.conf: %s\n"), e.message);
            }
        } else {
            warning (_("vkBasalt.conf file does not exist."));
        }
    }

    void delete_mangohud_backup () {
        var file = File.new_for_path (Environment.get_home_dir ())
                      .get_child (".config")
                      .get_child ("MangoHud")
                      .get_child (".MangoHud.backup");

        if (file.query_exists ()) {
            try {
                file.delete ();
                warning (_(".MangoHud.backup file deleted."));
            } catch (Error e) {
                stderr.printf (_("Error deleting .MangoHud.backup: %s\n"), e.message);
            }
        } else {
            warning (_(".MangoHud.backup file does not exist."));
        }
    }

    void open_folder_chooser_dialog () {
        var dialog = new Gtk.FileDialog ();
        dialog.select_folder.begin (this.active_window, null, (obj, res) => {
            try {
                var folder = dialog.select_folder.end (res);
                custom_logs_path_entry.text = folder.get_path ();
            } catch (Error e) {
                stderr.printf (_("Error when selecting a folder: %s\n"), e.message);
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

    public Gtk.DropDown gpu_dropdown;
    private string[] gpu_pci_addresses = {};
        
    public void initialize_gpu_entry (Box extras_box) {
        var gpu_list_label = create_label (_("List GPUs to display"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        
        gpu_entry = new Entry () { hexpand = true, halign = Align.FILL };
        var gpu_box = create_entry_with_clear_button (gpu_entry, _("Video card display order (0,1,2)"), "");
        gpu_entry.changed.connect (() => { SaveStates.update_gpu_in_file (gpu_entry.text); save_config (); });
        
        var string_list = new Gtk.StringList (null);
        string_list.append (_("All video cards"));
        
        gpu_dropdown = new Gtk.DropDown (string_list, null) { hexpand = true, halign = Align.FILL };
        
        var factory = new Gtk.SignalListItemFactory();
        factory.setup.connect((item) => {
            var label = new Gtk.Label("") {
                halign = Gtk.Align.START,
                ellipsize = Pango.EllipsizeMode.END
            };
            var list_item = item as Gtk.ListItem;
            if (list_item != null) {
                list_item.set_child(label);
            }
        });
        
        factory.bind.connect((item) => {
            var list_item = item as Gtk.ListItem;
            if (list_item != null) {
                var label = list_item.get_child() as Gtk.Label;
                var string_object = list_item.get_item() as Gtk.StringObject;
                if (label != null && string_object != null) {
                    string display_text = string_object.get_string();
                    if (list_item.get_position() != 0 && display_text.length > 15) {
                        display_text = display_text.substring(15);
                    }
                    label.set_label(display_text);
                }
            }
        });

        gpu_dropdown.factory = factory;
        
        gpu_pci_addresses = get_gpu_pci_addresses ();
        
        if (gpu_pci_addresses.length == 1 && !Config.IS_DEVEL) {
            gpu_list_label.visible = gpu_box.visible = gpu_dropdown.visible = false;
        } else {
            foreach (var pci_address in gpu_pci_addresses) {
                string_list.append (pci_address);
            }
        
            gpu_dropdown.notify["selected"].connect (() => {
                uint selected_index = gpu_dropdown.selected;
                if (selected_index == 0) {
                    SaveStates.update_pci_dev_in_file (_("All video cards"));
                } else if (selected_index - 1 < gpu_pci_addresses.length) {
                    SaveStates.update_pci_dev_in_file (gpu_pci_addresses[selected_index - 1]);
                }
                save_config ();
            });
        
            var gpu_hbox = new FlowBox () {
                margin_start = FLOW_BOX_MARGIN,
                margin_end = FLOW_BOX_MARGIN,
                hexpand = true,
                max_children_per_line = 2
            };
            
            gpu_hbox.append (gpu_box);
            gpu_hbox.append (gpu_dropdown);
        
            extras_box.append (gpu_list_label);
            extras_box.append (gpu_hbox);
        }
    }

    private string[] get_gpu_pci_addresses() {
        string[] addresses = {};
        try {
            string output;
            Process.spawn_command_line_sync("lspci", out output);
            string[] lines = output.split("\n");
        
            foreach (var line in lines) {
                if ("VGA compatible controller" in line || "3D controller" in line || "Display controller" in line) {
                    string pci_address = line[0:7].strip();
                    string detailed_output;
                    Process.spawn_command_line_sync("lspci -D -s " + pci_address, out detailed_output);
                    string full_pci_address = detailed_output[0:12].strip();
        
                    string vendor_info = "";
                    if ("Intel" in line) {
                        vendor_info = line.substring(line.index_of("Intel")).strip();
                    } else if ("AMD" in line) {
                        vendor_info = line.substring(line.index_of("AMD")).strip();
                    } else if ("ATI" in line) {
                        vendor_info = line.substring(line.index_of("ATI")).strip();
                    } else if ("NVIDIA" in line) {
                        vendor_info = line.substring(line.index_of("NVIDIA")).strip();
                    } else if ("Nvidia" in line) {
                        vendor_info = line.substring(line.index_of("Nvidia")).strip();
                    } else {
                        vendor_info = _("Unknown Videocard");
                    }

                    vendor_info = vendor_info.replace(" [", " ").replace("[", " ")
                                           .replace(" ]", " ").replace("]", " ")
                                           .replace(" (", " ").replace("(", " ")
                                           .replace(" )", " ").replace(")", " ")
                                           .replace("  ", " ").strip();
                    
                    addresses += full_pci_address + " # " + vendor_info;
                }
            }
        } catch (Error e) {
            stderr.printf("Error getting GPU PCI addresses: %s\n", e.message);
        }
        return addresses;
    }

    bool is_vkcube_available () {
        try {
            string[] argv = { "which", "vkcube" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);
            return exit_status == 0;
        } catch (Error e) {
            stderr.printf (_("Error checking vkcube availability: %s\n"), e.message);
            return false;
        }
    }

    bool is_mangohud_available () {
        try {
            string[] argv = { "which", "mangohud" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);
            if (exit_status != 0) {
                stderr.printf (_("MangoHud not found. Please install MangoHud to use this application.\n"));
            }
            return exit_status == 0;
        } catch (Error e) {
            stderr.printf (_("Error checking MangoHud availability: %s\n"), e.message);
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
            return exit_status == 0;
        } catch (Error e) {
            stderr.printf (_("Error checking glxgears availability: %s\n"), e.message);
            return false;
        }
    }

    void on_save_as_button_clicked () {
        var dialog = new Gtk.FileDialog ();
        dialog.set_accept_label (_("Save"));
        dialog.set_initial_name ("MangoHud.conf");

        dialog.save.begin (this.active_window, null, (obj, res) => {
            try {
                var file = dialog.save.end (res);
                save_config_to_file (file.get_path ());
            } catch (Error e) {
                stderr.printf (_("Error when saving the file: %s\n"), e.message);
            }
        });
    }

    void save_config_to_file (string file_path) {
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        var file = config_dir.get_child ("MangoHud.conf");
        if (!file.query_exists ()) {
            stderr.printf (_("MangoHud.conf does not exist.\n"));
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
            stderr.printf (_("Error writing to the file: %s\n"), e.message);
        }
    }

    void on_restore_config_button_clicked () {
        var dialog = new Gtk.FileDialog ();
        dialog.set_title (_("Select config file to restore"));
        dialog.set_accept_label (_("Restore"));

        dialog.open.begin (this.active_window, null, (obj, res) => {
            try {
                var file = dialog.open.end (res);
                restore_config_from_file (file.get_path ());
            } catch (Error e) {
                stderr.printf (_("Error when selecting a file: %s\n"), e.message);
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
            stdout.printf (_("Configuration restored from %s\n"), file_path);
        } catch (Error e) {
            stderr.printf (_("Error writing to the file: %s\n"), e.message);
        }
        LoadStates.load_states_from_file.begin (this);
        reset_manager.reset_all_widgets ();
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
        result.scale.set_size_request (120, -1);
        result.scale.set_hexpand (true);
        result.scale.adjustment.page_increment = 1;

        result.entry = new Entry ();
        result.entry.text = "%d".printf (initial_value);
        result.entry.set_width_chars (3);
        result.entry.set_max_width_chars (4);
        result.entry.set_halign (Align.END);
        validate_numeric_entry (result.entry, min, max);

        bool is_updating = false;

        result.scale.value_changed.connect (() => {
            validate_entry_value (result.entry, min, max);
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
                bool is_valid = int.try_parse (result.entry.text, out value);
        
                if (is_valid && value >= min && value <= max) {
                    is_updating = true;
                    GLib.Idle.add (() => {
                        result.scale.set_value (value);
                        result.entry.remove_css_class ("error");
                        is_updating = false;
                        return false;
                    });
                } else if (result.entry.text.strip () != "") {
                    result.entry.add_css_class ("error");
                }
            }
        });

        result.entry.activate.connect (() => {
            if (result.entry.text.strip () == "" || result.entry.has_css_class ("error")) {
                result.entry.text = "%d".printf (initial_value);
                result.scale.set_value (initial_value);
                result.entry.remove_css_class ("error");
            }
        
            result.entry.get_parent().grab_focus();
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

        var gesture_drag = new Gtk.GestureDrag ();
        gesture_drag.drag_update.connect ((offset_x, offset_y) => {
            double current_value = result.scale.get_value ();

            int scale_width = result.scale.get_width ();

            double new_value = current_value + (offset_x / scale_width) * (max - min);

            new_value = new_value.clamp (min, max);

            result.scale.set_value (new_value);
        });

        result.scale.add_controller (gesture_drag);

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
                stderr.printf (_("Error deleting MANGOHUD from /etc/environment: %s\n"), e.message);
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
                stderr.printf (_("Error adding MANGOHUD to /etc/environment: %s\n"), e.message);
            }
        }

        if (success) {
            check_mangohud_global_status ();
            show_restart_warning ();
        } else {
            stderr.printf (_("Failed to modify /etc/environment.\n"));
        }
    }

    void save_config () {
        if (!is_loading) {
            SaveStates.save_states_to_file (this);
        }
    }

    void set_preset (string[] preset_values) {
        var file = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child("MangoHud").get_child ("MangoHud.conf");
        var backup_file = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud").get_child (".MangoHud.backup");
        try {
            if (file.query_exists () && !backup_file.query_exists ()) {
                file.copy (backup_file, FileCopyFlags.OVERWRITE);
            }
            var output_stream = new DataOutputStream (file.replace(null, false, FileCreateFlags.NONE));
            output_stream.put_string ("#Preset config by MangoJuice #\n");
            output_stream.put_string ("legacy_layout=false\n");
            foreach (string value in preset_values) {
                output_stream.put_string ("%s\n".printf (value));
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
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
                Process.spawn_sync ( null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status );

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
                stderr.printf (_("Error checking the MANGOHUD status: %s\n"), e.message);
            }
        });
    }

    async void add_other_box_if_needed () {
        if (Config.IS_DEVEL || yield check_vkbasalt_installed_async ()) {
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

    bool check_appstream_available() {
        if (!FileUtils.test("/usr/bin/xdg-open", FileTest.EXISTS)) {
            return false;
        }
        var appinfo = AppInfo.get_default_for_uri_scheme("appstream");
        return appinfo != null;
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

