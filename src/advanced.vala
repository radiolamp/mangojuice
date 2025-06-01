/* advanced.vala // Licence:  GPL-v3.0 */
using Gtk;
using Adw;

public class AdvancedDialog : Adw.Dialog {
    File config_file;
    List<string> all_config_lines;
    List<string> filtered_config_lines;
    ListBox list_box;

    string[] allowed_prefixes = { "custom_text_center=", "custom_text=", "gpu_stats", "vram", "cpu_stats",
    "core_load", "ram", "io_read", "io_write", "procmem", "swap", "fan", "fps", "fps_metrics=avg,0.01",
    "fps_metrics=avg,0.1", "version", "gamemode", "vkbasalt", "exec_name", "fsr", "hdr", "vulkan_driver",
    "engine_version", "refresh_rate", "resolution", "arch", "present_mode", "display_server", "show_fps_limit",
    "frame_timing", "frame_count", "battery", "battery_watt", "battery_time", "device_battery_icon",
    "device_battery=gamepad,mouse", "network", "media_player", "wine", "winesync" };

    public static void show_advanced_dialog(Gtk.Window parent_window, MangoJuice app) {
        var advanced_dialog = new AdvancedDialog(parent_window, app);
        advanced_dialog.set_content_width(1000);
        advanced_dialog.set_content_height(2000);
        advanced_dialog.present(parent_window);
    }

    public AdvancedDialog (Gtk.Window parent, MangoJuice app) {
        Object ();

        var header_bar = new Adw.HeaderBar ();
        header_bar.add_css_class ("flat");
        header_bar.set_size_request (320, -1);

        var warning_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
        warning_box.set_halign(Gtk.Align.CENTER);
        warning_box.set_margin_start(12);
        warning_box.set_margin_end(12);

        var warning_icon = new Gtk.Image.from_icon_name("dialog-warning-symbolic");
        var warning_label = new Gtk.Label(_("The setting is reset when the configuration is changed"));
        warning_label.set_ellipsize(Pango.EllipsizeMode.END);
        warning_label.add_css_class("warning");

        warning_box.append(warning_icon);
        warning_box.append(warning_label);
        header_bar.set_title_widget(warning_box);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        main_box.append (header_bar);

        main_box.append (create_advanced_content ());

        this.closed.connect(() => {
        //    LoadStates.load_states_from_file.begin(app);
        });

        this.set_child (main_box);
        this.present (parent);
    }

    Gtk.Widget create_advanced_content () {
        var scrolled_window = new Gtk.ScrolledWindow ();
        scrolled_window.set_hexpand (true);
        scrolled_window.set_vexpand (true);
    
        var clamp = new Adw.Clamp ();
        var group = new Adw.PreferencesGroup ();
    
        list_box = new ListBox ();
        list_box.set_selection_mode (SelectionMode.NONE);
        list_box.set_hexpand (true);
        list_box.set_margin_start (12);
        list_box.set_margin_end (12);
        list_box.set_margin_top (12);
        list_box.set_margin_bottom (12);
        list_box.add_css_class ("boxed-list");
    
        var config_dir = File.new_for_path (Environment.get_home_dir ()).get_child (".config").get_child ("MangoHud");
        config_file = config_dir.get_child ("MangoHud.conf");
    
        if (config_file.query_exists ()) {
            try {
                var input_stream = config_file.read ();
                var data_stream = new DataInputStream (input_stream);
                string line;
    
                all_config_lines = new List<string> ();
                filtered_config_lines = new List<string> ();
    
                while ((line = data_stream.read_line ()) != null) {
                    all_config_lines.append (line);
                
                    if (!line.contains ("color") &&
                        !line.contains ("fps_limit_method=") &&
                        !line.contains ("media_player_format=") &&
                        !line.contains ("fps_value=")) {
                        
                        foreach (var prefix in allowed_prefixes) {
                            if (line.has_prefix(prefix) || line.has_suffix ("#custom_command")) {
                                filtered_config_lines.append (line);
                                add_config_row (list_box, line);
                                break;
                            }
                        }
                    }
                }
                input_stream.close ();
            } catch (Error e) {
                print (_("Error when selecting a file: %s\n"), e.message);
            }
        } else {
            print (_("MangoHud.conf does not exist at: %s\n"), config_file.get_path ());
        }
    
        clamp.set_child (list_box);
        group.add (clamp);
        scrolled_window.set_child (group);
    
        var overlay = new Gtk.Overlay ();
        overlay.set_child (scrolled_window);
    
        var add_space_button = new Gtk.Button.with_label (_("Add space"));
        add_space_button.add_css_class ("suggested-action");
        add_space_button.set_halign (Gtk.Align.CENTER);
        add_space_button.set_valign (Gtk.Align.END);
        add_space_button.set_margin_bottom (16);
        add_space_button.clicked.connect (() => {
            var space_line = "custom_text=  #space";
            filtered_config_lines.append (space_line);
            add_config_row (list_box, space_line);
            save_config_to_file (list_box);
        });
    
        overlay.add_overlay (add_space_button);
    
        return overlay;
    }

    public void add_config_row (ListBox list_box, string line) {
        var action_row = new Adw.ActionRow ();

        string key = line.split ("=")[0];
        if (line.strip() == "custom_text=  #space") {
            action_row.title = "space";
        } else {
            action_row.title = get_localized_title (key);
        }
        action_row.subtitle = line;

        var drag_icon = new Gtk.Image.from_icon_name("list-drag-handle-symbolic");
        drag_icon.add_css_class("dim-label");
        action_row.add_prefix (drag_icon);
    
        var up_button = new Gtk.Button ();
        up_button.icon_name = "go-up-symbolic";
        up_button.add_css_class("circular");
        up_button.set_valign (Align.CENTER);
        up_button.has_frame = false;
        up_button.clicked.connect (() => {
            disable_scroll (list_box);
            move_row_up (list_box, action_row);
            save_config_to_file (list_box);
            enable_scroll (list_box);
        });
        action_row.add_suffix (up_button);
    
        var down_button = new Gtk.Button ();
        down_button.icon_name = "go-down-symbolic";
        down_button.add_css_class("circular");
        down_button.set_valign (Align.CENTER);
        down_button.has_frame = false;
        down_button.clicked.connect (() => {
            disable_scroll (list_box);
            move_row_down (list_box, action_row);
            save_config_to_file (list_box);
            enable_scroll (list_box);
        });
        action_row.add_suffix (down_button);

        var delete_button = new Gtk.Button ();
        delete_button.icon_name = "user-trash-symbolic";
        delete_button.add_css_class ("circular");
        delete_button.set_valign (Align.CENTER);
        delete_button.has_frame = false;
        delete_button.clicked.connect (() => {
            disable_scroll (list_box);
            list_box.remove (action_row);
            save_config_to_file (list_box);
            enable_scroll (list_box);
        });
        action_row.add_suffix (delete_button);

        enable_drag_and_drop (action_row, list_box, action_row);
    
        list_box.append (action_row);
    }

    void disable_scroll (ListBox list_box) {
        var scrolled_window = list_box.get_ancestor (typeof (Gtk.ScrolledWindow)) as Gtk.ScrolledWindow;
        if (scrolled_window != null) {
            scrolled_window.get_vadjustment ().set_value (scrolled_window.get_vadjustment ().get_value ());
            scrolled_window.set_sensitive (false);
        }
    }

    void enable_scroll (ListBox list_box) {
        var scrolled_window = list_box.get_ancestor (typeof (Gtk.ScrolledWindow)) as Gtk.ScrolledWindow;
        if (scrolled_window != null) {
            scrolled_window.set_sensitive (true);
        }
    }

    void enable_drag_and_drop (Gtk.Widget widget, ListBox list_box, ListBoxRow row) {
        var drag_source = new Gtk.DragSource ();
        drag_source.set_actions (Gdk.DragAction.MOVE);
    
        drag_source.drag_begin.connect ((source, drag) => {
            row.add_css_class ("card");
            var paintable = new Gtk.WidgetPaintable (row);
            drag_source.set_icon (paintable, 0, 0);
        });
    
        drag_source.drag_end.connect ((source, drag) => {
            row.remove_css_class ("card");
        });
    
        drag_source.prepare.connect ((source, x, y) => {
            Value value = Value (typeof (ListBoxRow));
            disable_scroll (list_box);
            value.set_object (row);
            enable_scroll (list_box);
            return new Gdk.ContentProvider.for_value (value);
        });
    
        widget.add_controller (drag_source);
    
        var drop_target = new Gtk.DropTarget (typeof (ListBoxRow), Gdk.DragAction.MOVE);
        drop_target.drop.connect ((target, value, x, y) => {
            var source_row = value.get_object () as ListBoxRow;
            var dest_row = list_box.get_row_at_y ((int)y);
            if (source_row != null && dest_row != null && source_row != dest_row) {
                int dest_index = get_row_index (list_box, dest_row);
                list_box.remove (source_row);
                list_box.insert (source_row, dest_index);
                save_config_to_file (list_box);
                return true;
            }
            return false;
        });
    
        drop_target.enter.connect ((target, x, y) => {
            var dest_row = list_box.get_row_at_y ((int)y);
            if (dest_row != null) {
                dest_row.add_css_class ("accent");
            }
            return Gdk.DragAction.MOVE;
        });
    
        drag_source.drag_end.connect ((source, drag) => {
            row.remove_css_class ("card");
    
            var child = list_box.get_first_child ();
            while (child != null) {
                child.remove_css_class ("accent");
                child = child.get_next_sibling ();
            }
        });
    
        drop_target.motion.connect ((target, x, y) => {
            var dest_row = list_box.get_row_at_y ((int)y);
            if (dest_row != null) {
                var child = list_box.get_first_child ();
                while (child != null) {
                    if (child == dest_row) {
                        child.add_css_class ("accent");
                    } else {
                        child.remove_css_class ("accent");
                    }
                    child = child.get_next_sibling ();
                }
            }
            return Gdk.DragAction.MOVE;
        });
    
        list_box.add_controller (drop_target);
    }

    int get_row_index (ListBox list_box, ListBoxRow row) {
        int index = 0;
        var child = list_box.get_first_child ();
        while (child != null) {
            if (child == row) return index;
            index++;
            child = child.get_next_sibling ();
        }
        return -1;
    }

    int get_row_count (ListBox list_box) {
        int count = 0;
        var child = list_box.get_first_child ();
        while (child != null) {
            count++;
            child = child.get_next_sibling ();
        }
        return count;
    }

    void move_row_up (ListBox list_box, ListBoxRow row) {
        int index = get_row_index (list_box, row);
        if (index > 0) {
            list_box.remove (row);
            list_box.insert (row, index - 1);
        }
    }

    void move_row_down (ListBox list_box, ListBoxRow row) {
        int index = get_row_index (list_box, row);
        if (index < get_row_count (list_box) - 1) {
            list_box.remove (row);
            list_box.insert (row, index + 1);
        }
    }

    void save_config_to_file (ListBox list_box) {
        try {
            var output_stream = config_file.replace (
                null,
                false,
                FileCreateFlags.NONE,
                null
            );
            var data_stream = new DataOutputStream (output_stream);

            data_stream.put_string ("# PRO MangoJuice #\n");

            var child = list_box.get_first_child ();
            while (child != null) {
                var action_row = child as Adw.ActionRow;
                if (action_row != null) {
                    data_stream.put_string (action_row.subtitle + "\n", null);
                }
                child = child.get_next_sibling ();
            }

            foreach (var config_line in all_config_lines) {
                if (filtered_config_lines.find_custom (config_line, strcmp) == null) {
                    data_stream.put_string (config_line + "\n", null);
                }
            }

            output_stream.close ();
        } catch (Error e) {
            print (_("Error writing to the file: %s\n"), e.message);
        }
    }

    string get_localized_title (string key) {
        switch (key) {
            case "custom_text_center":
                return _("Your text");
            case "custom_text":
                return _("Your text");
            case "gpu_stats":
                return _("Load GPU");
            case "vulkan_driver":
                return _("Vulkan Driver");
            case "vram":
                return _("VRAM");
            case "cpu_stats":
                return _("Load CPU");
            case "core_load":
                return _("Load per core");
            case "ram":
                return _("RAM");
            case "io_read":
                return _("Disk");
            case "io_write":
                return _("Disk");
            case "procmem":
                return _("Resident memory");
            case "swap":
                return _("Swap");
            case "fan":
                return _("Fan");
            case "fps":
                return _("FPS");
            case "fps_metrics=avg,0.01":
                return _("Lowest 0.1%");
            case "fps_metrics=avg,0.1":
                return _("Lowest 1%");
            case "version":
                return _("Version");
             case "engine_version":
                return _("Engine version");
            case "gamemode":
                return _("Gamemode");
            case "vkbasalt":
                return _("vkBasalt");
            case "exec_name":
                return _("Exe name");
            case "fsr":
                return _("FSR");
            case "hdr":
                return _("HDR");
            case "refresh_rate":
                return _("Refresh rate");
            case "resolution":
                return _("Resolution");
            case "arch":
                return _("Architecture");
            case "present_mode":
                return _("VPS");
            case "display_server":
                return _("Session type");
            case "show_fps_limit":
                return _("Frame limit");
            case "frame_timing":
                return _("Frame graph");
            case "frame_count":
                return _("Frame");
            case "battery":
                return _("Battery charge");
            case "battery_watt":
                return _("Battery power");
            case "battery_time":
                return _("Time remain");
            case "device_battery_icon":
                return _("Battery icon");
            case "device_battery=gamepad,mouse":
                return _("Other batteries");
            case "network":
                return _("Network");
            case "media_player":
                return _("Media");
            case "wine":
                return _("Version");
            case "winesync":
                return _("Winesync");
            default:
                return _("Other");
        }
    }
}
