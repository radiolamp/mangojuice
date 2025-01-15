project(
    'mangojuice', 'vala',  # Имя проекта и язык (Vala)
    version: '0.8.0',      # Версия проекта
    default_options: [
        'warning_level=0',  # Отключение предупреждений компилятора
        'localedir=/usr/share/locale'  # Каталог для установки файлов локализации
    ]
)

# Импорт необходимых модулей
i18n = import('i18n')  # Модуль для локализации
gnome = import('gnome')  # Модуль для работы с GNOME

# Добавление аргументов компиляции
add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),  # Имя пакета для gettext
    language: 'c'
)

# Отключение предупреждений (если необходимо)
add_project_arguments(
    '-Wno-discarded-qualifiers',  # Игнорировать предупреждения о потере квалификаторов
    language: 'c'
)

# Подключение подкаталогов
subdir('data')  # Каталог для ресурсов (например, .gresource.xml)
subdir('src')   # Каталог с исходным кодом
subdir('po')    # Каталог для локализации (файлы .po, .pot)
