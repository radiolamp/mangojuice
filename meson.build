project('mangojuice', 'vala',
  version: '1.0.0',
  default_options: ['warning_level=2'])

dependencies = [
  dependency('glib-2.0'),
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('gee-0.8')  
]

sources = files('src/mangojuice.vala')

executable('mangojuice', sources, dependencies: dependencies)