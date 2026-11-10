/* ui/widgets/shortcut_recorder.vala // License: GPL-3.0+ */
using Gtk;
using Gee;

namespace MangoJuice.UI {

public class ShortcutRecorder : Gtk.Box {
    const string KEY_CONTROL_L = "Control_L";
    const string KEY_CONTROL_R = "Control_R";
    const string KEY_SHIFT_L = "Shift_L";
    const string KEY_SHIFT_R = "Shift_R";
    const string KEY_ALT_L = "Alt_L";
    const string KEY_ALT_R = "Alt_R";
    const string KEY_SUPER_L = "Super_L";
    const string KEY_SUPER_R = "Super_R";
    const string KEY_META_L = "Meta_L";
    const string KEY_META_R = "Meta_R";

    Gtk.Button _record_button;
    Gtk.Label _display_label;
    Gtk.Button _edit_button;
    Gtk.Entry _entry;
    string _shortcut = "";
    string _previous_shortcut = "";
    bool _is_recording = false;
    Gdk.ModifierType _current_modifiers = 0;
    Gee.HashMap<string, bool> _active_modifiers = new Gee.HashMap<string, bool> ();

    public string shortcut {
        get { return _shortcut; }
        set {
            _shortcut = value;
            update_display ();
        }
    }

    public bool is_recording {
        get { return _is_recording; }
    }

    public signal void shortcut_changed (string shortcut);

    public ShortcutRecorder () {
        Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

        this.add_css_class ("linked");

        _record_button = new Gtk.Button ();
        _record_button.hexpand = true;
        _display_label = new Gtk.Label ("");
        _record_button.child = _display_label;

        _edit_button = new Gtk.Button.from_icon_name ("document-edit-symbolic");
        _edit_button.tooltip_text = _ ("Edit shortcut manually");

        _entry = new Gtk.Entry ();
        _entry.visible = false;
        _entry.primary_icon_name = "input-keyboard-symbolic";
        _entry.secondary_icon_name = "edit-clear-symbolic";
        _entry.secondary_icon_activatable = true;

        append (_record_button);
        append (_edit_button);
        append (_entry);

        _record_button.clicked.connect (() => {
            if (!_is_recording) start_recording ();
            else cancel_recording ();
        });

        _edit_button.clicked.connect (() => {
            start_editing ();
        });

        _entry.activate.connect (() => {
            apply_editing ();
        });

        _entry.icon_release.connect ((pos) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                cancel_editing ();
            }
        });
    }

    void update_display () {
        _display_label.label = _shortcut;
    }

    void start_recording () {
        _is_recording = true;
        _previous_shortcut = _shortcut;
        _shortcut = "";
        _current_modifiers = 0;
        _active_modifiers.clear ();

        var image = new Gtk.Image.from_icon_name ("input-keyboard-symbolic");
        image.pixel_size = 16;
        _record_button.child = image;

        _record_button.add_css_class ("suggested-action");
        _record_button.grab_focus ();
    }

    void stop_recording () {
        _is_recording = false;
        _record_button.child = _display_label;
        update_display ();
        _record_button.remove_css_class ("suggested-action");
        _current_modifiers = 0;
        _active_modifiers.clear ();
    }

    void cancel_recording () {
        _shortcut = _previous_shortcut;
        stop_recording ();
    }

    void start_editing () {
        _entry.text = _shortcut;
        _entry.visible = true;
        _record_button.visible = false;
        _edit_button.visible = false;
        _entry.grab_focus ();
    }

    void apply_editing () {
        _shortcut = _entry.text.strip ();
        shortcut_changed (_shortcut);
        finish_editing ();
    }

    void cancel_editing () {
        finish_editing ();
    }

    void finish_editing () {
        _entry.visible = false;
        _record_button.visible = true;
        _edit_button.visible = true;
        update_display ();
    }

    public bool handle_key_event (uint keyval, Gdk.ModifierType state) {
        return handle_key_event_with_code (keyval, 0, state);
    }

    public bool handle_key_event_with_code (uint keyval, uint keycode, Gdk.ModifierType state) {
        if (!_is_recording) return false;

        if (keyval == Gdk.Key.Escape) {
            cancel_recording ();
            return true;
        }

        var key = Gdk.keyval_name (keyval) ?? "Unknown";

        string[] ignored_modifiers = {
            "Control_L", "Control_R", "Shift_L", "Shift_R",
            "Alt_L", "Alt_R", "Super_L", "Super_R", "Meta_L", "Meta_R",
            "Num_Lock", "Caps_Lock", "Scroll_Lock"
        };

        bool is_modifier = false;
        foreach (string modifier in ignored_modifiers) {
            if (key == modifier) {
                is_modifier = true;
                break;
            }
        }

        if (is_modifier) {
            _active_modifiers[key] = true;
            _current_modifiers = state;
            return true;
        }

        string[] ignored_keys = {
            "ISO_Level3_Shift", "Mode_switch", "Multi_key", "Print", "Pause",
            "Insert", "Delete", "Home", "End", "Page_Up", "Page_Down"
        };

        foreach (string ignored in ignored_keys) {
            if (key == ignored) return true;
        }

        if (!is_modifier) {
            process_final_key (key, state);
            return true;
        }

        return true;
    }

    void process_final_key (string key, Gdk.ModifierType state) {
        var modifiers = new StringBuilder ();

        if (_active_modifiers["Control_L"]) modifiers.append ("Control_L+");
        else if (_active_modifiers["Control_R"]) modifiers.append ("Control_R+");

        if (_active_modifiers["Shift_L"]) modifiers.append ("Shift_L+");
        else if (_active_modifiers["Shift_R"]) modifiers.append ("Shift_R+");

        if (_active_modifiers["Alt_L"]) modifiers.append ("Alt_L+");
        else if (_active_modifiers["Alt_R"]) modifiers.append ("Alt_R+");

        if (_active_modifiers["Super_L"]) modifiers.append ("Super_L+");
        else if (_active_modifiers["Super_R"]) modifiers.append ("Super_R+");

        if (_active_modifiers["Meta_L"]) modifiers.append ("Meta_L+");
        else if (_active_modifiers["Meta_R"]) modifiers.append ("Meta_R+");

        string processed_key = key;

        if ((state & Gdk.ModifierType.SHIFT_MASK) != 0) {
            switch (processed_key) {
                case "exclam": processed_key = "1"; break;
                case "at": processed_key = "2"; break;
                case "numbersign": processed_key = "3"; break;
                case "dollar": processed_key = "4"; break;
                case "percent": processed_key = "5"; break;
                case "asciicircum": processed_key = "6"; break;
                case "ampersand": processed_key = "7"; break;
                case "asterisk": processed_key = "8"; break;
                case "parenleft": processed_key = "9"; break;
                case "parenright": processed_key = "0"; break;
                case "underscore": processed_key = "minus"; break;
                case "plus": processed_key = "equal"; break;
                case "braceleft": processed_key = "bracketleft"; break;
                case "braceright": processed_key = "bracketright"; break;
                case "bar": processed_key = "backslash"; break;
                case "colon": processed_key = "semicolon"; break;
                case "quotedbl": processed_key = "apostrophe"; break;
                case "tilde": processed_key = "grave"; break;
                case "less": processed_key = "comma"; break;
                case "greater": processed_key = "period"; break;
                case "question": processed_key = "slash"; break;
            }
        }

        if (processed_key.has_prefix ("KP_")) {
            processed_key = processed_key.substring (3);
        } else if (processed_key.has_prefix ("kr")) {
            processed_key = processed_key.substring (2);
        }

        if (processed_key.length == 1 && processed_key[0].isalpha ()) {
            processed_key = processed_key.up ();
        }

        if (processed_key == "Return") processed_key = "Enter";
        if (processed_key == "Escape") processed_key = "Esc";

        _shortcut = modifiers.str + processed_key;
        shortcut_changed (_shortcut);
        stop_recording ();
    }
}

}
