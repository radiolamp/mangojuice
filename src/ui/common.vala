/* ui/common.vala // License: GPL-3.0+ */
using Gtk;

namespace MangoJuice.UI {

public class Common {
    public const int MAIN_BOX_SPACING = 12;
    public const int FLOW_BOX_ROW_SPACING = 12;
    public const int FLOW_BOX_COLUMN_SPACING = 12;
    public const int FLOW_BOX_MARGIN = 12;

    public const string[] POSITION_VALUES = {
        "top-left", "top-center", "top-right",
        "middle-left", "middle-right",
        "bottom-left", "bottom-center", "bottom-right"
    };

    public const string[] FORMAT_VALUES = { "title", "artist", "album", "none" };

    public const string GPU_TITLE = _ ("GPU");
    public const string CPU_TITLE = _ ("CPU");
    public const string MEMORY_TITLE = _ ("Memory");
    public const string GIT_TITLE = _ ("Git");
    public const string OTHER_TITLE = _ ("Other");
    public const string SYSTEM_TITLE = _ ("System");
    public const string WINE_TITLE = _ ("Wine");
    public const string OPTIONS_TITLE = _ ("Options");
    public const string BATTERY_TITLE = _ ("Battery");
    public const string INFORM_TITLE = _ ("Information");
    public const string[] FILTER_VALUES = {
        "none", "bicubic", "trilinear", "retro"
    };

public static Gtk.ScrolledWindow create_scrolled_window (Gtk.Widget child) {
    var scrolled = new Gtk.ScrolledWindow ();
    scrolled.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
    scrolled.set_vexpand (true);
    scrolled.set_child (child);
    return scrolled;
}

public static Box create_entry_with_clear_button (Entry entry, string placeholder_text, string default_value) {
    entry.placeholder_text = placeholder_text;
    entry.text = default_value;
    entry.hexpand = true;

    entry.secondary_icon_name = "edit-clear-symbolic";
    entry.secondary_icon_activatable = true;
    entry.secondary_icon_sensitive = true;
    entry.secondary_icon_tooltip_text = _ ("Clear");

    entry.icon_release.connect ((pos) => {
        if (pos == EntryIconPosition.SECONDARY) {
            entry.text = default_value;
            entry.secondary_icon_name = null;
        }
    });

    entry.changed.connect (() => {
        bool should_show = entry.text != default_value && entry.text != "";
        entry.secondary_icon_name = should_show ? "edit-clear-symbolic" : null;
    });

    entry.secondary_icon_name = null;

    var entry_box = new Box (Orientation.HORIZONTAL, 0);
    entry_box.append (entry);
    return entry_box;
}

public static Label create_label (string text, Align halign = Align.START,
                    string[] css_classes = {},
                    int margin_start = 0, int margin_end = 0,
                    int margin_top = 0, int margin_bottom = 0) {
    var label = new Label (text);
    label.set_halign (halign);

    foreach (var css_class in css_classes) {
        label.add_css_class (css_class);
    }

    label.set_margin_start (margin_start);
    label.set_margin_end (margin_end);
    label.set_margin_top (margin_top);
    label.set_margin_bottom (margin_bottom);

    return label;
}
}

}
