using Gtk;

namespace AboutDialog {
    public void show_about_dialog (Gtk.Window parent_window) {

        const string[] developers = {
            "Radiolamp https://github.com/radiolamp/",
            "Rirusha https://github.com/Rirusha",
            "Boria138 https://github.com/Boria138",
            "SpikedPaladin https://github.com/SpikedPaladin",
            "slserg https://github.com/slserg"
        };

        const string[] designers = {
            "Radiolamp https://github.com/radiolamp/",
        };


        var dialog = new Adw.AboutDialog () {
            application_icon = "io.github.radiolamp.mangojuice",
            application_name = "MangoJuice",
            version = Config.VERSION,
            license_type = Gtk.License.GPL_3_0,
        };

        dialog.developers = developers;
        dialog.designers = designers;

        dialog.add_link ("MangoJuice на GitHub", "https://github.com/radiolamp/mangojuic e");
        dialog.add_link ("Financial support (Tinkoff)", "https://www.tbank.ru/cf/1J1DvYNesgD");
        dialog.add_link ("Financial support (Boosty)", "https://boosty.to/radiolamp");
        dialog.present (parent_window);
    }
}
