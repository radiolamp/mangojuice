using Gtk;
using Adw;

public class OtherBox : Box {

    public Switch[] switches;
    public Label[] labels;

    public OtherBox () {
        Object (orientation: Orientation.VERTICAL, spacing: 12);

        // Настройки для переключателей
        string[] config_vars = { "other_option_1", "other_option_2", "other_option_3" };
        string[] label_texts = { "Option 1", "Option 2", "Option 3" };
        string[] label_texts_2 = { "Description for Option 1", "Description for Option 2", "Description for Option 3" };

        switches = new Switch[config_vars.length];
        labels = new Label[config_vars.length];

        // Создаем переключатели и метки
        create_switches_and_labels (this, "VkBasalt", switches, labels, config_vars, label_texts, label_texts_2);

        // Добавляем обработчики для переключателей
        foreach (var sw in switches) {
            sw.notify["active"].connect (() => {
                OtherSave.save_states (this);
            });
        }

        // Загружаем состояния переключателей
        OtherLoad.load_states (this);
    }

    public void create_switches_and_labels (Box parent_box, string title, Switch[] switches, Label[] labels, string[] config_vars, string[] label_texts, string[] label_texts_2) {
        var label = new Label (title);
        label.add_css_class ("bold-label");
        label.set_margin_top (12);
        label.set_margin_start (12);
        label.set_margin_end (12);
        label.set_halign (Align.START);
        label.set_markup ("<span size='14000'>%s</span>".printf (title));
        
        parent_box.append (label);
        
        var flow_box = new FlowBox ();
        flow_box.set_homogeneous (true);
        flow_box.set_row_spacing (12);
        flow_box.set_column_spacing (12);
        flow_box.set_margin_top (12);
        flow_box.set_margin_bottom (12);
        flow_box.set_margin_start (12);
        flow_box.set_margin_end (12);
        flow_box.set_selection_mode (SelectionMode.NONE);
        
        for (int i = 0; i < config_vars.length; i++) {
            var row_box = new Box (Orientation.HORIZONTAL, 12);
            row_box.set_hexpand (true);
            row_box.set_valign (Align.CENTER);
            switches[i] = new Switch ();
            switches[i].set_valign (Align.CENTER);
        
            var text_box = new Box (Orientation.VERTICAL, 0);
            text_box.set_valign (Align.CENTER);
            text_box.set_halign (Align.START);
            text_box.set_size_request (160, -1); // Ширина 160 пикселей, нужна если не работает выравнивание.
        
            var label1 = new Label (null);
            label1.set_markup ("<b>%s</b>".printf (label_texts[i])); // Жирный текст
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
        
            row_box.append (switches[i]);
            row_box.append (text_box); // Добавляем контейнер с двумя строками текста
            flow_box.insert (row_box, -1);
        }
        
        parent_box.append (flow_box);
    }
}