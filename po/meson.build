# Импорт модуля локализации
i18n = import('i18n')

# Указываем имя пакета для gettext
gettext_package = meson.project_name()

# Генерация файлов перевода
i18n.gettext(
    gettext_package,  # Имя пакета gettext (совпадает с именем проекта)
    args: '--directory=' + meson.project_source_root(),  # Указываем корневой каталог для поиска исходных файлов
    preset: 'glib'  # Используем настройки по умолчанию для проектов на GLib/Gtk
)