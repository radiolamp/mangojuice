/*
 * Copyright (C) 2024 Radiolamp
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

[GtkTemplate (ui = "/io/github/radiolamp/mangojuice/ui/window.ui")]
public sealed class MangoJuice.Window : Adw.ApplicationWindow {

    [GtkChild]
    private MetricsPage metrics_page;
    [GtkChild]
    private ExtrasPage extras_page;
    [GtkChild]
    private PerformancePage performance_page;
    [GtkChild]
    private VisualPage visual_page;

    const ActionEntry[] ACTION_ENTRIES = {
        { "about", on_about_action },
    };

    public Window (MangoJuice.Application app) {
        Object (application: app);
    }

    static construct {
        typeof (TitledSwitch).ensure ();
        typeof (MangoJuice.Block).ensure ();
        typeof (ExtrasPage).ensure ();
        typeof (MetricsPage).ensure ();
        typeof (PerformancePage).ensure ();
        typeof (VisualPage).ensure ();
    }

    construct {
        var settings = new Settings ("io.github.radiolamp.mangojuice");
        settings.bind ("window-width", this, "default-width", SettingsBindFlags.DEFAULT);
        settings.bind ("window-height", this, "default-height", SettingsBindFlags.DEFAULT);
        settings.bind ("window-maximized", this, "maximized", SettingsBindFlags.DEFAULT);

        application_inst.values_manager.add_page (Pages.METRICS, metrics_page);
        application_inst.values_manager.add_page (Pages.EXTRAS, extras_page);
        application_inst.values_manager.add_page (Pages.PERFORMANCE, performance_page);
        application_inst.values_manager.add_page (Pages.VISUAL, visual_page);

        if (Config.IS_DEVEL) {
            add_css_class ("devel");
        }
    }

    public void on_about_action () {
        MangoJuice.About.show_about_dialog (this);
    }
}
