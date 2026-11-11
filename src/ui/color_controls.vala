/* ui/color_controls.vala // License: GPL-3.0+ */
using Gtk;
using MangoJuice;
using MangoJuice.Config;
using MangoJuice.System;

namespace MangoJuice.UI {

public class ColorControls : GLib.Object {

private MangoJuice.Application app { get; private set; }

public ColorControls (MangoJuice.Application app) {
    this.app = app;
}

public static void setup_color_button (Gtk.ColorDialogButton button, string default_color_hex) {
    var default_rgba = Gdk.RGBA ();
    default_rgba.parse (default_color_hex);
    button.set_rgba (default_rgba);

    var gesture = new Gtk.GestureClick ();
    gesture.set_button (0);

    gesture.pressed.connect ((n_press, x, y) => {
        var button_number = gesture.get_current_button ();
        if (button_number == Gdk.BUTTON_SECONDARY) {
            button.set_rgba (default_rgba);
        }
    });

    button.add_controller (gesture);
}

public void initialize (Box visual_box) {
    unowned State state = app.state;

    var color_label = Common.create_label (_ ("Color"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    visual_box.append (color_label);

    var color_flow_box = new FlowBox () {
        homogeneous = true,
        max_children_per_line = 9,
        row_spacing = Common.FLOW_BOX_ROW_SPACING,
        column_spacing = Common.FLOW_BOX_COLUMN_SPACING,
        margin_start = Common.FLOW_BOX_MARGIN,
        margin_end = Common.FLOW_BOX_MARGIN,
        margin_top = Common.FLOW_BOX_MARGIN,
        margin_bottom = Common.FLOW_BOX_MARGIN,
        selection_mode = SelectionMode.NONE
    };

var color_dialog = new ColorDialog ();
var gpu_linked_box = new Box (Orientation.HORIZONTAL, 0);
gpu_linked_box.add_css_class ("linked");

var cpu_linked_box = new Box (Orientation.HORIZONTAL, 0);
cpu_linked_box.add_css_class ("linked");
state.gpu_color_button = new ColorDialogButton (color_dialog);
setup_color_button (state.gpu_color_button, "#2e9762");
state.gpu_color_button.notify["rgba"].connect (() => {
    if (state.is_loading) return;
    var rgba = state.gpu_color_button.get_rgba ().copy ();
    app.saver.update_gpu_color_in_file (state.rgba_to_hex (rgba));
});
state.cpu_color_button = new ColorDialogButton (color_dialog);
setup_color_button (state.cpu_color_button, "#2e97cb");
state.cpu_color_button.notify["rgba"].connect (() => {
    if (state.is_loading) return;
    var rgba = state.cpu_color_button.get_rgba ().copy ();
    app.saver.update_cpu_color_in_file (state.rgba_to_hex (rgba));
});

state.gpu_text_entry = new Entry ();
state.gpu_text_entry.placeholder_text = _ ("GPU custom name");
state.gpu_text_entry.hexpand = true;
state.gpu_text_entry.changed.connect (() => {
    app.saver.update_gpu_text_in_file (state.gpu_text_entry.text);
    app.save_config ();
});

var gpu_clear_button = new Button () {
    icon_name = "edit-clear-symbolic",
    tooltip_text = _ ("Clear GPU name"),
    visible = false
};
gpu_clear_button.clicked.connect (() => {
    state.gpu_text_entry.text = "";
});

state.gpu_text_entry.notify["text"].connect ((obj, pspec) => {
    gpu_clear_button.visible = state.gpu_text_entry.text != "";
});

state.cpu_text_entry = new Entry ();
state.cpu_text_entry.placeholder_text = _ ("CPU custom name");
state.cpu_text_entry.hexpand = true;
state.cpu_text_entry.changed.connect (() => {
    app.saver.update_cpu_text_in_file (state.cpu_text_entry.text);
    app.save_config ();
});

var cpu_clear_button = new Button () {
    icon_name = "edit-clear-symbolic",
    tooltip_text = _ ("Clear CPU name"),
    visible = false
};
cpu_clear_button.clicked.connect (() => {
    state.cpu_text_entry.text = "";
});

state.cpu_text_entry.notify["text"].connect ((obj, pspec) => {
    cpu_clear_button.visible = state.cpu_text_entry.text != "";
});

gpu_linked_box.append (state.gpu_text_entry);
gpu_linked_box.append (gpu_clear_button);
gpu_linked_box.append (state.gpu_color_button);

cpu_linked_box.append (state.cpu_text_entry);
cpu_linked_box.append (cpu_clear_button);
cpu_linked_box.append (state.cpu_color_button);

var color_box = new FlowBox () {
    margin_start = Common.FLOW_BOX_MARGIN,
    margin_end = Common.FLOW_BOX_MARGIN,
    margin_top = Common.FLOW_BOX_MARGIN,
    margin_bottom = Common.FLOW_BOX_MARGIN,
    selection_mode = SelectionMode.NONE,
    max_children_per_line = 2
};
color_box.append (gpu_linked_box);
color_box.append (cpu_linked_box);
visual_box.append (color_box);

app.search.add_setting ("visual_box", _ ("Color"), _ ("GPU custom name"),
                        _ ("Override the GPU name"),
                        new string[] { "gpu_text" },
                        state.gpu_text_entry, gpu_linked_box);
app.search.add_setting ("visual_box", _ ("Color"), _ ("GPU color"),
                        _ ("Color text"), new string[] { "gpu_color" },
                        state.gpu_color_button, gpu_linked_box);
app.search.add_setting ("visual_box", _ ("Color"), _ ("CPU custom name"),
                        _ ("Override the CPU name"),
                        new string[] { "cpu_text" },
                        state.cpu_text_entry, cpu_linked_box);
app.search.add_setting ("visual_box", _ ("Color"), _ ("CPU color"),
                        _ ("Color text"), new string[] { "cpu_color" },
                        state.cpu_color_button, cpu_linked_box);

    var fps_clarge_label = Common.create_label (_ ("FPS color levels"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    visual_box.append (fps_clarge_label);

    state.fps_value_entry_1 = new Entry ();
    var fps_entry_box_1 = Common.create_entry_with_clear_button (state.fps_value_entry_1, _ ("Medium"), "30");
    state.fps_value_entry_1.changed.connect (() => {
        app.saver.update_fps_value_in_file (state.fps_value_entry_1.text, state.fps_value_entry_2.text);
    });

    state.fps_value_entry_2 = new Entry ();
    var fps_entry_box_2 = Common.create_entry_with_clear_button (state.fps_value_entry_2, _ ("High"), "60");
    state.fps_value_entry_2.changed.connect (() => {
        app.saver.update_fps_value_in_file (state.fps_value_entry_1.text, state.fps_value_entry_2.text);
    });

    var fps_entry_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    fps_entry_box.append (fps_entry_box_1);
    fps_entry_box.append (fps_entry_box_2);

    var color_dialog_fps = new ColorDialog ();

    var fps_color_buttons_box = new Box (Orientation.HORIZONTAL, 0);
    fps_color_buttons_box.add_css_class ("linked");

    state.fps_color_button_1 = new ColorDialogButton (color_dialog_fps);
    setup_color_button (state.fps_color_button_1, "#cc0000");
    state.fps_color_button_1.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.fps_color_button_1.get_rgba ().copy ();
        var rgba2 = state.fps_color_button_2.get_rgba ().copy ();
        var rgba3 = state.fps_color_button_3.get_rgba ().copy ();
        app.saver.update_fps_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    state.fps_color_button_2 = new ColorDialogButton (color_dialog_fps);
    setup_color_button (state.fps_color_button_2, "#ffaa7f");
    state.fps_color_button_2.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.fps_color_button_1.get_rgba ().copy ();
        var rgba2 = state.fps_color_button_2.get_rgba ().copy ();
        var rgba3 = state.fps_color_button_3.get_rgba ().copy ();
        app.saver.update_fps_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    state.fps_color_button_3 = new ColorDialogButton (color_dialog_fps);
    setup_color_button (state.fps_color_button_3, "#92e79a");
    state.fps_color_button_3.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.fps_color_button_1.get_rgba ().copy ();
        var rgba2 = state.fps_color_button_2.get_rgba ().copy ();
        var rgba3 = state.fps_color_button_3.get_rgba ().copy ();
        app.saver.update_fps_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    fps_color_buttons_box.append (state.fps_color_button_1);
    fps_color_buttons_box.append (state.fps_color_button_2);
    fps_color_buttons_box.append (state.fps_color_button_3);

    var fps_color_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING) {
        margin_start = Common.FLOW_BOX_MARGIN,
        margin_end = Common.FLOW_BOX_MARGIN,
        margin_top = Common.FLOW_BOX_MARGIN,
        margin_bottom = Common.FLOW_BOX_MARGIN
    };
    fps_color_box.append (fps_entry_box);
    fps_color_box.append (fps_color_buttons_box);
    visual_box.append (fps_color_box);

    app.search.add_setting ("visual_box", _ ("FPS color levels"), _ ("FPS color levels"),
                            _ ("Thresholds and colors"),
                            new string[] { "fps_color", "fps_value" },
                            state.fps_value_entry_1, fps_color_box);

    var gpu_load_clarge_label = Common.create_label (_ ("GPU level colors"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    visual_box.append (gpu_load_clarge_label);

    state.gpu_load_value_entry_1 = new Entry ();
    var gpu_load_entry_box_1 = Common.create_entry_with_clear_button (state.gpu_load_value_entry_1, _ ("Medium"), "60");
    state.gpu_load_value_entry_1.changed.connect (() => {
        app.saver.update_gpu_load_value_in_file (state.gpu_load_value_entry_1.text, state.gpu_load_value_entry_2.text);
    });

    state.gpu_load_value_entry_2 = new Entry ();
    var gpu_load_entry_box_2 = Common.create_entry_with_clear_button (state.gpu_load_value_entry_2, _ ("High"), "90");
    state.gpu_load_value_entry_2.changed.connect (() => {
        app.saver.update_gpu_load_value_in_file (state.gpu_load_value_entry_1.text, state.gpu_load_value_entry_2.text);
    });

    var gpu_load_entry_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    gpu_load_entry_box.append (gpu_load_entry_box_1);
    gpu_load_entry_box.append (gpu_load_entry_box_2);

    var color_dialog_gpu_load = new ColorDialog ();

    var gpu_load_color_buttons_box = new Box (Orientation.HORIZONTAL, 0);
    gpu_load_color_buttons_box.add_css_class ("linked");

    state.gpu_load_color_button_1 = new ColorDialogButton (color_dialog_gpu_load);
    setup_color_button (state.gpu_load_color_button_1, "#92e79a");
    state.gpu_load_color_button_1.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.gpu_load_color_button_1.get_rgba ().copy ();
        var rgba2 = state.gpu_load_color_button_2.get_rgba ().copy ();
        var rgba3 = state.gpu_load_color_button_3.get_rgba ().copy ();
        app.saver.update_gpu_load_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    state.gpu_load_color_button_2 = new ColorDialogButton (color_dialog_gpu_load);
    setup_color_button (state.gpu_load_color_button_2, "#ffaa7f");
    state.gpu_load_color_button_2.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.gpu_load_color_button_1.get_rgba ().copy ();
        var rgba2 = state.gpu_load_color_button_2.get_rgba ().copy ();
        var rgba3 = state.gpu_load_color_button_3.get_rgba ().copy ();
        app.saver.update_gpu_load_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    state.gpu_load_color_button_3 = new ColorDialogButton (color_dialog_gpu_load);
    setup_color_button (state.gpu_load_color_button_3, "#cc0000");
    state.gpu_load_color_button_3.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.gpu_load_color_button_1.get_rgba ().copy ();
        var rgba2 = state.gpu_load_color_button_2.get_rgba ().copy ();
        var rgba3 = state.gpu_load_color_button_3.get_rgba ().copy ();
        app.saver.update_gpu_load_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    gpu_load_color_buttons_box.append (state.gpu_load_color_button_1);
    gpu_load_color_buttons_box.append (state.gpu_load_color_button_2);
    gpu_load_color_buttons_box.append (state.gpu_load_color_button_3);

    var gpu_load_color_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING) {
        margin_start = Common.FLOW_BOX_MARGIN,
        margin_end = Common.FLOW_BOX_MARGIN,
        margin_top = Common.FLOW_BOX_MARGIN,
        margin_bottom = Common.FLOW_BOX_MARGIN
    };
    gpu_load_color_box.append (gpu_load_entry_box);
    gpu_load_color_box.append (gpu_load_color_buttons_box);
    visual_box.append (gpu_load_color_box);

    app.search.add_setting ("visual_box", _ ("GPU level colors"), _ ("GPU level colors"),
                            _ ("Thresholds and colors"),
                            new string[] { "gpu_load_color", "gpu_load_value" },
                            state.gpu_load_value_entry_1, gpu_load_color_box);

    var cpu_load_clarge_label = Common.create_label (_ ("CPU level colors"), Align.START, { "title-4" }, Common.FLOW_BOX_MARGIN);
    visual_box.append (cpu_load_clarge_label);

    state.cpu_load_value_entry_1 = new Entry ();
    var cpu_load_entry_box_1 = Common.create_entry_with_clear_button (state.cpu_load_value_entry_1, _ ("Medium"), "60");
    state.cpu_load_value_entry_1.changed.connect (() => {
        app.saver.update_cpu_load_value_in_file (state.cpu_load_value_entry_1.text, state.cpu_load_value_entry_2.text);
    });

    state.cpu_load_value_entry_2 = new Entry ();
    var cpu_load_entry_box_2 = Common.create_entry_with_clear_button (state.cpu_load_value_entry_2, _ ("High"), "90");
    state.cpu_load_value_entry_2.changed.connect (() => {
        app.saver.update_cpu_load_value_in_file (state.cpu_load_value_entry_1.text, state.cpu_load_value_entry_2.text);
    });

    var cpu_load_entry_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
    cpu_load_entry_box.append (cpu_load_entry_box_1);
    cpu_load_entry_box.append (cpu_load_entry_box_2);

    var color_dialog_cpu_load = new ColorDialog ();

    var cpu_load_color_buttons_box = new Box (Orientation.HORIZONTAL, 0);
    cpu_load_color_buttons_box.add_css_class ("linked");

    state.cpu_load_color_button_1 = new ColorDialogButton (color_dialog_cpu_load);
    setup_color_button (state.cpu_load_color_button_1, "#92e79a");
    state.cpu_load_color_button_1.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.cpu_load_color_button_1.get_rgba ().copy ();
        var rgba2 = state.cpu_load_color_button_2.get_rgba ().copy ();
        var rgba3 = state.cpu_load_color_button_3.get_rgba ().copy ();
        app.saver.update_cpu_load_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    state.cpu_load_color_button_2 = new ColorDialogButton (color_dialog_cpu_load);
    setup_color_button (state.cpu_load_color_button_2, "#ffaa7f");
    state.cpu_load_color_button_2.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.cpu_load_color_button_1.get_rgba ().copy ();
        var rgba2 = state.cpu_load_color_button_2.get_rgba ().copy ();
        var rgba3 = state.cpu_load_color_button_3.get_rgba ().copy ();
        app.saver.update_cpu_load_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    state.cpu_load_color_button_3 = new ColorDialogButton (color_dialog_cpu_load);
    setup_color_button (state.cpu_load_color_button_3, "#cc0000");
    state.cpu_load_color_button_3.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba1 = state.cpu_load_color_button_1.get_rgba ().copy ();
        var rgba2 = state.cpu_load_color_button_2.get_rgba ().copy ();
        var rgba3 = state.cpu_load_color_button_3.get_rgba ().copy ();
        app.saver.update_cpu_load_color_in_file (state.rgba_to_hex (rgba1), state.rgba_to_hex (rgba2), state.rgba_to_hex (rgba3));
    });

    cpu_load_color_buttons_box.append (state.cpu_load_color_button_1);
    cpu_load_color_buttons_box.append (state.cpu_load_color_button_2);
    cpu_load_color_buttons_box.append (state.cpu_load_color_button_3);

    var cpu_load_color_box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING) {
        margin_start = Common.FLOW_BOX_MARGIN,
        margin_end = Common.FLOW_BOX_MARGIN,
        margin_top = Common.FLOW_BOX_MARGIN,
        margin_bottom = Common.FLOW_BOX_MARGIN
    };
    cpu_load_color_box.append (cpu_load_entry_box);
    cpu_load_color_box.append (cpu_load_color_buttons_box);
    visual_box.append (cpu_load_color_box);

    app.search.add_setting ("visual_box", _ ("CPU level colors"), _ ("CPU level colors"),
                            _ ("Thresholds and colors"),
                            new string[] { "cpu_load_color", "cpu_load_value" },
                            state.cpu_load_value_entry_1, cpu_load_color_box);

    if (color_flow_box.get_parent () == null) {
        visual_box.append (color_flow_box);
    }

    state.background_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.background_color_button, "#000000");
    state.background_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.background_color_button.get_rgba ().copy ();
        app.saver.update_background_color_in_file (state.rgba_to_hex (rgba));
    });

    state.frametime_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.frametime_color_button, "#00ff00");
    state.frametime_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.frametime_color_button.get_rgba ().copy ();
        app.saver.update_frametime_color_in_file (state.rgba_to_hex (rgba));
    });

    state.vram_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.vram_color_button, "#ad64c1");
    state.vram_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.vram_color_button.get_rgba ().copy ();
        app.saver.update_vram_color_in_file (state.rgba_to_hex (rgba));
    });

    state.ram_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.ram_color_button, "#c26693");
    state.ram_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.ram_color_button.get_rgba ().copy ();
        app.saver.update_ram_color_in_file (state.rgba_to_hex (rgba));
    });

    state.wine_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.wine_color_button, "#eb5b5b");
    state.wine_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.wine_color_button.get_rgba ().copy ();
        app.saver.update_wine_color_in_file (state.rgba_to_hex (rgba));
    });

    state.engine_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.engine_color_button, "#eb5b5b");
    state.engine_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.engine_color_button.get_rgba ().copy ();
        app.saver.update_engine_color_in_file (state.rgba_to_hex (rgba));
    });

    state.text_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.text_color_button, "#FFFFFF");
    state.text_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.text_color_button.get_rgba ().copy ();
        app.saver.update_text_color_in_file (state.rgba_to_hex (rgba));
    });

    state.media_player_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.media_player_color_button, "#FFFFFF");
    state.media_player_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.media_player_color_button.get_rgba ().copy ();
        app.saver.update_media_player_color_in_file (state.rgba_to_hex (rgba));
    });

    state.network_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.network_color_button, "#e07b85");
    state.network_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.network_color_button.get_rgba ().copy ();
        app.saver.update_network_color_in_file (state.rgba_to_hex (rgba));
    });

    state.battery_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.battery_color_button, "#92e79a");
    state.battery_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.battery_color_button.get_rgba ().copy ();
        app.saver.update_battery_color_in_file (state.rgba_to_hex (rgba));
    });

    state.horizontal_separator_color_button = new ColorDialogButton (color_dialog);
    setup_color_button (state.horizontal_separator_color_button, "#FFFFFF");
    state.horizontal_separator_color_button.notify["rgba"].connect (() => {
        if (state.is_loading) return;
        var rgba = state.horizontal_separator_color_button.get_rgba ().copy ();
        app.saver.update_horizontal_separator_color_in_file (state.rgba_to_hex (rgba));
    });

    ColorDialogButton[] color_buttons = {
        state.background_color_button, state.frametime_color_button, state.vram_color_button,
        state.ram_color_button, state.wine_color_button, state.engine_color_button,
        state.media_player_color_button, state.network_color_button, state.text_color_button,
        state.battery_color_button, state.horizontal_separator_color_button
    };
    string[] color_labels = {
        _ ("Background"), _ ("Frametime"), _ ("VRAM"), _ ("RAM"),
        _ ("Wine"), _ ("Engine"), _ ("Media"), _ ("Network"),
        _ ("Text"), _ ("Battery"), _ ("Horizontal separator")
    };
    string[] color_keys = {
        "background_color", "frametime_color", "vram_color", "ram_color",
        "wine_color", "engine_color", "media_player_color", "network_color",
        "text_color", "battery_color", "horizontal_separator_color"
    };

    assert (color_buttons.length == color_labels.length);

    for (int i = 0; i < color_buttons.length; i++) {
        var label = new Label (color_labels[i]);
        label.set_halign (Align.START);
        label.set_ellipsize (Pango.EllipsizeMode.END);
        label.hexpand = true;

        var box = new Box (Orientation.HORIZONTAL, Common.MAIN_BOX_SPACING);
        box.append (color_buttons[i]);
        box.append (label);

        color_flow_box.insert (box, -1);

        app.search.add_setting ("visual_box", _ ("Color"), color_labels[i],
                                _ ("HUD color"), new string[] { color_keys[i] },
                                color_buttons[i], box);
    }
}}

}
