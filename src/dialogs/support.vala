/* dialogs/support.vala // License: GPL-3.0+ */
using Gtk;
using Adw;

namespace MangoJuice.Dialogs {

public class SupportDialog : GLib.Object {

    public async void show_support_dialog (Gtk.Window parent_window) {
        var dialog = new Adw.Dialog ();
        dialog.set_title (_("Support the Project"));
        dialog.set_content_width (560);
        dialog.set_content_height (480);

        var scrolled_window = new Gtk.ScrolledWindow ();
        scrolled_window.set_hexpand (true);
        scrolled_window.set_vexpand (true);
        scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        dialog.set_child (scrolled_window);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        scrolled_window.set_child (main_box);

        var header_bar = new Adw.HeaderBar ();
        header_bar.set_show_start_title_buttons (false);
        header_bar.set_show_end_title_buttons (true);
        header_bar.add_css_class ("flat");
        main_box.append (header_bar);

        var icon_container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        icon_container.set_halign (Gtk.Align.CENTER);
        icon_container.set_vexpand (true);
        main_box.append (icon_container);

        var app_icon = new Gtk.Image.from_icon_name ("io.github.radiolamp.mangojuice");
        app_icon.set_pixel_size (150);
        app_icon.set_halign (Gtk.Align.CENTER);
        icon_container.append (app_icon);

        var description_label = new Gtk.Label (
            _("It is only thanks to your support that Mangojuice lives and develops.")
            + _(" If it is not difficult for you, please support the project financially.")
            + _(" Any amount will be useful and will go towards development.")
        );
        description_label.set_wrap (true);
        description_label.set_halign (Gtk.Align.CENTER);
        description_label.add_css_class ("heading");
        description_label.set_margin_top (24);
        description_label.set_margin_bottom (48);
        description_label.set_margin_start (24);
        description_label.set_margin_end (24);
        main_box.append (description_label);

        var flow_box = new Gtk.FlowBox ();
        flow_box.set_selection_mode (Gtk.SelectionMode.NONE);
        flow_box.set_max_children_per_line (3);
        flow_box.set_min_children_per_line (1);
        flow_box.set_column_spacing (12);
        flow_box.set_row_spacing (12);
        flow_box.set_halign (Gtk.Align.CENTER);
        flow_box.set_valign (Gtk.Align.CENTER);
        flow_box.set_vexpand (true);
        flow_box.set_homogeneous (true);
        flow_box.set_margin_start (24);
        flow_box.set_margin_end (24);
        SourceFunc callback = null;
        bool dialog_closed = false;

        dialog.closed.connect (() => {
            dialog_closed = true;
            if (callback != null) {
                callback ();
            }
        });

        var donation_alerts_btn = new Gtk.Button.with_label (_("Donation Alerts"));
        donation_alerts_btn.set_tooltip_text ("https://www.donationalerts.com/r/radiolamp");
        donation_alerts_btn.clicked.connect (() => {
            var launcher = new Gtk.UriLauncher ("https://www.donationalerts.com/r/radiolamp");
            launcher.launch.begin (parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end (res);
                } catch (Error e) {
                    warning ("Failed to open Donation Alerts: %s", e.message);
                }
            });
        });

        var boosty_btn = new Gtk.Button.with_label (_("Boosty"));
        boosty_btn.set_tooltip_text ("https://boosty.to/radiolamp");
        boosty_btn.clicked.connect (() => {
            var launcher = new Gtk.UriLauncher ("https://boosty.to/radiolamp");
            launcher.launch.begin (parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end (res);
                } catch (Error e) {
                    warning ("Failed to open Boosty: %s", e.message);
                }
            });
        });

        var tinkoff_btn = new Gtk.Button.with_label (_("Tinkoff"));
        tinkoff_btn.set_tooltip_text ("https://www.tbank.ru/cf/3PPTstulqEq");
        tinkoff_btn.clicked.connect (() => {
            var launcher = new Gtk.UriLauncher ("https://www.tbank.ru/cf/3PPTstulqEq");
            launcher.launch.begin (parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end (res);
                } catch (Error e) {
                    warning ("Failed to open Tinkoff: %s", e.message);
                }
            });
        });

        var ymoney_btn = new Gtk.Button.with_label (_("ЮMoney (Мир)"));
        ymoney_btn.set_tooltip_text ("https://yoomoney.ru/fundraise/1CRVAISSLRB.250918");
        ymoney_btn.clicked.connect (() => {
            var launcher = new Gtk.UriLauncher ("https://yoomoney.ru/fundraise/1CRVAISSLRB.250918");
            launcher.launch.begin (parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end (res);
                } catch (Error e) {
                    warning ("Failed to open ЮMoney: %s", e.message);
                }
            });
        });

        var sber_btn = new Gtk.Button.with_label (_("Sber (Мир)"));
        sber_btn.set_tooltip_text ("https://messenger.online.sberbank.ru/sl/eIrNTQ3a1dCLQ8gxL");
        sber_btn.clicked.connect (() => {
            var launcher = new Gtk.UriLauncher ("https://messenger.online.sberbank.ru/sl/eIrNTQ3a1dCLQ8gxL");
            launcher.launch.begin (parent_window, null, (obj, res) => {
                try {
                    launcher.launch.end (res);
                } catch (Error e) {
                    warning ("Failed to open Sber: %s", e.message);
                }
            });
        });

        var telegram_btn = new Gtk.Button.with_label (_("Telegram (TON)"));
        telegram_btn.set_tooltip_text (_("Click to copy the wallet number"));
        telegram_btn.clicked.connect (() => {
            var clipboard = Gdk.Display.get_default ().get_clipboard ();
            clipboard.set_text ("UQCHkkZx3UT_8A-tAI8Zlu6iuX5WsBYLa0JVC7SK8PfJ3Rqf");
            string original_text = telegram_btn.get_label ();
            telegram_btn.set_label (_("Copied"));
            Timeout.add_seconds (1, () => {
                telegram_btn.set_label (original_text);
                return false;
            });
        });

        var donation_child = new Gtk.FlowBoxChild ();
        donation_child.set_child (donation_alerts_btn);

        var tinkoff_child = new Gtk.FlowBoxChild ();
        tinkoff_child.set_child (tinkoff_btn);

        var boosty_child = new Gtk.FlowBoxChild ();
        boosty_child.set_child (boosty_btn);

        var ymoney_child = new Gtk.FlowBoxChild ();
        ymoney_child.set_child (ymoney_btn);

        var telegram_child = new Gtk.FlowBoxChild ();
        telegram_child.set_child (telegram_btn);

        var sber_child = new Gtk.FlowBoxChild ();
        sber_child.set_child (sber_btn);

        flow_box.append (donation_child);
        flow_box.append (boosty_child);
        flow_box.append (ymoney_child);
        flow_box.append (tinkoff_child);
        flow_box.append (telegram_child);
        flow_box.append (sber_child);

        main_box.append (flow_box);

        var spacer = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        spacer.set_hexpand (true);
        spacer.set_vexpand (true);
        main_box.append (spacer);

        var thanks_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        thanks_box.set_halign (Gtk.Align.CENTER);
        thanks_box.set_margin_bottom (24);
        thanks_box.set_margin_top (24);

        var thanks_label = new Gtk.Label (_("Thank you for your support!"));
        thanks_label.add_css_class ("dim-label");

        var heart_icon = new Gtk.Image.from_icon_name ("io.github.radiolamp.mangojuice.donate-symbolic");
        heart_icon.add_css_class ("love-hover");
        heart_icon.set_pixel_size (16);

        thanks_box.append (thanks_label);
        thanks_box.append (heart_icon);

        main_box.append (thanks_box);

        dialog.present (parent_window);

        Timeout.add (500, () => {
            icon_container.add_css_class ("wobble-animation");
            return Source.REMOVE;
        });

        while (!dialog_closed) {
            callback = show_support_dialog.callback;
            yield;
        }
    }

}

}
