project('mangojuice', 'vala',
  version: '1.0.0',
  default_options: ['warning_level=2'])

# Зависимости
gtk_dep = dependency('gtk4')
glib_dep = dependency('glib-2.0')
adw_dep = dependency('libadwaita-1')
#mango_dep = dependency('mangohud')

# Исходные файлы
sources = files('src/mangojuice.vala')

# Сборка приложения
executable('mangojuice',
  sources: sources,
  dependencies: [gtk_dep, glib_dep, adw_dep],
  install: true)