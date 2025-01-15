deps = [
    dependency('libadwaita-1'),
    dependency('gee-0.8')
]

vapi_sources = files(
  'config.vapi',
)

sources = files(
    'about_dialog.vala',
    'mangojuice.vala',
    'save_states.vala',
    'other/OtherBox.vala',
    'other/other_save.vala',
    'other/other_load.vala',
    'load_states.vala'
)

executable(
    'mangojuice',
    
    resources,
    sources,
    dependencies: deps,
    install: true
)