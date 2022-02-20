#### jq

Changing json content

    echo '
    {
      "key1": {
        "key11": "value11",
        "key12": "value12"
      }
    }
    ' \
     | jq '.[] |= . + {"key13" : "value13","key14" : "value14"}' \
     | jq --arg prefix 'PREFIX_' 'with_entries(.key = $prefix + .key)'

    # result
    {
      "PREFIX_key1": {
        "key11": "value11",
        "key12": "value12",
        "key13": "value13",
        "key14": "value14"
      }
    }

Moving csv into json with jq

    # content of file.csv
    item,value
    x,0.2
    y,0.001

    # content of csv2json.jq
    [
      [                                               
        split("\n")[]                  # transform csv input into array
      | split(", ")                    # where first element has key names
      | select(length==2)              # and other elements have values
      ]                                
      | {h:.[0], v:.[1:][]}            # {h:[keys], v:[values]}
      | [.h, (.v|map(tonumber?//.))]   # [ [keys], [values] ]
      | [ transpose[]                  # [ [key,value], [key,value], ... ]
          | {key:.[0], value:.[1]}     # [ {"key":key, "value":value}, ... ]
        ]
      | from_entries                   # { key:value, key:value, ... }
    ]
    
    cat file.csv | jq -s -R -f csv2json.jq
    [
      {
        "item": "x",
        "value": 0.2
      },
      {
        "item": "y",
        "value": 0.001
      }
    ]

Formatting output:

     curl -v -k -s http://jenkins.company.com/job/myJob/lastBuild/api/json \
      | jq -r '(.actions[0].parameters[] | select(.name=="BRANCH").value) + " | " + (.number|tostring) + " | " + (.duration/1000/3600 | floor | tostring) + "h" + (.duration/1000%3600/60 | floor | tostring) + "m" + (.duration/1000%60 | tostring) + "s"  + " | " + .result + " |"')

     curl -s http://server.company.com/api/json/v0/test/12345/import_log \
      | jq -r '.payload .recorded_data[] | select(.value!=null) | .metric + " " +(.value *1000.0 + 0.5|floor/1000.0 |tostring)'

References:

 * https://stedolan.github.io/jq/manual/
 * https://earthly.dev/blog/jq-select/ 
