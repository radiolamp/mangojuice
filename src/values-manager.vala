//values-manager.vala

public sealed class MangoJuice.ValuesManager {

    Gee.HashMap<Pages, Page> pages { get; set; default = new Gee.HashMap<Pages, Page> (); }

    public void add_page (Pages name, Page page) {
        pages.set (name, page);
    }

    public void set_all_values (AllValues all_values) {
        pages.get (Pages.METRICS).set_values (all_values.metrics);
        pages.get (Pages.EXTRAS).set_values (all_values.extras);
        pages.get (Pages.PERFORMANCE).set_values (all_values.performance);
        pages.get (Pages.VISUAL).set_values (all_values.visual);
    }
}