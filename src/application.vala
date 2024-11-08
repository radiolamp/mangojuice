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

public sealed class MangoJuice.Application : Adw.Application {

    const ActionEntry[] ACTION_ENTRIES = {
        { "quit", on_quit_action },
    };

    public Application () {
        Object (
            application_id: Config.APP_ID,
            resource_base_path: "/io/github/radiolamp/mangojuice/",
            flags: ApplicationFlags.DEFAULT_FLAGS | ApplicationFlags.HANDLES_OPEN
        );
    }

    construct {
        add_action_entries (ACTION_ENTRIES, this);
        set_accels_for_action ("app.quit", { "<primary>q" });
    }

    public override void activate () {
        base.activate ();

        if (active_window == null) {
            var window = new Window (this);
            window.present ();
        } else {
            active_window.present ();
        }
    }

    public new void on_quit_action () {
        if (is_vkcube_running ()) {
            try {
                Process.spawn_command_line_sync ("pkill vkcube");
            } catch (Error e) {
                stderr.printf ("Error closing vkcube: %s\n", e.message);
            }
        }

        if (is_glxgears_running ()) {
            try {
                Process.spawn_command_line_sync ("pkill glxgears");
            } catch (Error e) {
                stderr.printf ("Error closing glxgears: %s\n", e.message);
            }
        }

        base.quit ();
    }
}
