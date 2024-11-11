// window.vala

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
    };

    public Window (MangoJuice.Application app) {
        Object (application: app);
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
}