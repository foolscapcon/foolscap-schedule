#!/bin/bash
this=$( cd $(dirname ${BASH_SOURCE[0]}); pwd -P )
build_dir="$this/build"
source_dir="$this"
echo watch $source_dir
files=$(find $source_dir -maxdepth 1 -name \*.md -or -name \*.markdown -or -name \*.json -or -name \*.liquid -or -name \*.sh -or -name \*.rb  )
echo "files ${files}"
bash $source_dir/build.sh build | tee $build_dir/ci.log
fswatch --print0 -otvx --batch-marker $files  $source_dir/build.sh --exclude \.#.* | xargs -0 -n 1 -I {} bash $source_dir/build.sh | tee $build_dir/ci.log

