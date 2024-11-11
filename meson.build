project(
    'mangojuice',
    'vala',
    version: '0.7.8',
    default_options: ['warning_level=0']
)

# on Relise
add_project_arguments(
  '-include', 'config.h',
  '-Wno-discarded-qualifiers',
  language: ['c']
)

add_project_arguments(
  '--target-glib', '2.76',
  '--vapidir', meson.current_source_dir(),
  language: ['vala']
)

app_id = 'io.github.radiolamp.mangojuice'
app_name = 'MangoJuice'
homapage = 'https://github.com/radiolamp/mangojuice'
bugtracker = 'https://github.com/radiolamp/mangojuice/issues'

conf = configuration_data()
conf.set_quoted('APP_ID', app_id)
conf.set_quoted('APP_NAME', app_name)
conf.set_quoted('G_LOG_DOMAIN', app_id)
conf.set10('IS_DEVEL', get_option('is_devel'))
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('HOMEPAGE', homapage)
conf.set_quoted('BUGTRACKER', bugtracker)

configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

i18n = import('i18n')
gnome = import('gnome')

subdir('data')
subdir('src')
subdir('po')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true,
)
