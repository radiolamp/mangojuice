quotless_conf = configuration_data()
quotless_conf.set('APP_ID', app_id)
quotless_conf.set('APP_NAME', app_name)
quotless_conf.set('HOMEPAGE', homapage)
quotless_conf.set('BUGTRACKER', bugtracker)


desktop_file = i18n.merge_file(
  input: configure_file(
    output: '@0@.desktop.in'.format(app_id),
    input: '@0@.desktop.in.in'.format(app_id),
    configuration: quotless_conf),
  output: '@0@.desktop'.format(app_id),
  type: 'desktop',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
  test('Validate desktop file', desktop_utils, args: [desktop_file])
endif

appstream_file = i18n.merge_file(
  input: configure_file(
    output: '@0@.metainfo.xml.in'.format(app_id),
    input: '@0@.metainfo.xml.in.in'.format(app_id),
    configuration: quotless_conf),
  output: '@0@.metainfo.xml'.format(app_id),
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'metainfo')
)

appstreamcli = find_program('appstreamcli', required: false)
if appstreamcli.found()
  test('Validate appstream file', appstreamcli, args: ['validate', appstream_file])
endif

install_data('@0@.gschema.xml'.format(app_id),
  install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file',
  compile_schemas,
  args: ['--strict', '--dry-run', meson.current_source_dir()])
endif

# blueprints = custom_target('blueprints',
#   input: files(
#   ),
#   output: '.',
#   command: [find_program('blueprint-compiler'), 'batch-compile', '@OUTPUT@', '@CURRENT_SOURCE_DIR@', '@INPUT@'],
# )

resources = gnome.compile_resources(
    'mangojuice-resources',
    files('@0@.gresource.xml'.format(app_id)),
    # dependencies: blueprints,
    source_dir: meson.current_build_dir()
)

subdir('icons')
