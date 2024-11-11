#!/bin/bash
# Should run from project root dir

touch ./po/unsort-POTFILES.in

# find ./data/ui -iname "*.blp" -type f -exec grep -lrE '_\(|C_|ngettext' {} + | while read file; do echo "${file#./}" >> ./po/unsort-POTFILES.in; done
find ./src -iname "*.vala" -type f -exec grep -lrE '_\(|C_|ngettext' {} + | while read file; do echo "${file#./}" >> ./po/unsort-POTFILES.in; done
find ./data/ -iname "*.desktop.in.in" | while read file; do echo "${file#./}" >> ./po/unsort-POTFILES.in; done
find ./data/ -iname "*.metainfo.xml.in.in" | while read file; do echo "${file#./}" >> ./po/unsort-POTFILES.in; done

cat ./po/unsort-POTFILES.in | sort | uniq > ./po/POTFILES.in

rm ./po/unsort-POTFILES.in
