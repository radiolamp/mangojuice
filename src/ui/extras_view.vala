/* ui/extras_view.vala // License: GPL-3.0+ */
using Gtk;
using MangoJuice;
using MangoJuice.Config;
using MangoJuice.System;

namespace MangoJuice.UI {

public class ExtrasView : GLib.Object {

    private MangoJuice.Application app { get; private set; }

    public ExtrasView (MangoJuice.Application app) {
        this.app = app;
    }

    public void initialize (Box extras_box, Box visual_box) {
        unowned State state = app.state;
        state.custom_command_entry = new Entry ();
        var custom_command_box = Common.create_entry_with_clear_button (state.custom_command_entry, _ ("MangoHud variable"), "");
        state.custom_command_entry.tooltip_text = _ ("Enter MangoHud variables separated by commas");
        state.custom_command_entry.changed.connect (() => {
            app.save_config ();
        });
        app.search.add_setting ("extras_box", _ ("Customize"),
                                _ ("MangoHud variable"),
                                _ ("Enter MangoHud variables separated by commas"),
                                new string[] { "custom_command" },
                                state.custom_command_entry, custom_command_box);

        var custom_logs_path_container = new Box (Orientation.HORIZONTAL, 0);
        custom_logs_path_container.add_css_class ("linked");

        state.custom_logs_path_entry = new Entry () {
            placeholder_text = _ ("Home"),
            tooltip_text = _ ("Directory for logs"),
            hexpand = true
        };
        state.custom_logs_path_entry.changed.connect (() => {
            app.save_config ();
        });

        var clear_logs_path_button = new Button () {
            icon_name = "edit-clear-symbolic",
            tooltip_text = _ ("Clear path"),
            visible = false
        };
        clear_logs_path_button.clicked.connect (() => {
            state.custom_logs_path_entry.text = "";
        });

        state.logs_path_button = new Button () {
            icon_name = "folder-symbolic",
            tooltip_text = _ ("The directory for saving the logging")
        };
        state.logs_path_button.clicked.connect (() => app.open_folder_chooser_dialog());

        state.custom_logs_path_entry.notify["text"].connect ((obj, pspec) => {
            bool has_text = state.custom_logs_path_entry.text != "";
            clear_logs_path_button.visible = has_text;
        });

        custom_logs_path_container.append (state.custom_logs_path_entry);
        custom_logs_path_container.append (clear_logs_path_button);
        custom_logs_path_container.append (state.logs_path_button);

        app.search.add_setting ("extras_box", _ ("Customize"), _ ("Logs folder"),
                                _ ("Directory for logs"),
                                new string[] { "custom_logs_path" },
                                state.custom_logs_path_entry, custom_logs_path_container);

        state.intel_power_fix_button = new Button () {
            hexpand = true,
            child = new Label (_ ("Intel Power Fix")) {
                ellipsize = Pango.EllipsizeMode.END,
                halign = Align.CENTER,
                hexpand = true
            }
        };
        state.intel_power_fix_button.clicked.connect (() => {
            handle_intel_power_fix_clicked.begin ();
        });
        refresh_intel_power_fix_button.begin ();
        app.restart_vkcube_or_glxgears ();

        state.logs_key_recorder = new ShortcutRecorder () {
            tooltip_text = _ ("Click to record shortcut"),
            hexpand = true,
            shortcut = "Shift_L+F2"
        };

        var key_controller = new Gtk.EventControllerKey ();
        key_controller.key_pressed.connect ((keyval, keycode, mod_state) => {
            if (state.logs_key_recorder.is_recording) {
                return state.logs_key_recorder.handle_key_event_with_code (keyval, 0, mod_state);
            }
            return false;
        });
        state.logs_key_recorder.add_controller (key_controller);

        state.logs_key_recorder.shortcut_changed.connect ((shortcut_value) => {
            app.saver.update_logs_key_in_file (shortcut_value);
            app.save_config ();
        });

        app.search.add_setting ("extras_box", _ ("Customize"), _ ("Logs key"),
                                _ ("Keyboard shortcut"),
                                new string[] { "toggle_log" },
                                state.logs_key_recorder, state.logs_key_recorder);

        state.reset_button = new Button () {
            hexpand = true,
            child = new Label (_ ("Reset Config")) {
                ellipsize = Pango.EllipsizeMode.END,
                halign = Align.CENTER,
                hexpand = true
            }
        };
        state.reset_button.add_css_class ("destructive-action");
        state.reset_button.clicked.connect (() => {
            app.delete_vkbasalt_conf ();
            app.delete_mangohud_backup ();
            app.reset_manager.reset_all_widgets ();
        });

        app.search.add_setting ("extras_box", _ ("Customize"), _ ("Intel Power Fix"),
                                _ ("Set Intel GPU power permissions"),
                                new string[] { "intel_power_fix" },
                                state.intel_power_fix_button, state.intel_power_fix_button);
        app.search.add_setting ("extras_box", _ ("Customize"), _ ("Reset Config"),
                                _ ("Restore default settings"),
                                new string[] { "reset_config" },
                                state.reset_button, state.reset_button);

        var blacklist_row = new Box (Orientation.HORIZONTAL, 5) {
            margin_start = 15,
            margin_end = 15
        };

        state.blacklist_entry = new Entry ();
        var blacklist_box = Common.create_entry_with_clear_button (
            state.blacklist_entry, _ ("Blacklist: (vkcube, WatchDogs2.exe)"), "");
        blacklist_box.hexpand = true;
        state.blacklist_entry.changed.connect (() => {
            app.saver.update_blacklist_in_file (state.blacklist_entry.text);
            app.save_config ();
        });

        blacklist_row.append (blacklist_box);

        app.search.add_setting ("extras_box", _ ("Blacklist"), _ ("Blacklist"),
                                _ ("Games excluded from MangoHud"),
                                new string[] { "blacklist" },
                                state.blacklist_entry, blacklist_row);

        if (!app.env.is_flatpak ()) {
            state.mangohud_global_button = new Button.with_label (_ ("MangoHud Global"));
            state.mangohud_global_button.clicked.connect (app.on_mangohud_global_button_clicked);
            blacklist_row.append (state.mangohud_global_button);
        }

        extras_box.append (blacklist_row);

        var custom_command_flow_box = new FlowBox () {
            max_children_per_line = 3,
            margin_start = Common.FLOW_BOX_MARGIN,
            margin_end = Common.FLOW_BOX_MARGIN,
            margin_bottom = Common.FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var command_key_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        var logs_key_label = new Label (_ ("Logs key")) {
            ellipsize = Pango.EllipsizeMode.END,
            halign = Align.START,
            hexpand = false
        };
        command_key_box.append (custom_command_box);
        command_key_box.append (logs_key_label);
        command_key_box.append (state.logs_key_recorder);
        custom_command_flow_box.insert (command_key_box, -1);

        var logs_path_box = new Box (Orientation.HORIZONTAL, 5);
        logs_path_box.append (custom_logs_path_container);
        custom_command_flow_box.insert (logs_path_box, -1);

        var intel_reset_box = new Box (Orientation.HORIZONTAL, 5);
        if (!app.env.is_flatpak ()) {
            intel_reset_box.append (state.intel_power_fix_button);
        }
        intel_reset_box.append (state.reset_button);
        custom_command_flow_box.insert (intel_reset_box, -1);

        extras_box.append (custom_command_flow_box);

        var customize_label = Common.create_label (
            _ ("Customize"), Align.START, { "title-4" },
            Common.FLOW_BOX_MARGIN, Common.FLOW_BOX_MARGIN, Common.FLOW_BOX_MARGIN);
        visual_box.append (customize_label);

        state.custom_text_center_entry = new Entry ();
        var custom_text_center_box = Common.create_entry_with_clear_button (state.custom_text_center_entry, _ ("Your text"), "");
        state.custom_text_center_entry.changed.connect (() => {
            app.save_config ();
        });

        var custom_text_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING) {
            margin_start = Common.FLOW_BOX_MARGIN,
            margin_end = Common.FLOW_BOX_MARGIN,
            margin_top = Common.FLOW_BOX_MARGIN
        };
        custom_text_box.append (custom_text_center_box);
        visual_box.append (custom_text_box);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Your text"),
                                _ ("Text shown in the HUD"),
                                new string[] { "custom_text_center" },
                                state.custom_text_center_entry, custom_text_box);

        var combined_flow_box = new FlowBox () {
            row_spacing = Common.FLOW_BOX_ROW_SPACING,
            column_spacing = Common.FLOW_BOX_COLUMN_SPACING,
            max_children_per_line = 3,
            margin_start = Common.FLOW_BOX_MARGIN,
            margin_end = Common.FLOW_BOX_MARGIN,
            margin_top = Common.FLOW_BOX_MARGIN,
            margin_bottom = Common.FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var custom_switch_label = new Label (_ ("Horizontal HUD")) {
            halign = Align.START,
            hexpand = true
        };
        state.custom_switch = new Switch () {
            valign = Align.CENTER
        };
        state.custom_switch.notify["active"].connect (() => {
            app.save_config ();
        });

        var custom_switch_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        custom_switch_pair.append (custom_switch_label);
        custom_switch_pair.append (state.custom_switch);
        custom_switch_pair.set_size_request (50, -1);
        combined_flow_box.insert (custom_switch_pair, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Horizontal HUD"),
                                _ ("Arrange HUD in one row"),
                                new string[] { "horizontal" },
                                state.custom_switch, custom_switch_pair);

        var borders_widget = app.create_scale_entry_widget (_ ("Borders"), _ ("Round"), 0, 40, 0);
        state.borders_scale = borders_widget.scale;
        state.borders_entry = borders_widget.entry;
        state.borders_scale.value_changed.connect (() => {
            if (state.borders_entry != null) {
                int cursor_position = state.borders_entry.cursor_position;
                state.borders_entry.text = "%d".printf ((int)state.borders_scale.get_value ());
                state.borders_entry.set_position (cursor_position);
            }
        });
        combined_flow_box.insert (borders_widget.widget, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Borders"),
                                _ ("Round"), new string[] { "round_corners" },
                                state.borders_scale, borders_widget.widget);

        var alpha_widget = app.create_scale_entry_widget (_ ("Alpha"), _ ("Transparency"), 0, 10, 5);
        state.alpha_scale = alpha_widget.scale;
        state.alpha_entry = alpha_widget.entry;
        state.alpha_value_label = new Label ("5") {
            width_chars = 3
        };
        state.alpha_scale.value_changed.connect (() => {
            double value = state.alpha_scale.get_value ();
            state.alpha_value_label.label = "%.1f".printf (value / 10.0);
            app.save_config ();
        });
        combined_flow_box.insert (alpha_widget.widget, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Alpha"),
                                _ ("Transparency"), new string[] { "background_alpha" },
                                state.alpha_scale, alpha_widget.widget);

        var position_labels = new string[] {
            _ ("Top Left"), _ ("Top Center"), _ ("Top Right"),
            _ ("Middle Left"), _ ("Middle Right"),
            _ ("Bottom Left"), _ ("Bottom Center"), _ ("Bottom Right")
        };

        var position_model = new Gtk.StringList (null);
        foreach (var label in position_labels) {
            position_model.append (label);
        }

        state.position_dropdown = new DropDown (position_model, null) {
            valign = Align.CENTER,
            hexpand = true
        };
        state.position_dropdown.set_size_request (200, -1);

        state.position_dropdown.notify["selected-item"].connect (() => {
            int selected = (int)state.position_dropdown.selected;
            if (selected >= 0 && selected < Common.POSITION_VALUES.length) {
                app.saver.update_position_in_file (Common.POSITION_VALUES[selected]);
            }
        });

        var position_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        position_pair.append (new Label (_ ("Position")));
        position_pair.append (state.position_dropdown);
        combined_flow_box.insert (position_pair, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Position"),
                                _ ("HUD position on screen"),
                                new string[] { "position" },
                                state.position_dropdown, position_pair);

        var colums_widget = app.create_scale_entry_widget (_ ("Columns"), _ ("Number of columns"), 1, 6, 3);
        state.colums_scale = colums_widget.scale;
        state.colums_entry = colums_widget.entry;
        state.colums_entry.valign = Align.CENTER;
        state.colums_scale.value_changed.connect (() => {
            if (state.colums_entry != null) {
                state.colums_entry.text = "%d".printf ((int)state.colums_scale.get_value ());
            }
        });
        combined_flow_box.insert (colums_widget.widget, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Columns"),
                                _ ("Number of columns"),
                                new string[] { "hud_columns" },
                                state.colums_scale, colums_widget.widget);

        state.toggle_hud_entry = new Entry () {
            placeholder_text = _ ("Key shortcuts"),
            text = "Shift_R+F12",
            hexpand = true,
            valign = Align.CENTER,
            margin_top = Common.FLOW_BOX_MARGIN,
            margin_bottom = Common.FLOW_BOX_MARGIN
        };

        var attrs = new Pango.AttrList ();
        attrs.insert (Pango.attr_weight_new (Pango.Weight.BOLD));

        state.toggle_posic = new ShortcutRecorder () {
            tooltip_text = _ ("Click to record a new HUD toggle shortcut"),
            hexpand = true
        };

        state.toggle_hud_entry.changed.connect (() => {
            if (state.toggle_posic.shortcut != state.toggle_hud_entry.text) {
                state.toggle_posic.shortcut = state.toggle_hud_entry.text;
            }
        });

        if (state.toggle_hud_entry.text != "") {
            state.toggle_posic.shortcut = state.toggle_hud_entry.text;
        }

        state.toggle_posic.shortcut_changed.connect ((toggle_hud_value) => {
            state.toggle_hud_entry.text = toggle_hud_value;
            app.saver.update_toggle_hud_in_file (toggle_hud_value);
            app.save_config ();
        });

        var toggle_hud_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        toggle_hud_box.append (new Label (_ ("Hide HUD")));
        toggle_hud_box.append (state.toggle_posic);
        combined_flow_box.insert (toggle_hud_box, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Hide HUD"),
                                _ ("Toggle overlay shortcut"),
                                new string[] { "toggle_hud" },
                                state.toggle_posic, toggle_hud_box);

        var toggle_hud_key_controller = new EventControllerKey ();
        toggle_hud_key_controller.key_pressed.connect ((keyval, keycode, mod_state) => {
            if (state.toggle_posic.is_recording) {
                return state.toggle_posic.handle_key_event_with_code (keyval, 0, mod_state);
            }
            return false;
        });
        state.toggle_posic.add_controller (toggle_hud_key_controller);

        visual_box.append (combined_flow_box);

        var offset_x_widget = app.create_scale_entry_widget (_ ("Offset X"), _ ("Horizontal offset"), -10, 1500, 0);
        state.offset_x_scale = offset_x_widget.scale;
        state.offset_x_entry = offset_x_widget.entry;
        state.offset_x_value_label = new Label ("0") {
            width_chars = 5,
            halign = Align.END
        };
        state.offset_x_scale.value_changed.connect (() => {
            state.offset_x_value_label.label = "%d".printf ((int)state.offset_x_scale.get_value ());
            app.saver.update_offset_x_in_file ("%d".printf ((int)state.offset_x_scale.get_value ()));
        });

        var offset_y_widget = app.create_scale_entry_widget (_ ("Offset Y"), _ ("Vertical offset"), -10, 1500, 0);
        state.offset_y_scale = offset_y_widget.scale;
        state.offset_y_entry = offset_y_widget.entry;
        state.offset_y_value_label = new Label ("0") {
            width_chars = 5,
            halign = Align.END
        };
        state.offset_y_scale.value_changed.connect (() => {
            state.offset_y_value_label.label = "%d".printf ((int)state.offset_y_scale.get_value ());
            app.saver.update_offset_y_in_file ("%d".printf ((int)state.offset_y_scale.get_value ()));
        });

        var toggle_position_label = new Label (_ ("Toggle position")) {
            halign = Align.START
        };

        state.toggle_hud_key_recorder = new ShortcutRecorder () {
            tooltip_text = _ ("Click to record a new toggle position shortcut"),
            hexpand = true,
            shortcut = "Shift_R+F11"
        };

        key_controller = new Gtk.EventControllerKey ();
        key_controller.key_pressed.connect ((keyval, keycode, mod_state) => {
            if (state.toggle_hud_key_recorder.is_recording) {
                return state.toggle_hud_key_recorder.handle_key_event_with_code (keyval, 0, mod_state);
            }
            return false;
        });

        state.toggle_hud_key_recorder.add_controller (key_controller);

        state.toggle_hud_key_recorder.shortcut_changed.connect ((shortcut_value) => {
            debug ("New shortcut recorded: %s", shortcut_value);
            app.saver.update_toggle_hud_key_in_file (shortcut_value);
            app.save_config ();
        });

        var toggle_position_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        toggle_position_pair.append (toggle_position_label);
        toggle_position_pair.append (state.toggle_hud_key_recorder);
        combined_flow_box.insert (toggle_position_pair, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Toggle position"),
                                _ ("Shortcut to change HUD position"),
                                new string[] { "toggle_hud_position" },
                                state.toggle_hud_key_recorder, toggle_position_pair);

        var offset_x_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        offset_x_pair.append (offset_x_widget.widget);
        combined_flow_box.insert (offset_x_pair, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Offset X"),
                                _ ("Horizontal offset"),
                                new string[] { "offset_x" },
                                state.offset_x_scale, offset_x_pair);

        var offset_y_pair = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        offset_y_pair.append (offset_y_widget.widget);
        combined_flow_box.insert (offset_y_pair, -1);

        app.search.add_setting ("visual_box", _ ("Customize"), _ ("Offset Y"),
                                _ ("Vertical offset"),
                                new string[] { "offset_y" },
                                state.offset_y_scale, offset_y_pair);

        var fonts_label = Common.create_label (_ ("Font"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
        visual_box.append (fonts_label);

        var font_size_widget = app.create_scale_entry_widget (_ ("Size"), _ ("Size in pixels"), 8, 64, 24);
        state.font_size_scale = font_size_widget.scale;
        state.font_size_entry = font_size_widget.entry;
        state.font_size_scale.value_changed.connect (() => {
            if (state.font_size_entry != null) {
                state.font_size_entry.text = "%d".printf ((int)state.font_size_scale.get_value ());
            }
        });

        var font_size_secondary_widget = app.create_scale_entry_widget (
            _ ("Small fonts"), _ ("Secondary font size"), 8, 64, 12);
        state.font_size_secondary_scale = font_size_secondary_widget.scale;
        state.font_size_secondary_entry = font_size_secondary_widget.entry;
        state.font_size_secondary_scale.value_changed.connect (() => {
            if (state.font_size_secondary_entry != null) {
                state.font_size_secondary_entry.text = "%d".printf ((int)state.font_size_secondary_scale.get_value ());
            }
        });

        var fonts_flow_box = new FlowBox () {
            row_spacing = Common.FLOW_BOX_ROW_SPACING,
            column_spacing = Common.FLOW_BOX_COLUMN_SPACING,
            max_children_per_line = 3,
            margin_start = Common.FLOW_BOX_MARGIN,
            margin_end = Common.FLOW_BOX_MARGIN,
            margin_top = Common.FLOW_BOX_MARGIN,
            margin_bottom = Common.FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE
        };

        var font_selector_widget = new Box (Orientation.HORIZONTAL, 0);
        app.font_selector.initialize (font_selector_widget);

        fonts_flow_box.insert (font_selector_widget, -1);
        fonts_flow_box.insert (font_size_widget.widget, -1);
        fonts_flow_box.insert (font_size_secondary_widget.widget, -1);

        app.search.add_setting ("visual_box", _ ("Font"), _ ("Font"),
                                _ ("HUD font file"), new string[] { "font_file" },
                                state.font_button, font_selector_widget);
        app.search.add_setting ("visual_box", _ ("Font"), _ ("Size"),
                                _ ("Size in pixels"), new string[] { "font_size" },
                                state.font_size_scale, font_size_widget.widget);
        app.search.add_setting ("visual_box", _ ("Font"), _ ("Small fonts"),
                                _ ("Secondary font size"), new string[] { "font_size_secondary" },
                                state.font_size_secondary_scale, font_size_secondary_widget.widget);

        visual_box.append (fonts_flow_box);

        var media_label = Common.create_label (_ ("Media"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
        visual_box.append (media_label);

        var format_options = new Gtk.StringList (null);
        foreach (var label in app.labels.format_labels) {
            format_options.append (label);
        }

        state.media_format_dropdowns = new Gee.ArrayList<DropDown> ();
        for (int i = 0; i < 3; i++) {
            var dropdown = new DropDown (format_options, null) {
                hexpand = true,
                selected = i < Common.FORMAT_VALUES.length - 1 ? i : 0
            };

            dropdown.notify["selected"].connect (() => {
                var values = new string[3];
                for (int j = 0; j < 3 && j < state.media_format_dropdowns.size; j++) {
                    int selected = (int)state.media_format_dropdowns.get (j).selected;
                    if (selected >= 0 && selected < Common.FORMAT_VALUES.length) {
                        values[j] = Common.FORMAT_VALUES[selected];
                    } else {
                        values[j] = "none";
                    }
                }
                string media_format = "{%s};{%s};{%s}".printf (values[0], values[1], values[2]);
                app.saver.update_media_player_format_in_file (media_format);
                app.save_config ();
            });

            state.media_format_dropdowns.add (dropdown);
        }

        var media_flow_box = new FlowBox () {
            max_children_per_line = 3,
            margin_start = Common.FLOW_BOX_MARGIN,
            margin_end = Common.FLOW_BOX_MARGIN,
            margin_top = Common.FLOW_BOX_MARGIN,
            margin_bottom = Common.FLOW_BOX_MARGIN,
            selection_mode = SelectionMode.NONE,
            hexpand = true,
            homogeneous = true
        };

        foreach (var dropdown in state.media_format_dropdowns) {
            media_flow_box.insert (dropdown, -1);
        }

        visual_box.append (media_flow_box);

        app.search.add_setting ("visual_box", _ ("Media"), _ ("Media"),
                                _ ("Media player format"), new string[] { "media_player_format" },
                                state.media_format_dropdowns.get (0), media_flow_box);

        app.color_controls.initialize (visual_box);
    }

    private async void handle_intel_power_fix_clicked () {
        var window = app.state.intel_power_fix_button.get_root () as Gtk.Window;
        if (window == null) {
            return;
        }

        yield app.intel_power_fix.open_fix_dialog (window);
        yield refresh_intel_power_fix_button ();
    }

    private async void refresh_intel_power_fix_button () {
        var status = yield app.intel_power_fix.get_permissions_status_async ();
        var button = app.state.intel_power_fix_button;

        if (!status.available) {
            button.set_visible (false);
            return;
        }

        button.set_visible (true);

        if (status.has_permissions) {
            button.add_css_class ("suggested-action");
            button.set_tooltip_text (
                status.service_active
                ? _ ("Permissions set permanently (systemd service active)")
                : (status.service_installed ? _ ("Service exists but not active") : _ ("Permissions set until reboot"))
            );
        } else {
            button.remove_css_class ("suggested-action");
            button.set_tooltip_text (
                status.service_active
                ? _ ("Service active but permissions not set")
                : (status.service_installed ? _ ("Service exists but inactive") : _ ("Permissions not set"))
            );
        }
    }
}

}
