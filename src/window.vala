using Gtk;
using GLib;

[GtkTemplate (ui = "/io/github/radiolamp/mangojuice/ui/window.ui")]
public sealed class MangoJuice.Window : Adw.ApplicationWindow {

    [GtkChild]
    private unowned MetricsPage metrics_page;
    [GtkChild]
    private unowned ExtrasPage extras_page;
    [GtkChild]
    private unowned PerformancePage performance_page;
    [GtkChild]
    private unowned VisualPage visual_page;

    [GtkChild]
    private unowned Button test_button;

    const ActionEntry[] ACTION_ENTRIES = {
        { "about", on_about_action },
        { "save_config", on_save_config_action_sync },
        { "load_config", on_load_config_action_sync },
    };

    public Window (MangoJuice.Application app) {
        Object (application: app);

        if (!is_vkcube_available () && !is_glxgears_available ()) {
            test_button.visible = false;
        }

        this.add_action_entries (ACTION_ENTRIES, this);
    }

    static construct {
        typeof (TitledSwitch).ensure ();
        typeof (MangoJuice.Block).ensure ();
        typeof (ExtrasPage).ensure ();
        typeof (MetricsPage).ensure ();
        typeof (PerformancePage).ensure ();
        typeof (VisualPage).ensure ();
    }

    construct {
        var settings = new GLib.Settings ("io.github.radiolamp.mangojuice"); // Явно указываем GLib.Settings
        settings.bind ("window-width", this, "default-width", SettingsBindFlags.DEFAULT);
        settings.bind ("window-height", this, "default-height", SettingsBindFlags.DEFAULT);
        settings.bind ("window-maximized", this, "maximized", SettingsBindFlags.DEFAULT);

        application_inst.values_manager.add_page (Pages.METRICS, metrics_page);
        application_inst.values_manager.add_page (Pages.EXTRAS, extras_page);
        application_inst.values_manager.add_page (Pages.PERFORMANCE, performance_page);
        application_inst.values_manager.add_page (Pages.VISUAL, visual_page);

        if (Config.IS_DEVEL) {
            add_css_class ("devel");
        }

        test_button.clicked.connect (on_test_button_clicked);
    }

    public void on_about_action () {
        MangoJuice.About.show_about_dialog (this);
    }

    private void on_test_button_clicked () {
        run_test_command ();
    }

    private async void on_save_config_action () {
        var file_dialog = new Gtk.FileDialog ();
        file_dialog.set_title ("Save Mangohud.conf");
        file_dialog.set_initial_name ("Mangohud.conf");

        try {
            var file = yield file_dialog.save (this, null);
            var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
            var config_file = config_dir.get_child ("MangoHud.conf");

            try {
                config_file.copy (file, FileCopyFlags.OVERWRITE);
            } catch (Error e) {
                warning ("Error saving config: %s", e.message);
            }
        } catch (Error e) {
            warning ("Error opening file chooser: %s", e.message);
        }
    }

    private async void on_load_config_action () {
        var file_dialog = new Gtk.FileDialog ();
        file_dialog.set_title ("Load Mangohud.conf");

        try {
            var file = yield file_dialog.open (this, null);
            var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
            var config_file = config_dir.get_child ("MangoHud.conf");

            try {
                file.copy (config_file, FileCopyFlags.OVERWRITE);
            } catch (Error e) {
                warning ("Error loading config: %s", e.message);
            }
        } catch (Error e) {
            warning ("Error opening file chooser: %s", e.message);
        }
    }

    private void on_save_config_action_sync () {
        var loop = new MainLoop ();
        on_save_config_action.begin ((obj, res) => {
            on_save_config_action.end (res);
            loop.quit ();
        });
        loop.run ();
    }

    private void on_load_config_action_sync () {
        var loop = new MainLoop ();
        on_load_config_action.begin ((obj, res) => {
            on_load_config_action.end (res);
            loop.quit ();
        });
        loop.run ();
    }
}