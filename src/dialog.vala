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
        dialog.add_link (_("Financial support") + " (Donationalerts)", "https://www.donationalerts.com/r/radiolamp");
        dialog.add_link (_("Financial support") + " (Tinkoff)", "https://www.tbank.ru/cf/3PPTstulqEq");
        dialog.add_link (_("Financial support") + " (Boosty)", "https://boosty.to/radiolamp");
    
        dialog.present (parent_window);
    }
}

public void show_mangohud_install_dialog(Gtk.Window parent, Gtk.Button test_button) {
    var dialog = new Adw.AlertDialog(
        _("MangoHud Not Installed"),
        _("MangoHud is required for this application. Install it from Flathub")
    );

    var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
    box.margin_top = 12;

    var hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);

    var entry = new Gtk.Entry() {
        text = "flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud",
        editable = false,
        hexpand = true
    };
    entry.add_css_class("monospace");

    var click_controller = new Gtk.GestureClick();
    click_controller.pressed.connect(() => {
        entry.select_region(0, -1);
    });
    entry.add_controller(click_controller);

    var copy_button = new Gtk.Button() {
        icon_name = "edit-copy-symbolic",
        tooltip_text = _("Copy to clipboard")
    };
    
    copy_button.clicked.connect(() => {
        var clipboard = Gdk.Display.get_default()?.get_clipboard();
        clipboard?.set_text(entry.text);

        copy_button.icon_name = "emblem-ok-symbolic";
        Timeout.add_seconds(2, () => {
            copy_button.icon_name = "edit-copy-symbolic";
            return Source.REMOVE;
        });
    });
    
    hbox.append(entry);
    hbox.append(copy_button);
    box.append(hbox);

    dialog.set_extra_child(box);
    
    dialog.add_response("cancel", _("Cancel"));
    dialog.add_response("install", _("Install from Flathub"));
    
    dialog.set_default_response("install");
    dialog.set_response_appearance("install", Adw.ResponseAppearance.SUGGESTED);
    
    dialog.response.connect((response) => {
        if (response == "install") {
            string file_path = Path.build_filename(Environment.get_home_dir(), "mangohud.flatpakref");
            
            try {
                string flatpakref_content = """[Flatpak Ref]
                Name=org.freedesktop.Platform.VulkanLayer.MangoHud
                Branch=24.08
                IsRuntime=true
                Url=https://dl.flathub.org/repo/appstream/org.freedesktop.Platform.VulkanLayer.MangoHud.flatpakref
                """;

                FileUtils.set_contents(file_path, flatpakref_content);
                FileUtils.chmod(file_path, 0644);

                try {
                    Process.spawn_command_line_async("xdg-open " + file_path);

                    Timeout.add_seconds(10, () => {
                        FileUtils.remove(file_path);
                        return Source.REMOVE;
                    });
                } catch (SpawnError e) {
                    FileUtils.remove(file_path);
                    AppInfo.launch_default_for_uri("https://flathub.org/apps/org.freedesktop.Platform.VulkanLayer.MangoHud", null);      
                }
                test_button.set_visible(true);
            } catch (Error e) {
                stderr.printf("Error creating flatpakref file: %s\n", e.message);
            }
        }
    });

    dialog.present(parent);
}

public void show_carousel_dialog(Gtk.Window parent_window, MangoJuice app) {
    var dialog = new Adw.Dialog();
    dialog.set_content_width(800);
    dialog.set_content_height(600);
    dialog.set_size_request(320, 240);

    var breakpoint_450px = new Adw.Breakpoint(Adw.BreakpointCondition.parse("max-width: 450px"));
    dialog.add_breakpoint(breakpoint_450px);

    var main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    dialog.set_child(main_box);

    var window_handle = new Gtk.WindowHandle();
    main_box.append(window_handle);

    var header_bar = new Adw.HeaderBar();
    header_bar.set_show_start_title_buttons(true);
    header_bar.set_show_end_title_buttons(true);
    header_bar.add_css_class("flat");

    var restore_button = new Gtk.Button.with_label("Restore"); 
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
    header_bar.pack_start(restore_button); 

    var indicators_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

    var carousel = new Adw.Carousel();
    
    var indicators = new Adw.CarouselIndicatorDots();
    indicators.set_carousel(carousel);
    indicators.set_valign(Gtk.Align.CENTER);
    indicators_box.append(indicators);

    breakpoint_450px.add_setter(indicators, "visible", false);

    var apply_button = new Gtk.Button.with_label(_("Apply"));
    ((Gtk.Label)apply_button.get_child()).set_ellipsize(Pango.EllipsizeMode.END);
    apply_button.add_css_class("suggested-action");
    apply_button.set_visible(false);
    apply_button.clicked.connect(() => {
        int current_page = (int)carousel.get_position();
        string[] page_names = { _("New Option"), _("Minimal"), _("Default"), _("Advanced"), _("Full"), _("Only FPS") };
        stdout.printf(_("Applying %s layout\n"), page_names[current_page]);
        switch (current_page) {
            case 1:
                string[] profile1_vars = { "background_alpha=0.4", "round_corners=0", "background_color=000000", "text_color=FFFFFF", "position=top-left",
                "table_columns=2", "cpu_stats", "gpu_stats", "ram", "vram", "hud_compact", "fps", "hud_no_margin" };
                set_preset(profile1_vars);
                break;
            case 2:
                string[] profile2_vars = { "background_alpha=0.4", "round_corners=10", "cpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                "gpu_load_color=FFFFFF,FFAA7F,CC0000", "gpu_temp", "gpu_fan", "gpu_power", "gpu_stats", "cpu_load_change", "cpu_load_value=30,60",
                "cpu_load_color=FFFFFF,FFAA7F,CC0000", "cpu_mhz", "cpu_temp", "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram", "ram_color=C26693",
                "wine_color=EB4B4B", "fps", "frametime_color=00e4ff", "toggle_fps_limit=Shift_L+F1", "fps_limit=0,30,60", "fps_color_change",
                 "fps_color=ff0000,FDFD09,ffffff", "fps_value=30,60", "engine_short_names", "frame_timing" };
                set_preset(profile2_vars);
                break;
            case 3:
                string[] profile3_vars = { "background_alpha=0.4", "round_corners=10", "gpu_text=GPU", "gpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                "gpu_load_color=ffffff,ffaa7f,cc0000", "gpu_temp", "gpu_fan", "gpu_power", "gpu_color=2E9762", "cpu_text=CPU", "cpu_stats", "cpu_load_change",
                "cpu_load_value=30,60", "cpu_load_color=ffffff,ffaa7f,cc0000", "cpu_mhz", "cpu_temp", "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram",
                "ram_color=C26693", "fps", "engine_short_names", "gpu_name", "wine", "wine_color=eb4b4b", "frame_timing", "frametime_color=00edff",
                "toggle_fps_limit=Shift_L+F1", "show_fps_limit", "fps_limit=0,30,60", "resolution", "fsr", "hdr", "refresh_rate", "fps_color_change",
                "fps_color=ff0000,fdfd09,ffffff", "fps_value=30,60", "media_player", "media_player_color=FFFFFF" };
                set_preset(profile3_vars);
                break;
            case 4:
                string[] profile4_vars = { "background_alpha=0.4", "round_corners=10", "table_columns=4", "gpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                "gpu_load_color=FFFFFF,FFAA7F,CC0000", "gpu_temp", "gpu_fan", "gpu_power", "gpu_color=2E9762", "cpu_stats", "cpu_load_change", "cpu_load_value=30,60",
                "cpu_load_color=FFFFFF,FFAA7F,CC0000", "cpu_mhz", "cpu_temp", "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram", "procmem", "io_read", "io_write",
                "ram_color=C26693", "fps", "engine_short_names", "gpu_name", "wine_color=EB4B4B", "frame_timing", "frame_count", "frametime_color=00FF00", "show_fps_limit",
                "fps_limit=0,120,240", "resolution", "fsr", "hdr", "refresh_rate", "fps_color_change", "fps_color=ff0000,FDFD09,ffffff", "fps_value=80,140", "media_player",
                "media_player_color=FFFFFF", "cpu_power", "gpu_junction_temp", "gpu_core_clock", "gpu_mem_temp", "gpu_mem_clock", "gpu_voltage", "procmem_shared", "procmem_virt",
                "battery", "battery_icon", "device_battery_icon", "battery_watt", "battery_time", "exec_name", "throttling_status_graph", "arch", "full" };
                set_preset(profile4_vars);
                break;
            case 5:
                string[] profile5_vars = { "fps_only", "background_alpha=0" };
                set_preset(profile5_vars);
                break;
        }
        LoadStates.load_states_from_file.begin(app);
        app.reset_manager.reset_all_widgets();
    });
    carousel.notify["position"].connect(() => {
        int current_page = (int)carousel.get_position();
        apply_button.set_visible(current_page > 0);
    });
    header_bar.pack_end(apply_button);

    header_bar.set_title_widget(indicators_box);
    main_box.append(header_bar);

    var content_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);
    content_box.set_margin_top(12);
    content_box.set_margin_bottom(12);
    content_box.set_margin_start(12);
    content_box.set_margin_end(12);
    content_box.set_hexpand(true);
    content_box.set_vexpand(true);
    main_box.append(content_box);

    carousel.set_hexpand(true);
    carousel.set_vexpand(true);

    string[] titles = { _("Your presets"), _("Minimal"), _("Default"), _("Advanced"), _("Full"), _("Only FPS") };
    string[] icons = { "applications-graphics-symbolic", "minimal", "default", "advanced", "full", "fps" };

    for (int i = 0; i < titles.length; i++) {
        var page_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
        page_box.set_hexpand(true);
        page_box.set_vexpand(true);

        var center_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);
        center_box.set_hexpand(true);
        center_box.set_vexpand(true);

        Gtk.Image image;
        if (i == 0) {
            image = new Gtk.Image.from_icon_name(icons[i]);
            image.set_pixel_size(128);
        } else {
            image = new Gtk.Image.from_resource(
                "/io/github/radiolamp/mangojuice/images/" + icons[i] + ".png"
            );
        }
        image.set_hexpand(true);
        image.set_vexpand(true);

        var label = new Gtk.Label(titles[i]);
        label.add_css_class("title-2");
        label.set_margin_top(10);
        label.set_margin_bottom(10);

        center_box.append(image);

        if (i == 0) {
            var wrap = new Adw.WrapBox();
            wrap.set_orientation(Gtk.Orientation.HORIZONTAL);
            wrap.set_halign(Gtk.Align.CENTER);
            
            var add_button = new Gtk.Button();
            add_button.set_icon_name("list-add-symbolic");
            add_button.add_css_class("circular");
            add_button.set_margin_top(4);

            add_button.clicked.connect(() => {
                add_option_button(wrap, add_button);
            });

            wrap.append(add_button);
            center_box.append(wrap);

            try {
                var config_dir = File.new_for_path(Environment.get_home_dir())
                    .get_child(".config")
                    .get_child("MangoHud");
                
                if (config_dir.query_exists()) {
                    var enumerator = config_dir.enumerate_children(FileAttribute.STANDARD_NAME, 0);
                    FileInfo info;
                    while ((info = enumerator.next_file()) != null) {
                        string name = info.get_name();
                        if (name.has_prefix("MangoJuice-") && name.has_suffix(".conf")) {
                            string profile_name = name[11:-5].replace("_", " ");
                            add_option_button(wrap, add_button, profile_name, true);
                        }
                    }
                }
            } catch (Error e) {
                warning("Error loading profiles: %s", e.message);
            }
        }

        page_box.append(center_box);
        page_box.append(label);

        var mobile_indicators = new Adw.CarouselIndicatorDots();
        mobile_indicators.set_carousel(carousel);
        mobile_indicators.set_hexpand(true);
        mobile_indicators.set_valign(Gtk.Align.CENTER);
        mobile_indicators.set_margin_top(10);
        mobile_indicators.set_visible(false);

        page_box.append(mobile_indicators);
        breakpoint_450px.add_setter(mobile_indicators, "visible", true);

        carousel.append(page_box);
    }

    content_box.append(carousel);

    dialog.set_hexpand(true);
    dialog.set_vexpand(true);
    dialog.present(parent_window);
}

private Gtk.Box add_option_button(Adw.WrapBox wrap, Gtk.Button add_button, string initial_name = _("Profile"), bool is_existing_profile = false) {
    var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
    box.set_margin_top(4);
    box.set_margin_end(4);
    box.set_margin_start(2);
    box.add_css_class("regular");

    string profile_name = initial_name;
    if (!is_existing_profile && initial_name == _("Profile")) {
        profile_name = generate_unique_profile_name(initial_name);
        create_profile_config(profile_name);
    }

    var button = new Gtk.Button.with_label(profile_name);
    var entry = new Gtk.Entry();
    entry.set_text(profile_name);
    entry.set_visible(false);
    entry.set_hexpand(true);

    var close_btn = new Gtk.Button();
    close_btn.set_icon_name("window-close-symbolic");
    close_btn.add_css_class("circular");
    close_btn.set_halign(Gtk.Align.CENTER);
    close_btn.set_valign(Gtk.Align.CENTER);
    close_btn.set_margin_end(4);
    close_btn.set_focusable(false);
    close_btn.set_visible(false);

    var edit_btn = new Gtk.Button();
    edit_btn.set_icon_name("document-edit-symbolic");
    edit_btn.add_css_class("circular");
    edit_btn.set_halign(Gtk.Align.CENTER);
    edit_btn.set_valign(Gtk.Align.CENTER);
    edit_btn.set_focusable(false);
    edit_btn.set_visible(false);

    edit_btn.clicked.connect(() => {
        button.set_visible(false);
        entry.set_visible(true);
        entry.grab_focus();
    });

    entry.activate.connect(() => {
        string new_name = entry.get_text().strip();
        if (new_name != "" && new_name != button.get_label()) {
            rename_profile_config(button.get_label(), new_name);
            button.set_label(new_name);
        }
        entry.set_visible(false);
        button.set_visible(true);
    });

    var focus_controller = new Gtk.EventControllerFocus();
    focus_controller.leave.connect(() => {
        if (entry.get_visible()) {
            entry.activate();
        }
    });
    entry.add_controller(focus_controller);

    close_btn.clicked.connect(() => {
        delete_profile_config(button.get_label());
        wrap.remove(box);
    });

    var right_click = new Gtk.GestureClick();
    right_click.set_button(Gdk.BUTTON_SECONDARY);
    right_click.pressed.connect((n_press, x, y) => {
        bool currently_visible = close_btn.get_visible();
        close_btn.set_visible(!currently_visible);
        edit_btn.set_visible(!currently_visible);
    });
    box.add_controller(right_click);

    box.append(button);
    box.append(entry);
    box.append(edit_btn);
    box.append(close_btn);

    button.clicked.connect(() => {
        apply_profile_config(button.get_label());
    });

    wrap.remove(add_button);
    wrap.append(box);
    wrap.append(add_button);

    return box;
}

private string generate_unique_profile_name(string base_name) {
    string name = base_name;
    int counter = 1;

    while (true) {
        string config_path = Path.build_filename(
            Environment.get_home_dir(),
            ".config",
            "MangoHud",
            "MangoJuice-" + name.replace(" ", "_") + ".conf"
        );

        if (!File.new_for_path(config_path).query_exists()) {
            break;
        }

        name = @"$base_name $counter";
        counter++;
    }

    return name;
}

private void create_profile_config(string profile_name) {
    try {
        var config_dir = File.new_for_path(Environment.get_home_dir())
            .get_child(".config")
            .get_child("MangoHud");

        var original_config = config_dir.get_child("MangoHud.conf");
        var new_config = config_dir.get_child(
            "MangoJuice-" + profile_name.replace(" ", "_") + ".conf"
        );

        if (original_config.query_exists()) {
            original_config.copy(new_config, FileCopyFlags.OVERWRITE);
        }
    } catch (Error e) {
        warning("Failed to create profile: %s", e.message);
    }
}

private void rename_profile_config(string old_name, string new_name) {
    try {
        string old_path = Path.build_filename(
            Environment.get_home_dir(),
            ".config",
            "MangoHud",
            "MangoJuice-" + old_name.replace(" ", "_") + ".conf"
        );

        string new_path = Path.build_filename(
            Environment.get_home_dir(),
            ".config",
            "MangoHud",
            "MangoJuice-" + new_name.replace(" ", "_") + ".conf"
        );

        var old_file = File.new_for_path(old_path);
        if (old_file.query_exists()) {
            old_file.move(File.new_for_path(new_path), FileCopyFlags.OVERWRITE);
        }
    } catch (Error e) {
        warning("Failed to rename profile: %s", e.message);
    }
}

private void delete_profile_config(string profile_name) {
    try {
        string path = Path.build_filename(
            Environment.get_home_dir(),
            ".config",
            "MangoHud",
            "MangoJuice-" + profile_name.replace(" ", "_") + ".conf"
        );

        var file = File.new_for_path(path);
        if (file.query_exists()) {
            file.delete();
        }
    } catch (Error e) {
        warning("Failed to delete profile: %s", e.message);
    }
}

private void apply_profile_config(string profile_name) {
    try {
        string profile_path = Path.build_filename(
            Environment.get_home_dir(),
            ".config",
            "MangoHud",
            "MangoJuice-" + profile_name.replace(" ", "_") + ".conf"
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