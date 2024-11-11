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

[GtkTemplate (ui = "/io/github/radiolamp/mangojuice/ui/titled-switch.ui")]
public sealed class MangoJuice.TitledSwitch : Adw.Bin {

    [GtkChild]
    unowned Gtk.Switch root_switch;
    [GtkChild]
    unowned Gtk.Label subtitle_label;

    public string title { get; set; }

    public string subtitle { get; set; }

    public bool active { get; set; }

    public signal void changed (bool is_active);

    construct {
        subtitle_label.bind_property ("label",
        subtitle_label, "visible",
        BindingFlags.DEFAULT,
    (binding, srcval, ref trgval) => {
            trgval.set_boolean (srcval.get_string () != "");
        });

        root_switch.notify["active"].connect (() => {
            changed (root_switch.active);
        });
    }
}
