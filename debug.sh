#!/bin/sh
# foolscap-schedule
# to run
# bash README.md | pbcopy && bash README.md > test.md
# gem install liquid
# gem install liquid-cli

template_name="schedule-template"
template_ext=".md.liquid"

bundle install --with development


build_dir=${1:-"."}
if [ ! -d "$build_dir" ]; then
    mkdir -p "$build_dir"
fi

echo "build_dir is '$build_dir'"
#cat $file | liquid "$(< $json)"
for datafile in *.json; do
    year="${datafile//[!0-9]/}"
    echo $year
    # check to see if there is a specialized template for the year '-NNNN'
    file="${template_name}-${year}${template_ext}"
    if [ -f "${template_name}-${year}${template_ext}" ]; then
        echo "custom ${year} template"
    else
        file="${template_name}${template_ext}"
    fi

    filename="${datafile%%.*}"
    json="${filename}.json"
    out="$build_dir/${filename}.html"
    error="$build_dir/${filename}.error"
    echo "build ${file} with ${datafile} to ${out}"
    rescue run.rb "$file" "$json" "${out}" 2> "${error}"
    if [ "$?" -ne 0 ]; then
        echo "json error ${json}?" >> "${error}"
        cat $json | json_pp -f json >> "${error}" 2>&1
    fi
done

#cat "${out}" | pbcopy
echo "build complete $(wc ${build_dir}/*.html ${build_dir}/*.error)"
#and copied to pasteboard [$out] $(date)"
