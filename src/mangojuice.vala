using Gtk;
using GLib;
using Adw;

public class MangoJuice : Gtk.Application {
    private Button saveButton;
    private Switch[] gpu_switches;
    private Switch[] cpu_switches;
    private Switch[] other_switches;
    private Switch[] system_switches;
    private Switch[] wine_switches;
    private Switch[] options_switches;
    private Switch[] battery_switches; // Добавляем массив для переключателей "Battery"
    private Switch[] other_extra_switches; // Добавляем массив для переключателей "Other"
    private Label[] gpu_labels;
    private Label[] cpu_labels;
    private Label[] other_labels;
    private Label[] system_labels;
    private Label[] wine_labels;
    private Label[] options_labels;
    private Label[] battery_labels; // Добавляем массив для меток "Battery"
    private Label[] other_extra_labels; // Добавляем массив для меток "Other"
    private string[] gpu_config_vars = {
        "gpu_stats", "gpu_load_change", "vram", "gpu_core_clock", "gpu_mem_clock",
        "gpu_temp", "gpu_mem_temp", "gpu_junction_temp", "gpu_fan", "gpu_name",
        "gpu_power", "gpu_voltage", "throttling_status", "throttling_status_graph", "vulkan_driver"
    };
    private string[] cpu_config_vars = {
        "cpu_stats", "cpu_load_change", "core_load", "cpu_mhz", "cpu_temp",
        "cpu_power"
    };
    private string[] other_config_vars = {
        "ram", "io_stats", "procmem", "swap"
    };
    private string[] system_config_vars = {
        "exec=uname -r", "refresh_rate", "resolution", "exec=echo $XDG_SESSION_TYPE",
        "time", "arch"
    };
    private string[] wine_config_vars = {
        "wine", "engine", "engine_short_names"
    };
    private string[] options_config_vars = {
        "version", "gamemode", "vkbasalt", "fcat", "fsr", "hdr"
    };
    private string[] battery_config_vars = { // Добавляем массив для переменных "Battery"
        "battery", "battery_watt", "battery_time", "device_battery"
    };
    private string[] other_extra_config_vars = { // Добавляем массив для переменных "Other"
        "media_player", "network", "full"
    };
    private string[] gpu_label_texts = {
        "GPU Load", "Load Color", "VRAM", "Core Freq", "Mem Freq",
        "GPU Temp", "Memory Temp", "Juntion", "Fans", "Model",
        "Power", "Voltage", "Throttling", "Throttling GRAPH", "Vulcan Driver"
    };
    private string[] cpu_label_texts = {
        "CPU Load", "CPU Load Color", "CPU Core Load", "CPU Freq", "CPU Temp",
        "CPU Power"
    };
    private string[] other_label_texts = {
        "RAM", "Disk IO", "Procces", "Swap"
    };
    private string[] system_label_texts = {
        "Distro", "Refresh rate", "Resolution", "Session",
        "Time", "Arch"
    };
    private string[] wine_label_texts = {
        "Version", "Engine Ver", "Short names"
    };
    private string[] options_label_texts = {
        "Hud Version", "Gamemode", "VKbasalt", "Fcat", "FSR", "HDR"
    };
    private string[] battery_label_texts = { // Добавляем массив для текстов меток "Battery"
        "Percentage", "Wattage", "Time remain", "Devisec"
    };
    private string[] other_extra_label_texts = { // Добавляем массив для текстов меток "Other"
        "Media Info", "Network", "Full ON"
    };
    private const int GPU_SWITCHES_COUNT = 15;
    private const int CPU_SWITCHES_COUNT = 6;
    private const int OTHER_SWITCHES_COUNT = 4;
    private const int SYSTEM_SWITCHES_COUNT = 6;
    private const int WINE_SWITCHES_COUNT = 3;
    private const int OPTIONS_SWITCHES_COUNT = 6;
    private const int BATTERY_SWITCHES_COUNT = 4; // Добавляем константу для количества переключателей "Battery"
    private const int OTHER_EXTRA_SWITCHES_COUNT = 3; // Добавляем константу для количества переключателей "Other"
    private const int MAIN_BOX_SPACING = 10;
    private const int GRID_ROW_SPACING = 10;
    private const int GRID_COLUMN_SPACING = 10;
    private const int FLOW_BOX_ROW_SPACING = 10;
    private const int FLOW_BOX_COLUMN_SPACING = 10;
    private const int FLOW_BOX_MARGIN = 10;

    private bool vkcube_was_running = false;

    public MangoJuice() {
        Object(application_id: "com.radiolamp.mangojuice", flags: ApplicationFlags.DEFAULT_FLAGS);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this);
        window.set_default_size(960,600); // Размера окна
        window.set_title("MangoJuice"); // Устанавливаем заголовок окна

        var main_box = new Box(Orientation.VERTICAL, MAIN_BOX_SPACING);
        main_box.set_homogeneous(false);

        var scrolled_window = new ScrolledWindow();
        scrolled_window.set_policy(PolicyType.NEVER, PolicyType.AUTOMATIC);
        scrolled_window.set_vexpand(true);
 
        var grid = new Grid();
        grid.set_row_spacing(GRID_ROW_SPACING);
        grid.set_column_spacing(GRID_COLUMN_SPACING);

        // Создаем Adw.ViewStack и Adw.ViewSwitcher
        var view_stack = new ViewStack();
        var toolbar_view_switcher = new ViewSwitcher();
        toolbar_view_switcher.stack = view_stack; // Используем свойство stack

        // Создаем боксы
        var box1 = new Box(Orientation.VERTICAL, MAIN_BOX_SPACING);
        var box2 = new Box(Orientation.VERTICAL, MAIN_BOX_SPACING);
        var box3 = new Box(Orientation.VERTICAL, MAIN_BOX_SPACING);
        var box4 = new Box(Orientation.VERTICAL, MAIN_BOX_SPACING);

        // Добавляем подзаголовок "GPU" в бокс "Metric"
        var gpu_label = new Label("GPU");
        gpu_label.set_halign(Align.CENTER); // Выравниваем по центру
        gpu_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        gpu_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        gpu_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box1.append(gpu_label);

        // Добавляем 15 переключателей под надписью "GPU" в FlowBox
        gpu_switches = new Switch[GPU_SWITCHES_COUNT];
        gpu_labels = new Label[GPU_SWITCHES_COUNT];
        var gpu_flow_box = new FlowBox();
        gpu_flow_box.set_homogeneous(true);
        gpu_flow_box.set_max_children_per_line(5);
        gpu_flow_box.set_min_children_per_line(5);
        gpu_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        gpu_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        gpu_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        gpu_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        gpu_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        gpu_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        gpu_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < GPU_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            gpu_switches[i] = new Switch();
            gpu_labels[i] = new Label(gpu_label_texts[i]);
            gpu_labels[i].set_halign(Align.START);
            row_box.append(gpu_switches[i]);
            row_box.append(gpu_labels[i]);
            gpu_flow_box.insert(row_box, -1);
        }

        box1.append(gpu_flow_box);

        // Добавляем подзаголовок "CPU" в бокс "Metric"
        var cpu_label = new Label("CPU");
        cpu_label.set_halign(Align.CENTER); // Выравниваем по центру
        cpu_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        cpu_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        cpu_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box1.append(cpu_label);

        // Добавляем 6 переключателей под надписью "CPU" в FlowBox
        cpu_switches = new Switch[CPU_SWITCHES_COUNT];
        cpu_labels = new Label[CPU_SWITCHES_COUNT];
        var cpu_flow_box = new FlowBox();
        cpu_flow_box.set_homogeneous(true);
        cpu_flow_box.set_max_children_per_line(5);
        cpu_flow_box.set_min_children_per_line(5);
        cpu_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        cpu_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        cpu_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        cpu_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        cpu_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        cpu_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        cpu_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < CPU_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            cpu_switches[i] = new Switch();
            cpu_labels[i] = new Label(cpu_label_texts[i]);
            cpu_labels[i].set_halign(Align.START);
            row_box.append(cpu_switches[i]);
            row_box.append(cpu_labels[i]);
            cpu_flow_box.insert(row_box, -1);
        }

        box1.append(cpu_flow_box);

        // Добавляем подзаголовок "Other" в бокс "Metric"
        var other_label = new Label("Other");
        other_label.set_halign(Align.CENTER); // Выравниваем по центру
        other_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        other_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        other_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box1.append(other_label);

        // Добавляем 4 переключателей под надписью "Other" в FlowBox
        other_switches = new Switch[OTHER_SWITCHES_COUNT];
        other_labels = new Label[OTHER_SWITCHES_COUNT];
        var other_flow_box = new FlowBox();
        other_flow_box.set_homogeneous(true);
        other_flow_box.set_max_children_per_line(5);
                other_flow_box.set_min_children_per_line(5);
        other_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        other_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        other_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        other_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        other_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        other_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        other_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < OTHER_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            other_switches[i] = new Switch();
            other_labels[i] = new Label(other_label_texts[i]);
            other_labels[i].set_halign(Align.START);
            row_box.append(other_switches[i]);
            row_box.append(other_labels[i]);
            other_flow_box.insert(row_box, -1);
        }

        box1.append(other_flow_box);

        // Добавляем боксы в Adw.ViewStack с иконками
        view_stack.add_titled(box1, "box1", "Metrics").icon_name = "view-continuous-symbolic";
        view_stack.add_titled(box2, "box2", "Extras").icon_name = "application-x-addon-symbolic";
        view_stack.add_titled(box3, "box3", "Performance").icon_name = "emblem-system-symbolic";
        view_stack.add_titled(box4, "box4", "Visual").icon_name = "preferences-desktop-appearance-symbolic";

        // Добавляем подзаголовок "System" в бокс "Extras"
        var system_label = new Label("System");
        system_label.set_halign(Align.CENTER); // Выравниваем по центру
        system_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        system_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        system_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box2.append(system_label);

        // Добавляем 6 переключателей под надписью "System" в FlowBox
        system_switches = new Switch[SYSTEM_SWITCHES_COUNT];
        system_labels = new Label[SYSTEM_SWITCHES_COUNT];
        var system_flow_box = new FlowBox();
        system_flow_box.set_homogeneous(true);
        system_flow_box.set_max_children_per_line(6);
        system_flow_box.set_min_children_per_line(6);
        system_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        system_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        system_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        system_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        system_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        system_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        system_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < SYSTEM_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            system_switches[i] = new Switch();
            system_labels[i] = new Label(system_label_texts[i]);
            system_labels[i].set_halign(Align.START);
            row_box.append(system_switches[i]);
            row_box.append(system_labels[i]);
            system_flow_box.insert(row_box, -1);
        }

        box2.append(system_flow_box);

        // Добавляем подзаголовок "Wine" в бокс "Extras"
        var wine_label = new Label("Wine");
        wine_label.set_halign(Align.CENTER); // Выравниваем по центру
        wine_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        wine_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        wine_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box2.append(wine_label);

        // Добавляем 3 переключателей под надписью "Wine" в FlowBox
        wine_switches = new Switch[WINE_SWITCHES_COUNT];
        wine_labels = new Label[WINE_SWITCHES_COUNT];
        var wine_flow_box = new FlowBox();
        wine_flow_box.set_homogeneous(true);
        wine_flow_box.set_max_children_per_line(6);
        wine_flow_box.set_min_children_per_line(3);
        wine_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        wine_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        wine_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        wine_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        wine_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        wine_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        wine_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < WINE_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            wine_switches[i] = new Switch();
            wine_labels[i] = new Label(wine_label_texts[i]);
            wine_labels[i].set_halign(Align.START);
            row_box.append(wine_switches[i]);
            row_box.append(wine_labels[i]);
            wine_flow_box.insert(row_box, -1);
        }

        box2.append(wine_flow_box);

        // Добавляем подзаголовок "Options" в бокс "Extras"
        var options_label = new Label("Options");
        options_label.set_halign(Align.CENTER); // Выравниваем по центру
        options_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        options_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        options_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box2.append(options_label);

        // Добавляем 6 переключателей под надписью "Options" в FlowBox
        options_switches = new Switch[OPTIONS_SWITCHES_COUNT];
        options_labels = new Label[OPTIONS_SWITCHES_COUNT];
        var options_flow_box = new FlowBox();
        options_flow_box.set_homogeneous(true);
        options_flow_box.set_max_children_per_line(6);
        options_flow_box.set_min_children_per_line(6);
        options_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        options_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        options_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        options_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        options_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        options_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        options_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < OPTIONS_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            options_switches[i] = new Switch();
            options_labels[i] = new Label(options_label_texts[i]);
            options_labels[i].set_halign(Align.START);
            row_box.append(options_switches[i]);
            row_box.append(options_labels[i]);
            options_flow_box.insert(row_box, -1);
        }

        box2.append(options_flow_box);

        // Добавляем подзаголовок "Battery" в бокс "Extras"
        var battery_label = new Label("Battery");
        battery_label.set_halign(Align.CENTER); // Выравниваем по центру
        battery_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        battery_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        battery_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box2.append(battery_label);

        // Добавляем 4 переключателей под надписью "Battery" в FlowBox
        battery_switches = new Switch[BATTERY_SWITCHES_COUNT];
        battery_labels = new Label[BATTERY_SWITCHES_COUNT];
        var battery_flow_box = new FlowBox();
        battery_flow_box.set_homogeneous(true);
        battery_flow_box.set_max_children_per_line(6);
        battery_flow_box.set_min_children_per_line(4);
        battery_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        battery_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        battery_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        battery_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        battery_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        battery_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        battery_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < BATTERY_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            battery_switches[i] = new Switch();
            battery_labels[i] = new Label(battery_label_texts[i]);
            battery_labels[i].set_halign(Align.START);
            row_box.append(battery_switches[i]);
            row_box.append(battery_labels[i]);
            battery_flow_box.insert(row_box, -1);
        }

        box2.append(battery_flow_box);

        // Добавляем подзаголовок "Other" в бокс "Extras"
        var other_extra_label = new Label("Other");
        other_extra_label.set_halign(Align.CENTER); // Выравниваем по центру
        other_extra_label.set_margin_top(FLOW_BOX_MARGIN); // Отступ сверху
        other_extra_label.set_margin_start(FLOW_BOX_MARGIN); // Отступ слева
        other_extra_label.set_margin_end(FLOW_BOX_MARGIN); // Отступ справа
        box2.append(other_extra_label);

        // Добавляем 3 переключателей под надписью "Other" в FlowBox
        other_extra_switches = new Switch[OTHER_EXTRA_SWITCHES_COUNT];
        other_extra_labels = new Label[OTHER_EXTRA_SWITCHES_COUNT];
        var other_extra_flow_box = new FlowBox();
        other_extra_flow_box.set_homogeneous(true);
        other_extra_flow_box.set_max_children_per_line(6);
        other_extra_flow_box.set_min_children_per_line(3);
        other_extra_flow_box.set_row_spacing(FLOW_BOX_ROW_SPACING);
        other_extra_flow_box.set_column_spacing(FLOW_BOX_COLUMN_SPACING);
        other_extra_flow_box.set_margin_start(FLOW_BOX_MARGIN);
        other_extra_flow_box.set_margin_end(FLOW_BOX_MARGIN);
        other_extra_flow_box.set_margin_top(FLOW_BOX_MARGIN);
        other_extra_flow_box.set_margin_bottom(FLOW_BOX_MARGIN);
        other_extra_flow_box.set_selection_mode(SelectionMode.NONE); // Отключаем выделение

        for (int i = 0; i < OTHER_EXTRA_SWITCHES_COUNT; i++) {
            var row_box = new Box(Orientation.HORIZONTAL, MAIN_BOX_SPACING);
            other_extra_switches[i] = new Switch();
            other_extra_labels[i] = new Label(other_extra_label_texts[i]);
            other_extra_labels[i].set_halign(Align.START);
            row_box.append(other_extra_switches[i]);
            row_box.append(other_extra_labels[i]);
            other_extra_flow_box.insert(row_box, -1);
        }

        box2.append(other_extra_flow_box);

        // Создаем HeaderBar
        var header_bar = new Gtk.HeaderBar();
        header_bar.set_show_title_buttons(true);
        header_bar.set_title_widget(toolbar_view_switcher); // Устанавливаем ToolbarViewSwitcher в центр заголовка

        saveButton = new Button.with_label("Save"); // Переименовываем кнопку "Сохранить" в "Save"
        saveButton.add_css_class("suggested-action"); // Добавляем акцентный цвет
        header_bar.pack_end(saveButton); // Добавляем кнопку "Save" в правый угол заголовка

        saveButton.clicked.connect((_sender) => {
            save_states_to_file();
            if (vkcube_was_running) {
                restart_mangohud();
            } else {
                warning("vkcube was not running before saving. Restart aborted.");
            }
        });

        // Добавляем кнопку "Test" в левую часть заголовка
        var testButton = new Button.with_label("Test");
        testButton.clicked.connect((_sender) => {
            try {
                // Завершаем текущий процесс vkcube
                Process.spawn_command_line_sync("pkill vkcube");
                // Запускаем новый экземпляр mangohud vkcube
                Process.spawn_command_line_async("mangohud vkcube");
            } catch (Error e) {
                stderr.printf("Ошибка при запуске команды: %s\n", e.message);
            }
        });
        header_bar.pack_start(testButton);

        // Устанавливаем HeaderBar в качестве заголовка окна
        window.set_titlebar(header_bar);


        main_box.append(scrolled_window);
        scrolled_window.set_child(view_stack);


        window.set_child(main_box);
        window.present();

        // Загрузка состояний переключателей из файла MangoHud.conf
        load_states_from_file();

        // Проверяем, запущен ли vkcube при запуске приложения
        vkcube_was_running = is_vkcube_running();
    }

    private void save_states_to_file() {
        var config_dir = File.new_for_path(Environment.get_home_dir()).get_child(".config").get_child("MangoHud");
        if (!config_dir.query_exists()) {
            try {
                config_dir.make_directory_with_parents();
            } catch (Error e) {
                stderr.printf("Ошибка при создании директории: %s\n", e.message);
                return;
            }
        }

        var file = config_dir.get_child("MangoHud.conf");
        try {
            var file_stream = file.replace(null, false, FileCreateFlags.NONE);
            var data_stream = new DataOutputStream(file_stream);

            // Добавляем обязательную надпись в начале файла и временно не реализованные пременные.
            data_stream.put_string("################### File Generated by MangoJuice ###################\n");
            data_stream.put_string("legacy_layout=false\n");
            data_stream.put_string("gpu_load_value=50,90\n");
            data_stream.put_string("#gpu_load_color=8FF0A4,F8E45C,CC0000\n");
            data_stream.put_string("#vram_color=AD64C1\n");
            data_stream.put_string("cpu_load_value=50,90\n");
            data_stream.put_string("#cpu_load_color=33D17A,F9F06B,CC0000\n");
            data_stream.put_string("#core_bars\n");
            data_stream.put_string("#ram_color=C26693\n");
            data_stream.put_string("fps\n");
            data_stream.put_string("#wine_color=EB5B5B\n");
            data_stream.put_string("#engine_color=EB5B5B\n");
            data_stream.put_string("#battery_color=00FF00\n");
            data_stream.put_string("#media_player_color=FFFF00\n");

            for (int i = 0; i < gpu_switches.length; i++) {
                var state = gpu_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, gpu_config_vars[i]));
            }

            for (int i = 0; i < cpu_switches.length; i++) {
                var state = cpu_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, cpu_config_vars[i]));
            }

            for (int i = 0; i < other_switches.length; i++) {
                var state = other_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, other_config_vars[i]));
            }

            for (int i = 0; i < system_switches.length; i++) {
                var state = system_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, system_config_vars[i]));
            }

            for (int i = 0; i < wine_switches.length; i++) {
                var state = wine_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, wine_config_vars[i]));
            }

            for (int i = 0; i < options_switches.length; i++) {
                var state = options_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, options_config_vars[i]));
            }

            for (int i = 0; i < battery_switches.length; i++) { // Добавляем сохранение состояний переключателей "Battery"
                var state = battery_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, battery_config_vars[i]));
            }

            for (int i = 0; i < other_extra_switches.length; i++) { // Добавляем сохранение состояний переключателей "Other"
                var state = other_extra_switches[i].active ? "" : "#";
                data_stream.put_string("%s%s\n".printf(state, other_extra_config_vars[i]));
            }

            data_stream.close();
        } catch (Error e) {
            stderr.printf("Ошибка при записи в файл: %s\n", e.message);
        }
    }

    private void load_states_from_file() {
        var config_dir = File.new_for_path(Environment.get_home_dir()).get_child(".config").get_child("MangoHud");
        var file = config_dir.get_child("MangoHud.conf");
        if (!file.query_exists()) {
            return;
        }

        try {
            var file_stream = new DataInputStream(file.read());
            string line;
            while ((line = file_stream.read_line()) != null) {
                for (int i = 0; i < gpu_config_vars.length; i++) {
                    if (line.has_prefix("#%s".printf(gpu_config_vars[i]))) {
                        gpu_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(gpu_config_vars[i]))) {
                        gpu_switches[i].active = true;
                    }
                }

                for (int i = 0; i < cpu_config_vars.length; i++) {
                    if (line.has_prefix("#%s".printf(cpu_config_vars[i]))) {
                        cpu_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(cpu_config_vars[i]))) {
                        cpu_switches[i].active = true;
                    }
                }

                for (int i = 0; i < other_config_vars.length; i++) {
                    if (line.has_prefix("#%s".printf(other_config_vars[i]))) {
                        other_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(other_config_vars[i]))) {
                        other_switches[i].active = true;
                    }
                }

                for (int i = 0; i < system_config_vars.length; i++) {
                    if (line.has_prefix("#%s".printf(system_config_vars[i]))) {
                        system_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(system_config_vars[i]))) {
                        system_switches[i].active = true;
                    }
                }

                for (int i = 0; i < wine_config_vars.length; i++) {
                    if (line.has_prefix("#%s".printf(wine_config_vars[i]))) {
                        wine_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(wine_config_vars[i]))) {
                        wine_switches[i].active = true;
                    }
                }

                for (int i = 0; i < options_config_vars.length; i++) {
                    if (line.has_prefix("#%s".printf(options_config_vars[i]))) {
                        options_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(options_config_vars[i]))) {
                        options_switches[i].active = true;
                    }
                }

                for (int i = 0; i < battery_config_vars.length; i++) { // Добавляем загрузку состояний переключателей "Battery"
                    if (line.has_prefix("#%s".printf(battery_config_vars[i]))) {
                        battery_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(battery_config_vars[i]))) {
                        battery_switches[i].active = true;
                    }
                }

                for (int i = 0; i < other_extra_config_vars.length; i++) { // Добавляем загрузку состояний переключателей "Other"
                    if (line.has_prefix("#%s".printf(other_extra_config_vars[i]))) {
                        other_extra_switches[i].active = false;
                    } else if (line.has_prefix("%s".printf(other_extra_config_vars[i]))) {
                        other_extra_switches[i].active = true;
                    }
                }
            }
        } catch (Error e) {
            stderr.printf("Ошибка при чтении файла: %s\n", e.message);
        }
    }

    private void restart_mangohud() {
        try {
            // Проверяем, запущен ли vkcube
            string[] argv = { "pgrep", "mangohud" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync(null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            if (exit_status == 0) {
                // Закрываем текущий экземпляр vkcube
                Process.spawn_command_line_sync("pkill vkcube");
                // Запускаем новый экземпляр mangohud vkcube
                Process.spawn_command_line_async("mangohud vkcube");
            }
        } catch (Error e) {
            stderr.printf("Ошибка при перезапуске mangohud: %s\n", e.message);
        }
    }

    private bool is_vkcube_running() {
        try {
            string[] argv = { "pgrep", "vkcube" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync(null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            return exit_status == 0;
        } catch (Error e) {
            stderr.printf("Ошибка при проверке запущенных процессов: %s\n", e.message);
            return false;
        }
    }

    public static int main(string[] args) {
        var app = new MangoJuice();
        return app.run(args);
    }
}