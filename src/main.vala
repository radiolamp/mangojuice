/* main.vala // License: GPL-3.0+ */
using GLib;

int main (string[] args) {
    Intl.setlocale (LocaleCategory.ALL, "");
    Intl.textdomain ("mangojuice");
    string locale_dir = Environment.get_variable ("APPDIR") != null
        ? Path.build_filename (Environment.get_variable ("APPDIR"), "share/locale")
        : BuildConfig.GNOMELOCALEDIR;

    Intl.bindtextdomain ("mangojuice", locale_dir);
    Intl.bind_textdomain_codeset ("mangojuice", "UTF-8");
    var app = new MangoJuice.Application ();
    return app.run (args);
}
