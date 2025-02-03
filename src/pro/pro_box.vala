using Gtk;
using Adw;

public class ProBox : Box {

    public ProBox () {
        Object (
            orientation: Orientation.VERTICAL,
            spacing: 10
        );

        load_css (); // Загружаем CSS

        var group = new Adw.PreferencesGroup ();
        var group_label = create_label (_("Advansed"), Gtk.Align.START, { "title-4" });
        group.add (group_label);

        var list_box = new ListBox ();
        list_box.set_selection_mode (SelectionMode.NONE);
        list_box.set_margin_start (12);
        list_box.set_margin_end (12);
        list_box.set_margin_top (12);
        list_box.set_margin_bottom (12);

        list_box.add_css_class ("boxed-list");
        for (int i = 1; i <= 5; i++) {
            var action_row = new Adw.ActionRow ();
            action_row.title = "Заголовок %d".printf (i);
            action_row.subtitle = "Подзаголовок %d".printf (i);

            var drag_button = new Gtk.Button ();
            drag_button.icon_name = "list-drag-handle-symbolic";
            drag_button.tooltip_text = "Перетащить";
            drag_button.has_frame = false;

            enable_drag_and_drop (drag_button, list_box, action_row);

            list_box.append (action_row);
            action_row.add_prefix (drag_button);
        }

        var clamp = new Adw.Clamp ();
        clamp.set_maximum_size (600);
        clamp.set_child (list_box);

        group.add (clamp);
        this.append (group);
    }

    private void load_css () {
        var provider = new Gtk.CssProvider ();
        provider.load_from_string ("""
            .default {
                background-color: rgba(128, 128, 128, 0.2);
                border-radius: 5px;
            }
        """);

        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }

    private void enable_drag_and_drop (Gtk.Button drag_button, ListBox list_box, ListBoxRow row) {
        var drag_source = new Gtk.DragSource ();
        drag_source.set_actions (Gdk.DragAction.MOVE);
    
        drag_source.drag_begin.connect ((source, drag) => {
            var paintable = new Gtk.WidgetPaintable (row);
            drag_source.set_icon (paintable, 0, 0);
    
            row.add_css_class ("dragging");
            row.add_css_class ("default"); // Добавляем класс "default"
        });
    
        drag_source.drag_end.connect ((source, drag) => {
            row.remove_css_class ("dragging");
            row.remove_css_class ("default"); // Удаляем класс "default"
        });
    
        drag_source.prepare.connect ((source, x, y) => {
            Value value = Value (typeof (ListBoxRow));
            value.set_object (row);
            return new Gdk.ContentProvider.for_value (value);
        });
    
        drag_button.add_controller (drag_source);
    
        var drop_target = new Gtk.DropTarget (typeof (ListBoxRow), Gdk.DragAction.MOVE);
        drop_target.drop.connect ((target, value, x, y) => {
            var source_row = value.get_object () as ListBoxRow;
            var dest_row = list_box.get_row_at_y ((int)y);
            if (source_row != null && dest_row != null && source_row != dest_row) {
                int source_index = get_row_index (list_box, source_row);
                int dest_index = get_row_index (list_box, dest_row);
                stdout.printf ("Moving row from index %d to index %d\n", source_index, dest_index);
                list_box.remove (source_row);
                list_box.insert (source_row, dest_index);
                return true;
            }
            return false;
        });
        list_box.add_controller (drop_target);
    }

    private int get_row_index (ListBox list_box, ListBoxRow row) {
        int index = 0;
        var child = list_box.get_first_child ();
        while (child != null) {
            if (child == row) {
                return index;
            }
            index++;
            child = child.get_next_sibling ();
        }
        return -1;
    }

    private Gtk.Label create_label (string text, Gtk.Align align, string[] style_classes) {
        var label = new Gtk.Label (text);
        label.set_halign (align);
        foreach (var style_class in style_classes) {
            label.add_css_class (style_class);
            label.set_margin_start (12);
            label.set_margin_end (12);
            label.set_margin_top (12);
            label.set_margin_bottom (12);
        }
        return label;
    }
}