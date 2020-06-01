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

