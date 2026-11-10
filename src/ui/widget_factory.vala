/* ui/widget_factory.vala // License: GPL-3.0+ */
using Gtk;

namespace MangoJuice.UI {

public class WidgetFactory : GLib.Object {

    public struct ScaleEntryWidget {
        public Scale scale;
        public Entry entry;
        public Box widget;
    }

    public ScaleEntryWidget create_scale_entry_widget (string title, string description, int min, int max, int initial_value) {
        ScaleEntryWidget result = ScaleEntryWidget ();

        result.scale = new Scale.with_range (Orientation.HORIZONTAL, min, max, 1);
        result.scale.set_value (initial_value);
        result.scale.set_size_request (100, -1);
        result.scale.set_hexpand (true);
        result.scale.adjustment.page_increment = 1;

        result.entry = new Entry ();
        result.entry.text = "%d".printf (initial_value);
        result.entry.set_width_chars (3);
        result.entry.set_max_width_chars (4);
        result.entry.set_halign (Align.END);
        result.entry.add_css_class ("linked");
        result.entry.set_input_purpose (Gtk.InputPurpose.NUMBER);
        validate_entry_value (result.entry, min, max);

        var reset_value_button = new Button.from_icon_name ("edit-undo-symbolic");
        reset_value_button.set_focusable (false);
        reset_value_button.set_valign (Align.CENTER);
        reset_value_button.add_css_class ("linked");
        reset_value_button.set_visible (false);

        var entry_container = new Box (Orientation.HORIZONTAL, 0);
        entry_container.append (result.entry);
        entry_container.append (reset_value_button);
        entry_container.add_css_class ("linked");

        bool is_updating = false;

        result.scale.value_changed.connect (() => {
            if (!is_updating) {
                is_updating = true;
                GLib.Idle.add (() => {
                    int scale_val = (int) result.scale.get_value ();
                    result.entry.text = "%d".printf (scale_val);
                    validate_entry_value (result.entry, min, max);
                    is_updating = false;
                    return false;
                });
            }
        });

        result.entry.changed.connect (() => {
            if (!is_updating) {
                int value = 0;
                bool valid = int.try_parse (result.entry.text, out value);

                if (valid && value >= min && value <= max) {
                    is_updating = true;
                    GLib.Idle.add (() => {
                        result.scale.set_value (value);
                        result.entry.remove_css_class ("error");
                        is_updating = false;
                        return false;
                    });
                } else if (result.entry.text.strip () != "") {
                    result.entry.add_css_class ("error");
                }
            }
        });

        reset_value_button.clicked.connect (() => {
            is_updating = true;
            result.entry.text = "%d".printf (initial_value);
            result.scale.set_value (initial_value);
            result.entry.remove_css_class ("error");
            is_updating = false;
        });

        var focus_controller = new EventControllerFocus ();
        focus_controller.enter.connect (() => {
            reset_value_button.set_visible (true);
        });

        focus_controller.leave.connect (() => {
            Timeout.add (300, () => {
                if (!reset_value_button.has_focus) {
                    reset_value_button.set_visible (false);
                }
                return false;
            });
        });
        result.entry.add_controller (focus_controller);

        var labels_box = new Box (Orientation.VERTICAL, 0);
        labels_box.set_valign (Align.CENTER);

        var title_label = new Label (null);
        title_label.set_markup ("<b>%s</b>".printf (title));
        title_label.set_halign (Align.START);
        title_label.set_ellipsize (Pango.EllipsizeMode.END);

        var desc_label = new Label (null);
        desc_label.set_markup ("<span size='8500'>%s</span>".printf (description));
        desc_label.set_halign (Align.START);
        desc_label.add_css_class ("dim-label");
        desc_label.set_ellipsize (Pango.EllipsizeMode.END);

        labels_box.append (title_label);
        labels_box.append (desc_label);

        result.widget = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        result.widget.append (labels_box);
        result.widget.append (result.scale);
        result.widget.append (entry_container);

        var gesture_drag = new GestureDrag ();
        gesture_drag.drag_update.connect ((offset_x, offset_y) => {
            double current_value = result.scale.get_value ();
            int scale_width = result.scale.get_width ();
            double new_value = current_value + (offset_x / scale_width) * (max - min);
            new_value = new_value.clamp (min, max);
            result.scale.set_value (new_value);
        });
        result.scale.add_controller (gesture_drag);

        return result;
    }

    void validate_entry_value (Entry entry, int min, int max) {
        int value = 0;
        if (int.try_parse (entry.text, out value)) {
            if (value < min || value > max) {
                entry.add_css_class ("error");
            } else {
                entry.remove_css_class ("error");
            }
        } else {
            entry.add_css_class ("error");
        }
    }

    public void validate_numeric_entry (Entry entry, int min_value = int.MIN, int max_value = int.MAX) {
        entry.input_purpose = Gtk.InputPurpose.NUMBER;
        entry.set_max_length (4);
        entry.insert_text.connect ((new_text, new_text_length, ref position) => {
            foreach (var c in new_text.to_utf8 ()) {
                if (!c.isdigit () && c != '-') {
                    Signal.stop_emission_by_name (entry, "insert-text");
                    break;
                }
            }
        });
        entry.changed.connect (() => {
            string text = entry.text;
            bool is_valid = true;
            foreach (var c in text.to_utf8 ()) {
                if (!c.isdigit () && c != '-') {
                    is_valid = false;
                    break;
                }
            }
            int value = 0;
            if (is_valid && !int.try_parse (text, out value)) {
                is_valid = false;
            }
            if (is_valid && (value < min_value || value > max_value)) {
                is_valid = false;
            }
            if (is_valid) {
                entry.remove_css_class ("error");
            } else {
                entry.add_css_class ("error");
            }
        });
    }
}

}
