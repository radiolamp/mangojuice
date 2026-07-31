using Gtk;
using Adw;

public class DragRow : Adw.Bin {
    public Gtk.Widget content { get; construct; }
    public weak Gtk.ListBoxRow row { get; construct; }

    private const int TRANSITION_DURATION = 200;
    private Adw.Bin motion_top_grid;
    private Gtk.Revealer motion_top_revealer;
    private Adw.Bin motion_bottom_grid;
    private Gtk.Revealer motion_bottom_revealer;
    private Gtk.Revealer main_revealer;

    private Gtk.DragSource drag_source;
    private Gtk.DropTarget drop_order_target;
    private Gtk.DropControllerMotion drop_motion_ctrl;

    public bool on_drag { get; set; default = false; }
    public signal void on_drop_end (Gtk.ListBox listbox);

    public DragRow (Gtk.Widget content, Gtk.ListBoxRow row) {
        Object (content: content, row: row);
    }

    construct {
        motion_top_grid = new Adw.Bin ();
        motion_top_grid.add_css_class ("drop-target");
        motion_top_revealer = new Gtk.Revealer () {
            transition_type = SLIDE_DOWN,
            transition_duration = TRANSITION_DURATION,
            child = motion_top_grid
        };

        motion_bottom_grid = new Adw.Bin ();
        motion_bottom_grid.add_css_class ("drop-target");
        motion_bottom_revealer = new Gtk.Revealer () {
            transition_type = SLIDE_DOWN,
            transition_duration = TRANSITION_DURATION,
            child = motion_bottom_grid
        };

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        main_box.append (motion_top_revealer);
        main_box.append (content);
        main_box.append (motion_bottom_revealer);

        main_revealer = new Gtk.Revealer () {
            transition_type = SLIDE_DOWN,
            transition_duration = TRANSITION_DURATION,
            child = main_box,
            reveal_child = true
        };

        child = main_revealer;
    }

    public void build_drag_and_drop () {
        draw_motion_widgets ();

        drag_source = new Gtk.DragSource ();
        drag_source.set_actions (Gdk.DragAction.MOVE);
        row.add_controller (drag_source);

        drag_source.prepare.connect ((source, x, y) => {
            return new Gdk.ContentProvider.for_value (row);
        });

        drag_source.drag_begin.connect ((source, drag) => {
            var paintable = new Gtk.WidgetPaintable (content);
            source.set_icon (paintable, 0, 0);
            drag_begin ();
        });

        drag_source.drag_end.connect ((source, drag, delete_data) => {
            drag_end ();
        });

        drag_source.drag_cancel.connect ((source, drag, reason) => {
            drag_end ();
            return false;
        });

        drop_order_target = new Gtk.DropTarget (typeof (Gtk.ListBoxRow), Gdk.DragAction.MOVE);
        row.add_controller (drop_order_target);

        drop_order_target.drop.connect ((value, x, y) => {
            var source_row = value.get_object () as Gtk.ListBoxRow;
            if (source_row == null || source_row == row) {
                return false;
            }

            bool bottom = y >= row.get_height () / 2.0;
            int target_index = row.get_index () + (bottom ? 1 : 0);
            int source_index = source_row.get_index ();

            ((Gtk.ListBox) source_row.get_parent ()).remove (source_row);
            ((Gtk.ListBox) row.get_parent ()).insert (source_row, target_index > source_index ? target_index - 1 : target_index);

            on_drop_end ((Gtk.ListBox) row.get_parent ());
            return true;
        });

        drop_motion_ctrl = new Gtk.DropControllerMotion ();
        row.add_controller (drop_motion_ctrl);

        drop_motion_ctrl.motion.connect ((x, y) => {
            var row_height = row.get_height ();
            if (row_height <= 0) {
                return;
            }
            bool is_top_half = (y < row_height / 2);

            if (motion_top_revealer.reveal_child != is_top_half) {
                motion_top_revealer.reveal_child = is_top_half;
                if (is_top_half) {
                    motion_top_grid.add_css_class ("drop-area");
                } else {
                    motion_top_grid.remove_css_class ("drop-area");
                }
            }

            if (motion_bottom_revealer.reveal_child != !is_top_half) {
                motion_bottom_revealer.reveal_child = !is_top_half;
                if (!is_top_half) {
                    motion_bottom_grid.add_css_class ("drop-area");
                } else {
                    motion_bottom_grid.remove_css_class ("drop-area");
                }
            }
        });

        drop_motion_ctrl.leave.connect (() => {
            motion_top_revealer.reveal_child = false;
            motion_bottom_revealer.reveal_child = false;
            motion_top_grid.remove_css_class ("drop-area");
            motion_bottom_grid.remove_css_class ("drop-area");
        });
    }

    public void drag_begin () {
        content.add_css_class ("drop-begin");
        on_drag = true;
        main_revealer.reveal_child = false;
    }

    public void drag_end () {
        content.remove_css_class ("drop-begin");
        on_drag = false;
        main_revealer.reveal_child = true;
    }

    public void draw_motion_widgets () {
        var height = row.get_height ();
        if (height == 0) {
            height = 48;
        }
        motion_top_grid.height_request = height;
        motion_bottom_grid.height_request = height;
    }
}
