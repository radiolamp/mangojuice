//about.vala

using Gtk;

namespace MangoJuice.About {
    public void show_about_dialog (Widget widget) {
        var dialog = new Adw.AboutDialog () {
            application_icon = Config.APP_ID,
            application_name = Config.APP_NAME,
            developer_name = "Radiolamp",
            translator_credits = _("translator-credits"),
           // developers = {
           //     "Radiolamp",
           //     "Vladimir Vaskov https://rirusha.space/"
           // },
           // artists = {},
           // documenters = {},
           // designers = {},
            version = Config.VERSION,
            license_type = Gtk.License.GPL_3_0,
            copyright = "© 2024 Radiolamp",
            issue_url = Config.BUGTRACKER,
            website = Config.HOMEPAGE
        };

        // Translators: don't translate MangoHud
        dialog.add_link (_("MangoHud repository"), "https://github.com/flightlessmango/MangoHud");
        dialog.present (widget);
    }
}
