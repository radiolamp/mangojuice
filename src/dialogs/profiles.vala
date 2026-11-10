/* dialogs/profiles.vala // License: GPL-3.0+ */
using Gtk;
using Adw;
using MangoJuice;
using MangoJuice.Config;

namespace MangoJuice.Dialogs {

public class ProfileDialog : GLib.Object {

    MangoJuice.Application app;

    int profile_count = 0;

    public ProfileDialog (MangoJuice.Application app) {
        this.app = app;
    }

    delegate void DeleteCallback ();

    class DeleteCallbackHolder {
        public DeleteCallback cb;
        public DeleteCallbackHolder (owned DeleteCallback cb) {
            this.cb = (owned) cb;
        }
    }

    void update_group_state (Adw.PreferencesGroup group, Adw.StatusPage status_page) {
        if (profile_count == 0 && status_page.get_parent () == null) {
            group.add (status_page);
        } else if (profile_count > 0 && status_page.get_parent () != null) {
            group.remove (status_page);
        }
    }

    public void preset_dialog (Gtk.Window parent_window) {
        var dialog = new Adw.Dialog ();
        dialog.set_content_width (800);
        dialog.set_content_height (600);
        dialog.set_size_request (320, 240);

        var breakpoint_450px = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 450px"));
        dialog.add_breakpoint (breakpoint_450px);

        var toast_overlay = new Adw.ToastOverlay ();
        dialog.set_child (toast_overlay);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        toast_overlay.set_child (main_box);

        var window_handle = new Gtk.WindowHandle ();
        main_box.append (window_handle);

        var header_bar = new Adw.HeaderBar ();
        header_bar.set_show_start_title_buttons (true);
        header_bar.set_show_end_title_buttons (true);
        header_bar.add_css_class ("flat");
        main_box.append (header_bar);

        var info_button = new Gtk.Button ();
        info_button.set_icon_name ("dialog-information-symbolic");
        info_button.add_css_class ("circular");
        info_button.set_tooltip_text (_("To get ready presets, click on the title."));
        header_bar.pack_start (info_button);

        var popover = new Gtk.Popover ();
        var popover_label = new Gtk.Label (_("To get ready presets, click on the title."));
        popover.set_child (popover_label);
        popover.set_parent (info_button);

        info_button.clicked.connect (() => {
            popover.popup ();
        });

        var presets_button = new Gtk.Button ();
        presets_button.set_hexpand (true);
        presets_button.add_css_class ("flat");
        var button_content = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        button_content.set_halign (Gtk.Align.CENTER);
        var presets_label = new Gtk.Label (_("Presets"));
        var arrow_icon = new Gtk.Image.from_icon_name ("go-next-symbolic");
        button_content.append (presets_label);
        button_content.append (arrow_icon);
        presets_button.set_child (button_content);
        header_bar.set_title_widget (presets_button);

        var content_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        content_box.set_hexpand (true);
        content_box.set_vexpand (true);
        main_box.append (content_box);

        var clamp = new Adw.Clamp () {
            maximum_size = 800,
            tightening_threshold = 450,
            margin_top = 12,
            margin_bottom = 12
        };
        content_box.append (clamp);

        var clamped_content = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
        clamped_content.set_margin_start (24);
        clamped_content.set_margin_end (24);
        clamp.set_child (clamped_content);

        var group = new Adw.PreferencesGroup ();
        var status_page = new Adw.StatusPage () {
            title = _("No profiles yet"),
            icon_name = "emoji-symbols-symbolic"
        };
        status_page.add_css_class ("dim-label");
        status_page.set_vexpand (true);

        var add_button = new Gtk.Button.with_label (_("Add Profile"));
        add_button.set_size_request (-1, 40);

        add_button.clicked.connect (() => {
            var row = add_option_button (group, toast_overlay, breakpoint_450px, () => {
                profile_count--;
                update_group_state (group, status_page);
            });
            group.add (row);
            profile_count++;
            update_group_state (group, status_page);
        });

        try {
            var config_dir = app.paths.mangohud_dir;

            if (config_dir.query_exists ()) {
                var enumerator = config_dir.enumerate_children (FileAttribute.STANDARD_NAME, 0);
                FileInfo info;
                var profiles = new GLib.List<string> ();

                try {
                    while ((info = enumerator.next_file ()) != null) {
                        string name = info.get_name ();
                        if (name.has_suffix (".conf") && name.length > 5
                            && name != "MangoHud.conf" && name != ".MangoHud.backup") {
                            string profile_name = name[0:-5].replace ("-", " ");
                            profiles.append (profile_name);
                        }
                    }
                } finally {
                    try {
                        enumerator.close ();
                    } catch (Error e) {
                        warning ("Failed to close profiles directory: %s", e.message);
                    }
                }

                profiles.sort ((a, b) => {
                    return a.collate (b);
                });

                foreach (string profile_name in profiles) {
                    var row = add_option_button (group, toast_overlay, breakpoint_450px, () => {
                        profile_count--;
                        update_group_state (group, status_page);
                    }, profile_name, true);
                    group.add (row);
                    profile_count++;
                }
            }
        } catch (Error e) {
            warning ("Error loading profiles: %s", e.message);
        }

        update_group_state (group, status_page);

        var scrolled = new Gtk.ScrolledWindow ();
        scrolled.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);

        var profile_container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        profile_container.set_margin_top (2);
        profile_container.set_margin_bottom (2);
        profile_container.set_margin_start (2);
        profile_container.set_margin_end (2);
        profile_container.append (group);

        scrolled.set_child (profile_container);
        scrolled.set_vexpand (true);
        clamped_content.append (scrolled);
        clamped_content.append (add_button);

        presets_button.clicked.connect (() => {
            app.presets_dialog.show_presets_carousel_dialog (dialog);
        });

        dialog.closed.connect (() => {
            app.test_runner.stop_test_app ();
        });

        dialog.present (parent_window);
    }

    bool check_if_profile_active_simple (string profile_name) {
        try {
            string profile_filename = profile_name.replace (" ", "-") + ".conf";
            var active_file = app.paths.mangohud_conf;
            if (!active_file.query_exists ()) {
                return false;
            }

            var dis = new DataInputStream (active_file.read ());
            try {
                string? first_line = dis.read_line (null);
                return first_line != null && first_line.contains (profile_filename);
            } finally {
                try {
                    dis.close ();
                } catch (Error e) {
                    warning ("Failed to close active config: %s", e.message);
                }
            }
        } catch (Error e) {
            warning ("Failed to check if profile is active: %s", e.message);
            return false;
        }
    }

    Adw.ActionRow? currently_selected_row = null;
    Gtk.Button? currently_playing_button = null;

    void run_preview_impl (string profile_name) {
        app.saver.flush_all_pending ();
        string config_path = app.paths.profile_path (profile_name);
        app.test_runner.run_vkcube_with_profile (config_path);
    }

    void do_edit_impl (Gtk.Entry entry, Adw.ActionRow row, string profile_name) {
        entry.set_text (profile_name);
        row.set_title ("");
        entry.set_visible (true);
        entry.grab_focus ();

        if (currently_selected_row != null && currently_selected_row != row) {
            currently_selected_row.remove_css_class ("selected");
        }
        row.add_css_class ("selected");
        currently_selected_row = row;
    }

    void do_reset_impl (string profile_name, Adw.ToastOverlay toast_overlay) {
        try {
            var original_config = app.paths.mangohud_conf;
            var profile_config = app.paths.profile_file (profile_name);

            if (original_config.query_exists ()) {
                original_config.copy (profile_config, FileCopyFlags.OVERWRITE);
            }

            var toast = new Adw.Toast (_("Changed"));
            toast.set_timeout (3);
            toast_overlay.add_toast (toast);
        } catch (Error e) {
            warning ("Failed to reset profile: %s", e.message);
        }
    }

    void do_delete_impl (
        Gtk.Button play_btn, Adw.ActionRow row, string profile_name,
        Adw.PreferencesGroup group, DeleteCallback on_delete, Adw.ToastOverlay toast_overlay
    ) {
        if (currently_playing_button == play_btn) {
            currently_playing_button = null;
        }

        if (currently_selected_row == row) {
            currently_selected_row.remove_css_class ("selected");
            currently_selected_row = null;
        }
        delete_profile_config (profile_name);
        group.remove (row);
        on_delete ();
        var toast = new Adw.Toast (_("Deleted"));
        toast.set_timeout (3);
        toast_overlay.add_toast (toast);
    }

    static bool is_valid_profile_name (string name) {
        return name != ""
            && name != "."
            && name != ".."
            && !name.contains ("/")
            && !name.contains ("\\");
    }

    Adw.ActionRow add_option_button (
        Adw.PreferencesGroup group,
        Adw.ToastOverlay toast_overlay,
        Adw.Breakpoint breakpoint,
        owned DeleteCallback on_delete,
        string initial_name = _("Profile"), bool is_existing_profile = false
    ) {
        string profile_name = initial_name;

        if (!is_existing_profile) {
            if (profile_name.has_suffix (".exe") && profile_name.length > 4) {
                profile_name = "wine-" + profile_name.substring (0, profile_name.length - 4);
            } else if (initial_name == _("Profile")) {
                profile_name = generate_unique_profile_name (initial_name);
            }
            create_profile_config (profile_name);
        }

        var cb_holder = new DeleteCallbackHolder ((owned) on_delete);
        unowned DeleteCallback del = cb_holder.cb;

        var row = new Adw.ActionRow ();
        row.set_title (profile_name);
        row.set_selectable (false);
        row.set_tooltip_text (_("Profile preview"));

        var play_btn = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
        play_btn.add_css_class ("flat");
        play_btn.add_css_class ("circular");
        play_btn.set_tooltip_text (_("Apply the profile to the entire system"));
        play_btn.set_valign (Gtk.Align.CENTER);

        var edit_btn = new Gtk.Button ();
        edit_btn.set_icon_name ("document-edit-symbolic");
        edit_btn.set_focusable (false);
        edit_btn.add_css_class ("flat");
        edit_btn.add_css_class ("circular");
        edit_btn.set_tooltip_text (
            _("Renaming. Name the name of the game, or name.exe for Wine games,")
            + _(" e.g. DOOM.exe. Attention case is important!")
        );
        edit_btn.set_valign (Gtk.Align.CENTER);

        var preview_btn = new Gtk.Button ();
        preview_btn.set_icon_name ("view-reveal-symbolic");
        preview_btn.set_focusable (false);
        preview_btn.add_css_class ("flat");
        preview_btn.add_css_class ("circular");
        preview_btn.set_tooltip_text (_("Profile preview"));
        preview_btn.set_valign (Gtk.Align.CENTER);

        var reset_btn = new Gtk.Button ();
        reset_btn.set_icon_name ("view-refresh-symbolic");
        reset_btn.set_focusable (false);
        reset_btn.add_css_class ("flat");
        reset_btn.add_css_class ("circular");
        reset_btn.set_tooltip_text (_("Overwrite profile"));
        reset_btn.set_valign (Gtk.Align.CENTER);

        var close_btn = new Gtk.Button ();
        close_btn.set_icon_name ("edit-delete-symbolic");
        close_btn.set_focusable (false);
        close_btn.add_css_class ("flat");
        close_btn.add_css_class ("circular");
        close_btn.set_tooltip_text (_("Delete profile"));
        close_btn.set_valign (Gtk.Align.CENTER);

        var menu_btn = new Gtk.MenuButton ();
        menu_btn.set_icon_name ("view-more-symbolic");
        menu_btn.set_focusable (false);
        menu_btn.add_css_class ("flat");
        menu_btn.add_css_class ("circular");
        menu_btn.set_tooltip_text (_("Options"));
        menu_btn.set_valign (Gtk.Align.CENTER);
        menu_btn.set_visible (false);

        var menu_popover = new Gtk.Popover ();
        var menu_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        menu_box.set_margin_top (6);
        menu_box.set_margin_bottom (6);
        menu_box.set_margin_start (6);
        menu_box.set_margin_end (6);
        menu_popover.set_child (menu_box);
        menu_btn.set_property ("popover", menu_popover);

        var btn_preview = new Gtk.Button.with_label (_("Preview"));
        btn_preview.set_icon_name ("view-reveal-symbolic");
        btn_preview.add_css_class ("flat");
        btn_preview.set_hexpand (true);
        menu_box.append (btn_preview);

        var btn_edit = new Gtk.Button.with_label (_("Rename"));
        btn_edit.set_icon_name ("document-edit-symbolic");
        btn_edit.add_css_class ("flat");
        btn_edit.set_hexpand (true);
        menu_box.append (btn_edit);

        var btn_reset = new Gtk.Button.with_label (_("Overwrite"));
        btn_reset.set_icon_name ("view-refresh-symbolic");
        btn_reset.add_css_class ("flat");
        btn_reset.set_hexpand (true);
        menu_box.append (btn_reset);

        var btn_delete = new Gtk.Button.with_label (_("Delete"));
        btn_delete.set_icon_name ("edit-delete-symbolic");
        btn_delete.add_css_class ("flat");
        btn_delete.add_css_class ("destructive-action");
        btn_delete.set_hexpand (true);
        menu_box.append (btn_delete);

        bool is_active_profile = check_if_profile_active_simple (profile_name);
        if (is_active_profile) {
            play_btn.add_css_class ("accent");
            play_btn.remove_css_class ("flat");
            currently_playing_button = play_btn;
        }

        var entry = new Gtk.Entry ();
        entry.set_text (profile_name);
        entry.set_visible (false);
        entry.set_hexpand (true);
        entry.set_valign (Gtk.Align.CENTER);

        row.add_prefix (entry);
        row.add_prefix (play_btn);

        var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
        button_box.append (preview_btn);
        button_box.append (edit_btn);
        button_box.append (reset_btn);
        button_box.append (close_btn);
        button_box.append (menu_btn);
        row.add_suffix (button_box);

        breakpoint.add_setter (preview_btn, "visible", false);
        breakpoint.add_setter (edit_btn, "visible", false);
        breakpoint.add_setter (reset_btn, "visible", false);
        breakpoint.add_setter (close_btn, "visible", false);
        breakpoint.add_setter (menu_btn, "visible", true);

        btn_preview.clicked.connect (() => {
            menu_popover.popdown ();
            run_preview_impl (profile_name);
        });

        btn_edit.clicked.connect (() => {
            menu_popover.popdown ();
            do_edit_impl (entry, row, profile_name);
        });

        btn_reset.clicked.connect (() => {
            menu_popover.popdown ();
            do_reset_impl (profile_name, toast_overlay);
        });

        btn_delete.clicked.connect (() => {
            menu_popover.popdown ();
            do_delete_impl (play_btn, row, profile_name, group, del, toast_overlay);
        });

        play_btn.clicked.connect (() => {
            if (currently_playing_button != null) {
                currently_playing_button.remove_css_class ("accent");
                currently_playing_button.add_css_class ("flat");
            }

            app.run_test ();
            apply_profile_config (profile_name);
            app.loader.load.begin ();
            app.reset_manager.reset_all_widgets ();

            play_btn.add_css_class ("accent");
            play_btn.remove_css_class ("flat");
            currently_playing_button = play_btn;

            var toast = new Adw.Toast (_("Applied"));
            toast.set_timeout (3);
            toast_overlay.add_toast (toast);

            if (currently_selected_row == row) {
                row.remove_css_class ("selected");
                currently_selected_row = null;
            }
        });

        if (!is_existing_profile) {
            Timeout.add (100, () => {
                entry.set_text (profile_name);
                row.set_title ("");
                entry.set_visible (true);
                entry.grab_focus ();

                if (currently_selected_row != null && currently_selected_row != row) {
                    currently_selected_row.remove_css_class ("selected");
                }
                row.add_css_class ("selected");
                currently_selected_row = row;

                return false;
            });
        }

        entry.activate.connect (() => {
            string new_name = entry.get_text ().strip ();

            if (new_name.has_suffix (".exe") && new_name.length > 4) {
                new_name = "wine " + new_name.substring (0, new_name.length - 4);
            }

            if (new_name != "" && new_name != profile_name) {
                if (!is_valid_profile_name (new_name)) {
                    var toast = new Adw.Toast (_("Invalid profile name"));
                    toast.set_timeout (3);
                    toast_overlay.add_toast (toast);
                    entry.set_text (profile_name);
                } else {
                    rename_profile_config (profile_name, new_name);
                    profile_name = new_name;

                    if (currently_playing_button == play_btn) {
                        play_btn.add_css_class ("destructive-action");
                    } else {
                        play_btn.remove_css_class ("destructive-action");
                    }
                }
            }

            entry.set_visible (false);
            row.set_title (profile_name);

            if (currently_selected_row != null && currently_selected_row != row) {
                currently_selected_row.remove_css_class ("selected");
            }
            row.add_css_class ("selected");
            currently_selected_row = row;
        });

        var focus_controller = new Gtk.EventControllerFocus ();
        focus_controller.leave.connect (() => {
            if (entry.get_visible ()) {
                entry.activate ();
            }
        });
        entry.add_controller (focus_controller);

        preview_btn.clicked.connect (() => run_preview_impl (profile_name));
        edit_btn.clicked.connect (() => do_edit_impl (entry, row, profile_name));
        reset_btn.clicked.connect (() => do_reset_impl (profile_name, toast_overlay));
        close_btn.clicked.connect (() => do_delete_impl (play_btn, row, profile_name, group, del, toast_overlay));

        return row;
    }

    string generate_unique_profile_name (string base_name) {
        string name = base_name;
        int counter = 1;

        while (true) {
            if (!app.paths.profile_file (name).query_exists ()) {
                break;
            }

            name = @"$base_name $counter";
            counter++;
        }

        return name;
    }

    void create_profile_config (string profile_name) {
        if (!is_valid_profile_name (profile_name)) {
            warning ("Invalid profile name: %s", profile_name);
            return;
        }

        try {
            var original_config = app.paths.mangohud_conf;
            var new_config = app.paths.profile_file (profile_name);
            if (original_config.query_exists ()) {
                original_config.copy (new_config, FileCopyFlags.OVERWRITE);
            }
        } catch (Error e) {
            warning ("Failed to create profile: %s", e.message);
        }
    }

    void rename_profile_config (string old_name, string new_name) {
        if (!is_valid_profile_name (old_name) || !is_valid_profile_name (new_name)) {
            warning ("Invalid profile name");
            return;
        }

        try {
            var old_file = app.paths.profile_file (old_name);
            var new_file = app.paths.profile_file (new_name);
            if (old_file.query_exists ()) {
                old_file.move (new_file, FileCopyFlags.OVERWRITE);
            }
        } catch (Error e) {
            warning ("Failed to rename profile: %s", e.message);
        }
    }

    void delete_profile_config (string profile_name) {
        if (!is_valid_profile_name (profile_name)) {
            warning ("Invalid profile name: %s", profile_name);
            return;
        }

        try {
            var file = app.paths.profile_file (profile_name);
            if (file.query_exists ()) {
                file.delete ();
            }
        } catch (Error e) {
            warning ("Failed to delete profile: %s", e.message);
        }
    }

    void apply_profile_config (string profile_name) {
        if (!is_valid_profile_name (profile_name)) {
            warning ("Invalid profile name: %s", profile_name);
            return;
        }

        try {
            var profile_file = app.paths.profile_file (profile_name);
            var target_file = app.paths.mangohud_conf;
            if (profile_file.query_exists ()) {
                profile_file.copy (target_file, FileCopyFlags.OVERWRITE);
                add_profile_comment_to_file (target_file, profile_name);
            }
        } catch (Error e) {
            warning ("Failed to apply profile: %s", e.message);
        }
    }

    void add_profile_comment_to_file (File file, string profile_name) {
        try {
            var temp_file = File.new_for_path (file.get_path () + ".tmp");
            var output = new DataOutputStream (temp_file.create (FileCreateFlags.REPLACE_DESTINATION));

            try {
                output.put_string ("# Active profile: " + profile_name.replace (" ", "-") + ".conf\n");

                var input = new DataInputStream (file.read ());
                try {
                    string? line;
                    while ((line = input.read_line (null)) != null) {
                        if (!line.has_prefix ("# Active profile:")) {
                            output.put_string (line + "\n");
                        }
                    }
                } finally {
                    try {
                        input.close ();
                    } catch (Error e) {
                        warning ("Failed to close profile config: %s", e.message);
                    }
                }
            } finally {
                try {
                    output.close ();
                } catch (Error e) {
                    warning ("Failed to close temporary profile config: %s", e.message);
                }
            }

            temp_file.move (file, FileCopyFlags.OVERWRITE);
        } catch (Error e) {
            warning ("Failed to add profile comment: %s", e.message);
        }
    }

}

}
