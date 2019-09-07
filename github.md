#### Github

##### API usage

get emails from github users

     myUser='ariya'
     curl -s https://api.github.com/users/${myUser}/events/public | grep --no-group-separator -A1 email | sed 's/^\s\+//;s///' | tr -d '\n' | sed 's/"email": "/\n/g;s/"name"//g;s/[",]//g' | sort | uniq

##### Fixing errors

recreate repository without commits history

    git checkout --orphan latest_branch
    git add -A
    git commit -am "commit message"
    git branch -D master
    git branch -m master
    git push -f origin master
