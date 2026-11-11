/* system/env.vala // License: GPL-3.0+ */
using GLib;

namespace MangoJuice.System {

public class Env : GLib.Object {

public bool is_flatpak () {
    return Environment.get_variable ("FLATPAK_ID") != null;
}

public bool is_appimage () {
    return Environment.get_variable ("APPIMAGE") != null
        || Environment.get_variable ("APPDIR") != null;
}

public bool check_appstream_available () {
    if (!FileUtils.test ("/usr/bin/xdg-open", FileTest.EXISTS)) {
        return false;
    }
    var appinfo = AppInfo.get_default_for_uri_scheme ("appstream");
    return appinfo != null;
}
}

}
