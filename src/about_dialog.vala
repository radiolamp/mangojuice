using Gtk;

namespace AboutDialog {
    public void show_about_dialog (Gtk.Window parent_window) {
        var dialog = new Adw.AboutDialog () {
            application_icon = "io.github.radiolamp.mangojuice",
            application_name = "MangoJuice",
            version = "0.7.9",
            license_type = Gtk.License.GPL_3_0,
        };

        dialog.add_link ("MangoJuice на GitHub", "https://github.com/radiolamp/mangojuice");
        dialog.present (parent_window);
    }
}
