vapi_sources = files(
    'config.vapi',
)

vala_sources = files(
    'pages/extras.vala',
    'pages/metrics.vala',
    'pages/page.vala',
    'pages/performance.vala',
    'pages/visual.vala',
    'widgets/block.vala',
    'widgets/titled-switch.vala',
    'about.vala',
    'application.vala',
    'load-states.vala',
    'main.vala',
    'mangojuice.vala',
    'save-states.vala',
    'utils.vala',
    'values-manager.vala',
    'window.vala',
)

sources = [
  vapi_sources,
  blueprints,
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
