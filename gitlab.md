#### Gitlab

##### Create new project

Create from command line

    $ mkdir gitlab-project
    $ cd gitlab-project
    $ git init
    $ touch .gitignore README.md
    $ git add -A
    $ git commit -m 'Initial commit'
    
    # for Git over HTTPS
    $ git push --set-upstream https://gitlab.com/project/repo.git

    # update  .git/config for ssh access
    [remote "origin"]
            url = git@gitlab.com:project/repo.git
            fetch = +refs/heads/*:refs/remotes/origin/*
    [branch "master"]
            remote = git@gitlab.com:project/repo.git
            merge = refs/heads/master

NOTE: in case you ses smth like: 

    remote: HTTP Basic: Access denied. The provided password or token is incorrect or your account has 2FA enabled and you must use a personal access token instead of a password. See https://gitlab.com/help/topics/git/troubleshooting_git#error-on-git-fetch-http-basic-access-denied 

Login 1st with browser to enable access from your IP.
