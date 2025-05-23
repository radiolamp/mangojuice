#!/bin/bash
# Should run from project root dir

touch ./po/unsort-POTFILES

find ./src -iname "*.vala" -type f -exec grep -lrE '_\(|C_|ngettext' {} + | while read file; do echo "${file#./}" >> ./po/unsort-POTFILES; done
find ./data/ -iname "*.desktop" | while read file; do echo "${file#./}" >> ./po/unsort-POTFILES; done
find ./data/ -iname "*.metainfo.xml" | while read file; do echo "${file#./}" >> ./po/unsort-POTFILES; done

cat ./po/unsort-POTFILES | sort | uniq > ./po/POTFILES

rm ./po/unsort-POTFILES

# To add translation, please use Damned Lies service https://l10n.gnome.org/
