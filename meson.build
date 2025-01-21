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

name_suffix = ''
app_id_suffix = ''
version_suffix = ''

if get_option('is_devel')
  name_suffix = ' (Devel)'
  app_id_suffix = '-Devel'

  find_program('git', required: true)
  vcs_tag = run_command('git', 'rev-parse', '--short', 'HEAD', check: true).stdout().strip()
  version_suffix = '-dev.@0@'.format(vcs_tag)
endif

conf = configuration_data()
conf.set10('IS_DEVEL', get_option('is_devel'))
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
conf.set_quoted('VERSION', meson.project_version() + version_suffix)

# Добавляем аргументы для компилятора C
add_project_arguments(
    '-Wno-discarded-qualifiers',
    language: 'c'
)

subdir('data')  # Каталог для ресурсов (например, .gresource.xml)
subdir('src')   # Каталог с исходным кодом
subdir('po')    # Каталог для локализации (файлы .po, .pot)