# foolscap-schedule

#gem install liquid-cli
filename="schedule2017-preview"
file="${filename}.markdown"
json="${filename}.json"



#cat $file | liquid "$(< $json)"
cat $file | ruby run.rb "$(< $json)"
if [ "$?" -ne 0 ]; then
    echo "json error?"
    cat $json | json_pp -f json
fi

