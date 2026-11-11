/* application.vala // License: GPL-3.0+ */
using Gtk;
using Adw;
using Gee;
using MangoJuice;
using MangoJuice.Config;
using MangoJuice.Dialogs;
using MangoJuice.System;
using MangoJuice.UI;

namespace MangoJuice {

public class Application : Adw.Application {
    // Widget registry / persisted configuration state
    public State state { get; private set; }
    public MangoJuice.Config.Paths paths { get; private set; }
    public MangoJuice.Config.Saver saver { get; private set; }
    public MangoJuice.Config.Loader loader { get; private set; }
    public Env env { get; private set; }
    public GPU gpu { get; private set; }
    public TestApps test_apps { get; private set; }
    public IntelPowerFix intel_power_fix { get; private set; }
    public ControlsView controls_view { get; private set; }
    public ExtrasView extras_view { get; private set; }
    public GpuSelector gpu_selector { get; private set; }
    public FontSelector font_selector { get; private set; }
    public ColorControls color_controls { get; private set; }
    public ProfileDialog profile_dialog { get; private set; }
    public PresetsDialog presets_dialog { get; private set; }
    public SupportDialog support_dialog { get; private set; }
    public AboutInfo about_dialog { get; private set; }
    public Labels labels { get; private set; }
    public TestRunner test_runner { get; private set; }
    public MangohudGlobal mangohud_global { get; private set; }
    public FileActions file_actions { get; private set; }
    public AdvancedMode advanced_mode { get; private set; }
    public WidgetFactory widget_factory { get; private set; }
    public SearchController search { get; private set; }

    // UI Elements
    public MangoJuice.VkBasalt.OtherBox other_box;
    bool first_run = false;

    ScrolledWindow other_scrolled_window;
    ViewStack view_stack;
    Adw.HeaderBar header_bar;

    // Configuration Variables

    public ResetManager reset_manager;

    // Vulkan and OpenGL Values

    public Application () {
        Object (application_id: "io.github.radiolamp.mangojuice", flags: ApplicationFlags.DEFAULT_FLAGS);
        state = new State ();
        paths = new MangoJuice.Config.Paths ();
        saver = new MangoJuice.Config.Saver (paths);
        loader = new MangoJuice.Config.Loader (state, paths);
        env = new Env ();
        gpu = new GPU ();
        test_apps = new TestApps ();
        intel_power_fix = new IntelPowerFix ();
        search = new SearchController (this);
        controls_view = new ControlsView (this);
        extras_view = new ExtrasView (this);
        gpu_selector = new GpuSelector (this);
        font_selector = new FontSelector (this);
        color_controls = new ColorControls (this);
        profile_dialog = new ProfileDialog (this);
        presets_dialog = new PresetsDialog (this);
        support_dialog = new SupportDialog ();
        about_dialog = new AboutInfo ();
        labels = new Labels ();
        test_runner = new TestRunner (paths, saver, state, env, test_apps);
        mangohud_global = new MangohudGlobal (state);
        file_actions = new FileActions (state, paths, loader);
        advanced_mode = new AdvancedMode (paths);
        widget_factory = new WidgetFactory ();

        register_actions ();
    }

    SimpleAction add_app_action (string name) {
        var action = new SimpleAction (name, null);
        this.add_action (action);
        return action;
    }

    void register_actions () {
        const string[] QUIT_ACCELS = { "<Control>Q", null };
        const string[] TEST_NEW_ACCELS = { "<Primary>T", null };
        const string[] RESTORE_CONFIG_ACCELS = { "<Primary>R", null };
        const string[] SAVE_ACCELS = { "<Primary>S", null };
        const string[] SAVE_AS_ACCELS = { "<Primary>E", null };
        const string[] PRESETS_ACCELS = { "<Primary>P", null };
        const string[] PROFILES_ACCELS = { "<Primary>Y", null };
        const string[] ADVANCED_ACCELS = { "<Primary>A", null };
        const string[] SEARCH_ACCELS = { "<Primary>F", null };

        // Handlers must be method references: a lambda that touches this member and is
        // connected to GSimpleAction::activate is marshalled with a null instance, because
        // that signal has no instance parameter.
        add_app_action ("quit").activate.connect (on_quit);
        add_app_action ("test_new").activate.connect (run_test);
        add_app_action ("restore_config").activate.connect (on_restore_config_button_clicked);
        add_app_action ("save").activate.connect (on_save_action_activated);
        add_app_action ("save_as").activate.connect (on_save_as_button_clicked);
        add_app_action ("presets_carousel").activate.connect (on_presets_clicked);
        add_app_action ("preset_dialog").activate.connect (on_profiles_clicked);
        add_app_action ("advanced").activate.connect (on_advanced_clicked);
        add_app_action ("about").activate.connect (on_about_button_clicked);
        add_app_action ("donate").activate.connect (on_donate_clicked);
        add_app_action ("search").activate.connect (on_search_clicked);

        this.set_accels_for_action ("app.quit", QUIT_ACCELS);
        this.set_accels_for_action ("app.test_new", TEST_NEW_ACCELS);
        this.set_accels_for_action ("app.restore_config", RESTORE_CONFIG_ACCELS);
        this.set_accels_for_action ("app.save", SAVE_ACCELS);
        this.set_accels_for_action ("app.save_as", SAVE_AS_ACCELS);
        this.set_accels_for_action ("app.presets_carousel", PRESETS_ACCELS);
        this.set_accels_for_action ("app.preset_dialog", PROFILES_ACCELS);
        this.set_accels_for_action ("app.advanced", ADVANCED_ACCELS);
        this.set_accels_for_action ("app.search", SEARCH_ACCELS);
    }

    protected override void activate () {
        var window = new Adw.ApplicationWindow (this);
        window.set_default_size (1024, 700);
        window.set_title ("MangoJuice");
        if (BuildConfig.IS_DEVEL) window.add_css_class ("devel");
        mangohud_global.window = window;

        var toast_overlay = new Adw.ToastOverlay ();
        var content_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        toast_overlay.set_child (content_box);

        view_stack = new Adw.ViewStack ();
        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, Common.MAIN_BOX_SPACING);
        main_box.set_homogeneous (true);

        var toolbar_view_switcher = new Adw.ViewSwitcher ();
        toolbar_view_switcher.stack = view_stack;
        toolbar_view_switcher.policy = Adw.ViewSwitcherPolicy.WIDE;

        var bottom_headerbar = new Gtk.HeaderBar ();
        bottom_headerbar.show_title_buttons = false;
        bottom_headerbar.set_visible (false);

        var bottom_view_switcher = new Adw.ViewSwitcher ();
        bottom_view_switcher.stack = view_stack;

        var center_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        center_box.set_halign (Gtk.Align.CENTER);
        center_box.append (bottom_view_switcher);
        bottom_headerbar.set_title_widget (center_box);

        var breakpoint_800px = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 800px"));
        var breakpoint_550px = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 550px"));

        breakpoint_800px.add_setter (toolbar_view_switcher, "policy", Adw.ViewSwitcherPolicy.NARROW);
        breakpoint_550px.add_setter (toolbar_view_switcher, "policy", Adw.ViewSwitcherPolicy.NARROW);
        breakpoint_550px.add_setter (bottom_headerbar, "visible", true);
        breakpoint_550px.add_setter (toolbar_view_switcher, "visible", false);

        window.add_breakpoint (breakpoint_800px);
        window.add_breakpoint (breakpoint_550px);

        var metrics_box = new Gtk.Box (Gtk.Orientation.VERTICAL, Common.MAIN_BOX_SPACING);
        var extras_box = new Gtk.Box (Gtk.Orientation.VERTICAL, Common.MAIN_BOX_SPACING);
        var performance_box = new Gtk.Box (Gtk.Orientation.VERTICAL, Common.MAIN_BOX_SPACING);
        var visual_box = new Gtk.Box (Gtk.Orientation.VERTICAL, Common.MAIN_BOX_SPACING);
        other_box = new MangoJuice.VkBasalt.OtherBox (paths, test_runner);

        controls_view.initialize (metrics_box, extras_box, performance_box, visual_box);
        extras_view.initialize (extras_box, visual_box);

        var metrics_scrolled_window = Common.create_scrolled_window (metrics_box);
        var extras_scrolled_window = Common.create_scrolled_window (extras_box);
        var performance_scrolled_window = Common.create_scrolled_window (performance_box);
        var visual_scrolled_window = Common.create_scrolled_window (visual_box);
        other_scrolled_window = Common.create_scrolled_window (other_box);

        search.register_page ("metrics_box", metrics_scrolled_window);
        search.register_page ("extras_box", extras_scrolled_window);
        search.register_page ("performance_box", performance_scrolled_window);
        search.register_page ("visual_box", visual_scrolled_window);

        string? current_desktop = Environment.get_variable ("XDG_CURRENT_DESKTOP");
        bool is_gnome = (current_desktop != null && current_desktop.contains ("GNOME"));

        add_view_to_stack (metrics_scrolled_window, "metrics_box", _ ("Metrics"),
                          is_gnome ? "view-continuous-symbolic" : "io.github.radiolamp.mangojuice-metrics-symbolic");
        add_view_to_stack (extras_scrolled_window, "extras_box", _ ("Extras"),
                          is_gnome ? "application-x-addon-symbolic" : "io.github.radiolamp.mangojuice-extras-symbolic");
        add_view_to_stack (performance_scrolled_window, "performance_box", _ ("Performance"),
                          is_gnome ? "emblem-system-symbolic" : "io.github.radiolamp.mangojuice-performance-symbolic");
        add_view_to_stack (visual_scrolled_window, "visual_box", _ ("Visual"),
                          is_gnome
                          ? "preferences-desktop-appearance-symbolic"
                          : "io.github.radiolamp.mangojuice-visual-symbolic");

        add_other_box_if_needed.begin ();

        header_bar = new Adw.HeaderBar ();
        header_bar.set_title_widget (toolbar_view_switcher);

        advanced_mode.load (state);
        if (state.custom_order_changed) {
            header_bar.add_css_class ("custom-order-active");
        }

        state.notify["custom-order-changed"].connect (() => {
            if (state.custom_order_changed) {
                header_bar.add_css_class ("custom-order-active");
            } else {
                header_bar.remove_css_class ("custom-order-active");
            }
            advanced_mode.save (state);
        });

        var test_button = new Gtk.Button.with_label (_ ("Test"));
        test_button.clicked.connect (run_test);
        header_bar.pack_start (test_button);

        var search_button = new Gtk.Button () {
            icon_name = "system-search-symbolic",
            tooltip_text = _ ("Search settings (Ctrl+F)")
        };
        search_button.clicked.connect (on_search_clicked);

        var menu_button = create_menu_button ();
        header_bar.pack_end (menu_button);
        header_bar.pack_end (search_button);

        content_box.append (header_bar);
        content_box.append (view_stack);
        content_box.append (bottom_headerbar);
        window.set_content (toast_overlay);
        window.present ();

        Idle.add (() => {
            setup_initial_checks (window, toast_overlay, test_button);
            return false;
        });

        loader.load.begin ();
    }

    void add_view_to_stack (Gtk.Widget widget, string name, string title, string icon_name) {
        view_stack.add_titled (widget, name, title).icon_name = icon_name;
    }

    Gtk.MenuButton create_menu_button () {
        var menu_button = new Gtk.MenuButton ();
        menu_button.add_css_class ("circular");

        var menu_model = new GLib.Menu ();
        menu_model.append_item (new GLib.MenuItem (_ ("Save"), "app.save"));
        menu_model.append_item (new GLib.MenuItem (_ ("Save As"), "app.save_as"));
        menu_model.append_item (new GLib.MenuItem (_ ("Restore"), "app.restore_config"));
        menu_model.append_item (new GLib.MenuItem (_ ("Your profiles"), "app.preset_dialog"));
        menu_model.append_item (new GLib.MenuItem (_ ("Presets"), "app.presets_carousel"));
        menu_model.append_item (new GLib.MenuItem (_ ("Change order"), "app.advanced"));
        menu_model.append_item (new GLib.MenuItem (_ ("Donate"), "app.donate"));
        menu_model.append_item (new GLib.MenuItem (_ ("About"), "app.about"));

        menu_button.set_menu_model (menu_model);
        menu_button.set_icon_name ("open-menu-symbolic");
        return menu_button;
    }

    void setup_initial_checks (Adw.ApplicationWindow window, Adw.ToastOverlay toast_overlay, Gtk.Button test_button) {
        bool mangohud_available = test_apps.is_mangohud_available ();
        bool vkcube_available = test_apps.is_vkcube_available ();
        bool glxgears_available = false;
        if (!vkcube_available) {
            glxgears_available = test_apps.is_glxgears_available ();
        }

        var first_run_file = paths.first_run_file;
        first_run = !first_run_file.query_exists ();

        if (first_run) {
            Timeout.add (1000, () => {
                try {
                    first_run_file.create (FileCreateFlags.NONE);
                } catch (Error e) {
                    warning ("Could not create first-run file: %s", e.message);
                }
                support_dialog.show_support_dialog.begin (window, (obj, res) => {
                    support_dialog.show_support_dialog.end (res);
                });

                return false;
            });
        }

        var click_controller = new Gtk.GestureClick ();
        click_controller.pressed.connect (() => window.set_focus (null));
        toast_overlay.add_controller (click_controller);

        if (!mangohud_available) {
            show_mangohud_not_found_toast (toast_overlay, test_button);
        }

        if (!mangohud_available || (!vkcube_available && !glxgears_available)) {
            test_button.set_visible (false);
            if (!vkcube_available && !glxgears_available) {
                show_test_tools_not_found_toast (toast_overlay, test_button, mangohud_available);
            }
        }

        reset_manager = new ResetManager (state);
        file_actions.reset_manager = reset_manager;
        controls_view.register_scale_handlers ();
        if (!env.is_flatpak ()) {
            mangohud_global.check_status ();
        }

    }

    void show_mangohud_not_found_toast (Adw.ToastOverlay toast_overlay, Gtk.Button test_button) {
        var toast_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        var toast_label = new Gtk.Label (_ ("MangoHud is not installed. Please install it."));
        toast_label.set_ellipsize (Pango.EllipsizeMode.END);
        toast_label.set_halign (Gtk.Align.START);
        var install_button = new Gtk.Button.with_label (_ ("Install"));

        toast_box.append (toast_label);
        toast_box.append (install_button);

        var toast = new Adw.Toast ("");
        toast.set_custom_title (toast_box);
        toast.set_timeout (0);

        bool appstream_available = env.check_appstream_available ();
        install_button.visible = appstream_available;

        if (appstream_available) {
            install_button.clicked.connect (() => {
                try {
                    Process.spawn_command_line_async ("xdg-open appstream://io.github.flightlessmango.mangohud");
                    toast.dismiss ();
                } catch (Error e) {
                    var error_toast = new Adw.Toast (_ ("Failed to launch AppStream: %s").printf (e.message));
                    error_toast.timeout = 15;
                    toast_overlay.add_toast (error_toast);
                }
            });
        }

        toast.dismissed.connect (() => {
            if (test_apps.is_mangohud_available ()) {
                if (test_apps.is_vkcube_available () && test_apps.is_glxgears_available ()) {
                    test_button.set_visible (true);
                }
            } else {
                test_button.set_visible (false);
            }
        });

        toast_overlay.add_toast (toast);
    }

    void show_test_tools_not_found_toast (Adw.ToastOverlay toast_overlay,
                                          Gtk.Button test_button,
                                          bool mangohud_available) {
        stderr.printf (_ ("vkcube not found. If you want a test button, install vulkan-tools.\n") +
                      _ ("glxgears not found. If you want a test button, install mesa-utils.\n"));

        var toast = new Adw.Toast (
            _ ("vkcube and glxgears not found. Install vulkan-tools and mesa-utils to enable the test button."));
        toast.set_timeout (15);
        toast.dismissed.connect (() => {
            if (test_apps.is_vkcube_available () && test_apps.is_glxgears_available ()) {
                if (test_apps.is_mangohud_available ()) {
                    test_button.set_visible (true);
                }
            } else {
                test_button.set_visible (false);
            }
        });
        toast_overlay.add_toast (toast);
    }

    protected override void shutdown () {
        saver.flush_all_pending ();
        test_runner.stop_test_app ();

        base.shutdown ();
    }

    public void run_test () {
        test_runner.run_test ();
    }

    public void restart_vkcube_or_glxgears () {
        test_runner.restart_vkcube_or_glxgears ();
    }

    public void save_and_restart () {
        test_runner.save_and_restart ();
    }

    public void delete_vkbasalt_conf () {
        file_actions.delete_vkbasalt_conf ();
    }

    public void delete_mangohud_backup () {
        file_actions.delete_mangohud_backup ();
    }

    public void open_folder_chooser_dialog () {
        file_actions.open_folder_chooser_dialog (this.active_window);
    }

    void on_save_as_button_clicked () {
        file_actions.save_as_dialog (this.active_window);
    }

    void on_restore_config_button_clicked () {
        file_actions.restore_dialog (this.active_window);
    }

    public bool restore_config_from_file (string file_path) {
        return file_actions.restore_config_from_file (file_path);
    }

    public WidgetFactory.ScaleEntryWidget create_scale_entry_widget (string title, string description, int min, int max, int initial_value) {
        return widget_factory.create_scale_entry_widget (title, description, min, max, initial_value);
    }

    public void on_mangohud_global_button_clicked () {
        mangohud_global.on_button_clicked ();
    }

    public void save_config () {
        if (!state.is_loading) {
            saver.save_states (state);
        }
    }

    public void show_page (string page_id) {
        view_stack.set_visible_child_name (page_id);
    }

    void on_search_clicked () {
        search.open ();
    }

    void on_donate_clicked () {
        support_dialog.show_support_dialog.begin (this.active_window, (obj, res) => {
            support_dialog.show_support_dialog.end (res);
        });
    }

    async void add_other_box_if_needed () {
        if (BuildConfig.IS_DEVEL || yield check_vkbasalt_installed_async ()) {
            view_stack.add_titled (other_scrolled_window, "other_box", _ ("Other")).icon_name = "view-grid-symbolic";
            search.register_page ("other_box", other_scrolled_window);
            other_box.enable_search (search);
        }
    }

    async bool check_vkbasalt_installed_async () {
        string[] paths = {
            "/usr/lib/libvkbasalt.so",
            "/usr/lib/x86_64-linux-gnu/libvkbasalt.so",
            "/usr/lib/x86_64-linux-gnu/vkbasalt/libvkbasalt.so",
            "/usr/local/lib/libvkbasalt.so",
            "/usr/lib64/vkbasalt/libvkbasalt.so"
        };
        foreach (var path in paths) {
            if (FileUtils.test (path, FileTest.EXISTS)) {
                return true;
            }
        }
        return false;
    }

    public void validate_numeric_entry (Entry entry, int min_value = int.MIN, int max_value = int.MAX) {
        widget_factory.validate_numeric_entry (entry, min_value, max_value);
    }

    public void on_quit () {
        this.quit ();
    }

    public void on_save_action_activated () {
        save_config ();
        test_runner.restart_if_testing ();
    }

    public void on_presets_clicked () {
        if (active_window != null) {
            presets_dialog.show_presets_carousel_dialog (active_window);
        }
    }

    public void on_profiles_clicked () {
        if (active_window != null) {
            profile_dialog.preset_dialog (active_window);
        }
    }

    public void on_advanced_clicked () {
        if (active_window != null) {
            Advanced.show_advanced_dialog (active_window, this);
        }
    }

    public void on_about_button_clicked () {
        about_dialog.show_about (this.active_window);
    }
}

}
