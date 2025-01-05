using Gtk;
using Gee;

public class OtherBox : Box {

    // Константы для ширины полей ввода
    private const int MAX_WIDTH_CHARS = 6;
    private const int WIDTH_CHARS = 4;

    // Константы для настроек Scale и Entry
    private const int FLOW_BOX_MARGIN = 12;
    private const int FLOW_BOX_ROW_SPACING = 6;
    private const int FLOW_BOX_COLUMN_SPACING = 6;
    private const int MAIN_BOX_SPACING = 6;

    // Свойства для Scale, Entry и Label
    public ArrayList<Scale> scales { get; private set; }
    public ArrayList<Entry> entries { get; private set; }
    public ArrayList<Label> scale_labels { get; private set; }

    public ArrayList<Switch> switches { get; private set; }
    public ArrayList<Label> labels { get; private set; }

    public Button vkbasalt_global_button { get; private set; }
    public bool vkbasalt_global_enabled { get; private set; }

    public OtherBox () {
        Object (orientation: Orientation.VERTICAL, spacing: 12);

        // Инициализация массивов
        scales = new ArrayList<Scale> ();
        entries = new ArrayList<Entry> ();
        scale_labels = new ArrayList<Label> ();

        switches = new ArrayList<Switch> ();
        labels = new ArrayList<Label> ();

        string[] config_vars = { "cas", "dls", "fxaa", "smaa", "lut" };
        string[] label_texts = { "CAS", "DLS", "FXAA", "SMAA", "LUT" };
        string[] label_texts_2 = { "Contrast Adaptive Sharpening", "Denoised Luma Sharpening", "Fast Approximate Anti-Aliasing", "Subpixel Morphological Antialiasing", "Color LookUp Table" };

        create_switches_and_labels (this, "VkBasalt", switches, labels, config_vars, label_texts, label_texts_2);

        foreach (var switch_widget in switches) {
            switch_widget.state_set.connect ((state) => {
                OtherSave.save_states (this);
                return false;
            });
        }

        // Создание Scale и Entry для каждого параметра
        create_scale_with_entry ("CAS Sharpness", -1.0, 1.0, 0.01, 0.0, "%.2f");
        create_scale_with_entry ("DLS Sharpness", 0.0, 1.0, 0.01, 0.5, "%.2f");
        create_scale_with_entry ("DLS Denoise", 0.0, 1.0, 0.01, 0.17, "%.2f");
        create_scale_with_entry ("FXAA Quality Subpix", 0.0, 1.0, 0.01, 0.75, "%.2f");
        create_scale_with_entry ("FXAA Edge Threshold", 0.0, 0.333, 0.01, 0.125, "%.3f");
        create_scale_with_entry ("FXAA Threshold Min", 0.0, 0.0833, 0.001, 0.0833, "%.4f");
        create_scale_with_entry ("SMAA Threshold", 0.0, 0.5, 0.01, 0.05, "%.2f");
        create_scale_with_entry ("SMAA Max Search Steps", 0, 112, 1, 8, "%d");
        create_scale_with_entry ("SMAA Max Steps Diag", 0, 20, 1, 0, "%d");
        create_scale_with_entry ("SMAA Corner Rounding", 0, 100, 1, 25, "%d");

        // Добавляем кнопку Global VkBasalt
        vkbasalt_global_button = new Button.with_label ("Global VkBasalt");
        vkbasalt_global_button.set_margin_top (FLOW_BOX_MARGIN);
        vkbasalt_global_button.set_margin_end (FLOW_BOX_MARGIN);
        vkbasalt_global_button.set_margin_start (FLOW_BOX_MARGIN);
        vkbasalt_global_button.set_margin_bottom (FLOW_BOX_MARGIN);
        vkbasalt_global_button.clicked.connect (on_vkbasalt_global_button_clicked);
        this.append (vkbasalt_global_button);

        // Проверяем текущее состояние VkBasalt
        check_vkbasalt_global_status ();

        OtherLoad.load_states (this);
    }

    // Метод для создания Scale и Entry
    private void create_scale_with_entry (string label_text, double min, double max, double step, double initial_value, string format) {
        var main_box = new Box (Orientation.VERTICAL, 6); // Вертикальный контейнер
        main_box.set_margin_start (FLOW_BOX_MARGIN);
        main_box.set_margin_end (FLOW_BOX_MARGIN);

        // Создаем Label
        var label = new Label (label_text);
        label.set_halign (Align.START);
        label.set_hexpand (true);
        label.add_css_class ("title-4"); // Добавляем стиль, как в примере
        label.set_margin_start (16);
        label.set_valign (Align.START); // Выравниваем Label по верхнему краю

        // Создаем горизонтальный контейнер для Scale и Entry
        var scale_entry_box = new Box (Orientation.HORIZONTAL, 12);
        scale_entry_box.set_hexpand (true);

        // Создаем Scale
        var adjustment = new Adjustment (initial_value, min, max, step, step, 0.0);
        var scale = new Scale (Orientation.HORIZONTAL, adjustment);
        scale.set_hexpand (true); // Scale занимает всё доступное пространство
        scale.set_valign (Align.CENTER); // Выравниваем Scale по центру

        // Создаем Entry
        var entry = new Entry ();
        entry.set_max_width_chars (MAX_WIDTH_CHARS);
        entry.set_width_chars (WIDTH_CHARS);
        entry.set_halign (Align.END);
        entry.set_hexpand (false); // Не расширяем Entry
        entry.set_valign (Align.CENTER); // Выравниваем Entry по центру
        entry.set_text (format.printf (initial_value).replace (",", "."));

        // Подключаем сигналы для синхронизации Scale и Entry
        scale.value_changed.connect (() => {
            update_entry_from_scale (scale, entry, format);
            OtherSave.save_states (this);
        });

        entry.activate.connect (() => {
            update_scale_from_entry (scale, entry, min, max, format);
        });

        // Добавляем Scale и Entry в горизонтальный контейнер
        scale_entry_box.append (scale);
        scale_entry_box.append (entry);

        // Добавляем Label и горизонтальный контейнер в основной вертикальный контейнер
        main_box.append (label);
        main_box.append (scale_entry_box);

        // Добавляем Scale, Entry и Label в массивы
        scales.add (scale);
        entries.add (entry);
        scale_labels.add (label);

        this.append (main_box);
    }

    // Метод для обновления Entry из Scale
    private void update_entry_from_scale (Scale scale, Entry entry, string format) {
        double value = scale.get_value ();
        if (format == "%d") {
            entry.set_text ("%d".printf ((int) value));
        } else {
            entry.set_text (format.printf (value).replace (",", "."));
        }
    }

    // Метод для обновления Scale из Entry
    private void update_scale_from_entry (Scale scale, Entry entry, double min, double max, string format) {
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

    // Метод для создания переключателей и меток
    private void create_switches_and_labels (Box parent_box, string title, ArrayList<Switch> switches, ArrayList<Label> labels, string[] config_vars, string[] label_texts, string[] label_texts_2) {
        var label = new Label (title);
        label.add_css_class ("bold-label");
        label.set_margin_top (FLOW_BOX_MARGIN);
        label.set_margin_start (FLOW_BOX_MARGIN);
        label.set_margin_end (FLOW_BOX_MARGIN);
        label.set_halign (Align.START);
        label.set_markup ("<span size='14000'>%s</span>".printf (title));

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
            switches.add (switch_widget);

            var text_box = new Box (Orientation.VERTICAL, 0);
            text_box.set_valign (Align.CENTER);
            text_box.set_halign (Align.START);
            text_box.set_size_request (160, -1);

            var label1 = new Label (null);
            label1.set_markup ("<b>%s</b>".printf (label_texts[i]));
            label1.set_halign (Align.START);
            label1.set_hexpand (false);

            var label2 = new Label (label_texts_2[i]);
            label2.set_halign (Align.START);
            label2.set_hexpand (false);
            label2.add_css_class ("dim-label");

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

    // Метод для обработки нажатия на кнопку Global VkBasalt
    private void on_vkbasalt_global_button_clicked () {
        if (vkbasalt_global_enabled) {
            try {
                Process.spawn_command_line_sync ("pkexec sed -i '/ENABLE_VKBASALT=1/d' /etc/environment");
                vkbasalt_global_enabled = false;
                vkbasalt_global_button.remove_css_class ("suggested-action");
                check_vkbasalt_global_status ();
                show_restart_warning ();
            } catch (Error e) {
                stderr.printf ("Error deleting ENABLE_VKBASALT from /etc/environment: %s\n", e.message);
            }
        } else {
            try {
                Process.spawn_command_line_sync ("pkexec sh -c 'echo \"ENABLE_VKBASALT=1\" >> /etc/environment'");
                vkbasalt_global_enabled = true;
                vkbasalt_global_button.add_css_class ("suggested-action");
                check_vkbasalt_global_status ();
                show_restart_warning ();
            } catch (Error e) {
                stderr.printf ("Error adding ENABLE_VKBASALT to /etc/environment: %s\n", e.message);
            }
        }
    }

    // Метод для проверки текущего состояния VkBasalt
    private void check_vkbasalt_global_status () {
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

    // Метод для показа предупреждения о необходимости перезагрузки
    private void show_restart_warning () {
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
}