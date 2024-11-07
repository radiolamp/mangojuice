vapi_sources = files(
    'config.vapi',
)

vala_sources = files(
    'about_dialog.vala',
    'load_states.vala',
    'main.vala',
    'mangojuice.vala',
    'save_states.vala',
)

sources = [
  vapi_sources,
#   blueprints,
  vala_sources,
  resources
]

deps = [
    dependency('libadwaita-1'),
    dependency('gee-0.8')
]

executable(
    meson.project_name(),
    sources,
    include_directories: config_h_dir,
    dependencies: deps,
    install: true
)
