project(
    'mangojuice', 'vala',
    version: '0.8.0',
    default_options: [
        'warning_level=0',
        'localedir=/usr/share/locale'
    ]
)

i18n = import('i18n')
gnome = import('gnome')

add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

add_project_arguments('-Wno-discarded-qualifiers', language: 'c')

# Подключение поддиректорий
subdir('data')
subdir('src')

i18n.gettext(meson.project_name(),
    args: '--directory=' + meson.project_source_root(),
    preset: 'glib',
    install: true,
    install_dir: get_option('localedir')
)