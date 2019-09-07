#### Github

##### API usage

get emails from github users

     myUser='ariya'
     curl -s https://api.github.com/users/${myUser}/events/public | grep --no-group-separator -A1 email | sed 's/^\s\+//;s///' | tr -d '\n' | sed 's/"email": "/\n/g;s/"name"//g;s/[",]//g' | sort | uniq
