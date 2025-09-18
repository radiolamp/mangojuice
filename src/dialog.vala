/* dialog  // Licence:  GPL-v3.0 */
using Gtk;
using Adw;

namespace AboutDialog {

    public void show_about_dialog (Gtk.Window parent_window) {

        const string[] developers = {
            "Radiolamp https://github.com/radiolamp",
            "Rirusha https://rirusha.space",
            "Boria138 https://github.com/Boria138",
            "SpikedPaladin https://github.com/SpikedPaladin",
            "slserg https://github.com/slserg",
            "Samueru-sama https://github.com/Samueru-sama",
            "x1z53 https://gitverse.ru/x1z53"
        };

        var dialog = new Adw.AboutDialog.from_appdata (
            "/io/github/radiolamp/mangojuice/io.github.radiolamp.mangojuice.metainfo.xml",
            null
        );

        dialog.application_icon = "io.github.radiolamp.mangojuice";
        dialog.version = Config.VERSION;
        dialog.translator_credits = _("translator-credits");
        dialog.set_developers(developers);
        dialog.present (parent_window);
    }

    public async void show_support_dialog (Gtk.Window parent_window) {
        var dialog = new Adw.Dialog();
        dialog.set_title(_("Support the Project"));
        dialog.set_content_width(560);
        dialog.set_content_height(480);
        
        var scrolled_window = new Gtk.ScrolledWindow();
        scrolled_window.set_hexpand(true);
        scrolled_window.set_vexpand(true);
        scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        dialog.set_child(scrolled_window);
        
        var main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        scrolled_window.set_child(main_box);
        
        var header_bar = new Adw.HeaderBar();
        header_bar.set_show_start_title_buttons(false);
        header_bar.set_show_end_title_buttons(true);
        header_bar.add_css_class("flat");
        main_box.append(header_bar);
    
        var icon_container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        icon_container.set_halign(Gtk.Align.CENTER);
        icon_container.set_vexpand(true);
        main_box.append(icon_container);
        
        var app_icon = new Gtk.Image.from_icon_name("io.github.radiolamp.mangojuice");
        app_icon.set_pixel_size(150);
        app_icon.set_halign(Gtk.Align.CENTER);
        icon_container.append(app_icon);
        
        var description_label = new Gtk.Label(_("Your support helps us continue developing and improving MangoJuice. Choose your preferred method:"));
        description_label.set_wrap(true);
        description_label.set_halign(Gtk.Align.CENTER);
        description_label.add_css_class("heading");
        description_label.set_margin_top(24);
        description_label.set_margin_bottom(48);
        description_label.set_margin_start(24);
        description_label.set_margin_end(24);
        main_box.append(description_label);
        
        var flow_box = new Gtk.FlowBox();
        flow_box.set_selection_mode(Gtk.SelectionMode.NONE);
        flow_box.set_max_children_per_line(3);
        flow_box.set_min_children_per_line(1);
        flow_box.set_column_spacing(12);
        flow_box.set_row_spacing(12);
        flow_box.set_halign(Gtk.Align.CENTER);
        flow_box.set_valign(Gtk.Align.CENTER);
        flow_box.set_vexpand(true);
        flow_box.set_homogeneous (true);
        flow_box.set_margin_start(24);
        flow_box.set_margin_end(24);
        SourceFunc callback = null;
        bool dialog_closed = false;
        
        dialog.closed.connect(() => {
            dialog_closed = true;
            if (callback != null) {
                callback();
            }
        });
        
        var donation_alerts_btn = new Gtk.Button.with_label(_("Donation Alerts"));
        donation_alerts_btn.set_tooltip_text("https://www.donationalerts.com/r/radiolamp");
        donation_alerts_btn.clicked.connect(() => {
            var launcher = new Gtk.UriLauncher("https://www.donationalerts.com/r/radiolamp");
            launcher.launch.begin(parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end(res);
                } catch (Error e) {
                    warning("Failed to open Donation Alerts: %s", e.message);
                }
            });
        });
        
        var boosty_btn = new Gtk.Button.with_label(_("Boosty"));
        boosty_btn.set_tooltip_text("https://boosty.to/radiolamp");
        boosty_btn.clicked.connect(() => {
            var launcher = new Gtk.UriLauncher("https://boosty.to/radiolamp");
            launcher.launch.begin(parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end(res);
                } catch (Error e) {
                    warning("Failed to open Boosty: %s", e.message);
                }
            });
        });

        var tinkoff_btn = new Gtk.Button.with_label(_("Tinkoff"));
        tinkoff_btn.set_tooltip_text("https://www.tbank.ru/cf/3PPTstulqEq");
        tinkoff_btn.clicked.connect(() => {
            var launcher = new Gtk.UriLauncher("https://www.tbank.ru/cf/3PPTstulqEq");
            launcher.launch.begin(parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end(res);
                } catch (Error e) {
                    warning("Failed to open Tinkoff: %s", e.message);
                }
            });
        });

        var ymoney_btn = new Gtk.Button.with_label(_("ЮMoney (Мир)"));
        ymoney_btn.set_tooltip_text("https://yoomoney.ru/fundraise/1CRVAISSLRB.250918");
        ymoney_btn.clicked.connect(() => {
            var launcher = new Gtk.UriLauncher("https://yoomoney.ru/fundraise/1CRVAISSLRB.250918");
            launcher.launch.begin(parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end(res);
                } catch (Error e) {
                    warning("Failed to open ЮMoney: %s", e.message);
                }
            });
        });

        var sber_btn = new Gtk.Button.with_label(_("Sber (Мир)"));
        sber_btn.set_tooltip_text("https://messenger.online.sberbank.ru/sl/eIrNTQ3a1dCLQ8gxL");
        sber_btn.clicked.connect(() => {
            var launcher = new Gtk.UriLauncher("https://messenger.online.sberbank.ru/sl/eIrNTQ3a1dCLQ8gxL");
            launcher.launch.begin(parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end(res);
                } catch (Error e) {
                    warning("Failed to open Sber: %s", e.message);
                }
            });
        });

        var telegram_btn = new Gtk.Button.with_label(_("Telegram (TON)"));
        telegram_btn.set_tooltip_text(_("Click to copy the wallet number"));
        telegram_btn.clicked.connect(() => {
            var clipboard = Gdk.Display.get_default().get_clipboard();
            clipboard.set_text("UQCHkkZx3UT_8A-tAI8Zlu6iuX5WsBYLa0JVC7SK8PfJ3Rqf");
            string original_text = telegram_btn.get_label();
            telegram_btn.set_label(_("Copied"));
            Timeout.add_seconds(1, () => {
                telegram_btn.set_label(original_text);
                return false;
            });
        });
        
        var donation_child = new Gtk.FlowBoxChild();
        donation_child.set_child(donation_alerts_btn);
        
        var tinkoff_child = new Gtk.FlowBoxChild();
        tinkoff_child.set_child(tinkoff_btn);
        
        var boosty_child = new Gtk.FlowBoxChild();
        boosty_child.set_child(boosty_btn);

        var ymoney_child = new Gtk.FlowBoxChild();
        ymoney_child.set_child(ymoney_btn);

        var telegram_child = new Gtk.FlowBoxChild();
        telegram_child.set_child(telegram_btn);

        var sber_child = new Gtk.FlowBoxChild();
        sber_child.set_child(sber_btn);
        
        flow_box.append(donation_child);
        flow_box.append(boosty_child);
        flow_box.append(ymoney_child);
        flow_box.append(tinkoff_child);
        flow_box.append(telegram_child);
        flow_box.append(sber_child);
        
        main_box.append(flow_box);
        
        var spacer = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        spacer.set_hexpand(true);
        spacer.set_vexpand(true);
        main_box.append(spacer);
        
        var thanks_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
        thanks_box.set_halign(Gtk.Align.CENTER);
        thanks_box.set_margin_bottom(24);
        thanks_box.set_margin_top(24);
        
        var thanks_label = new Gtk.Label(_("Thank you for your support!"));
        thanks_label.add_css_class("dim-label");
        
        var heart_icon = new Gtk.Image.from_icon_name("io.github.radiolamp.mangojuice.donate-symbolic");
        heart_icon.add_css_class("love-hover");
        heart_icon.set_pixel_size(16);
        
        thanks_box.append(thanks_label);
        thanks_box.append(heart_icon);
        
        main_box.append(thanks_box);
    
        dialog.present(parent_window);
    
        Timeout.add(500, () => {
            icon_container.add_css_class("wobble-animation");
            return Source.REMOVE;
        });
        
        while (!dialog_closed) {
            callback = show_support_dialog.callback;
            yield;
        }
    }

    int profile_count = 0;

    delegate void DeleteCallback();

    void update_group_state(Adw.PreferencesGroup group, Adw.StatusPage status_page) {
        if (profile_count == 0 && status_page.get_parent() == null) {
            group.add(status_page);
        } else if (profile_count > 0 && status_page.get_parent() != null) {
            group.remove(status_page);
        }
    }

    public void preset_dialog(Gtk.Window parent_window, MangoJuice app) {
        var dialog = new Adw.Dialog();
        dialog.set_content_width(800);
        dialog.set_content_height(600);
        dialog.set_size_request(320, 240);
    
        var breakpoint_450px = new Adw.Breakpoint(Adw.BreakpointCondition.parse("max-width: 450px"));
        dialog.add_breakpoint(breakpoint_450px);
    
        var toast_overlay = new Adw.ToastOverlay();
        dialog.set_child(toast_overlay);
    
        var main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        toast_overlay.set_child(main_box);
    
        var window_handle = new Gtk.WindowHandle();
        main_box.append(window_handle);
    
        var header_bar = new Adw.HeaderBar();
        header_bar.set_show_start_title_buttons(true);
        header_bar.set_show_end_title_buttons(true);
        header_bar.add_css_class("flat");
        main_box.append(header_bar);
    
        var info_button = new Gtk.Button();
        info_button.set_icon_name("dialog-information-symbolic");
        info_button.add_css_class("circular");
        info_button.set_tooltip_text(_("To get ready presets, click on the title."));
        header_bar.pack_start(info_button);
        
        var popover = new Gtk.Popover();
        var popover_label = new Gtk.Label(_("To get ready presets, click on the title."));
        popover.set_child(popover_label);
        popover.set_parent(info_button);
        
        info_button.clicked.connect(() => {
            popover.popup();
        });
    
        var presets_button = new Gtk.Button();
        presets_button.set_hexpand(true);
        presets_button.add_css_class("flat");
        var button_content = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
        button_content.set_halign(Gtk.Align.CENTER);
        var presets_label = new Gtk.Label(_("Presets"));
        var arrow_icon = new Gtk.Image.from_icon_name("go-next-symbolic");
        button_content.append(presets_label);
        button_content.append(arrow_icon);
        presets_button.set_child(button_content);
        header_bar.set_title_widget(presets_button);
    
        var content_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        content_box.set_hexpand(true);
        content_box.set_vexpand(true);
        main_box.append(content_box);
    
        var clamp = new Adw.Clamp() {
            maximum_size = 800,
            tightening_threshold = 450,
            margin_top = 12,
            margin_bottom = 12
        };
        content_box.append(clamp);
    
        var clamped_content = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);
        clamped_content.set_margin_start(24);
        clamped_content.set_margin_end(24);
        clamp.set_child(clamped_content);
    
        var group = new Adw.PreferencesGroup();
        var status_page = new Adw.StatusPage() {
            title = _("No profiles yet"),
            icon_name = "emoji-symbols-symbolic"
        };
        status_page.add_css_class("dim-label");
        status_page.set_vexpand(true);
    
        var add_button = new Gtk.Button.with_label(_("Add Profile"));
        add_button.set_size_request(-1, 40);
    
        add_button.clicked.connect(() => {
            var row = add_option_button(group, app, toast_overlay, () => {
                profile_count--;
                update_group_state(group, status_page);
            });
            group.add(row);
            profile_count++;
            update_group_state(group, status_page);
        });
    
        try {
            var config_dir = File.new_for_path(Environment.get_home_dir())
                .get_child(".config")
                .get_child("MangoHud");
    
            if (config_dir.query_exists()) {
                var enumerator = config_dir.enumerate_children(FileAttribute.STANDARD_NAME, 0);
                FileInfo info;
                var profiles = new GLib.List<string>();
    
                while ((info = enumerator.next_file()) != null) {
                    string name = info.get_name();
                    if (name.has_suffix(".conf") && name != "MangoHud.conf" && name != ".MangoHud.backup") {
                        string profile_name = name[0:-5].replace("-", " ");
                        profiles.append(profile_name);
                    }
                }
    
                profiles.sort((a, b) => {
                    return a.collate(b);
                });
    
                foreach (string profile_name in profiles) {
                    var row = add_option_button(group, app, toast_overlay, () => {
                        profile_count--;
                        update_group_state(group, status_page);
                    }, profile_name, true);
                    group.add(row);
                    profile_count++;
                }
            }
        } catch (Error e) {
            warning("Error loading profiles: %s", e.message);
        }
    
        update_group_state(group, status_page);
    
        var scrolled = new Gtk.ScrolledWindow();
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
    
        var profile_container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        profile_container.set_margin_top(2);
        profile_container.set_margin_bottom(2);
        profile_container.set_margin_start(2);
        profile_container.set_margin_end(2);
        profile_container.append(group);
    
        scrolled.set_child(profile_container);
        scrolled.set_vexpand(true);
        clamped_content.append(scrolled);
        clamped_content.append(add_button);
    
        presets_button.clicked.connect(() => {
            show_presets_carousel_dialog((Gtk.Window)dialog, app);
        });
    
        dialog.closed.connect(() => {
            try {
                Process.spawn_command_line_async("pkill vkcube");
                Process.spawn_command_line_async("pkill glxgears");
            } catch (Error e) {
                stderr.printf(_("Error when executing the command: %s\n"), e.message);
            }
        });
    
        dialog.present(parent_window);
    }

    static Adw.ActionRow? currently_selected_row = null;
    
    Adw.ActionRow add_option_button(Adw.PreferencesGroup group, MangoJuice app, Adw.ToastOverlay toast_overlay, owned DeleteCallback on_delete, string initial_name = _("Profile"), bool is_existing_profile = false) {
        string profile_name = initial_name;
        
        if (!is_existing_profile) {
            if (profile_name.has_suffix(".exe")) {
                profile_name = "wine-" + profile_name.substring(0, profile_name.length - 4);
            } else if (initial_name == _("Profile")) {
                profile_name = generate_unique_profile_name(initial_name);
            }
            create_profile_config(profile_name);
        }
        
        var row = new Adw.ActionRow();
        row.set_title(profile_name);
        row.set_activatable(true);
        row.set_selectable(false);
        row.set_tooltip_text(_("Profile preview"));
        row.add_css_class("profile-row");
        
        var edit_btn = new Gtk.Button();
        edit_btn.set_icon_name("document-edit-symbolic");
        edit_btn.set_focusable(false);
        edit_btn.add_css_class("flat");
        edit_btn.add_css_class("circular");
        edit_btn.set_tooltip_text(_("Renaming. Name the name of the game, or name.exe for Wine games, e.g. DOOM.exe. Attention case is important!"));
        edit_btn.set_valign(Gtk.Align.CENTER);
        
        var reset_btn = new Gtk.Button();
        reset_btn.set_icon_name("view-refresh-symbolic");
        reset_btn.set_focusable(false);
        reset_btn.add_css_class("flat");
        reset_btn.add_css_class("circular");
        reset_btn.set_tooltip_text(_("Overwrite profile"));
        reset_btn.set_valign(Gtk.Align.CENTER);
        
        var close_btn = new Gtk.Button();
        close_btn.set_icon_name("edit-delete-symbolic");
        close_btn.set_focusable(false);
        close_btn.add_css_class("flat");
        close_btn.set_tooltip_text(_("Delete profile"));
        close_btn.set_valign(Gtk.Align.CENTER);
        close_btn.add_css_class("circular");
        
        var button_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);
        button_box.append(edit_btn);
        button_box.append(reset_btn);
        button_box.append(close_btn);
        row.add_suffix(button_box);
        
        var entry = new Gtk.Entry();
        entry.set_text(profile_name);
        entry.set_visible(false);
        entry.set_hexpand(true);
        entry.set_valign(Gtk.Align.CENTER);
        row.add_prefix(entry);
        
        edit_btn.clicked.connect(() => {
            entry.set_text(profile_name);
            row.set_title("");
            entry.set_visible(true);
            entry.grab_focus();
    
            if (currently_selected_row != null && currently_selected_row != row) {
                currently_selected_row.remove_css_class("selected");
            }
            row.add_css_class("selected");
            currently_selected_row = row;
        });
    
        if (!is_existing_profile) {
            Timeout.add(100, () => {
                entry.set_text(profile_name);
                row.set_title("");
                entry.set_visible(true);
                entry.grab_focus();
    
                if (currently_selected_row != null && currently_selected_row != row) {
                    currently_selected_row.remove_css_class("selected");
                }
                row.add_css_class("selected");
                currently_selected_row = row;
                
                return false;
            });
        }
        
        reset_btn.clicked.connect(() => {
            try {
                var config_dir = File.new_for_path(Environment.get_home_dir())
                    .get_child(".config")
                    .get_child("MangoHud");
    
                var original_config = config_dir.get_child("MangoHud.conf");
                var profile_config = config_dir.get_child(
                    profile_name.replace(" ", "-") + ".conf"
                );
    
                if (original_config.query_exists()) {
                    original_config.copy(profile_config, FileCopyFlags.OVERWRITE);
                }
    
                var toast = new Adw.Toast(_("Changed"));
                toast.set_timeout(3);
                toast_overlay.add_toast(toast);
            } catch (Error e) {
                warning("Failed to reset profile: %s", e.message);
            }
        });
        
        entry.activate.connect(() => {
            string new_name = entry.get_text().strip();
    
            if (new_name.has_suffix(".exe")) {
                new_name = "wine " + new_name.substring(0, new_name.length - 4);
            }
    
            if (new_name != "" && new_name != profile_name) {
                rename_profile_config(profile_name, new_name);
                profile_name = new_name;
            }
    
            entry.set_visible(false);
            row.set_title(profile_name);
    
            if (currently_selected_row != null && currently_selected_row != row) {
                currently_selected_row.remove_css_class("selected");
            }
            row.add_css_class("selected");
            currently_selected_row = row;
        });
        
        var play_btn = new Gtk.Button.from_icon_name("media-playback-start-symbolic");
        play_btn.add_css_class("flat");
        play_btn.set_tooltip_text(_("Apply the profile to the entire system"));
        play_btn.set_valign(Gtk.Align.CENTER);
        play_btn.add_css_class("circular");
        play_btn.clicked.connect(() => {
            app.run_test();
            apply_profile_config(profile_name);
            LoadStates.load_states_from_file.begin(app);
            app.reset_manager.reset_all_widgets();
            
            var toast = new Adw.Toast(_("Applied"));
            toast.set_timeout(3);
            toast_overlay.add_toast(toast);
            if (currently_selected_row == row) {
                row.remove_css_class("selected");
                currently_selected_row = null;
            }
        });
        row.add_prefix(play_btn);
        
        var focus_controller = new Gtk.EventControllerFocus();
        focus_controller.leave.connect(() => {
            if (entry.get_visible()) {
                entry.activate();
            }
        });
        entry.add_controller(focus_controller);
        
        close_btn.clicked.connect(() => {
            if (currently_selected_row == row) {
                currently_selected_row.remove_css_class("selected");
                currently_selected_row = null;
            }
            delete_profile_config(profile_name);
            group.remove(row);
            on_delete();
            var toast = new Adw.Toast(_("Deleted"));
            toast.set_timeout(3);
            toast_overlay.add_toast(toast);
        });
        
        string? wayland_display = Environment.get_variable("WAYLAND_DISPLAY");
        bool is_wayland = (wayland_display != null && wayland_display != "");
        
        row.activated.connect(() => {
            if (currently_selected_row != null && currently_selected_row != row) {
                currently_selected_row.remove_css_class("selected");
            }
            row.add_css_class("selected");
            currently_selected_row = row;
            
            try {
                Process.spawn_command_line_async("pkill vkcube");
                Process.spawn_command_line_async("pkill glxgears");
                SaveStates.reset_config_file_cache();
                string config_path = Path.build_filename(
                    Environment.get_home_dir(),
                    ".config",
                    "MangoHud",
                    profile_name.replace(" ", "-") + ".conf"
                );
    
                string base_cmd = @"env MANGOHUD_CONFIGFILE='$config_path' mangohud";
    
                if (app.is_flatpak ()) {
                    Process.spawn_command_line_sync ("pkill vkcube");
                    if (is_wayland) {
                        Process.spawn_command_line_async (base_cmd + " mangohud vkcube-wayland");
                    } else {
                        Process.spawn_command_line_async (base_cmd + " mangohud vkcube --wsi xcb");
                    }
                } else if (app.is_vkcube_available ()) {
                    Process.spawn_command_line_sync ("pkill vkcube");
                    Process.spawn_command_line_async (base_cmd + " mangohud vkcube --wsi xcb");
                } else if (app.is_glxgears_available ()) {
                    Process.spawn_command_line_sync ("pkill glxgears");
                    Process.spawn_command_line_async (base_cmd + " mangohud glxgears");
                }
            } catch (Error e) {
                warning("%s", e.message);
            }
        });
    
        var click_controller = new Gtk.GestureClick();
        click_controller.pressed.connect((n_press, x, y) => {
            if (currently_selected_row != null && currently_selected_row != row) {
                currently_selected_row.remove_css_class("selected");
            }
            row.add_css_class("selected");
            currently_selected_row = row;
        });
        row.add_controller(click_controller);
        
        return row;
    }

    void show_presets_carousel_dialog(Gtk.Window parent_dialog, MangoJuice app) {
        var dialog = new Adw.Dialog();
        dialog.set_content_width(800);
        dialog.set_content_height(600);
        dialog.set_size_request(320, 240);

        var breakpoint_mobile = new Adw.Breakpoint(Adw.BreakpointCondition.parse("max-width: 450px"));
        var breakpoint_desktop = new Adw.Breakpoint(Adw.BreakpointCondition.parse("min-width: 451px"));
        dialog.add_breakpoint(breakpoint_mobile);
        dialog.add_breakpoint(breakpoint_desktop);

        var main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        dialog.set_child(main_box);

        var header = new Adw.HeaderBar();
        header.set_show_start_title_buttons(true);
        header.set_show_end_title_buttons(true);
        header.add_css_class("flat");
        main_box.append(header);

        var header_center_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
        header_center_box.set_halign(Gtk.Align.CENTER);
        header_center_box.set_valign(Gtk.Align.CENTER);
        header_center_box.set_hexpand(true);
        header_center_box.set_vexpand(false);
        header.set_title_widget(header_center_box);

        var carousel = new Adw.Carousel();
        carousel.set_hexpand(true);
        carousel.set_vexpand(true);

        var header_indicators = new Adw.CarouselIndicatorDots();
        header_indicators.set_carousel(carousel);
        header_indicators.set_valign(Gtk.Align.CENTER);
        header_indicators.set_halign(Gtk.Align.CENTER);

        header_center_box.append(header_indicators);

        var restore_button = new Gtk.Button.with_label(_("Restore"));
        ((Gtk.Label)restore_button.get_child()).set_ellipsize(Pango.EllipsizeMode.END);
        restore_button.clicked.connect(() => {
            try {
                var backup_file = File.new_for_path(Environment.get_home_dir())
                    .get_child(".config")
                    .get_child("MangoHud")
                    .get_child(".MangoHud.backup");
                app.restore_config_from_file(backup_file.get_path());
                backup_file.delete();
            } catch (Error e) {
                stderr.printf("Error: %s\n", e.message);
            }
        });
        header.pack_start(restore_button);

        var apply_button = new Gtk.Button.with_label(_("Apply"));
        ((Gtk.Label)apply_button.get_child()).set_ellipsize(Pango.EllipsizeMode.END);
        apply_button.add_css_class("suggested-action");
        apply_button.clicked.connect(() => {
            apply_preset(carousel, app);
        });
        header.pack_end(apply_button);

        var content_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);
        content_box.set_margin_top(12);
        content_box.set_margin_bottom(12);
        content_box.set_margin_start(12);
        content_box.set_margin_end(12);
        content_box.set_hexpand(true);
        content_box.set_vexpand(true);
        main_box.append(content_box);

        content_box.append(carousel);

        var bottom_indicators = new Adw.CarouselIndicatorDots();
        bottom_indicators.set_carousel(carousel);
        bottom_indicators.set_valign(Gtk.Align.CENTER);
        bottom_indicators.set_halign(Gtk.Align.CENTER);
        bottom_indicators.set_margin_top(10);
        bottom_indicators.set_visible(false);
        content_box.append(bottom_indicators);

        breakpoint_mobile.add_setter(header_indicators, "visible", false);
        breakpoint_mobile.add_setter(bottom_indicators, "visible", true);
        breakpoint_desktop.add_setter(header_indicators, "visible", true);
        breakpoint_desktop.add_setter(bottom_indicators, "visible", false);

        string[] titles = { _("Minimal"), _("Default"), _("Advanced"), _("Full"), _("Only FPS") };
        string[] icons = { "minimal", "default", "advanced", "full", "fps" };

        for (int i = 0; i < titles.length; i++) {
            var page = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
            page.set_hexpand(true);
            page.set_vexpand(true);

            var center = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
            center.set_hexpand(true);
            center.set_vexpand(true);

            var picture = new Gtk.Picture();
            picture.set_resource("/io/github/radiolamp/mangojuice/images/" + icons[i] + ".png");
            picture.set_hexpand(true);
            picture.set_vexpand(true);
            picture.set_can_shrink(false);
        
            var label = new Gtk.Label(titles[i]);
            label.add_css_class("title-2");
            label.set_margin_top(10);
            label.set_margin_bottom(10);

            center.append(picture);
            center.append(label);
            page.append(center);

            carousel.append(page);
        }

        dialog.present(parent_dialog);
    }


    void apply_preset(Adw.Carousel carousel, MangoJuice app) {
        int current_page = (int)carousel.get_position();
        string[] page_names = { _("Minimal"), _("Default"), _("Advanced"), _("Full"), _("Only FPS") };
        stdout.printf(_("Applying %s layout\n"), page_names[current_page]);

        switch (current_page) {
            case 0:
                string[] profile1_vars = { "background_alpha=0.4", "round_corners=0", "background_color=000000", "text_color=FFFFFF", "position=top-left",
                "table_columns=2", "cpu_stats", "gpu_stats", "ram", "vram", "hud_compact", "fps", "hud_no_margin" };
                set_preset(profile1_vars);
                break;
            case 1:
                string[] profile2_vars = { "background_alpha=0.4", "round_corners=10", "cpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                "gpu_load_color=FFFFFF,FFAA7F,CC0000", "gpu_temp", "gpu_fan", "gpu_power", "gpu_stats", "cpu_load_change", "cpu_load_value=30,60",
                "cpu_load_color=FFFFFF,FFAA7F,CC0000", "cpu_mhz", "cpu_temp", "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram", "ram_color=C26693",
                "wine_color=EB4B4B", "fps", "frametime_color=00e4ff", "toggle_fps_limit=Shift_L+F1", "fps_limit=0,30,60", "fps_color_change",
                 "fps_color=ff0000,FDFD09,ffffff", "fps_value=30,60", "engine_short_names", "frame_timing" };
                set_preset(profile2_vars);
                break;
            case 2:
                string[] profile3_vars = { "background_alpha=0.4", "round_corners=10", "gpu_text=GPU", "gpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                "gpu_load_color=ffffff,ffaa7f,cc0000", "gpu_temp", "gpu_fan", "gpu_power", "gpu_color=2E9762", "cpu_text=CPU", "cpu_stats", "cpu_load_change",
                "cpu_load_value=30,60", "cpu_load_color=ffffff,ffaa7f,cc0000", "cpu_mhz", "cpu_temp", "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram",
                "ram_color=C26693", "fps", "engine_short_names", "gpu_name", "wine", "wine_color=eb4b4b", "frame_timing", "frametime_color=00edff",
                "toggle_fps_limit=Shift_L+F1", "show_fps_limit", "fps_limit=0,30,60", "resolution", "fsr", "hdr", "refresh_rate", "fps_color_change",
                "fps_color=ff0000,fdfd09,ffffff", "fps_value=30,60", "media_player", "media_player_color=FFFFFF" };
                set_preset(profile3_vars);
                break;
            case 3:
                string[] profile4_vars = { "background_alpha=0.4", "round_corners=10", "table_columns=4", "gpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                "gpu_load_color=FFFFFF,FFAA7F,CC0000", "gpu_temp", "gpu_fan", "gpu_power", "gpu_color=2E9762", "cpu_stats", "cpu_load_change", "cpu_load_value=30,60",
                "cpu_load_color=FFFFFF,FFAA7F,CC0000", "cpu_mhz", "cpu_temp", "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram", "procmem", "io_read", "io_write",
                "ram_color=C26693", "fps", "engine_short_names", "gpu_name", "wine_color=EB4B4B", "frame_timing", "frame_count", "frametime_color=00FF00", "show_fps_limit",
                "fps_limit=0,120,240", "resolution", "fsr", "hdr", "refresh_rate", "fps_color_change", "fps_color=ff0000,FDFD09,ffffff", "fps_value=80,140", "media_player",
                "media_player_color=FFFFFF", "cpu_power", "gpu_junction_temp", "gpu_core_clock", "gpu_mem_temp", "gpu_mem_clock", "gpu_voltage", "procmem_shared", "procmem_virt",
                "battery", "battery_icon", "device_battery_icon", "battery_watt", "battery_time", "exec_name", "throttling_status_graph", "arch", "full" };
                set_preset(profile4_vars);
                break;
            case 4:
                string[] profile5_vars = { "fps_only", "background_alpha=0" };
                set_preset(profile5_vars);
                break;
        }
        LoadStates.load_states_from_file.begin(app);
        app.reset_manager.reset_all_widgets();
    }

    string generate_unique_profile_name(string base_name) {
        string name = base_name;
        int counter = 1;

        while (true) {
            string config_path = Path.build_filename(
                Environment.get_home_dir(),
                ".config",
                "MangoHud",
                name.replace(" ", "-") + ".conf"
            );

            if (!File.new_for_path(config_path).query_exists()) {
                break;
            }

            name = @"$base_name $counter";
            counter++;
        }

        return name;
    }

    void create_profile_config(string profile_name) {
        try {
            var config_dir = File.new_for_path(Environment.get_home_dir())
                .get_child(".config")
                .get_child("MangoHud");

            var original_config = config_dir.get_child("MangoHud.conf");
            var new_config = config_dir.get_child(
                profile_name.replace(" ", "-") + ".conf"
            );
            if (original_config.query_exists()) {
                original_config.copy(new_config, FileCopyFlags.OVERWRITE);
            }
        } catch (Error e) {
            warning("Failed to create profile: %s", e.message);
        }
    }

    void rename_profile_config(string old_name, string new_name) {
        try {
            string old_path = Path.build_filename(
                Environment.get_home_dir(),
                ".config",
                "MangoHud",
                old_name.replace(" ", "-") + ".conf"
            );
            string new_path = Path.build_filename(
                Environment.get_home_dir(),
                ".config",
                "MangoHud",
                new_name.replace(" ", "-") + ".conf"
            );

            var old_file = File.new_for_path(old_path);
            if (old_file.query_exists()) {
                old_file.move(File.new_for_path(new_path), FileCopyFlags.OVERWRITE);
            }
        } catch (Error e) {
            warning("Failed to rename profile: %s", e.message);
        }
    }

    void delete_profile_config(string profile_name) {
        try {
            string path = Path.build_filename(
                Environment.get_home_dir(),
                ".config",
                "MangoHud",
                profile_name.replace(" ", "-") + ".conf"
            );

            var file = File.new_for_path(path);
            if (file.query_exists()) {
                file.delete();
            }
        } catch (Error e) {
            warning("Failed to delete profile: %s", e.message);
        }
    }

    void apply_profile_config(string profile_name) {
        try {
            string profile_path = Path.build_filename(
                Environment.get_home_dir(),
                ".config",
                "MangoHud",
                profile_name.replace(" ", "-") + ".conf"
            );

            string target_path = Path.build_filename(
                Environment.get_home_dir(),
                ".config",
                "MangoHud",
                "MangoHud.conf"
            );

            var profile_file = File.new_for_path(profile_path);
            if (profile_file.query_exists()) {
                profile_file.copy(File.new_for_path(target_path), FileCopyFlags.OVERWRITE);
            }
        } catch (Error e) {
            warning("Failed to apply profile: %s", e.message);
        }
    }

    void set_preset (string[] preset_values) {
        var file = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child("MangoHud").get_child ("MangoHud.conf");
        var backup_file = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud").get_child (".MangoHud.backup");
        try {
            if (file.query_exists () && !backup_file.query_exists ()) {
                file.copy (backup_file, FileCopyFlags.OVERWRITE);
            }
            var output_stream = new DataOutputStream (file.replace(null, false, FileCreateFlags.NONE));
            output_stream.put_string ("#Preset config by MangoJuice #\n");
            output_stream.put_string ("legacy_layout=false\n");
            foreach (string value in preset_values) {
                output_stream.put_string ("%s\n".printf (value));
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }
}