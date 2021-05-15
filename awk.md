#### AWK

Processing some files containing multiline xml-s inside

    cat some.data.with.xmls.log \
     | tr -d '\n' \
     | sed 's/Case1\/Case2 request: /\n/g;s/Type1RQ>/Type1RQ>\n/g' \
     | awk '(/Type1RQ/ && /Type>Case1</) {print > "case1.txt"} (/Type1RQ/ && /Type>Case2</) {print > "case2.txt"}'

Removing end-of-line example
Note: removes EOL from all lines except the ones where pattern '<\/ATQ>#&#' is seen

    input="$1"
    output="$2"
    
    if [[ -f "${input}" ]];then
     echo "processing [${input}] to ${output}"
     zcat ${input} \
     | awk '/<\/ATQ>#&#/ {print; next} {printf "%s ", $0}' \
     | sed 's/#&#$//;s/^.*#&#//;s/> *</></g' \
     | head -n 100000 \
     > ${output}
    else
     echo "missing input file [${input}]"
    fi

Calculating difference

    #!/bin/bash
    
    #compares two columns
    myFile=$1
    
    #calculate diff
    awk '
    {
     if ($1!=0){
      printf "|%.2f|%.2f|%.2f|\n",$1,$2,(($2-$1)/$1);
     }else{
      printf "|%.2f|%.2f|n/a|\n",$1,$2;
     }
    }' ${myFile}

