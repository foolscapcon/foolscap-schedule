#!/bin/sh
# foolscap-schedule
# to run
# bash README.md | pbcopy && bash README.md > test.md
# gem install liquid
# gem install liquid-cli

template="schedule-template.md.liquid"
file="${template}"



mkdir -p build

#cat $file | liquid "$(< $json)"
for datafile in *.json; do
    filename="${datafile%%.*}"
    json="${filename}.json"
    out="build/${filename}.out.markdown"
    error="build/${filename}.error"    
    echo "build ${file} with ${datafile} to ${out}"
    cat $file | ruby run.rb "$(< $json)" > "${out}" 2> "${error}"
    if [ "$?" -ne 0 ]; then
        echo "json error ${json}?" >> "${error}"
        cat $json | json_pp -f json >> "${error}" 2>&1
    fi
done

cat "${out}" | pbcopy        
echo "build complete and copied to pasteboard [$out] $(date)"
