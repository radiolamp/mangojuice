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

using Gtk;

namespace AboutDialog {
    public void show_about_dialog (Widget widget) {
        var dialog = new Adw.AboutDialog () {
            application_icon = "io.github.radiolamp.mangojuice",
            application_name = "MangoJuice",
            developer_name = "Radiolamp",
            translator_credits = _("translator-credits"),
            developers = {
                "Radiolamp",
                "Vladimir Vaskov https://rirusha.space/"
            },
            artists = {},
            documenters = {},
            designers = {},
            version = "0.7.8",
            license_type = Gtk.License.GPL_3_0,
            copyright = "© 2024 Radiolamp",
            issue_url = "https://github.com/radiolamp/mangojuice/issues",
        };

        dialog.add_link ("MangoJuice на GitHub", "https://github.com/radiolamp/mangojuice");
        dialog.present (widget);
    }
}
