/* ui/gpu_selector.vala // License: GPL-3.0+ */
using Gtk;
using MangoJuice;
using MangoJuice.Config;
using MangoJuice.System;

namespace MangoJuice.UI {

public class GpuSelector : GLib.Object {

private MangoJuice.Application app { get; private set; }

public GpuSelector (MangoJuice.Application app) {
    this.app = app;
}

public void initialize (Box extras_box) {
    unowned State state = app.state;
    var gpu_list_label = Common.create_label (_ ("List GPUs to display"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);

    state.gpu_entry = new Entry () { hexpand = true, halign = Align.FILL };
    var gpu_box = Common.create_entry_with_clear_button (state.gpu_entry, _ ("Video card display order (0,1,2)"), "");
    state.gpu_entry.changed.connect (() => { app.saver.update_gpu_in_file (state.gpu_entry.text); app.save_config (); });

    var string_list = new Gtk.StringList (null);
    string_list.append (_ ("All video cards"));

    state.gpu_dropdown = new Gtk.DropDown (string_list, null) { hexpand = true, halign = Align.FILL };

    var factory = new Gtk.SignalListItemFactory ();
    factory.setup.connect ((item) => {
        var label = new Gtk.Label ("") {
            halign = Gtk.Align.START,
            ellipsize = Pango.EllipsizeMode.END
        };
        var list_item = item as Gtk.ListItem;
        if (list_item != null) {
            list_item.set_child (label);
        }
    });

    factory.bind.connect ((item) => {
        var list_item = item as Gtk.ListItem;
        if (list_item != null) {
            var label = list_item.get_child () as Gtk.Label;
            var string_object = list_item.get_item () as Gtk.StringObject;
            if (label != null && string_object != null) {
                string display_text = string_object.get_string ();
                if (list_item.get_position () != 0 && display_text.length > 15) {
                    display_text = display_text.substring (15);
                }
                label.set_label (display_text);
            }
        }
    });

    state.gpu_dropdown.factory = factory;

    string[] gpu_pci_addresses = app.gpu.get_gpu_pci_addresses ();

    if (gpu_pci_addresses.length == 1 && !BuildConfig.IS_DEVEL) {
        gpu_list_label.visible = gpu_box.visible = state.gpu_dropdown.visible = false;
    } else {
        foreach (var pci_address in gpu_pci_addresses) {
            string_list.append (pci_address);
        }

        state.gpu_dropdown.notify["selected"].connect (() => {
            uint selected_index = state.gpu_dropdown.selected;
            if (selected_index == 0) {
                app.saver.update_pci_dev_in_file (_ ("All video cards"));
            } else if (selected_index - 1 < gpu_pci_addresses.length) {
                state.gpu_text_entry.text = "";
                app.saver.update_pci_dev_in_file (gpu_pci_addresses[selected_index - 1]);
            }
            app.save_config ();
        });

        var gpu_hbox = new FlowBox () {
            margin_start = Common.FLOW_BOX_MARGIN,
            margin_end = Common.FLOW_BOX_MARGIN,
            hexpand = true,
            max_children_per_line = 2
        };

        gpu_hbox.append (gpu_box);
        gpu_hbox.append (state.gpu_dropdown);

        extras_box.append (gpu_list_label);
        extras_box.append (gpu_hbox);
    }
}}

}
