/* config.vapi // Licence:  GPL-v3.0 */
[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "config.h")]
namespace Config {
    public const string GETTEXT_PACKAGE;
    public const string GNOMELOCALEDIR;
    public const string VERSION;
    public const bool IS_DEVEL;
}