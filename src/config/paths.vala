/* config/paths.vala // License: GPL-3.0+ */
using GLib;

namespace MangoJuice.Config {

public class Paths : GLib.Object {

    public string config_home { get; private set; }
    public File mangohud_dir { get; private set; }
    public File mangohud_conf { get; private set; }
    public File mangohud_backup { get; private set; }
    public File first_run_file { get; private set; }
    public File vkbasalt_dir { get; private set; }
    public File vkbasalt_conf { get; private set; }

    public Paths (string? config_home = null) {
        this.config_home = (config_home != null && config_home != "")
            ? config_home
            : resolve_config_home ();

        var base_dir = File.new_for_path (this.config_home);
        mangohud_dir = base_dir.get_child ("MangoHud");
        mangohud_conf = mangohud_dir.get_child ("MangoHud.conf");
        mangohud_backup = mangohud_dir.get_child (".MangoHud.backup");
        first_run_file = base_dir.get_child (".mangojuice");
        vkbasalt_dir = base_dir.get_child ("vkBasalt");
        vkbasalt_conf = vkbasalt_dir.get_child ("vkBasalt.conf");
    }

    static string resolve_config_home () {
        var xdg_config_home = Environment.get_variable ("XDG_CONFIG_HOME");
        if (xdg_config_home != null && xdg_config_home != "") {
            return xdg_config_home;
        }
        return Path.build_filename (Environment.get_home_dir (), ".config");
    }

    public File profile_file (string profile_name) {
        return mangohud_dir.get_child (profile_name.replace (" ", "-") + ".conf");
    }

    public string profile_path (string profile_name) {
        return profile_file (profile_name).get_path ();
    }
}

}
