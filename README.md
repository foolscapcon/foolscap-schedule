[![Build Status](https://travis-ci.org/foolscapcon/foolscap-schedule.svg?branch=master)](https://travis-ci.org/foolscapcon/foolscap-schedule)
# foolscap-schedule
# to run
# bash README.md | pbcopy && bash README.md > test.md
# gem install liquid
# gem install liquid-cli

filename="schedule2017-preview"
file="${filename}.markdown"
json="${filename}.json"



#cat $file | liquid "$(< $json)"
cat $file | ruby run.rb "$(< $json)"
if [ "$?" -ne 0 ]; then
    echo "json error?"
    cat $json | json_pp -f json
fi

