deps = [
    dependency('libadwaita-1'),
    dependency('gee-0.8')
]

vapi_sources = files('config.vapi')

sources = files(
    'main.vala',
    'application.vala',
    'config/state.vala',
    'config/paths.vala',
    'config/loader.vala',
    'config/saver.vala',
    'config/reset_manager.vala',
    'config/labels.vala',
    'config/advanced_mode.vala',
    'config/file_actions.vala',
    'system/env.vala',
    'system/gpu.vala',
    'system/test_apps.vala',
    'system/test_runner.vala',
    'system/mangohud_global.vala',
    'system/intel_power_fix.vala',
    'ui/common.vala',
    'ui/widget_factory.vala',
    'ui/color_controls.vala',
    'ui/font_selector.vala',
    'ui/gpu_selector.vala',
    'ui/extras_view.vala',
    'ui/controls_view.vala',
    'ui/widgets/shortcut_recorder.vala',
    'ui/widgets/drag_row.vala',
    'dialogs/about.vala',
    'dialogs/support.vala',
    'dialogs/profiles.vala',
    'dialogs/presets.vala',
    'dialogs/advanced.vala',
    'vkbasalt/other_box.vala',
    'vkbasalt/loader.vala',
    'vkbasalt/saver.vala',
)

configure_file(output: 'config.h', configuration: conf)
#config_h_dir = include_directories('.')

executable(
    'mangojuice',

    resources,
    vapi_sources,
    sources,
    vala_args: ['--vapidir', meson.current_source_dir()],
    c_args: ['-Wno-incompatible-pointer-types', '-rdynamic'],
    dependencies: deps,
    install: true
)
