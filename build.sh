#!/bin/sh
# foolscap-schedule
# to run
# bash README.md | pbcopy && bash README.md > test.md
# gem install liquid
# gem install liquid-cli

filename="schedule2017-preview"
file="${filename}.markdown"
json="${filename}.json"
out="build/${filename}.out.markdown"
error="build/${filename}.error"

mkdir -p build

#cat $file | liquid "$(< $json)"
cat $file | ruby run.rb "$(< $json)" > "${out}" 2> "${error}"
cat "${out}" | pbcopy
if [ "$?" -ne 0 ]; then
    echo "json error?"
    cat $json | json_pp -f json > "${error}" 2>&1
fi

