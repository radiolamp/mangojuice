/* advanced.vala // Licence:  GPL-v3.0 */
using Gtk;
using Adw;

public class AdvancedDialog : Adw.Dialog {
    File config_file;
    List<string> all_config_lines;
    List<string> filtered_config_lines;
    ListBox list_box;
    private Gtk.ListBoxRow? drop_indicator_row = null;

    string[] allowed_prefixes = { "custom_text_center=", "custom_text=", "gpu_stats", "vram", "cpu_stats",
    "core_load", "ram", "io_read", "io_write", "procmem", "swap", "fan", "fps", "fps_metrics=avg,0.01",
    "fps_metrics=avg,0.1", "version", "gamemode", "vkbasalt", "exec_name", "fsr", "hdr", "vulkan_driver",
    "engine_version", "refresh_rate", "resolution", "arch", "present_mode", "display_server", "show_fps_limit",
    "frame_timing", "frame_count", "battery", "battery_watt", "battery_time", "device_battery_icon",
    "device_battery=gamepad,mouse", "network", "media_player", "wine", "winesync", "time" };

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
                        !line.contains ("fps_limit=") &&
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

        var drag_icon = new Gtk.Image.from_icon_name("io.github.radiolamp.mangojuice.list-drag-handle-symbolic");
        drag_icon.add_css_class("dim-label");
        action_row.add_prefix (drag_icon);
    
        var up_button = new Gtk.Button ();
        up_button.icon_name = "go-up-symbolic";
        up_button.add_css_class("circular");
        up_button.set_valign (Align.CENTER);
        up_button.has_frame = false;
        up_button.clicked.connect (() => {
            move_row_up (list_box, action_row);
            save_config_to_file (list_box);
        });
        action_row.add_suffix (up_button);
    
        var down_button = new Gtk.Button ();
        down_button.icon_name = "go-down-symbolic";
        down_button.add_css_class("circular");
        down_button.set_valign (Align.CENTER);
        down_button.has_frame = false;
        down_button.clicked.connect (() => {
            move_row_down (list_box, action_row);
            save_config_to_file (list_box);
        });
        action_row.add_suffix (down_button);

        var delete_button = new Gtk.Button ();
        delete_button.icon_name = "user-trash-symbolic";
        delete_button.add_css_class ("circular");
        delete_button.set_valign (Align.CENTER);
        delete_button.has_frame = false;
        delete_button.clicked.connect (() => {
            list_box.remove (action_row);
            save_config_to_file (list_box);
        });
        action_row.add_suffix (delete_button);

        enable_drag_and_drop (action_row, list_box, action_row);
    
        list_box.append (action_row);
    }

    void enable_drag_and_drop(Gtk.Widget widget, ListBox list_box, ListBoxRow row) {
        var drag_source = new Gtk.DragSource();
        drag_source.set_actions(Gdk.DragAction.MOVE);
        
        // Store the dragged row reference
        ListBoxRow? dragged_row = null;
        
        drag_source.drag_begin.connect((source, drag) => {
            dragged_row = row;
            row.add_css_class("card");
            var paintable = new Gtk.WidgetPaintable(row);
            drag_source.set_icon(paintable, 0, 0);
        });
        
        drag_source.drag_end.connect((source, drag) => {
            if (dragged_row != null) {
                dragged_row.remove_css_class("card");
                dragged_row = null;
            }
            clear_drop_highlight(list_box);
        });
        
        drag_source.prepare.connect((source, x, y) => {
            Value value = Value(typeof(ListBoxRow));
            value.set_object(row);
            return new Gdk.ContentProvider.for_value(value);
        });
        
        widget.add_controller(drag_source);
        
        var drop_target = new Gtk.DropTarget(typeof(ListBoxRow), Gdk.DragAction.MOVE);
        
        drop_target.drop.connect((target, value, x, y) => {
            var source_row = value.get_object() as ListBoxRow;
            var dest_row = list_box.get_row_at_y((int)y);
            
            if (source_row == null || dest_row == null || source_row == dest_row) {
                return false;
            }
        
            var scrolled_window = get_scrolled_parent(list_box);
            double scroll_position = 0;
            if (scrolled_window != null) {
                scroll_position = get_scroll_position(scrolled_window);
            }
        
            int source_index = get_row_index(list_box, source_row);
            int dest_index = get_row_index(list_box, dest_row);
        
            list_box.remove(source_row);
            
            if (source_index < dest_index) {
                dest_index--;
            }
            
            list_box.insert(source_row, dest_index);
            save_config_to_file(list_box);
        
            if (scrolled_window != null) {
                restore_scroll_position(scrolled_window, scroll_position);
            }
        
            return true;
        });
        
        drop_target.enter.connect((target, x, y) => {
            var hover_row = list_box.get_row_at_y((int)y);
            if (hover_row != null && hover_row != dragged_row) {
                update_drop_highlight(list_box, (int)y);
            }
            return Gdk.DragAction.MOVE;
        });
        
        drop_target.motion.connect((target, x, y) => {
            var hover_row = list_box.get_row_at_y((int)y);
            if (hover_row != null && hover_row != dragged_row) {
                update_drop_highlight(list_box, (int)y);
            } else {
                clear_drop_highlight(list_box);
            }
            return Gdk.DragAction.MOVE;
        });
        
        drop_target.leave.connect((target) => {
            clear_drop_highlight(list_box);
        });
        
        list_box.add_controller(drop_target);
    }

    private void update_drop_highlight (ListBox list_box, int y) {
        clear_drop_highlight (list_box);
    
        var dest_row = list_box.get_row_at_y (y);
        if (dest_row != null) {
            drop_indicator_row = dest_row;
            drop_indicator_row.add_css_class ("row-drop-indicator");
        }
    }
    
    private void clear_drop_highlight (ListBox list_box) {
        if (drop_indicator_row != null) {
            drop_indicator_row.remove_css_class ("row-drop-indicator");
            drop_indicator_row = null;
        }
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
        var scrolled_window = get_scrolled_parent(list_box);
        if (scrolled_window != null) {
            double vpos = get_scroll_position(scrolled_window);
    
            int index = get_row_index (list_box, row);
            if (index > 0) {
                list_box.remove (row);
                list_box.insert (row, index - 1);
            }
    
            restore_scroll_position(scrolled_window, vpos);
        }
    }
    
    void move_row_down (ListBox list_box, ListBoxRow row) {
        var scrolled_window = get_scrolled_parent(list_box);
        if (scrolled_window != null) {
            double vpos = get_scroll_position(scrolled_window);
    
            int index = get_row_index (list_box, row);
            if (index < get_row_count (list_box) - 1) {
                list_box.remove (row);
                list_box.insert (row, index + 1);
            }
    
            restore_scroll_position(scrolled_window, vpos);
        }
    }
    
    Gtk.ScrolledWindow? get_scrolled_parent(Gtk.Widget widget) {
        Gtk.Widget? parent = widget.get_parent();
        while (parent != null) {
            if (parent is Gtk.ScrolledWindow) {
                return parent as Gtk.ScrolledWindow;
            }
            parent = parent.get_parent();
        }
        return null;
    }
    
    double get_scroll_position(Gtk.ScrolledWindow scrolled_window) {
        var vadjustment = scrolled_window.get_vadjustment();
        return vadjustment.get_value();
    }
    
    void restore_scroll_position(Gtk.ScrolledWindow scrolled_window, double value) {
        var vadjustment = scrolled_window.get_vadjustment();
        Idle.add(() => {
            vadjustment.set_value(value);
            return false;
        });
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
        var localized_titles = new Gee.HashMap<string, string>();
        
        localized_titles["custom_text_center"] = _("Your text");
        localized_titles["custom_text"] = _("Your text");
        localized_titles["gpu_stats"] = _("Load GPU");
        localized_titles["vulkan_driver"] = _("Vulkan Driver");
        localized_titles["vram"] = _("VRAM");
        localized_titles["cpu_stats"] = _("Load CPU");
        localized_titles["core_load"] = _("Load per core");
        localized_titles["ram"] = _("RAM");
        localized_titles["io_read"] = _("Disk");
        localized_titles["io_write"] = _("Disk");
        localized_titles["procmem"] = _("Resident memory");
        localized_titles["swap"] = _("Swap");
        localized_titles["fan"] = _("Fan");
        localized_titles["fps"] = _("FPS");
        localized_titles["fps_metrics=avg,0.01"] = _("Lowest 0.1%");
        localized_titles["fps_metrics=avg,0.1"] = _("Lowest 1%");
        localized_titles["version"] = _("Version");
        localized_titles["engine_version"] = _("Engine version");
        localized_titles["gamemode"] = _("Gamemode");
        localized_titles["vkbasalt"] = _("vkBasalt");
        localized_titles["exec_name"] = _("Exe name");
        localized_titles["fsr"] = _("FSR");
        localized_titles["hdr"] = _("HDR");
        localized_titles["refresh_rate"] = _("Refresh rate");
        localized_titles["resolution"] = _("Resolution");
        localized_titles["arch"] = _("Architecture");
        localized_titles["present_mode"] = _("VPS");
        localized_titles["display_server"] = _("Session type");
        localized_titles["show_fps_limit"] = _("Frame limit");
        localized_titles["frame_timing"] = _("Frame graph");
        localized_titles["frame_count"] = _("Frame");
        localized_titles["battery"] = _("Battery charge");
        localized_titles["battery_watt"] = _("Battery power");
        localized_titles["battery_time"] = _("Time remain");
        localized_titles["device_battery_icon"] = _("Battery icon");
        localized_titles["device_battery=gamepad,mouse"] = _("Other batteries");
        localized_titles["network"] = _("Network");
        localized_titles["media_player"] = _("Media");
        localized_titles["wine"] = _("Version");
        localized_titles["winesync"] = _("Winesync");
        localized_titles["time"] = _("Watch");
        
        return localized_titles.has_key(key) ? localized_titles[key] : _("Other");
    }
}
