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

        OtherLoad.load_states (this);
    }

    // Метод для создания Scale и Entry
    private void create_scale_with_entry (string label_text, double min, double max, double step, double initial_value, string format) {
        var adjustment = new Adjustment (initial_value, min, max, step, step, 0.0);
        var scale = new Scale (Orientation.HORIZONTAL, adjustment);
        scale.set_hexpand (true);

        var entry = create_entry ();
        entry.set_text (format.printf (initial_value).replace (",", "."));

        scale.value_changed.connect (() => {
            update_entry_from_scale (scale, entry, format);
            OtherSave.save_states (this);
        });

        entry.activate.connect (() => {
            update_scale_from_entry (scale, entry, min, max, format);
        });

        var box = create_scale_box (label_text, scale, entry);

        // Добавляем Scale, Entry и Label в массивы
        scales.add (scale);
        entries.add (entry);
        scale_labels.add (box.get_first_child () as Label); // Первый элемент в box — это Label

        this.append (box);
    }

    // Метод для создания Entry
    private Entry create_entry () {
        var entry = new Entry ();
        entry.set_width_chars (WIDTH_CHARS);
        entry.set_max_width_chars (MAX_WIDTH_CHARS);
        entry.set_alignment (1);
        return entry;
    }

    // Метод для обновления Entry из Scale
    private void update_entry_from_scale (Scale scale, Entry entry, string format) {
        double value = scale.get_value ();
        if (format == "%d") {
            // Для целочисленных значений
            entry.set_text ("%d".printf ((int) value));
        } else {
            // Для дробных значений
            entry.set_text (format.printf (value).replace (",", "."));
        }
    }

    // Метод для обновления Scale из Entry
    private void update_scale_from_entry (Scale scale, Entry entry, double min, double max, string format) {
        string text = entry.get_text ();
        double value = 0;

        // Пытаемся преобразовать текст в число
        if (double.try_parse (text, out value)) {
            // Проверяем, чтобы значение было в пределах min и max
            if (value >= min && value <= max) {
                scale.set_value (value);
            } else {
                // Если значение выходит за пределы, восстанавливаем предыдущее значение
                entry.set_text (format == "%d" ? "%d".printf ((int) scale.get_value ()) : format.printf (scale.get_value ()).replace (",", "."));
            }
        } else {
            // Если текст не является числом, восстанавливаем предыдущее значение
            entry.set_text (format == "%d" ? "%d".printf ((int) scale.get_value ()) : format.printf (scale.get_value ()).replace (",", "."));
        }
    }

    // Метод для создания контейнера с Scale и Entry
    private Box create_scale_box (string label_text, Scale scale, Entry entry) {
        var box = new Box (Orientation.HORIZONTAL, 12);
        box.set_margin_top (FLOW_BOX_MARGIN);
        box.set_margin_start (FLOW_BOX_MARGIN);
        box.set_margin_end (FLOW_BOX_MARGIN);

        // Создаем Label и задаем размер
        var label = new Label (label_text);
        label.set_size_request (160, -1); // Ширина 160 пикселей, высота автоматическая
        label.add_css_class ("bold-label");
        label.set_halign (Align.START);   // Выравнивание текста по левому краю

        // Добавляем Label, Scale и Entry в контейнер
        box.append (label);
        box.append (scale);
        box.append (entry);

        return box;
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
            label1.set_halign (Align.START); // Выравнивание по левому краю
            label1.set_hexpand (false);
    
            var label2 = new Label (label_texts_2[i]);
            label2.set_halign (Align.START); // Выравнивание по левому краю
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
}