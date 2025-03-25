deps = [
    dependency('libadwaita-1'),
    dependency('gee-0.8')
]

vapi_sources = files('config.vapi')

sources = files(
    'about_dialog.vala',
    'mangojuice.vala',
    'save_states.vala',
    'other/OtherBox.vala',
    'other/other_save.vala',
    'other/other_load.vala',
    'load_states.vala',
    'reset_manager.vala',
    'advanced.vala'
)

configure_file(output: 'config.h', configuration: conf)
#config_h_dir = include_directories('.')

executable(
    'mangojuice',
    
    resources,
    vapi_sources,
    sources,
    vala_args: ['--vapidir', meson.current_source_dir()],
    dependencies: deps,
    install: true
)