/* ui/widgets/drag_row.vala // License: GPL-3.0+ */
using Gtk;
using Adw;

namespace MangoJuice.UI {

public class DragRow : Adw.Bin {
    public Gtk.Widget content { get; construct; }
    public weak Gtk.ListBoxRow list_row { get; construct; }

    private const int SLIDE_DURATION_MS = 200;
    private const int DEFAULT_ROW_HEIGHT = 48;

    private Adw.Bin motion_top_bin;
    private Gtk.Revealer motion_top_revealer;
    private Adw.Bin motion_bottom_bin;
    private Gtk.Revealer motion_bottom_revealer;
    private Gtk.Revealer main_revealer;

    public signal void reordered (Gtk.ListBox list_box);

    public DragRow (Gtk.Widget content, Gtk.ListBoxRow list_row) {
        Object (content: content, list_row: list_row);
    }

    construct {
        motion_top_bin = new Adw.Bin ();
        motion_top_bin.add_css_class ("drop-target");
        motion_top_revealer = new Gtk.Revealer () {
            transition_type = SLIDE_DOWN,
            transition_duration = SLIDE_DURATION_MS,
            child = motion_top_bin
        };

        motion_bottom_bin = new Adw.Bin ();
        motion_bottom_bin.add_css_class ("drop-target");
        motion_bottom_revealer = new Gtk.Revealer () {
            transition_type = SLIDE_DOWN,
            transition_duration = SLIDE_DURATION_MS,
            child = motion_bottom_bin
        };

        var content_list = new Gtk.ListBox ();
        content_list.set_selection_mode (Gtk.SelectionMode.NONE);
        content_list.add_css_class ("drag-content");
        content_list.append (content);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        main_box.append (motion_top_revealer);
        main_box.append (content_list);
        main_box.append (motion_bottom_revealer);

        main_revealer = new Gtk.Revealer () {
            transition_type = SLIDE_DOWN,
            transition_duration = SLIDE_DURATION_MS,
            child = main_box,
            reveal_child = true
        };

        child = main_revealer;

        setup_drag_and_drop ();
    }

    private void setup_drag_and_drop () {
        update_drop_placeholders ();

        var drag_source = new Gtk.DragSource ();
        drag_source.set_actions (Gdk.DragAction.MOVE);
        list_row.add_controller (drag_source);

        drag_source.prepare.connect ((source, x, y) => {
            return new Gdk.ContentProvider.for_value (list_row);
        });

        drag_source.drag_begin.connect ((source, drag) => {
            var paintable = new Gtk.WidgetPaintable (content);
            source.set_icon (paintable, 0, 0);
            begin_drag ();
        });

        drag_source.drag_end.connect ((source, drag, delete_data) => {
            end_drag ();
        });

        drag_source.drag_cancel.connect ((source, drag, reason) => {
            end_drag ();
            return false;
        });

        var drop_order_target = new Gtk.DropTarget (typeof (Gtk.ListBoxRow), Gdk.DragAction.MOVE);
        list_row.add_controller (drop_order_target);

        drop_order_target.drop.connect ((value, x, y) => {
            var source_row = value.get_object () as Gtk.ListBoxRow;
            if (source_row == null || source_row == list_row) {
                return false;
            }

            var source_list_box = source_row.get_parent () as Gtk.ListBox;
            var target_list_box = list_row.get_parent () as Gtk.ListBox;
            if (source_list_box == null || target_list_box == null || source_list_box != target_list_box) {
                return false;
            }

            bool drop_below = y >= list_row.get_height () / 2.0;
            int target_index = list_row.get_index () + (drop_below ? 1 : 0);
            int source_index = source_row.get_index ();
            if (target_index < 0 || source_index < 0) {
                return false;
            }

            source_list_box.remove (source_row);
            target_list_box.insert (source_row, target_index > source_index ? target_index - 1 : target_index);

            reset_drop_indicators ();
            reordered (target_list_box);
            return true;
        });

        var drop_motion_ctrl = new Gtk.DropControllerMotion ();
        list_row.add_controller (drop_motion_ctrl);

        drop_motion_ctrl.enter.connect (() => {
            update_drop_placeholders ();
        });

        drop_motion_ctrl.motion.connect ((x, y) => {
            var row_height = list_row.get_height ();
            if (row_height <= 0) {
                return;
            }
            bool is_top_half = y < row_height / 2;

            if (motion_top_revealer.reveal_child != is_top_half) {
                motion_top_revealer.reveal_child = is_top_half;
                if (is_top_half) {
                    motion_top_bin.add_css_class ("drop-area");
                } else {
                    motion_top_bin.remove_css_class ("drop-area");
                }
            }

            if (motion_bottom_revealer.reveal_child != !is_top_half) {
                motion_bottom_revealer.reveal_child = !is_top_half;
                if (!is_top_half) {
                    motion_bottom_bin.add_css_class ("drop-area");
                } else {
                    motion_bottom_bin.remove_css_class ("drop-area");
                }
            }
        });

        drop_motion_ctrl.leave.connect (() => {
            reset_drop_indicators ();
        });

        list_row.map.connect (() => update_drop_placeholders ());
    }

    private void begin_drag () {
        content.add_css_class ("drop-begin");
        main_revealer.reveal_child = false;
    }

    private void end_drag () {
        content.remove_css_class ("drop-begin");
        reset_drop_indicators ();
        main_revealer.reveal_child = true;
    }

    private void reset_drop_indicators () {
        motion_top_revealer.reveal_child = false;
        motion_bottom_revealer.reveal_child = false;
        motion_top_bin.remove_css_class ("drop-area");
        motion_bottom_bin.remove_css_class ("drop-area");
    }

    private void update_drop_placeholders () {
        var height = content.get_height ();
        if (height <= 0) {
            height = list_row.get_height ();
        }
        if (height <= 0) {
            height = DEFAULT_ROW_HEIGHT;
        }
        motion_top_bin.height_request = height;
        motion_bottom_bin.height_request = height;
    }
}

}
