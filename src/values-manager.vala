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

public sealed class MangoJuice.ValuesManager {

    Gee.HashMap<Pages, Page> pages { get; set; default = new Gee.HashMap<Pages, Page> (); }

    public void add_page (Pages name, Page page) {
        pages.set (name, page);
    }

    public void trigger_changed () {
        // Load here
        AllValues all_values = {
            metrics: pages.get (Pages.METRICS).get_values (),
            extras: pages.get (Pages.EXTRAS).get_values (),
            performance: pages.get (Pages.PERFORMANCE).get_values (),
            visual: pages.get (Pages.VISUAL).get_values (),
        };
    }

    public void set_all_values (AllValues all_values) {
        pages.get (Pages.METRICS).set_values (all_values.metrics);
        pages.get (Pages.EXTRAS).set_values (all_values.extras);
        pages.get (Pages.PERFORMANCE).set_values (all_values.performance);
        pages.get (Pages.VISUAL).set_values (all_values.visual);
    }
}
