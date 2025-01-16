project(
    'mangojuice', 'vala',
    version: '0.8.1',
    default_options: [
        'warning_level=0',
    ]
)

i18n = import('i18n')
gnome = import('gnome')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

conf = configuration_data()
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
conf.set_quoted('VERSION', meson.project_version())

add_project_arguments(
    '-Wno-discarded-qualifiers',
    language: 'c'
)

subdir('data')  # Каталог для ресурсов (например, .gresource.xml)
subdir('src')   # Каталог с исходным кодом
subdir('po')    # Каталог для локализации (файлы .po, .pot)
