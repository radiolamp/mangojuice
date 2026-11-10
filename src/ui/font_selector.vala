/* ui/font_selector.vala // License: GPL-3.0+ */
using Gtk;
using MangoJuice;
using MangoJuice.Config;
using MangoJuice.System;

namespace MangoJuice.UI {

public class FontSelector : GLib.Object {

private MangoJuice.Application app { get; private set; }

public FontSelector (MangoJuice.Application app) {
    this.app = app;
}

public void initialize (Box visual_box) {
    unowned State state = app.state;
    state.font_button = new Button.with_label (_ ("Default"));
    state.font_button.set_tooltip_text (
        _ ("If you are going to play through Wine, then you need to select ")
        + _ ("fonts from the home directory, the system fonts will not work."));
    state.font_button.set_hexpand (true);
    state.font_button.set_size_request (100, -1);

    var popover = new Gtk.Popover ();
    popover.set_autohide (true);
    popover.set_has_arrow (true);
    popover.set_parent (state.font_button);

    var popover_box = new Gtk.Box (Orientation.VERTICAL, 6);

    popover.add_css_class ("menu");
    popover.set_child (popover_box);

    var search_entry = new SearchEntry ();
    search_entry.set_placeholder_text (_ ("Search font"));
    search_entry.set_margin_start (12);
    search_entry.set_margin_end (12);
    search_entry.set_margin_top (12);
    popover_box.append (search_entry);

    var scroll = new ScrolledWindow ();
    scroll.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
    scroll.set_size_request (-1 , 300);
    popover_box.append (scroll);

    var list_box = new ListBox ();
    scroll.set_child (list_box);

    var fonts = state.find_fonts ();
    var font_items = new Gee.HashMap<string, string> ();

    foreach (var font_path in fonts) {
        var font_name = Path.get_basename (font_path);
        font_items[font_name] = font_path;
    }

    var sorted_fonts = new Gee.ArrayList<string> ();
    sorted_fonts.add_all (font_items.keys);
    sorted_fonts.sort ((a, b) => a.collate (b));

    sorted_fonts.insert (0, _ ("Default"));

    search_entry.search_changed.connect (() => {
        while (list_box.get_first_child () != null) {
            list_box.remove (list_box.get_first_child ());
        }

        foreach (var font_name in sorted_fonts) {
            if (search_entry.text == "" || font_name.down ().contains (search_entry.text.down ())) {
                var row = new ListBoxRow ();
                var box = new Box (Orientation.HORIZONTAL, 5);
                var label = new Label (font_name);
                label.set_xalign (0);
                label.set_hexpand (true);

                var wine_label = new Label (_ ("Wine"));
                wine_label.add_css_class ("dim-label");
                wine_label.set_visible (false);
                wine_label.set_halign (Align.END);

                if (font_name != _ ("Default") && font_items.has_key (font_name)) {
                    var font_path = font_items[font_name];
                    if (font_path.has_prefix (Environment.get_home_dir ())) {
                        wine_label.set_visible (true);
                    }
                }

                box.append (label);
                box.append (wine_label);
                row.set_child (box);
                list_box.append (row);
            }
        }
    });

    search_entry.search_changed ();

    list_box.row_activated.connect ((row) => {
        var box = row.get_child () as Box;
        var label = box.get_first_child () as Label;
        var font_name = label.label;

        if (font_name == _ ("Default")) {
            app.saver.update_font_file_in_file ("");
        } else if (font_items.has_key (font_name)) {
            app.saver.update_font_file_in_file (font_items[font_name]);
        }

        state.font_button.label = font_name;
        popover.popdown ();
        app.save_config ();
    });

    state.font_button.clicked.connect (() => {
        popover.popup ();
        search_entry.grab_focus ();
    });

    visual_box.append (state.font_button);
}}

}
