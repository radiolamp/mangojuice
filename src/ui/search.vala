/* ui/search.vala // License: GPL-3.0+ */
using Gtk;
using Adw;
using Gee;

namespace MangoJuice.UI {

public class SearchItem : GLib.Object {
    public string page_id { get; private set; }
    public string page_title { get; private set; }
    public string section { get; private set; }
    public string title { get; private set; }
    public string description { get; private set; }
    public Gtk.Widget target { get; private set; }
    public Gtk.Widget? highlight { get; private set; }

    public string norm_title { get; private set; }
    public string norm_description { get; private set; }
    public string norm_section { get; private set; }
    public string norm_page { get; private set; }
    public string[] norm_keywords { get; private set; }

    public int match_score { get; set; default = 0; }

    public SearchItem (string page_id, string page_title, string section,
                       string title, string description, string[] keywords,
                       Gtk.Widget target, Gtk.Widget? highlight) {
        this.page_id = page_id;
        this.page_title = page_title;
        this.section = section;
        this.title = title;
        this.description = description;
        this.target = target;
        this.highlight = highlight;

        norm_title = SearchController.normalize (title);
        norm_description = SearchController.normalize (description);
        norm_section = SearchController.normalize (section);
        norm_page = SearchController.normalize (page_title);

        norm_keywords = new string[keywords.length];
        for (int i = 0; i < keywords.length; i++) {
            norm_keywords[i] = SearchController.normalize (keywords[i]);
        }
    }
}

public class SearchController : GLib.Object {
    private MangoJuice.Application app;
    private Gee.ArrayList<SearchItem> items;
    private Gee.HashMap<string, Gtk.ScrolledWindow> page_scrolls;
    private Gee.HashMap<string, string> page_titles;
    private Gee.HashMap<Gtk.Widget, uint> highlight_timeouts;
    private SearchDialog? dialog = null;

    public SearchController (MangoJuice.Application app) {
        this.app = app;
        items = new Gee.ArrayList<SearchItem> ();
        page_scrolls = new Gee.HashMap<string, Gtk.ScrolledWindow> ();
        page_titles = new Gee.HashMap<string, string> ();
        highlight_timeouts = new Gee.HashMap<Gtk.Widget, uint> ();

        page_titles["metrics_box"] = _ ("Metrics");
        page_titles["extras_box"] = _ ("Extras");
        page_titles["performance_box"] = _ ("Performance");
        page_titles["visual_box"] = _ ("Visual");
        page_titles["other_box"] = _ ("Other");
    }

    public void register_page (string page_id, Gtk.ScrolledWindow scrolled) {
        page_scrolls[page_id] = scrolled;
    }

    public void add_setting (string page_id, string section, string title,
                             string description, string[] keywords,
                             Gtk.Widget target, Gtk.Widget? highlight = null) {
        string page_title = page_titles.has_key (page_id) ? page_titles[page_id] : page_id;
        items.add (new SearchItem (page_id, page_title, section, title,
                                   description, keywords, target, highlight));
    }

    public void clear_page (string page_id) {
        for (int i = items.size - 1; i >= 0; i--) {
            if (items[i].page_id == page_id) {
                items.remove_at (i);
            }
        }
    }

    public void open () {
        var window = app.active_window;
        if (window == null) {
            return;
        }

        if (dialog == null) {
            dialog = new SearchDialog (this);
            dialog.closed.connect (() => {
                dialog = null;
            });
        }

        dialog.present (window);
        dialog.focus_search ();
    }

    public Gee.ArrayList<SearchItem> search (string query, int limit = 50) {
        var results = new Gee.ArrayList<SearchItem> ();
        string normalized = normalize (query);
        if (normalized == "") {
            return results;
        }

        string[] tokens = normalized.split (" ");
        foreach (var item in items) {
            int score = 0;
            bool matches = true;

            foreach (var token in tokens) {
                if (token == "") {
                    continue;
                }

                int token_score = score_token (item, token);
                if (token_score == 0) {
                    matches = false;
                    break;
                }
                score += token_score;
            }

            if (matches && score > 0) {
                item.match_score = score;
                results.add (item);
            }
        }

        results.sort ((a, b) => {
            if (a.match_score != b.match_score) {
                return a.match_score > b.match_score ? -1 : 1;
            }
            return a.title.collate (b.title);
        });

        if (results.size > limit) {
            var limited = new Gee.ArrayList<SearchItem> ();
            for (int i = 0; i < limit; i++) {
                limited.add (results[i]);
            }
            return limited;
        }

        return results;
    }

    public void activate (SearchItem item) {
        if (!page_scrolls.has_key (item.page_id)) {
            return;
        }

        app.show_page (item.page_id);
        reveal_item (item, 0);
    }

    public static string normalize (string text) {
        string folded = text.casefold ();
        var builder = new StringBuilder ();
        int index = 0;
        unichar c;

        while (folded.get_next_char (ref index, out c)) {
            if (c == 'ё' || c == 'Ё') {
                c = 'е';
            }
            builder.append_unichar (c);
        }

        return builder.str.strip ();
    }

    public static string icon_for_page (string page_id) {
        switch (page_id) {
            case "metrics_box":
                return "view-continuous-symbolic";
            case "extras_box":
                return "application-x-addon-symbolic";
            case "performance_box":
                return "emblem-system-symbolic";
            case "visual_box":
                return "preferences-desktop-appearance-symbolic";
            case "other_box":
                return "view-grid-symbolic";
            default:
                return "system-search-symbolic";
        }
    }

    private static int score_token (SearchItem item, string token) {
        if (item.norm_title == token) {
            return 1000;
        }
        if (item.norm_title.has_prefix (token)) {
            return 650;
        }
        if (has_word_start (item.norm_title, token)) {
            return 500;
        }
        if (item.norm_title.contains (token)) {
            return 350;
        }
        if (item.norm_description.contains (token)) {
            return 220;
        }
        if (item.norm_section.contains (token)) {
            return 150;
        }
        if (item.norm_page.contains (token)) {
            return 130;
        }

        foreach (var keyword in item.norm_keywords) {
            if (keyword == token) {
                return 120;
            }
            if (keyword.has_prefix (token)) {
                return 90;
            }
            if (keyword.contains (token)) {
                return 70;
            }
        }

        return 0;
    }

    private static bool has_word_start (string text, string token) {
        int index = text.index_of (token);
        while (index >= 0) {
            if (index == 0) {
                return true;
            }

            char previous = text[index - 1];
            if (previous == ' ' || previous == '-' || previous == '_' || previous == '/' || previous == '(') {
                return true;
            }

            index = text.index_of (token, index + 1);
        }

        return false;
    }

    private void reveal_item (SearchItem item, int attempt) {
        var scrolled = page_scrolls[item.page_id];
        if (scrolled == null) {
            return;
        }

        var child = scrolled.get_child ();
        if (child == null) {
            return;
        }

        Graphene.Point origin = Graphene.Point.zero ();
        Graphene.Point point = Graphene.Point.zero ();
        if (item.target.get_mapped () && item.target.compute_point (child, origin, out point)) {
            var adjustment = scrolled.get_vadjustment ();
            double lower = adjustment.get_lower ();
            double upper = adjustment.get_upper () - adjustment.get_page_size ();
            double destination = point.y - 80;
            if (upper < lower) {
                upper = lower;
            }
            adjustment.set_value (destination.clamp (lower, upper));

            highlight_item (item);
            if (item.target.get_can_focus ()) {
                item.target.grab_focus ();
            }
        } else if (attempt < 10) {
            GLib.Timeout.add (50, () => {
                reveal_item (item, attempt + 1);
                return false;
            });
        }
    }

    private void highlight_item (SearchItem item) {
        Gtk.Widget widget = item.highlight ?? item.target;

        if (highlight_timeouts.has_key (widget)) {
            GLib.Source.remove (highlight_timeouts[widget]);
        }

        widget.add_css_class ("search-hit");

        uint timeout_id = 0;
        timeout_id = GLib.Timeout.add (2200, () => {
            widget.remove_css_class ("search-hit");
            highlight_timeouts.unset (widget);
            return false;
        });
        highlight_timeouts[widget] = timeout_id;
    }
}

private class SearchResultRow : Adw.ActionRow {
    public SearchItem item { get; private set; }

    public SearchResultRow (SearchItem item) {
        Object ();

        this.item = item;
        set_title (item.title);
        set_subtitle ("%s · %s".printf (item.page_title, item.section));
        add_prefix (new Gtk.Image.from_icon_name (SearchController.icon_for_page (item.page_id)));
        set_activatable (true);
    }
}

public class SearchDialog : Adw.Dialog {
    private SearchController controller;
    private Gtk.SearchEntry entry;
    private Gtk.ListBox list_box;
    private Gtk.Stack stack;
    private Gee.ArrayList<SearchItem> current_results;
    private uint search_timeout_id = 0;

    public SearchDialog (SearchController controller) {
        Object ();

        this.controller = controller;

        set_content_width (560);
        set_content_height (520);

        var header_bar = new Adw.HeaderBar ();
        header_bar.add_css_class ("flat");

        entry = new Gtk.SearchEntry () {
            placeholder_text = _ ("Search settings"),
            hexpand = true
        };
        entry.search_changed.connect (on_search_changed);
        entry.activate.connect (activate_selected);
        entry.stop_search.connect (() => close ());
        header_bar.set_title_widget (entry);

        var key_controller = new Gtk.EventControllerKey ();
        key_controller.set_propagation_phase (Gtk.PropagationPhase.CAPTURE);
        key_controller.key_pressed.connect ((keyval, keycode, modifiers) => {
            if (keyval == Gdk.Key.Down) {
                Gtk.ListBoxRow? row = list_box.get_row_at_index (0);
                if (row != null) {
                    list_box.select_row (row);
                    row.grab_focus ();
                    return true;
                }
            }
            return false;
        });
        entry.add_controller (key_controller);

        stack = new Gtk.Stack () {
            transition_type = Gtk.StackTransitionType.CROSSFADE,
            vexpand = true
        };
        stack.add_named (create_empty_page (), "empty");
        stack.add_named (create_no_results_page (), "none");

        list_box = new Gtk.ListBox () {
            selection_mode = Gtk.SelectionMode.SINGLE,
            activate_on_single_click = true,
            show_separators = false
        };
        list_box.add_css_class ("boxed-list");
        list_box.set_margin_start (12);
        list_box.set_margin_end (12);
        list_box.set_margin_top (12);
        list_box.set_margin_bottom (12);
        list_box.row_activated.connect (on_row_activated);

        var list_key_controller = new Gtk.EventControllerKey ();
        list_key_controller.key_pressed.connect ((keyval, keycode, modifiers) => {
            if (keyval == Gdk.Key.Escape) {
                close ();
                return true;
            }
            if (keyval == Gdk.Key.Up && list_box.get_row_at_index (0) == list_box.get_selected_row ()) {
                entry.grab_focus ();
                return true;
            }
            return false;
        });
        list_box.add_controller (list_key_controller);

        var scrolled = new Gtk.ScrolledWindow () {
            vexpand = true,
            hscrollbar_policy = Gtk.PolicyType.NEVER
        };
        scrolled.set_child (list_box);
        stack.add_named (scrolled, "results");

        var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        content.append (header_bar);
        content.append (stack);

        var dialog_key_controller = new Gtk.EventControllerKey ();
        dialog_key_controller.key_pressed.connect ((keyval, keycode, modifiers) => {
            if (keyval == Gdk.Key.Escape) {
                close ();
                return true;
            }
            return false;
        });
        content.add_controller (dialog_key_controller);

        set_child (content);

        current_results = new Gee.ArrayList<SearchItem> ();
        stack.set_visible_child_name ("empty");

        closed.connect (() => {
            if (search_timeout_id != 0) {
                GLib.Source.remove (search_timeout_id);
                search_timeout_id = 0;
            }
        });
    }

    public void focus_search () {
        GLib.Idle.add (() => {
            entry.grab_focus ();
            return false;
        });
    }

    private Gtk.Widget create_empty_page () {
        return new Adw.StatusPage () {
            icon_name = "system-search-symbolic",
            title = _ ("Search settings"),
            description = _ ("Type to find a MangoHud setting")
        };
    }

    private Gtk.Widget create_no_results_page () {
        return new Adw.StatusPage () {
            icon_name = "system-search-symbolic",
            title = _ ("No results"),
            description = _ ("Try another search query")
        };
    }

    private void on_search_changed () {
        if (search_timeout_id != 0) {
            GLib.Source.remove (search_timeout_id);
        }

        search_timeout_id = GLib.Timeout.add (120, () => {
            search_timeout_id = 0;
            update_results ();
            return false;
        });
    }

    private void update_results () {
        while (true) {
            Gtk.ListBoxRow? row = list_box.get_row_at_index (0);
            if (row == null) {
                break;
            }
            list_box.remove (row);
        }

        current_results = controller.search (entry.text);

        if (current_results.size == 0) {
            stack.set_visible_child_name (entry.text.strip () == "" ? "empty" : "none");
            return;
        }

        foreach (var item in current_results) {
            list_box.append (new SearchResultRow (item));
        }

        stack.set_visible_child_name ("results");

        Gtk.ListBoxRow? first = list_box.get_row_at_index (0);
        if (first != null) {
            list_box.select_row (first);
        }
    }

    private void activate_selected () {
        Gtk.ListBoxRow? row = list_box.get_selected_row ();
        if (row == null) {
            row = list_box.get_row_at_index (0);
        }
        if (row != null) {
            on_row_activated (row);
        }
    }

    private void on_row_activated (Gtk.ListBoxRow row) {
        var result_row = row as SearchResultRow;
        if (result_row == null) {
            return;
        }

        var item = result_row.item;
        close ();
        controller.activate (item);
    }
}

}
