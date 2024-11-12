//gpl-3.0 license
//page.vala

public abstract class MangoJuice.Page : Adw.Bin {

    public abstract MetricsValues get_values ();

    public abstract void set_values (MetricsValues metrics_values);
}
