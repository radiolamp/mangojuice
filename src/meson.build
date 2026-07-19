deps = [
    dependency('libadwaita-1'),
    dependency('gee-0.8')
]

vapi_sources = files('config.vapi')

sources = files(
    'dialog.vala',
    'mangojuice.vala',
    'save_states.vala',
    'other/OtherBox.vala',
    'other/other_save.vala',
    'other/other_load.vala',
    'load_states.vala',
    'reset_manager.vala',
    'intel_power_fix_handler.vala',
    'advanced.vala',
    'game_manager.vala'
)

configure_file(output: 'config.h', configuration: conf)

# Windows admin manifest (UAC elevation)
extra_link_args = []
extra_objects = []
if host_machine.system() == 'windows'
    windows_mod = import('windows')
    extra_objects += windows_mod.compile_resources(
        files('../data/mangojuice_win.rc'),
        include_directories: include_directories('../data')
    )
endif

executable(
    'mangojuice',

    resources,
    vapi_sources,
    sources,
    extra_objects,
    vala_args: ['--vapidir', meson.current_source_dir()],
    c_args: ['-Wno-incompatible-pointer-types'],
    dependencies: deps,
    install: true
)
