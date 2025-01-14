project(
    'mangojuice', 'vala',
    version: '0.8.0',
    default_options: ['warning_level=0']
)

i18n = import('i18n')
add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

i18n = import('i18n')
gnome = import('gnome')

# on Relise
add_project_arguments('-Wno-discarded-qualifiers', language: 'c')

subdir('data')
subdir('src')
