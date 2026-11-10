/* system/gpu.vala // License: GPL-3.0+ */
using GLib;

namespace MangoJuice.System {

public class GPU : GLib.Object {

public string[] get_gpu_pci_addresses () {
    string[] addresses = {};
    try {
        string output;
        Process.spawn_command_line_sync ("lspci", out output);
        string[] lines = output.split ("\n");

        foreach (var line in lines) {
            if ("VGA compatible controller" in line || "3D controller" in line || "Display controller" in line) {
                string pci_address = line[0:7].strip ();
                string detailed_output;
                Process.spawn_command_line_sync ("lspci -D -s " + pci_address, out detailed_output);
                string full_pci_address = detailed_output[0:12].strip ();

                string vendor_info = "";
                if ("Intel" in line) {
                    vendor_info = line.substring (line.index_of ("Intel")).strip ();
                } else if ("AMD" in line) {
                    vendor_info = line.substring (line.index_of ("AMD")).strip ();
                } else if ("ATI" in line) {
                    vendor_info = line.substring (line.index_of ("ATI")).strip ();
                } else if ("NVIDIA" in line) {
                    vendor_info = line.substring (line.index_of ("NVIDIA")).strip ();
                } else if ("Nvidia" in line) {
                    vendor_info = line.substring (line.index_of ("Nvidia")).strip ();
                } else {
                    vendor_info = _ ("Unknown Videocard");
                }

                vendor_info = vendor_info.replace (" [", " ").replace ("[", " ")
                                       .replace (" ]", " ").replace ("]", " ")
                                       .replace (" (", " ").replace ("(", " ")
                                       .replace (" )", " ").replace (")", " ")
                                       .replace (" ", " ").strip ();

                addresses += full_pci_address + " # " + vendor_info;
            }
        }
    } catch (Error e) {
        stderr.printf ("Error getting GPU PCI addresses: %s\n", e.message);
    }
    return addresses;
}
}

}
