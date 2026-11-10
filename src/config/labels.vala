/* config/labels.vala // License: GPL-3.0+ */
namespace MangoJuice.Config {

public class Labels {
    /*
     * Labels
     */

    // Metrics
    public string[] gpu_label_texts = {
        _ ("Load GPU"), _ ("Color load"), _ ("VRAM"), _ ("Core frequency"),
        _ ("Memory frequency"), _ ("Temperature"), _ ("Memory temperature"), _ ("Max temperature"),
        _ ("Fans"), _ ("Model"), _ ("Power"), _ ("Voltage"),
        _ ("Throttling"), _ ("Throttling graph"), _ ("Vulkan Driver"), _ ("GPU efficiency (F/J)"),
        _ ("Engine version"), _ ("Power limit"), _ ("VRAM usage")
    };
    public string[] cpu_label_texts = {
        _ ("Load CPU"), _ ("Color load"), _ ("Load per core"), _ ("Colored cores"), _ ("Diagram"),
        _ ("Maximum frequency"), _ ("Temperature"), _ ("Power"), _ ("Core type"), _ ("FPS per Joule"),
        _ ("EconoFlip")
    };
    public string[] memory_label_texts = {
        _ ("RAM"), _ ("Disk read"), _ ("Disk write"), _ ("Resident memory"),
        _ ("General memory"), _ ("Virtual memory"), _ ("Swap"), _ ("RAM temperature")
    };

    public string[] memory_label_texts_2 = {
        _ ("Size, GiB"), _ ("Input, MiB/s"), _ ("Output, MiB/s"), _ ("Size, GiB"),
        _ ("Size, MiB/s"), _ ("Size, MiB/s"), _ ("Size, GiB"), _ ("DDR5 only")
    };

    public string[] git_label_texts = { _ ("Hide FSR sharpness") };

    // Extras
    public string[] system_label_texts = {
        _ ("Refresh rate"), _ ("Fan"), _ ("Resolution"), _ ("Session type"),
        _ ("Compact API"), _ ("Watch"), _ ("Architecture"), _ ("Network")
    };
    public string[] options_label_texts = {
        _ ("HUD Version"), _ ("Gamemode"), _ ("vkBasalt"), _ ("Exe name"),
        _ ("Fcat"), _ ("FSR"), _ ("HDR"), _ ("Remove paddings"),
        _ ("Hide HUD"), _ ("Remove shadows"), _ ("Font normalization"), _ ("Remove margins")
    };
    public string[] battery_label_texts = {
        _ ("Battery charge"), _ ("Battery power"), _ ("Time remain"),
        _ ("Device icon"), _ ("More icon"), _ ("Other batteries")
    };
    public string[] wine_label_texts = {
        _ ("Version"), _ ("Winesync")
    };
    public string[] other_extra_label_texts = {
        _ ("Media"), _ ("Full ON"),
        _ ("Full log"), _ ("Upload logs")
    };

    // Performance
    public string[] inform_label_texts = {
        _ ("FPS"), _ ("Color FPS"), _ ("Lowest 1%"),
        _ ("Lowest 0.1%"), _ ("All lowest"), _ ("Frame limit"),
        _ ("Frame graph"), _ ("Detailed Frametime"), _ ("Histogram"),
        _ ("Frame Counter"), _ ("°C to °F"), _ ("VPS")
    };

    /*
     * Descriptions
     */

    // Metrics
    public string[] gpu_label_texts_2 = {
        _ ("Percentage load"), _ ("Color text"), _ ("Amount of video memory"), _ ("Frequency, MHz"),
        _ ("Frequency, MHz"), _ ("GPU temperature"), _ ("GDDR temperature"), _ ("Temperature peak"),
        _ ("Speed, RPM"), _ ("GPU name"), _ ("Consumption, W"), _ ("Consumption, V"),
        _ ("Trolling parametrs"), _ ("Curve"), _ ("Driver Version"), _ ("Efficiency in FPS/Joule"),
        _ ("OpenGL and Vulkan"), _ ("Display GPU power limit"), _ ("Display process' VRAM usage")
    };
    public string[] cpu_label_texts_2 = {
        _ ("Percentage load"), _ ("Color text"), _ ("All cores"), _ ("Colored cores text"), _ ("Load per core"),
        _ ("Peak among all cores"), _ ("CPU temperature"),
        _ ("Consumption, W"), _ ("For new Intel and ARM"),
        _ ("CPU efficiency in FPS/Joule"),
        _ ("Swaps FPS/J to J/Frame")
    };

    public string[] git_label_texts_2 = { _ ("Gamescope") };

    // Extras
    public string[] system_label_texts_2 = {
        _ ("Gamescope only"), _ ("Steam Deck only"), _ ("Window size"), _ ("X11/Wayland"),
        _ ("Shortens the name"), _ ("Current time"), _ ("Processor base"), _ ("Adapters speed")
    };
    public string[] options_label_texts_2 = {
        _ ("MangoHud version"), _ ("Gamemode state"), _ ("vkBasalt state"), _ ("Process name"),
        _ ("Updating visualization"), _ ("Gamescope only"), _ ("Gamescope only"), _ ("Internal offsets"),
        _ ("Hide overlay"), _ ("Shadows under text"), _ ("Same font size"), _ ("External offsets")
    };
    public string[] battery_label_texts_2 = {
        _ ("Power level, %"), _ ("Consumption, W"), _ ("Battery life"),
        _ ("This devices"), _ ("Wireless devices"), _ ("Wireless battries")
    };
    public string[] wine_label_texts_2 = {
        _ ("Wine or Proton version"), _ ("Wine sync method")
    };
    public string[] other_extra_label_texts_2 = {
        _ ("Current playback"), _ ("All but histograms"),
        _ ("Log information"), _ ("flightlessmango.com")
    };

    // Performance
    public string[] inform_label_texts_2 = {
        _ ("Frames per second"), _ ("Color text"), _ ("1% is lower than"),
        _ ("0.1% is lower than"), _ ("1% and 0.1% lower than"),
        _ ("FPS limitation"), _ ("Frametime"),
        _ ("Detailed frame time"), _ ("Graph to histogram"),
        _ ("Display frame count"), _ ("Temperature in °F"), _ ("Present mode")
    };

    public string[] format_labels = { _ ("Title"), _ ("Artist"), _ ("Album"), _ ("None") };
}

}
