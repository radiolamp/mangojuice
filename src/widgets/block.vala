//gpl-3.0 license
//block

[GtkTemplate (ui = "/io/github/radiolamp/mangojuice/ui/block.ui")]
public sealed class MangoJuice.Block : Adw.Bin {

    public string title { get; set; }

    public Gtk.Widget content { get; set; }
}
