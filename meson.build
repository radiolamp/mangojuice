project(
    'mangojuice', 'vala',
    version: '0.7.8',
    default_options: ['warning_level=0']
)

# on Relise
add_project_arguments('-Wno-discarded-qualifiers', language: 'c')

gnome = import('gnome')

subdir('data')
subdir('src')
subdir('po')
