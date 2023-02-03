#### bitbucket

##### API usage

Simple listing with curl

    bbHost='bitbucket.domain.com'
    bbUser='myUser'
    bbToken='SoMe123ToKeN'

    url="https://${bbHost}/rest/api/1.0/users/${bbUser}"
    #url="https://${bbHost}/rest/api/1.0/users/${bbUser}/repos"

    curl -H "Authorization: Bearer ${bbToken}" "${url}"

Search example

    query="project:bbProject repo:bbRepo lang:java someClassName"
    curl \
      --silent \
      --user ${bbUser}:${bbPass} \
      --header 'Content-Type: application/json' \
      -X POST "https://${bbHost}/rest/search/latest/search" \
      --data '{"query":"'"${query}"'","entities":{"code":{}},"limits":{"primary":3,"secondary":3}}' 
