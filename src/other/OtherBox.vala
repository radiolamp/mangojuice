/* OtherBox.vala // Licence:  GPL-v3.0 */
using Gtk;
using Gee;

public class OtherBox : Box {

    const int MAX_WIDTH_CHARS = 6;
    const int WIDTH_CHARS = 4;
    const int FLOW_BOX_MARGIN = 12;
    const int FLOW_BOX_ROW_SPACING = 12;
    const int FLOW_BOX_COLUMN_SPACING = 6;
    const int MAIN_BOX_SPACING = 6;

    public ArrayList<Scale> scales { get; set; }
    public ArrayList<Entry> entries { get; set; }
    public ArrayList<Label> scale_labels { get; set; }
    public ArrayList<Switch> switches { get; set; }
    public ArrayList<Label> labels { get; set; }
    public ArrayList<Switch> reshade_switches { get; set; }
    public ArrayList<Label> reshade_labels { get; set; }
    public Button vkbasalt_global_button { get; set; }
    public bool vkbasalt_global_enabled { get; set; }
    public Entry hotkey_entry;
    public string reshade_texture_path { get; set; }
    public string reshade_folders_path { get; set; }
    public string reshade_include_path { get; set; }
    public OtherLoad.LoadResult load_result { get; set; }
    public Gee.ArrayList<string> reshade_shaders { get; set; }
    public Button reshade_button;
    HashMap<string, ArrayList<Scale>> switch_scale_map;
    HashMap<string, ArrayList<Entry>> switch_entry_map;
    HashMap<string, ArrayList<Button>> switch_reset_map;
    
    Label reshade_section_label;
    FlowBox reshade_flow_box;
    bool is_loading = false;

    public OtherBox () {
        Object (orientation: Orientation.VERTICAL, spacing: 12);
        scales = new ArrayList<Scale> ();
        entries = new ArrayList<Entry> ();
        scale_labels = new ArrayList<Label> ();
        switches = new ArrayList<Switch> ();
        labels = new ArrayList<Label> ();
        reshade_switches = new ArrayList<Switch> ();
        reshade_labels = new ArrayList<Label> ();
        reshade_shaders = new Gee.ArrayList<string> ();
        switch_scale_map = new HashMap<string, ArrayList<Scale>> ();
        switch_entry_map = new HashMap<string, ArrayList<Entry>> ();
        switch_reset_map = new HashMap<string, ArrayList<Button>> ();
        
        reshade_section_label = null;
        reshade_flow_box = null;
        
        string[] config_vars = { "cas", "dls", "fxaa", "smaa", "lut" };
        string[] label_texts = { "CAS", "DLS", "FXAA", "SMAA", "LUT" };
        string[] label_texts_2 = {
            _("Contrast Adaptive Sharpening"),
            _("Denoised Luma Sharpening"),
            _("Fast Approximate Anti-Aliasing"),
            _("Subpixel Morphological Antialiasing"),
            _("Color LookUp Table")
        };
        create_switches_and_labels (this, "VkBasalt", switches, labels, config_vars, label_texts, label_texts_2);
        foreach (var switch_widget in switches) {
            switch_widget.state_set.connect ((state) => {
                if (!is_loading) {
                    OtherSave.save_states (this);
                    restart_vkcube();
                }
                update_scale_entry_reset_state (switch_widget);
                return false;
            });
        }
        var flow_box = new FlowBox ();
        flow_box.set_homogeneous (true);
        flow_box.set_margin_end (FLOW_BOX_MARGIN);
        flow_box.set_selection_mode (SelectionMode.NONE);
        flow_box.set_max_children_per_line (2);
        this.append (flow_box);
        create_scale_with_entry (flow_box, "CAS Sharpness",         -1.0, 1.0,    0.01,  0.0,    "%.2f", "cas");
        create_scale_with_entry (flow_box, "DLS Sharpness",         0.0,  1.0,    0.01,  0.5,    "%.2f", "dls");
        create_scale_with_entry (flow_box, "FXAA Quality Subpix",   0.0,  1.0,    0.01,  0.75,   "%.2f", "fxaa");
        create_scale_with_entry (flow_box, "DLS Denoise",           0.0,  1.0,    0.01,  0.17,   "%.2f", "dls");
        create_scale_with_entry (flow_box, "FXAA Edge Threshold",   0.0,  0.333,  0.01,  0.125,  "%.3f", "fxaa");
        create_scale_with_entry (flow_box, "FXAA Threshold Min",    0.0,  0.0833, 0.001, 0.0833, "%.4f", "fxaa");
        create_scale_with_entry (flow_box, "SMAA Threshold",        0.0,  0.5,    0.01,  0.05,   "%.2f", "smaa");
        create_scale_with_entry (flow_box, "SMAA Max Search Steps", 0,    112,    1,     8,      "%d",   "smaa");
        create_scale_with_entry (flow_box, "SMAA Max Steps Diag",   0,    20,     1,     0,      "%d",   "smaa");
        create_scale_with_entry (flow_box, "SMAA Corner Rounding",  0,    100,    1,     25,     "%d",   "smaa");    
        
        var buttons_flow_box = new FlowBox ();
        buttons_flow_box.set_homogeneous (true);
        buttons_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        buttons_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        buttons_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        buttons_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        buttons_flow_box.set_selection_mode (SelectionMode.NONE);
        buttons_flow_box.set_max_children_per_line (3);
        buttons_flow_box.set_min_children_per_line (1);
        
        vkbasalt_global_button = new Button.with_label (_("Global VkBasalt"));
        buttons_flow_box.append (vkbasalt_global_button);
        
        hotkey_entry = new Entry ();
        hotkey_entry.set_placeholder_text (_("hotkey"));
        hotkey_entry.set_width_chars (10);
        hotkey_entry.set_text ("Home");
        hotkey_entry.set_alignment (0.5f);
        hotkey_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "input-keyboard-symbolic");
        hotkey_entry.set_tooltip_text (_("Only 1 key. Only X11/Xwayland."));
        hotkey_entry.set_icon_activatable (Gtk.EntryIconPosition.PRIMARY, false);
        hotkey_entry.changed.connect (() => {
            if (!is_loading) {
                OtherSave.save_states (this);
            }
        });
        
        buttons_flow_box.append (hotkey_entry);

        reshade_button = new Button.with_label (_("Reshade"));
        buttons_flow_box.append (reshade_button);
        reshade_button.clicked.connect (on_reshade_button_clicked);
        
        this.append (buttons_flow_box);
        
        vkbasalt_global_button.clicked.connect (on_vkbasalt_global_button_clicked);
        
        check_vkbasalt_global_status ();

        is_loading = true;
        load_result = OtherLoad.load_states (this);
        is_loading = false;
        
        foreach (var switch_widget in switches) {
            update_scale_entry_reset_state (switch_widget);
        }

        if (load_result.reshade_folders_path != "") {
            reshade_button.set_label (load_result.reshade_folders_path);
            reshade_folders_path = load_result.reshade_folders_path;
            reshade_texture_path = load_result.reshade_texture_path;
            reshade_include_path = load_result.reshade_include_path;
        }

        if (reshade_button.get_label() != _("Reshade")) {
            create_reshade_section();
        }
    }

    void create_reshade_section() {
        reshade_section_label = create_label (_("ReShade Shaders"), Align.START, { "title-4" }, FLOW_BOX_MARGIN);
        this.append (reshade_section_label);
        reshade_flow_box = new FlowBox ();
        reshade_flow_box.set_homogeneous (true);
        reshade_flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        reshade_flow_box.set_column_spacing (FLOW_BOX_COLUMN_SPACING);
        reshade_flow_box.set_margin_top (FLOW_BOX_MARGIN);
        reshade_flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        reshade_flow_box.set_margin_start (FLOW_BOX_MARGIN);
        reshade_flow_box.set_margin_end (FLOW_BOX_MARGIN);
        reshade_flow_box.set_selection_mode (SelectionMode.NONE);
        reshade_flow_box.set_max_children_per_line (5);

        reshade_switches.clear();
        reshade_labels.clear();

        foreach (string shader_name in reshade_shaders) {
            var row_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            row_box.set_hexpand (true);
            row_box.set_valign (Align.CENTER);
            
            var switch_widget = new Switch ();
            switch_widget.set_valign (Align.CENTER);
            switch_widget.set_name ("reshade_" + shader_name);
            reshade_switches.add (switch_widget);
            
            var label = new Label (shader_name);
            label.set_halign (Align.START);
            label.set_hexpand (true);
            label.set_ellipsize (Pango.EllipsizeMode.END);
            label.set_max_width_chars (20);
            reshade_labels.add (label);
            
            row_box.append (switch_widget);
            row_box.append (label);
            reshade_flow_box.insert (row_box, -1);
            
            switch_widget.state_set.connect ((state) => {
                if (!is_loading) {
                    OtherSave.save_states (this);
                    restart_vkcube();
                }
                return false;
            });
        }
        
        this.append (reshade_flow_box);

        is_loading = true;
        OtherLoad.apply_reshade_states(this, load_result.reshade_states);
        is_loading = false;
    }
    
    void hide_reshade_section() {
        if (reshade_section_label != null) {
            this.remove(reshade_section_label);
            reshade_section_label = null;
        }
        
        if (reshade_flow_box != null) {
            this.remove(reshade_flow_box);
            reshade_flow_box = null;
        }
        
        reshade_switches.clear();
        reshade_labels.clear();
    }
    
    public void update_reshade_section() {
        hide_reshade_section();

        if (reshade_button.get_label() != _("Reshade")) {
            create_reshade_section();
        }
    }

    void on_reshade_button_clicked () {
        var folder_chooser = new Gtk.FileDialog ();
        folder_chooser.title = _("Select Reshade folder");
        
        Gtk.Window? parent_window = this.get_root () as Gtk.Window;
        
        folder_chooser.select_folder.begin (parent_window, null, (obj, res) => {
            try {
                File? folder = folder_chooser.select_folder.end (res);
                if (folder != null) {
                    string folder_path = folder.get_path ();

                    var previous_states = new Gee.HashMap<string, bool>();
                    foreach (var switch_widget in reshade_switches) {
                        string shader_name = switch_widget.get_name ().replace("reshade_", "");
                        previous_states[shader_name] = switch_widget.get_active();
                    }

                    reshade_button.set_label (folder_path);
                    reshade_folders_path = "%s/".printf(folder_path);
                    reshade_texture_path = "%s/textures".printf(folder_path);
                    reshade_include_path = "%s/shaders".printf(folder_path);

                    reshade_shaders.clear();
                    File shaders_folder = folder.get_child ("shaders");
                    
                    if (shaders_folder.query_exists ()) {
                        try {
                            FileEnumerator enumerator = shaders_folder.enumerate_children (
                                "standard::name,standard::type", 
                                FileQueryInfoFlags.NONE
                            );
                            
                            FileInfo file_info;
                            
                            while ((file_info = enumerator.next_file ()) != null) {
                                string filename = file_info.get_name ();
                                
                                if (filename.has_suffix (".fx")) {
                                    string name_without_extension = filename.substring (0, filename.length - 3);
                                    reshade_shaders.add (name_without_extension);
                                }
                            }
                            
                        } catch (Error e) {
                            print (_("Error reading shaders folder: %s\n"), e.message);
                        }
                    }

                    update_reshade_section();

                    is_loading = true;
                    OtherLoad.apply_reshade_states(this, previous_states);
                    is_loading = false;
                    
                    OtherSave.save_states (this);
                    
                    show_info_dialog (_("Reshade folder selected successfully"), 
                                    _("Shader effects: %d").printf(reshade_shaders.size));
                }
            } catch (Error e) {
                print (_("Error selecting folder: %s\n"), e.message);
            }
        });
    }

    void show_info_dialog (string title, string message) {
        var dialog = new Adw.AlertDialog (title, message);
        dialog.add_response ("ok", "OK");
        dialog.set_default_response ("ok");
        dialog.present (this.get_root () as Gtk.Window);
    }

    public bool is_switch_active (string switch_name) {
        foreach (var switch_widget in switches) {
            if (switch_widget.get_name () == switch_name) {
                return switch_widget.get_active ();
            }
        }
        return false;
    }

    void restart_vkcube() {
        try {
            Process.spawn_command_line_sync("pkill vkcube");
            Thread.usleep(1000);
            Process.spawn_command_line_async("bash -c 'ENABLE_VKBASALT=1 mangohud vkcube --wsi xcb'");
        } catch (Error e) {
            stderr.printf("Ошибка при перезапуске vkcube: %s\n", e.message);
        }
    }

    public bool is_reshade_switch_active (string shader_name) {
        foreach (var switch_widget in reshade_switches) {
            if (switch_widget.get_name () == "reshade_" + shader_name) {
                return switch_widget.get_active ();
            }
        }
        return false;
    }

    public bool is_scale_active (Scale scale, string switch_name) {
        return is_switch_active (switch_name);
    }

    void create_scale_with_entry (FlowBox flow_box, string label_text, double min, double max, double step, double initial_value, string format, string switch_name) {
        var main_box = new Box (Orientation.VERTICAL, 6);

        var label = new Label (label_text);
        label.set_halign (Align.START);
        label.set_hexpand (true);
        label.set_markup ("<b>%s</b>".printf (label_text));
        label.set_margin_start (12);

        var scale_entry_button_box = new Box (Orientation.HORIZONTAL, 0);
        scale_entry_button_box.set_hexpand (true);

        var adjustment = new Adjustment (initial_value, min, max, step, step, 0.0);
        var scale = new Scale (Orientation.HORIZONTAL, adjustment);
        scale.set_hexpand (true);
        scale.set_margin_start (6);
        scale.set_margin_end (6);
        scale.set_size_request (200, -1);

        var entry = new Entry ();
        entry.set_max_width_chars (MAX_WIDTH_CHARS);
        entry.set_width_chars (WIDTH_CHARS);
        entry.set_hexpand (false);
        entry.set_valign (Align.CENTER);
        entry.set_input_purpose (InputPurpose.NUMBER);
        entry.add_css_class ("linked");

        var reset_button = new Button.from_icon_name ("view-refresh-symbolic");
        reset_button.set_focusable (false);
        reset_button.set_valign (Align.CENTER);
        reset_button.add_css_class ("linked");
        reset_button.set_visible (false);
        reset_button.set_tooltip_text ("Сбросить значение по умолчанию");

        var entry_container = new Box (Orientation.HORIZONTAL, 0);
        entry_container.append (entry);
        entry_container.append (reset_button);
        entry_container.add_css_class ("linked");

        bool is_updating = false;

        scale.value_changed.connect (() => {
            if (!is_updating) {
                is_updating = true;
                GLib.Idle.add (() => {
                    update_entry_from_scale (scale, entry, format);
                    if (!is_loading) {
                        OtherSave.save_states (this);
                    }
                    is_updating = false;
                    return false;
                });
            }
        });

        entry.activate.connect (() => {
            if (!is_updating) {
                update_scale_from_entry (scale, entry, min, max, format);
            }
        });

        reset_button.clicked.connect (() => {
            if (!is_updating) {
                is_updating = true;
                scale.set_value (initial_value);
                update_entry_from_scale (scale, entry, format);
                if (!is_loading) {
                    OtherSave.save_states (this);
                }
                is_updating = false;
            }
        });

        var focus_controller = new EventControllerFocus ();
        focus_controller.enter.connect (() => {
            reset_button.set_visible (true);
        });
        focus_controller.leave.connect (() => {
            Timeout.add (300, () => {
                if (!reset_button.has_focus) {
                    reset_button.set_visible (false);
                }
                return false;
            });
        });
        entry.add_controller (focus_controller);

        scale_entry_button_box.append (scale);
        scale_entry_button_box.append (entry_container);

        main_box.append (label);
        main_box.append (scale_entry_button_box);

        scales.add (scale);
        entries.add (entry);
        scale_labels.add (label);

        if (!switch_scale_map.has_key (switch_name)) {
            switch_scale_map[switch_name] = new ArrayList<Scale> ();
            switch_entry_map[switch_name] = new ArrayList<Entry> ();
            switch_reset_map[switch_name] = new ArrayList<Button> ();
        }
        switch_scale_map[switch_name].add (scale);
        switch_entry_map[switch_name].add (entry);
        switch_reset_map[switch_name].add (reset_button);

        flow_box.insert (main_box, -1);
    }

    void update_scale_entry_reset_state (Switch switch_widget) {
        string switch_name = switch_widget.get_name ();
        if (switch_scale_map.has_key (switch_name)) {
            var scales = switch_scale_map[switch_name];
            var entries = switch_entry_map[switch_name];
            var reset_buttons = switch_reset_map[switch_name];

            bool is_active = switch_widget.get_active ();
            foreach (var scale in scales) {
                scale.set_sensitive (is_active);
            }
            foreach (var entry in entries) {
                entry.set_sensitive (is_active);
            }
            foreach (var reset_button in reset_buttons) {
                reset_button.set_sensitive (is_active);
                if (!is_active) {
                    reset_button.set_visible (false);
                }
            }
        }
    }

    void update_entry_from_scale (Scale scale, Entry entry, string format) {
        double value = scale.get_value ();
        if (format == "%d") {
            entry.set_text ("%d".printf ((int) value));
        } else {
            entry.set_text (format.printf (value).replace (",", "."));
        }
    }

    void update_scale_from_entry (Scale scale, Entry entry, double min, double max, string format) {
        string text = entry.get_text ();
        double value = 0;

        if (double.try_parse (text, out value)) {
            if (value >= min && value <= max) {
                scale.set_value (value);
            } else {
                entry.set_text (format == "%d" ? "%d".printf ((int) scale.get_value ()) : format.printf (scale.get_value ()).replace (",", "."));
            }
        } else {
            entry.set_text (format == "%d" ? "%d".printf ((int) scale.get_value ()) : format.printf (scale.get_value ()).replace (",", "."));
        }
    }

    void create_switches_and_labels (Box parent_box, string title, ArrayList<Switch> switches, ArrayList<Label> labels, string[] config_vars, string[] label_texts, string[] label_texts_2) {
        var label = new Label (title);
        label.add_css_class("title-4");
        label.set_margin_top (FLOW_BOX_MARGIN);
        label.set_margin_start (FLOW_BOX_MARGIN);
        label.set_margin_end (FLOW_BOX_MARGIN);
        label.set_halign (Align.START);
        label.set_markup ("%s".printf (title));
        parent_box.append (label);

        var flow_box = new FlowBox ();
        flow_box.set_homogeneous (true);
        flow_box.set_row_spacing (FLOW_BOX_ROW_SPACING);
        flow_box.set_column_spacing (FLOW_BOX_COLUMN_SPACING);
        flow_box.set_margin_top (FLOW_BOX_MARGIN);
        flow_box.set_margin_bottom (FLOW_BOX_MARGIN);
        flow_box.set_margin_start (FLOW_BOX_MARGIN);
        flow_box.set_margin_end (FLOW_BOX_MARGIN);
        flow_box.set_selection_mode (SelectionMode.NONE);

        for (int i = 0; i < config_vars.length; i++) {
            var row_box = new Box (Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            row_box.set_hexpand (true);
            row_box.set_valign (Align.CENTER);

            var switch_widget = new Switch ();
            switch_widget.set_valign (Align.CENTER);
            switch_widget.set_name (config_vars[i]);
            switches.add (switch_widget);

            var text_box = new Box (Orientation.VERTICAL, 0);
            text_box.set_valign (Align.CENTER);
            text_box.set_halign (Align.START);
            text_box.set_size_request (160, -1);

            var label1 = new Label (null);
            label1.set_markup ("<b>%s</b>".printf (label_texts[i]));
            label1.set_halign (Align.START);
            label1.set_hexpand (false);
            label1.set_ellipsize (Pango.EllipsizeMode.END);
            label1.set_max_width_chars (20);

            var label2 = new Label (label_texts_2[i]);
            label2.set_halign (Align.START);
            label2.set_hexpand (false);
            label2.add_css_class ("dim-label");
            label2.set_ellipsize (Pango.EllipsizeMode.END);
            label2.set_max_width_chars (25);

            label1.set_markup ("<b>%s</b>".printf (label_texts[i]));
            label2.set_markup ("<span size='9000'>%s</span>".printf (label_texts_2[i]));

            text_box.append (label1);
            text_box.append (label2);

            row_box.append (switch_widget);
            row_box.append (text_box);
            flow_box.insert (row_box, -1);
        }

        parent_box.append (flow_box);
    }

    void on_vkbasalt_global_button_clicked () {
        bool success = false;

        if (vkbasalt_global_enabled) {
            try {
                Process.spawn_command_line_sync ("pkexec sed -i '/ENABLE_VKBASALT=1/d' /etc/environment");
                string file_contents;
                FileUtils.get_contents ("/etc/environment", out file_contents);
                if (!file_contents.contains ("ENABLE_VKBASALT=1")) {
                    success = true;
                    vkbasalt_global_enabled = false;
                    vkbasalt_global_button.remove_css_class ("suggested-action");
                }
            } catch (Error e) {
                stderr.printf ("Error deleting ENABLE_VKBASALT from /etc/environment: %s\n", e.message);
            }
        } else {
            try {
                Process.spawn_command_line_sync ("pkexec sh -c 'echo \"ENABLE_VKBASALT=1\" >> /etc/environment'");
                string file_contents;
                FileUtils.get_contents ("/etc/environment", out file_contents);
                if (file_contents.contains ("ENABLE_VKBASALT=1")) {
                    success = true;
                    vkbasalt_global_enabled = true;
                    vkbasalt_global_button.add_css_class ("suggested-action");
                }
            } catch (Error e) {
                stderr.printf ("Error adding ENABLE_VKBASALT to /etc/environment: %s\n", e.message);
            }
        }

        if (success) {
            check_vkbasalt_global_status ();
            show_restart_warning ();
        } else {
            stderr.printf ("Failed to modify /etc/environment.\n");
        }
    }

    void check_vkbasalt_global_status () {
        try {
            string[] argv = { "grep", "ENABLE_VKBASALT=1", "/etc/environment" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            if (exit_status == 0) {
                vkbasalt_global_enabled = true;
                vkbasalt_global_button.add_css_class ("suggested-action");
            } else {
                vkbasalt_global_enabled = false;
                vkbasalt_global_button.remove_css_class ("suggested-action");
            }
        } catch (Error e) {
            stderr.printf ("Error checking the ENABLE_VKBASALT status: %s\n", e.message);
        }
    }

    void show_restart_warning () {
        var dialog = new Adw.AlertDialog ("Warning", "The changes will take effect only after the system is restarted.");
        dialog.add_response ("ok", "OK");
        dialog.add_response ("restart", "Restart");
        dialog.set_default_response ("ok");
        dialog.set_response_appearance ("restart", Adw.ResponseAppearance.SUGGESTED);

        dialog.present (this.get_root () as Gtk.Window);

        dialog.response.connect ((response) => {
            if (response == "restart") {
                try {
                    Process.spawn_command_line_sync ("reboot");
                } catch (Error e) {
                    stderr.printf ("Error when restarting the system: %s\n", e.message);
                }
            }
            dialog.destroy ();
        });
    }

    Label create_label (string text, Align halign, string[] style_classes, int margin = 0) {
        var label = new Label (text);
        label.set_halign (halign);
        label.set_hexpand (true);
        
        foreach (string style_class in style_classes) {
            label.add_css_class (style_class);
        }
        
        if (margin > 0) {
            label.set_margin_top (margin);
            label.set_margin_bottom (margin);
            label.set_margin_start (margin);
            label.set_margin_end (margin);
        }
        
        return label;
    }
}