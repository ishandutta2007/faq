#### wget

##### examples

script to get specyfic extension files

    myUrl=$1
    myExt=$2
    #./getExtFromUrl.bash 'http://some.url.com' 'png'
    
    wget \
     --recursive \
     --level=1 \
     --tries=1 \
     --no-directories \
     --timestamping \
     --no-parent \
     --accept ".${myExt}" \
     --execute robots=off \
     --wait=10 \
     ${myUrl}

