project(
    'mangojuice', 'vala',
    version: '0.8.0',
    default_options: [
        'warning_level=0',
    ]
)

i18n = import('i18n')
gnome = import('gnome')

# Добавление аргументов компиляции
add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

conf = configuration_data()
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))

add_project_arguments(
    '-Wno-discarded-qualifiers',  # Игнорировать предупреждения о потере квалификаторов
    language: 'c'
)

subdir('data')  # Каталог для ресурсов (например, .gresource.xml)
subdir('src')   # Каталог с исходным кодом
subdir('po')    # Каталог для локализации (файлы .po, .pot)
