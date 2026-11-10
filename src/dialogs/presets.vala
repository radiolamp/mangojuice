/* dialogs/presets.vala // License: GPL-3.0+ */
using Gtk;
using Adw;
using MangoJuice;
using MangoJuice.Config;

namespace MangoJuice.Dialogs {

public class PresetsDialog : GLib.Object {

    MangoJuice.Application app;

    public PresetsDialog (MangoJuice.Application app) {
        this.app = app;
    }

    public void show_presets_carousel_dialog (Gtk.Widget? parent_dialog) {
        var dialog = new Adw.Dialog ();
        dialog.set_content_width (800);
        dialog.set_content_height (600);
        dialog.set_size_request (320, 240);

        var breakpoint_mobile = new Adw.Breakpoint (Adw.BreakpointCondition.parse ("max-width: 450px"));
        dialog.add_breakpoint (breakpoint_mobile);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        dialog.set_child (main_box);

        var header = new Adw.HeaderBar ();
        header.set_show_start_title_buttons (true);
        header.set_show_end_title_buttons (true);
        header.add_css_class ("flat");
        main_box.append (header);

        var header_center_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        header_center_box.set_halign (Gtk.Align.CENTER);
        header_center_box.set_valign (Gtk.Align.CENTER);
        header_center_box.set_hexpand (true);
        header_center_box.set_vexpand (false);
        header.set_title_widget (header_center_box);

        var carousel = new Adw.Carousel ();
        carousel.set_hexpand (true);
        carousel.set_vexpand (true);

        var previous_button = new Gtk.Button.from_icon_name ("go-previous-symbolic");
        previous_button.set_tooltip_text (_("Previous"));
        previous_button.has_frame = false;
        previous_button.add_css_class ("circular");
        previous_button.set_valign (Gtk.Align.CENTER);
        previous_button.set_margin_start (4);
        previous_button.clicked.connect (() => {
            uint index = (uint) carousel.get_position ();
            if (index > 0) {
                carousel.scroll_to (carousel.get_nth_page (index - 1), true);
            }
        });

        var next_button = new Gtk.Button.from_icon_name ("go-next-symbolic");
        next_button.set_tooltip_text (_("Next"));
        next_button.has_frame = false;
        next_button.add_css_class ("circular");
        next_button.set_valign (Gtk.Align.CENTER);
        next_button.set_margin_end (4);
        next_button.clicked.connect (() => {
            uint index = (uint) carousel.get_position ();
            if (index + 1 < carousel.get_n_pages ()) {
                carousel.scroll_to (carousel.get_nth_page (index + 1), true);
            }
        });

        var carousel_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        carousel_box.set_hexpand (true);
        carousel_box.set_vexpand (true);
        carousel_box.append (previous_button);
        carousel_box.append (carousel);
        carousel_box.append (next_button);

        var header_indicators = new Adw.CarouselIndicatorDots ();
        header_indicators.set_carousel (carousel);
        header_indicators.set_valign (Gtk.Align.CENTER);
        header_indicators.set_halign (Gtk.Align.CENTER);

        header_center_box.append (header_indicators);

        carousel.page_changed.connect ((index) => {
            previous_button.set_sensitive (index > 0);
            next_button.set_sensitive (index + 1 < carousel.get_n_pages ());
        });

        var backup_file = app.paths.mangohud_backup;
        var restore_button = new Gtk.Button.with_label (_("Restore"));
        ((Gtk.Label)restore_button.get_child ()).set_ellipsize (Pango.EllipsizeMode.END);
        restore_button.set_sensitive (backup_file.query_exists ());
        restore_button.clicked.connect (() => {
            if (!backup_file.query_exists ()) {
                restore_button.set_sensitive (false);
                return;
            }

            bool restored = app.restore_config_from_file (backup_file.get_path ());
            if (restored) {
                try {
                    backup_file.delete ();
                } catch (Error e) {
                    stderr.printf ("Error deleting backup file: %s\n", e.message);
                }
            }

            restore_button.set_sensitive (backup_file.query_exists ());
        });
        header.pack_start (restore_button);

        var apply_button = new Gtk.Button.with_label (_("Apply"));
        ((Gtk.Label)apply_button.get_child ()).set_ellipsize (Pango.EllipsizeMode.END);
        apply_button.add_css_class ("suggested-action");
        apply_button.clicked.connect (() => {
            apply_preset (carousel, app);
            restore_button.set_sensitive (backup_file.query_exists ());
        });
        header.pack_end (apply_button);

        var content_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
        content_box.set_margin_top (6);
        content_box.set_margin_bottom (6);
        content_box.set_margin_start (12);
        content_box.set_margin_end (12);
        content_box.set_hexpand (true);
        content_box.set_vexpand (true);

        main_box.append (content_box);

        content_box.append (carousel_box);

        var bottom_indicators = new Adw.CarouselIndicatorDots ();
        bottom_indicators.set_carousel (carousel);
        bottom_indicators.set_valign (Gtk.Align.CENTER);
        bottom_indicators.set_halign (Gtk.Align.CENTER);
        bottom_indicators.set_margin_top (10);
        bottom_indicators.set_visible (false);
        content_box.append (bottom_indicators);

        breakpoint_mobile.apply.connect (() => {
            header_indicators.visible = false;
            bottom_indicators.visible = true;
            previous_button.visible = false;
            next_button.visible = false;
        });
        breakpoint_mobile.unapply.connect (() => {
            header_indicators.visible = true;
            bottom_indicators.visible = false;
            previous_button.visible = true;
            next_button.visible = true;
        });

        string[] titles = preset_titles ();
        string[] icons = { "minimal", "default", "advanced", "full", "fps" };

        for (int i = 0; i < titles.length; i++) {
            var page = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            page.set_hexpand (true);
            page.set_valign (Gtk.Align.CENTER);

            var center = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
            center.set_halign (Gtk.Align.CENTER);
            center.set_margin_top (20);

            var image = new Gtk.Picture.for_resource (
                "/io/github/radiolamp/mangojuice/images/" + icons[i] + ".png"
            );
            image.set_can_shrink (true);
            image.set_content_fit (Gtk.ContentFit.CONTAIN);

            var label = new Gtk.Label (titles[i]);
            label.add_css_class ("title-2");
            label.set_margin_top (10);
            label.set_margin_bottom (10);

            center.append (image);
            center.append (label);
            page.append (center);

            carousel.append (page);
        }

        previous_button.set_sensitive (false);
        next_button.set_sensitive (carousel.get_n_pages () > 1);

        dialog.present (parent_dialog);
    }


    string[] preset_titles () {
        return {
            _("Minimal"), _("Default"), _("Advanced"), _("Full"), _("Only FPS")
        };
    }

    void apply_preset (Adw.Carousel carousel, MangoJuice.Application app) {
        int current_page = (int)carousel.get_position ();
        string[] titles = preset_titles ();
        if (current_page < 0 || current_page >= titles.length) {
            return;
        }

        debug ("Applying %s layout", titles[current_page]);

        switch (current_page) {
            case 0:
                string[] profile1_vars = {
                    "background_alpha=0.4", "round_corners=0", "background_color=000000",
                    "text_color=FFFFFF", "position=top-left", "table_columns=2",
                    "cpu_stats", "gpu_stats", "ram", "vram", "hud_compact", "fps",
                    "hud_no_margin"
                };
                set_preset (profile1_vars);
                break;
            case 1:
                string[] profile2_vars = {
                    "background_alpha=0.4", "round_corners=10", "cpu_stats",
                    "gpu_load_change", "gpu_load_value=30,60",
                    "gpu_load_color=FFFFFF,FFAA7F,CC0000", "gpu_temp", "gpu_fan",
                    "gpu_power", "gpu_stats", "cpu_load_change", "cpu_load_value=30,60",
                    "cpu_load_color=FFFFFF,FFAA7F,CC0000", "cpu_mhz", "cpu_temp",
                    "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram",
                    "ram_color=C26693", "wine_color=EB4B4B", "fps",
                    "frametime_color=00e4ff", "toggle_fps_limit=Shift_L+F1",
                    "fps_limit=0,30,60", "fps_color_change",
                    "fps_color=ff0000,FDFD09,ffffff", "fps_value=30,60",
                    "engine_short_names", "frame_timing"
                };
                set_preset (profile2_vars);
                break;
            case 2:
                string[] profile3_vars = {
                    "background_alpha=0.4", "round_corners=10", "gpu_text=GPU",
                    "gpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                    "gpu_load_color=ffffff,ffaa7f,cc0000", "gpu_temp", "gpu_fan",
                    "gpu_power", "gpu_color=2E9762", "cpu_text=CPU", "cpu_stats",
                    "cpu_load_change", "cpu_load_value=30,60",
                    "cpu_load_color=ffffff,ffaa7f,cc0000", "cpu_mhz", "cpu_temp",
                    "cpu_color=2E97CB", "vram", "vram_color=AD64C1", "ram",
                    "ram_color=C26693", "fps", "engine_short_names", "gpu_name",
                    "wine", "wine_color=eb4b4b", "frame_timing",
                    "frametime_color=00edff", "toggle_fps_limit=Shift_L+F1",
                    "show_fps_limit", "fps_limit=0,30,60", "resolution", "fsr",
                    "hdr", "refresh_rate", "fps_color_change",
                    "fps_color=ff0000,fdfd09,ffffff", "fps_value=30,60",
                    "media_player", "media_player_color=FFFFFF"
                };
                set_preset (profile3_vars);
                break;
            case 3:
                string[] profile4_vars = {
                    "background_alpha=0.4", "round_corners=10", "table_columns=4",
                    "gpu_stats", "gpu_load_change", "gpu_load_value=30,60",
                    "gpu_load_color=FFFFFF,FFAA7F,CC0000", "gpu_temp", "gpu_fan",
                    "gpu_power", "gpu_color=2E9762", "cpu_stats", "cpu_load_change",
                    "cpu_load_value=30,60", "cpu_load_color=FFFFFF,FFAA7F,CC0000",
                    "cpu_mhz", "cpu_temp", "cpu_color=2E97CB", "vram",
                    "vram_color=AD64C1", "ram", "procmem", "io_read", "io_write",
                    "ram_color=C26693", "fps", "engine_short_names", "gpu_name",
                    "wine_color=EB4B4B", "frame_timing", "frame_count",
                    "frametime_color=00FF00", "show_fps_limit",
                    "fps_limit=0,120,240", "resolution", "fsr", "hdr",
                    "refresh_rate", "fps_color_change",
                    "fps_color=ff0000,FDFD09,ffffff", "fps_value=80,140",
                    "media_player", "media_player_color=FFFFFF", "cpu_power",
                    "gpu_junction_temp", "gpu_core_clock", "gpu_mem_temp",
                    "gpu_mem_clock", "gpu_voltage", "procmem_shared", "procmem_virt",
                    "battery", "battery_icon", "device_battery_icon", "battery_watt",
                    "battery_time", "exec_name", "throttling_status_graph", "arch",
                    "full"
                };
                set_preset (profile4_vars);
                break;
            case 4:
                string[] profile5_vars = { "fps_only", "background_alpha=0" };
                set_preset (profile5_vars);
                break;
        }
        app.loader.load.begin ();
        app.reset_manager.reset_all_widgets ();
    }

    void set_preset (string[] preset_values) {
        var file = app.paths.mangohud_conf;
        var backup_file = app.paths.mangohud_backup;
        try {
            if (file.query_exists () && !backup_file.query_exists ()) {
                file.copy (backup_file, FileCopyFlags.OVERWRITE);
            }
            var output_stream = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
            try {
                output_stream.put_string ("#Preset config by MangoJuice #\n");
                output_stream.put_string ("legacy_layout=false\n");
                foreach (string value in preset_values) {
                    output_stream.put_string ("%s\n".printf (value));
                }
            } finally {
                try {
                    output_stream.close ();
                } catch (Error e) {
                    stderr.printf ("Error closing preset config: %s\n", e.message);
                }
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

}

}
