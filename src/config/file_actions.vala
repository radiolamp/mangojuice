/* config/file_actions.vala // License: GPL-3.0+ */
namespace MangoJuice.Config {

public class FileActions : GLib.Object {

    State state;
    Paths paths;
    Loader loader;

    public ResetManager reset_manager { get; set; }

    public FileActions (State state, Paths paths, Loader loader) {
        this.state = state;
        this.paths = paths;
        this.loader = loader;
    }

    static bool is_dialog_cancelled (Error e) {
        return e.matches (Gtk.DialogError.quark (), Gtk.DialogError.DISMISSED)
            || e.matches (Gtk.DialogError.quark (), Gtk.DialogError.CANCELLED);
    }

    static bool copy_file_contents (File source, File destination) {
        if (source.equal (destination)) {
            return true;
        }

        var content = new StringBuilder ();

        try {
            var input = new DataInputStream (source.read ());
            try {
                string? line;
                while ((line = input.read_line ()) != null) {
                    content.append (line);
                    content.append ("\n");
                }
            } finally {
                try {
                    input.close ();
                } catch (Error e) {
                    stderr.printf (_ ("Error closing %s: %s\n"), source.get_path (), e.message);
                }
            }

            var output = new DataOutputStream (
                destination.replace (null, false, FileCreateFlags.NONE)
            );
            try {
                output.put_string (content.str);
            } finally {
                try {
                    output.close ();
                } catch (Error e) {
                    stderr.printf (_ ("Error closing %s: %s\n"), destination.get_path (), e.message);
                }
            }

            return true;
        } catch (Error e) {
            stderr.printf (
                _ ("Error copying %s to %s: %s\n"),
                source.get_path (), destination.get_path (), e.message
            );
            return false;
        }
    }

    public void save_as_dialog (Gtk.Window parent_window) {
        var dialog = new Gtk.FileDialog ();
        dialog.set_accept_label (_ ("Save"));
        dialog.set_initial_name ("MangoHud.conf");

        dialog.save.begin (parent_window, null, (obj, res) => {
            try {
                var file = dialog.save.end (res);
                save_config_to_file (file.get_path ());
            } catch (Error e) {
                if (is_dialog_cancelled (e)) {
                    return;
                }
                stderr.printf (_ ("Error when saving the file: %s\n"), e.message);
            }
        });
    }

    void save_config_to_file (string file_path) {
        var source = paths.mangohud_conf;
        if (!source.query_exists ()) {
            stderr.printf (_ ("MangoHud.conf does not exist.\n"));
            return;
        }

        copy_file_contents (source, File.new_for_path (file_path));
    }

    public void restore_dialog (Gtk.Window parent_window) {
        var dialog = new Gtk.FileDialog ();
        dialog.set_title (_ ("Select config file to restore"));
        dialog.set_accept_label (_ ("Restore"));

        dialog.open.begin (parent_window, null, (obj, res) => {
            try {
                var file = dialog.open.end (res);
                restore_config_from_file (file.get_path ());
            } catch (Error e) {
                if (is_dialog_cancelled (e)) {
                    return;
                }
                stderr.printf (_ ("Error when selecting a file: %s\n"), e.message);
            }
        });
    }

    public bool restore_config_from_file (string file_path) {
        var source = File.new_for_path (file_path);
        if (!source.query_exists ()) {
            stderr.printf (_ ("Selected config file does not exist.\n"));
            return false;
        }

        bool success = copy_file_contents (source, paths.mangohud_conf);
        if (!success) {
            return false;
        }

        stdout.printf (_ ("Configuration restored from %s\n"), file_path);
        loader.load.begin ();
        if (reset_manager != null) {
            reset_manager.reset_all_widgets ();
        }
        return true;
    }

    public void open_folder_chooser_dialog (Gtk.Window parent_window) {
        var dialog = new Gtk.FileDialog ();
        dialog.select_folder.begin (parent_window, null, (obj, res) => {
            try {
                var folder = dialog.select_folder.end (res);
                state.custom_logs_path_entry.text = folder.get_path ();
            } catch (Error e) {
                if (is_dialog_cancelled (e)) {
                    return;
                }
                stderr.printf (_ ("Error when selecting a folder: %s\n"), e.message);
            }
        });
    }

    public void delete_vkbasalt_conf () {
        var file = paths.vkbasalt_conf;
        if (file.query_exists ()) {
            try {
                file.delete ();
                warning (_ ("vkBasalt.conf file deleted."));
            } catch (Error e) {
                stderr.printf (_ ("Error deleting vkBasalt.conf: %s\n"), e.message);
            }
        } else {
            warning (_ ("vkBasalt.conf file does not exist."));
        }
    }

    public void delete_mangohud_backup () {
        var file = paths.mangohud_backup;

        if (file.query_exists ()) {
            try {
                file.delete ();
                warning (_ (".MangoHud.backup file deleted."));
            } catch (Error e) {
                stderr.printf (_ ("Error deleting .MangoHud.backup: %s\n"), e.message);
            }
        } else {
            warning (_ (".MangoHud.backup file does not exist."));
        }
    }
}

}
