/* dialogs/about.vala // License: GPL-3.0+ */
using Gtk;
using Adw;

namespace MangoJuice.Dialogs {

public class AboutInfo : GLib.Object {

    public void show_about (Gtk.Window parent_window) {

        const string[] developers = {
            "Radiolamp https://github.com/radiolamp",
            "Rirusha https://rirusha.space",
            "Boria138 https://github.com/Boria138",
            "SpikedPaladin https://github.com/SpikedPaladin",
            "slserg https://github.com/slserg",
            "Samueru-sama https://github.com/Samueru-sama",
            "x1z53 https://gitverse.ru/x1z53",
            "MrMeshok https://github.com/MrMeshok",
            null
        };

        var dialog = new Adw.AboutDialog.from_appdata (
            "/io/github/radiolamp/mangojuice/io.github.radiolamp.mangojuice.metainfo.xml",
            null
        );

        dialog.application_icon = "io.github.radiolamp.mangojuice";
        dialog.version = BuildConfig.VERSION;
        dialog.translator_credits = _("translator-credits");
        dialog.set_developers (developers);
        dialog.present (parent_window);
    }

}

}
