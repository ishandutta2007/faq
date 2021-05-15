#### bitbucket

##### API usage

Simple listing with curl

    bbHost='bitbucket.domain.com'
    bbUser='myUser'
    bbToken='SoMe123ToKeN'

    url="https://${bbHost}/rest/api/1.0/users/${bbUser}"
    #url="https://${bbHost}/rest/api/1.0/users/${bbUser}/repos"

    curl -H "Authorization: Bearer ${bbToken}" "${url}"

