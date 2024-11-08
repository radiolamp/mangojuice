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

namespace MangoJuice.About {
    public void show_about_dialog (Widget widget) {
        var dialog = new Adw.AboutDialog () {
            application_icon = Config.APP_ID,
            application_name = Config.APP_NAME,
            developer_name = "Radiolamp",
            translator_credits = _("translator-credits"),
            developers = {
                "Radiolamp",
                "Vladimir Vaskov https://rirusha.space/"
            },
            artists = {},
            documenters = {},
            designers = {},
            version = Config.VERSION,
            license_type = Gtk.License.GPL_3_0,
            copyright = "© 2024 Radiolamp",
            issue_url = Config.BUGTRACKER,
            website = Config.HOMEPAGE
        };

        // Translators: don't translate MangoHud
        dialog.add_link (_("MangoHud repository"), "https://github.com/flightlessmango/MangoHud");
        dialog.present (widget);
    }
}
