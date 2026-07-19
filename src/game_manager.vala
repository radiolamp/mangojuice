/* game_manager.vala // Licence: GPL-v3.0 */
/* Overlay manager: pick a running process, launch MangoHud.exe targeting it. */

using Gtk;
using Adw;
using Gee;

private static string get_sys_exe (string name) {
    string? sysroot = Environment.get_variable ("SystemRoot");
    if (sysroot == null) sysroot = "C:\\Windows";
    return Path.build_filename (sysroot, "System32", name);
}

private static bool run_reg (string[] args) {
    string[] real_args = args.copy ();
    real_args[0] = get_sys_exe ("reg.exe");
    try {
        int exit_status;
        string std_out, std_err;
        Process.spawn_sync (null, real_args, null, (SpawnFlags) 0, null,
            out std_out, out std_err, out exit_status);
        return (exit_status == 0);
    } catch (Error e) {
        return false;
    }
}

private static string? find_layer_json () {
    string exe_dir = Environment.get_current_dir ();
    string? appdir = Environment.get_variable ("APPDIR");
    if (appdir != null && appdir != "") exe_dir = appdir;
    string p = Path.build_filename (exe_dir, "MangoHud.x86_64.json");
    if (FileUtils.test (p, FileTest.EXISTS)) return p;
    p = Path.build_filename (exe_dir, "MangoHud.json");
    if (FileUtils.test (p, FileTest.EXISTS)) return p;
    return null;
}

public static bool register_vulkan_layer () {
    string? json = find_layer_json ();
    if (json == null) return false;
    string rp = json.replace ("/", "\\");
    // Try HKLM first (admin), fall back to HKCU
    bool admin = run_reg ({ "reg", "add", "HKLM\\SOFTWARE\\Khronos\\Vulkan\\ImplicitLayers",
        "/v", rp, "/t", "REG_DWORD", "/d", "0", "/f" });
    if (!admin) {
        if (!run_reg ({ "reg", "add", "HKCU\\SOFTWARE\\Khronos\\Vulkan\\ImplicitLayers",
            "/v", rp, "/t", "REG_DWORD", "/d", "0", "/f" })) return false;
        run_reg ({ "reg", "add",
            "HKCU\\Environment",
            "/v", "MANGOHUD", "/t", "REG_SZ", "/d", "1", "/f" });
    } else {
        run_reg ({ "reg", "add",
            "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment",
            "/v", "MANGOHUD", "/t", "REG_SZ", "/d", "1", "/f" });
    }
    return true;
}

public static bool is_vulkan_layer_registered () {
    string[] hives = {
        "HKLM\\SOFTWARE\\Khronos\\Vulkan\\ImplicitLayers",
        "HKCU\\SOFTWARE\\Khronos\\Vulkan\\ImplicitLayers",
    };
    foreach (var hive in hives) {
        try {
            int exit_status;
            string std_out, std_err;
            Process.spawn_sync (null,
                { get_sys_exe ("reg.exe"), "query", hive },
                null, (SpawnFlags) 0, null, out std_out, out std_err, out exit_status);
            if (exit_status == 0 && std_out.contains ("MangoHud")) return true;
        } catch (Error e) { continue; }
    }
    return false;
}

public class GameManager : Box {
    private ListBox process_list_box;
    private Button start_btn;
    private Button stop_btn;
    private Label status_label;
    private string? current_target = null;

    public GameManager () {
        Object (orientation: Orientation.VERTICAL, spacing: 8);
        set_margin_start (12); set_margin_end (12);
        set_margin_top (12); set_margin_bottom (12);
        setup_ui ();
        refresh_processes ();
        sync_overlay_state ();
    }

    private string get_exe_directory () {
        string? appdir = Environment.get_variable ("APPDIR");
        if (appdir != null && appdir != "") return appdir;
        return Environment.get_current_dir ();
    }

    private void setup_ui () {
        var header = new Label (_("Overlay"));
        header.add_css_class ("title-2");
        header.set_halign (Align.START);
        append (header);

        var desc = new Label (_("Select a running game and start the overlay. It tracks the game window automatically."));
        desc.add_css_class ("dim-label");
        desc.set_halign (Align.START);
        desc.set_wrap (true);
        append (desc);

        var scrolled = new ScrolledWindow ();
        scrolled.vexpand = true;
        scrolled.min_content_height = 250;
        process_list_box = new ListBox ();
        process_list_box.set_selection_mode (SelectionMode.SINGLE);
        process_list_box.add_css_class ("boxed-list");
        scrolled.child = process_list_box;
        append (scrolled);

        var btn_box = new FlowBox ();
        btn_box.set_halign (Align.CENTER);
        btn_box.set_margin_top (8);
        btn_box.set_max_children_per_line (3);
        btn_box.set_selection_mode (SelectionMode.NONE);

        var refresh_btn = new Button.with_label (_("Refresh"));
        refresh_btn.add_css_class ("flat");
        refresh_btn.clicked.connect (refresh_processes);
        btn_box.insert (refresh_btn, -1);

        start_btn = new Button.with_label (_("Start Overlay"));
        start_btn.add_css_class ("suggested-action");
        start_btn.add_css_class ("pill");
        start_btn.clicked.connect (on_start);
        btn_box.insert (start_btn, -1);

        stop_btn = new Button.with_label (_("Stop Overlay"));
        stop_btn.add_css_class ("destructive-action");
        stop_btn.sensitive = false;
        stop_btn.clicked.connect (on_stop);
        btn_box.insert (stop_btn, -1);

        append (btn_box);

        status_label = new Label (_("No overlay running."));
        status_label.add_css_class ("dim-label");
        status_label.set_margin_top (4);
        append (status_label);

        // Vulkan section
        var sep = new Separator (Orientation.HORIZONTAL);
        sep.set_margin_top (12);
        append (sep);

        var vk_h = new Label (_("Vulkan Games"));
        vk_h.add_css_class ("title-4");
        vk_h.set_halign (Align.START);
        vk_h.set_margin_top (6);
        append (vk_h);

        var vk_d = new Label (_("Register the Vulkan layer for CS2, Doom, etc. Requires admin."));
        vk_d.add_css_class ("dim-label");
        vk_d.set_halign (Align.START);
        vk_d.set_wrap (true);
        append (vk_d);

        var vk_status = new Label (is_vulkan_layer_registered () ? _("Registered") : _("Not registered"));
        vk_status.set_halign (Align.START);
        vk_status.set_margin_top (4);
        if (is_vulkan_layer_registered ()) vk_status.add_css_class ("success");
        else vk_status.add_css_class ("warning");

        var vk_btn = new Button.with_label (is_vulkan_layer_registered () ? _("Re-register") : _("Register Vulkan Layer"));
        vk_btn.set_margin_top (4);
        vk_btn.clicked.connect (() => {
            vk_btn.sensitive = false;
            vk_status.label = _("Registering...");
            new Thread<void> ("vk-reg", () => {
                bool ok = register_vulkan_layer ();
                bool reg = is_vulkan_layer_registered ();
                Idle.add (() => {
                    vk_btn.sensitive = true;
                    if (ok && reg) {
                        vk_status.label = _("Registered");
                        vk_status.remove_css_class ("warning");
                        vk_status.add_css_class ("success");
                    } else {
                        vk_status.label = _("Failed (need admin)");
                        vk_status.add_css_class ("error");
                    }
                    return false;
                });
            });
        });
        append (vk_status);
        append (vk_btn);
    }

    private bool is_mangohud_running () {
        try {
            int exit_status;
            string std_out, std_err;
            Process.spawn_sync (null,
                { get_sys_exe ("tasklist.exe"), "/FI", "IMAGENAME eq MangoHud.exe", "/NH", "/FO", "CSV" },
                null, (SpawnFlags) 0, null, out std_out, out std_err, out exit_status);
            return std_out.contains ("MangoHud.exe");
        } catch (Error e) { return false; }
    }

    public void sync_overlay_state () {
        if (is_mangohud_running ()) {
            start_btn.sensitive = false;
            stop_btn.sensitive = true;
            status_label.label = current_target != null
                ? _("Overlay running on: %s").printf (current_target)
                : _("Overlay running.");
            status_label.remove_css_class ("dim-label");
            status_label.add_css_class ("success");
        } else {
            start_btn.sensitive = true;
            stop_btn.sensitive = false;
            status_label.label = _("No overlay running.");
            status_label.remove_css_class ("success");
            status_label.add_css_class ("dim-label");
            current_target = null;
        }
    }

    private void refresh_processes () {
        var child = process_list_box.get_first_child ();
        while (child != null) {
            var next = child.get_next_sibling ();
            process_list_box.remove (child);
            child = next;
        }

        try {
            int exit_status;
            string std_out, std_err;
            Process.spawn_sync (null,
                { get_sys_exe ("tasklist.exe"), "/FO", "CSV", "/NH" },
                null, (SpawnFlags) 0, null, out std_out, out std_err, out exit_status);
            if (exit_status != 0) return;

            string[] skip = {
                "System", "svchost.exe", "csrss.exe", "wininit.exe",
                "services.exe", "lsass.exe", "smss.exe", "dwm.exe",
                "explorer.exe", "SearchHost.exe", "RuntimeBroker.exe",
                "ShellExperienceHost.exe", "sihost.exe", "taskhostw.exe",
                "ctfmon.exe", "conhost.exe", "cmd.exe", "powershell.exe",
                "WindowsTerminal.exe", "SecurityHealthSystray.exe",
                "TextInputHost.exe", "SystemSettings.exe",
                "ApplicationFrameHost.exe", "fontdrvhost.exe",
                "WmiPrvSE.exe", "spoolsv.exe", "dllhost.exe",
                "tasklist.exe", "mangojuice.exe", "MangoJuice.exe",
                "MangoHud.exe", "Code.exe", "msedge.exe",
                "chrome.exe", "firefox.exe", "Widgets.exe",
                "StartMenuExperienceHost.exe", "CompPkgSrv.exe",
                "audiodg.exe", "NVDisplay.Container.exe",
                "nvcontainer.exe", "SearchIndexer.exe",
                "MsMpEng.exe", "wscript.exe", "reg.exe",
            };

            var seen = new HashSet<string> ();
            foreach (string line in std_out.split ("\n")) {
                string trimmed = line.strip ();
                if (trimmed == "") continue;
                string[] parts = trimmed.split ("\",\"");
                if (parts.length < 2) continue;
                string name = parts[0].replace ("\"", "").strip ();
                if (name == "" || name == "Image Name") continue;

                bool should_skip = false;
                foreach (string s in skip) {
                    if (name == s) { should_skip = true; break; }
                }
                if (should_skip || seen.contains (name)) continue;
                seen.add (name);

                var row = new Adw.ActionRow ();
                row.title = name;
                process_list_box.append (row);
            }
        } catch (Error e) {
            stderr.printf ("Failed to list processes: %s\n", e.message);
        }
    }

    private string? get_selected_process () {
        var row = process_list_box.get_selected_row ();
        if (row == null) return null;
        var child = process_list_box.get_first_child ();
        while (child != null) {
            if (child == row) {
                var ar = child as Adw.ActionRow;
                if (ar != null) return ar.title;
            }
            child = child.get_next_sibling ();
        }
        return null;
    }

    private void on_start () {
        string? proc = get_selected_process ();
        if (proc == null) {
            show_error (_("No process selected"), _("Select a game from the list first."));
            return;
        }

        string mangohud = Path.build_filename (get_exe_directory (), "MangoHud.exe");
        if (!FileUtils.test (mangohud, FileTest.EXISTS)) {
            show_error (_("MangoHud.exe not found"), _("Expected at: %s").printf (mangohud));
            return;
        }

        // Launch elevated via VBScript ShellExecute runas
        try {
            string vbs = Path.build_filename (
                Environment.get_variable ("TEMP") ?? "C:\\Windows\\Temp",
                "mangohud_launch.vbs");
            FileUtils.set_contents (vbs,
                "Set s = CreateObject(\"Shell.Application\")\n" +
                "s.ShellExecute \"%s\", \"%s\", \"\", \"runas\", 1\n".printf (
                    mangohud.replace ("\\", "\\\\"), proc));
            Process.spawn_sync (null,
                { get_sys_exe ("wscript.exe"), vbs },
                null, (SpawnFlags) 0, null, null, null, null);

            current_target = proc;
            status_label.label = _("Starting overlay (accept UAC)...");
            start_btn.sensitive = false;

            Timeout.add (3000, () => { sync_overlay_state (); return false; });
        } catch (Error e) {
            show_error (_("Failed to start"), e.message);
        }
    }

    private void on_stop () {
        try {
            string vbs = Path.build_filename (
                Environment.get_variable ("TEMP") ?? "C:\\Windows\\Temp",
                "mangohud_stop.vbs");
            FileUtils.set_contents (vbs,
                "Set s = CreateObject(\"Shell.Application\")\n" +
                "s.ShellExecute \"%s\", \"/IM MangoHud.exe /F\", \"\", \"runas\", 0\n".printf (
                    get_sys_exe ("taskkill.exe").replace ("\\", "\\\\")));
            Process.spawn_sync (null,
                { get_sys_exe ("wscript.exe"), vbs },
                null, (SpawnFlags) 0, null, null, null, null);

            Timeout.add (1500, () => { sync_overlay_state (); return false; });
        } catch (Error e) {
            stderr.printf ("Failed to stop: %s\n", e.message);
        }
    }

    private void show_error (string title, string message) {
        var dlg = new Adw.AlertDialog (title, message);
        dlg.add_response ("ok", _("OK"));
        dlg.set_default_response ("ok");
        dlg.present (this.get_root () as Gtk.Window);
    }
}
