deps = [
    dependency('libadwaita-1'),
    dependency('gee-0.8')
]

sources = files(
    'about_dialog.vala',
    'mangojuice.vala',
    'save_states.vala',
    'OtherBox.vala',
    'load_states.vala'
)

executable(
    'mangojuice',
    
    resources,
    sources,
    dependencies: deps,
    install: true
)