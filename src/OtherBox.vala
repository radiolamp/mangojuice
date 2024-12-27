using Gtk;
using Adw;

public class OtherBox : Box {

    public Switch custom_switch;
    public Entry custom_entry;
    public Scale custom_scale;
    public Label custom_scale_label;

    public OtherBox () {
        Object (orientation: Orientation.VERTICAL, spacing: 12);

        var label = new Label ("Other Settings");
        label.set_halign (Align.START);
        label.set_markup ("<span size='14000'>%s</span>".printf ("Other Settings"));
        label.set_margin_top (12);
        label.set_margin_start (12);
        label.set_margin_end (12);

        var font_description = new Pango.FontDescription ();
        font_description.set_weight (Pango.Weight.BOLD);
        var attr_list = new Pango.AttrList ();
        attr_list.insert (new Pango.AttrFontDesc (font_description));
        label.set_attributes (attr_list);

        this.append (label);

        custom_switch = new Switch ();
        custom_switch.set_valign (Align.CENTER);

        custom_entry = new Entry ();
        custom_entry.placeholder_text = "Custom Entry";
        custom_entry.hexpand = true;

        custom_scale = new Scale.with_range (Orientation.HORIZONTAL, 0, 100, 1);
        custom_scale.set_hexpand (true);
        custom_scale.set_value (50);
        custom_scale_label = new Label ("");
        custom_scale.value_changed.connect (() => {
            custom_scale_label.label = "%d".printf ((int)custom_scale.get_value ());
        });

        var flow_box = new FlowBox ();
      //  flow_box.set_homogeneous (true);
        flow_box.set_row_spacing (12);
        flow_box.set_column_spacing (12);
        flow_box.set_margin_top (12);
        flow_box.set_margin_bottom (12);
        flow_box.set_margin_start (12);
        flow_box.set_margin_end (12);
        flow_box.set_selection_mode (SelectionMode.NONE);

        var switch_box = new Box (Orientation.HORIZONTAL, 12);
        switch_box.append (new Label ("Custom Switch"));
        switch_box.append (custom_switch);
      //  flow_box.insert (switch_box, -1);

        var entry_box = new Box (Orientation.HORIZONTAL, 12);
        entry_box.append (new Label ("Custom Entry"));
        entry_box.append (custom_entry);
     //   flow_box.insert (entry_box, -1);

        var scale_box = new Box (Orientation.HORIZONTAL, 12);
        scale_box.append (new Label ("Custom Scale"));
        scale_box.append (custom_scale);
        scale_box.append (custom_scale_label);
        flow_box.insert (scale_box, -1);

        this.append (flow_box);
    }
}