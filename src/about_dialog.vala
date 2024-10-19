using Gtk;

namespace AboutDialog {
    public void show_about_dialog (Gtk.Window parent_window) {
        var about_dialog = new Gtk.AboutDialog ();
        about_dialog.set_transient_for (parent_window);
        about_dialog.set_modal (true);
        about_dialog.set_program_name ("MangoJuice");
        about_dialog.set_version ("0.7.1");
        about_dialog.set_license_type (Gtk.License.GPL_3_0);
        about_dialog.set_website ("https://github.com/radiolamp/mangojuice");
        about_dialog.set_website_label ("MangoHud на GitHub");
        about_dialog.set_logo_icon_name ("io.github.radiolamp.mangojuice");
        about_dialog.present ();
    }
}
