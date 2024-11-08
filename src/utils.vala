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

namespace MangoJuice {

    public bool is_vkcube_running () {
        try {
            string[] argv = { "pgrep", "vkcube" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Error checking running processes: %s\n", e.message);
            return false;
        }
    }

    public bool is_glxgears_running () {
        try {
            string[] argv = { "pgrep", "glxgears" };
            int exit_status;
            string standard_output;
            string standard_error;
            Process.spawn_sync (null, argv, null, SpawnFlags.SEARCH_PATH, null, out standard_output, out standard_error, out exit_status);

            return exit_status == 0;
        } catch (Error e) {
            stderr.printf ("Error checking running processes: %s\n", e.message);
            return false;
        }
    }

    public string rgba_to_hex (Gdk.RGBA rgba) {
        return "%02x%02x%02x".printf ((int) (rgba.red * 255), (int) (rgba.green * 255), (int) (rgba.blue * 255));
    }

    /**
     * Run command and handle {@link Glib.Error} 
     */
    public void run_command (string[] cmd, out string? stdout = null, out string? stderr = null) {
        try {
            var sb = new Subprocess.newv (cmd, SubprocessFlags.NONE);
            sb.communicate_utf8 (null, null, out stdout, out stderr);
        } catch (Error e) {
            GLib.stderr.printf (
                "Error running '%s': %s\n",
                string.joinv (" ", cmd),
                e.message
            );
        }
    }

    /**
     * Async version od {@link run_command}
     */
    public async void run_command_async (string[] cmd, out string? stdout = null, out string? stderr = null) {
        try {
            var sb = new Subprocess.newv (cmd, SubprocessFlags.NONE);
            yield sb.communicate_utf8_async (null, null, out stdout, out stderr);
        } catch (Error e) {
            GLib.stderr.printf (
                "Error running '%s': %s\n",
                string.joinv (" ", cmd),
                e.message
            );
        }
    }
}
