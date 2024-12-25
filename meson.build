project(
    'mangojuice', 'vala',
    version: '0.8.0',
    default_options: ['warning_level=0']
)

# on Relise
add_project_arguments('-Wno-discarded-qualifiers', language: 'c')

gnome = import('gnome')

subdir('data')
subdir('src')
