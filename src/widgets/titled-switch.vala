//titled-switch

[GtkTemplate (ui = "/io/github/radiolamp/mangojuice/ui/titled-switch.ui")]
public sealed class MangoJuice.TitledSwitch : Adw.Bin {

    [GtkChild]
    unowned Gtk.Switch root_switch;
    [GtkChild]
    unowned Gtk.Label subtitle_label;

    public string title { get; set; }

    public string subtitle { get; set; }

    public bool active { get; set; }

    public signal void changed (bool is_active);

    construct {
        subtitle_label.bind_property ("label",
        subtitle_label, "visible",
        BindingFlags.DEFAULT,
    (binding, srcval, ref trgval) => {
            trgval.set_boolean (srcval.get_string () != "");
        });

        root_switch.notify["active"].connect (() => {
            changed (root_switch.active);
        });
    }
}
