#### Gitlab

##### Create new project

Create from script

    myPrj='X'
    myRepo='Y'
    
    # create dir
    mkdir ${myRepo}
    cd ${myRepo}
    git init
    
    # update config
    cat <<EOF>./.git/config
    [core]
       repositoryformatversion = 0
       filemode = false
       bare = false
       logallrefupdates = true
       ignorecase = true
    [branch "main"]
       remote = origin
       merge = refs/heads/main
    [user]
       name = ${myRepo}
       email = ${myRepo}@deepinspace.com
    [branch "master"]
       remote = origin
       merge = refs/heads/master
    EOF
    
    touch .gitignore
    git add -A
    git commit -m 'Initial commit'
    
    # push
    git push --set-upstream https://gitlab.com/${myPrj}/${myRepo}.git
    # remote:
    # remote:
    # remote: The private project go-for/mountebank was successfully created.
    # remote:
    # remote: To configure the remote, run:
    # remote:   git remote add origin https://gitlab.com/X/Y.git
    # remote:
    # remote: To view the project, visit:
    # remote:   https://gitlab.com/X/Y
    # remote:
    # remote:
    # remote:
    # To https://gitlab.com/X/Y.git
    #  * [new branch]      master -> master
    # Branch 'master' set up to track remote branch 'master' from 'https://gitlab.com/X/Y.git'.
    
    # change to ssh
    cat <<EOF>>./.git/config
    [remote "origin"]
       url = git@gitlab.com:${myPrj}/${myRepo}.git
       fetch = +refs/heads/*:refs/remotes/origin/*
    EOF
    sed -i 's/remote =.*/remote = origin/' ./.git/config
    
    touch README.md
    git add README.md
    git commit -m 'added README.md' README.md
    git push


NOTE: in case you ses smth like: 

    remote: HTTP Basic: Access denied. The provided password or token is incorrect or your account has 2FA enabled and you must use a personal access token instead of a password. See https://gitlab.com/help/topics/git/troubleshooting_git#error-on-git-fetch-http-basic-access-denied 

Login 1st with browser to enable access from your IP.
