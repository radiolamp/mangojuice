//windows.vala

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
        var settings = new Settings ("io.github.radiolamp.mangojuice");
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
    }

    public void on_about_action () {
        MangoJuice.About.show_about_dialog (this);
    }
}