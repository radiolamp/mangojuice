using Gtk;
using Adw;

public class AdvancedDialog : Adw.Dialog {
    private File config_file;
    private List<string> all_config_lines;
    private List<string> filtered_config_lines;
    private ListBox list_box;

    public AdvancedDialog (Gtk.Window parent) {
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

        this.set_child (main_box);
        this.present (parent);
    }

    private Gtk.Widget create_advanced_content () {
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

                    if (!line.contains ("color")) {
                        if (line.has_prefix ("custom_text_center=") ||
                            line.has_prefix ("custom_text=") ||
                            line.has_prefix ("gpu_stats") ||
                            line.has_prefix ("vram") ||
                            line.has_prefix ("cpu_stats") ||
                            line.has_prefix ("core_load") ||
                            line.has_prefix ("ram") ||
                            line.has_prefix ("io_read") ||
                            line.has_prefix ("io_write") ||
                            line.has_prefix ("procmem") ||
                            line.has_prefix ("swap") ||
                            line.has_prefix ("fan") ||
                            line.has_prefix ("fps") ||
                            line.has_prefix ("fps_metrics=avg,0.01") ||
                            line.has_prefix ("fps_metrics=avg,0.1") ||
                            line.has_prefix ("version") ||
                            line.has_prefix ("gamemode") ||
                            line.has_prefix ("vkbasalt") ||
                            line.has_prefix ("exec_name") ||
                            line.has_prefix ("fsr") ||
                            line.has_prefix ("hdr") ||
                            line.has_prefix ("engine_version") ||
                            line.has_prefix ("refresh_rate") ||
                            line.has_prefix ("resolution") ||
                            line.has_prefix ("arch") ||
                            line.has_prefix ("present_mode") ||
                            line.has_prefix ("show_fps_limit") ||
                            line.has_prefix ("frame_timing") ||
                            line.has_prefix ("frame_count") ||
                            line.has_prefix ("battery") ||
                            line.has_prefix ("battery_watt") ||
                            line.has_prefix ("battery_time") ||
                            line.has_prefix ("device_battery_icon") ||
                            line.has_prefix ("device_battery=gamepad,mouse") ||
                            line.has_prefix ("network") ||
                            line.has_prefix ("media_player") ||
                            line.has_prefix ("wine") ||
                            line.has_suffix ("#custom_command") ||
                            line.has_prefix ("winesync")) {
                            filtered_config_lines.append (line);
                            add_config_row (list_box, line);
                        }
                    }
                }

                input_stream.close ();
            } catch (Error e) {
                print (_("Error when selecting a file: %s\n"), e.message);
            }
        } else {
            print (_("MangoHud.conf does not exist.\n"), config_file.get_path ());
        }

        clamp.set_child (list_box);
        group.add (clamp);

        scrolled_window.set_child (group);

        return scrolled_window;
    }

    private void add_config_row (ListBox list_box, string line) {
        var action_row = new Adw.ActionRow ();

        string key = line.split ("=")[0];
        action_row.title = get_localized_title (key);
        action_row.subtitle = line;

        var drag_button = new Gtk.Button ();
        drag_button.icon_name = "list-drag-handle-symbolic";
        drag_button.has_frame = false;
        enable_drag_and_drop (drag_button, list_box, action_row);
        action_row.add_prefix (drag_button);

        var up_button = new Gtk.Button ();
        up_button.icon_name = "go-up-symbolic";
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
        down_button.has_frame = false;
        down_button.clicked.connect (() => {
            disable_scroll (list_box);
            move_row_down (list_box, action_row);
            save_config_to_file (list_box);
            enable_scroll (list_box);
        });
        action_row.add_suffix (down_button);
    
        list_box.append (action_row);
    }

    private void disable_scroll (ListBox list_box) {
        var scrolled_window = list_box.get_ancestor (typeof (Gtk.ScrolledWindow)) as Gtk.ScrolledWindow;
        if (scrolled_window != null) {
            scrolled_window.get_vadjustment ().set_value (scrolled_window.get_vadjustment ().get_value ());
            scrolled_window.set_sensitive (false);
        }
    }

    private void enable_scroll (ListBox list_box) {
        var scrolled_window = list_box.get_ancestor (typeof (Gtk.ScrolledWindow)) as Gtk.ScrolledWindow;
        if (scrolled_window != null) {
            scrolled_window.set_sensitive (true);
        }
    }

    private void enable_drag_and_drop (Gtk.Button drag_button, ListBox list_box, ListBoxRow row) {
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

        drag_button.add_controller (drag_source);

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

    private int get_row_index (ListBox list_box, ListBoxRow row) {
        int index = 0;
        var child = list_box.get_first_child ();
        while (child != null) {
            if (child == row) return index;
            index++;
            child = child.get_next_sibling ();
        }
        return -1;
    }

    private int get_row_count (ListBox list_box) {
        int count = 0;
        var child = list_box.get_first_child ();
        while (child != null) {
            count++;
            child = child.get_next_sibling ();
        }
        return count;
    }

    private void move_row_up (ListBox list_box, ListBoxRow row) {
        int index = get_row_index (list_box, row);
        if (index > 0) {
            list_box.remove (row);
            list_box.insert (row, index - 1);
        }
    }

    private void move_row_down (ListBox list_box, ListBoxRow row) {
        int index = get_row_index (list_box, row);
        if (index < get_row_count (list_box) - 1) {
            list_box.remove (row);
            list_box.insert (row, index + 1);
        }
    }

    private void save_config_to_file (ListBox list_box) {
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

    private string get_localized_title (string key) {
        switch (key) {
            case "custom_text_center":
                return _("Your text");
            case "custom_text":
                return _("Your text");
            case "gpu_stats":
                return _("Load GPU");
            case "engine_version":
                return _("Vulkan Driver");
            case "vram":
                return _("VRAM");
            case "cpu_stats":
                return _("Load CPU");
            case "core_load":
                return _("Core Load");
            case "ram":
                return _("RAM");
            case "io_read":
                return _("Disk IO");
            case "io_write":
                return _("Disk IO");
            case "procmem":
                return _("Resident mem");
            case "swap":
                return _("Swap");
            case "fan":
                return _("Fan");
            case "fps":
                return _("FPS");
            case "fps_metrics=avg,0.01":
                return _("FPS low 0.1%");
            case "fps_metrics=avg,0.1":
                return _("FPS low 1%");
            case "version":
                return _("Version");
            case "gamemode":
                return _("Gamemode");
            case "vkbasalt":
                return _("VKbasalt");
            case "exec_name":
                return _("Name");
            case "fsr":
                return _("FSR");
            case "hdr":
                return _("HDR");
            case "refresh_rate":
                return _("Refresh rate");
            case "resolution":
                return _("Resolution");
            case "arch":
                return _("Arch");
            case "present_mode":
                return _("VPS");
            case "show_fps_limit":
                return _("Frame limit");
            case "frame_timing":
                return _("Frame time");
            case "frame_count":
                return _("Frame");
            case "battery":
                return _("Percentage");
            case "battery_watt":
                return _("Wattage");
            case "battery_time":
                return _("Time remain");
            case "device_battery_icon":
                return _("Battery icon");
            case "device_battery=gamepad,mouse":
                return _("Device");
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