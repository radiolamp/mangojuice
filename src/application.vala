//aplication.vala

namespace MangoJuice {
    MangoJuice.Application application_inst;
}

public sealed class MangoJuice.Application : Adw.Application {

    const ActionEntry[] ACTION_ENTRIES = {
        //{ "quit", on_quit_action },
    };

    public ValuesManager values_manager { get; private set; }

    public Application () {
        Object (
            application_id: Config.APP_ID,
            resource_base_path: "/io/github/radiolamp/mangojuice/",
            flags: ApplicationFlags.DEFAULT_FLAGS | ApplicationFlags.HANDLES_OPEN
        );
    }

    construct {
        application_inst = this;
        values_manager = new ValuesManager ();

        add_action_entries (ACTION_ENTRIES, this);
        const string[] Q_ACCELS = { "<primary>q" };
        this.set_accels_for_action ("app.quit", Q_ACCELS);
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

}
