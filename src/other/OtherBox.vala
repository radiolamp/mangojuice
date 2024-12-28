using Gtk;

public class OtherBox : Box {

    public Scale cas_scale;
    public Label cas_value_label;

    public OtherBox () {
        Object (orientation: Orientation.VERTICAL, spacing: 12);

        var label = new Label ("");
        label.set_halign (Align.START);
        label.set_markup ("<span size='14000'>%s</span>".printf ("VkBasalt"));
        label.set_margin_top (12);
        label.set_margin_start (12);
        label.set_margin_end (12);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        label.set_attributes (attr_list);

        this.append (label);

        var adjustment = new Adjustment (0.5, 0.0, 1.0, 0.01, 0.1, 0.0);
        cas_scale = new Scale (Orientation.HORIZONTAL, adjustment);
        cas_scale.set_hexpand (true);
        cas_scale.set_value (0.5);

        cas_value_label = new Label ("0.50");
        cas_value_label.set_halign (Align.END);

        cas_scale.value_changed.connect (() => {
            double value = cas_scale.get_value ();
            cas_value_label.label = "%.2f".printf (value).replace (",", ".");
            OtherSave.save_states (this);
        });

        var cas_box = new Box (Orientation.HORIZONTAL, 12);
        cas_box.set_margin_top (12);
        cas_box.set_margin_start (12);
        cas_box.set_margin_end (12);
        cas_box.append (new Label ("CAS Sharpness"));
        cas_box.append (cas_scale);
        cas_box.append (cas_value_label);

        this.append (cas_box);

        OtherLoad.load_states (this);
    }
}