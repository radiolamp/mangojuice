/* about_dialog  // Licence:  GPL-v3.0 */
using Gtk;

namespace AboutDialog {
    public void show_about_dialog (Gtk.Window parent_window) {

        const string[] developers = {
            "Radiolamp https://github.com/radiolamp/",
            "Rirusha https://rirusha.space",
            "Boria138 https://github.com/Boria138",
            "SpikedPaladin https://github.com/SpikedPaladin",
            "slserg https://github.com/slserg",
            "x1z53 https://gitverse.ru/x1z53"
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

        dialog.add_link ("MangoJuice на GitHub", "https://github.com/radiolamp/mangojuice");
        dialog.add_link ("Financial support (Donationalerts)", "https://www.donationalerts.com/r/radiolamp");
        dialog.add_link ("Financial support (Tinkoff)", "https://www.tbank.ru/cf/3PPTstulqEq");
        dialog.add_link ("Financial support (Boosty)", "https://boosty.to/radiolamp");
        dialog.present (parent_window);
    }
}

void show_mangohud_install_dialog(Gtk.Window parent) {
    var dialog = new Adw.AlertDialog(
        _("MangoHud Not Installed"),
        _("MangoHud is required for this application. Would you like to install it from Flathub?")
    );
    
    dialog.add_response("cancel", _("Cancel"));
    dialog.add_response("install", _("Install"));
    
    dialog.set_default_response("install");
    dialog.set_response_appearance("install", Adw.ResponseAppearance.SUGGESTED);
    
    dialog.response.connect((response) => {
        if (response == "install") {
            try {
                AppInfo.launch_default_for_uri("https://flathub.org/apps/org.freedesktop.Platform.VulkanLayer.MangoHud", null);
            } catch (Error e) {
                stderr.printf("Error launching Flathub: %s\n", e.message);
            }
        }
    });
    
    dialog.present(parent);
}
