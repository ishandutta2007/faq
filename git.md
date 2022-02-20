#### GIT

##### config file

    # content of ~/.gitconfig
    # This is Git's per-user configuration file.
    [user]
     name = 1stName 2ndName
     email = email@company.com    


##### handling binary files

    # config of ~/.gitattributes
    *.jpg binary
    *.png binary
    *.gif binary
    *.gz binary
    *.zip binary

##### oneliners

    # config
    git config -l --local                      # get local config
    git config -l --global                     # get global config
    git config user.name '1stName 2ndName'     # set name
    git config user.email 'email@company.com'  # set email

    # create repo from exising dir
    cd newrepo
    git init
    git add . 
    git commit -m 'new repo'

    # clone specyfic branch
    git clone --branch 9.9.7 ssh://git@git.domain.com/depo/prj.git

    # basic operations    
    git commit -m 'some comment' myFile   # commit my changes with comments
    git reset HEAD~1                      # cancel last commit
    git checkout -- myFile                # revert my changes made in file under git control called myFile
    git diff myFile                       # check changes made on git controlled file myFile
    git log origin/master..master         # check my commits that are not populated to main repo yet
    git push                              # populate your changes to the remote repo

    # working as non-default user
    ssh-agent bash -c "ssh-add ${rsaIdFile}             # set correct rsa id
    git ls-remote --heads ${repoUrl} | grep master"     # git works with repo for different user
    
    # working with branches
    git checkout -b newBranch                  # swit to new created newBranch
    git checkout master                        # switch back to master
    git checkout newBranch                     # switch back to new Branch
    git add newFile                            # add new file
    git commit -m "comment" newFile            # commit
    git push --set-upstream origin newBranch   # push
    #remote:
    #remote: Create pull request for etp:
    #remote:   https://git.test.com/projects/team/repos/project/compare/commits?sourceBranch=refs/heads/newBranch
    #remote:
    # go to link, create pull request manually
    git push --delete origin newBranch         # remove your branch on remote
    git checkout master                        # switch back to master
    git branch -d newBranch                    # remove your branch on local
    git branch -D newBranch                    # remove your branch on local
    git pull --rebase                          # updated to sync better with only your changes (when too many commits ahead)
    git branch -m new-name                     # change branch name
    
    # searching for deleted files
    git log --diff-filter=D --summary | grep delete

    # restoring deleted file
    git rev-list -n 1 HEAD -- <file_path>           # list last available commit with the file
    git checkout <deleting_commit>^ -- <file_path>  # checkout the version at the commit before
    git checkout $(git rev-list -n 1 HEAD -- "$file")^ -- "$file" # same as above in one command

    # restoring for simple cases
    git reset HEAD some/path
    git checkout -- some/path

    # restoring from master
    git checkout origin/master -- some/path
    
    # search all versions for a specyfic string
    git rev-list --all | xargs git grep test_str    # all versions
    
    # as the string change (add/remove) introduced
    git log --pickaxe-regex -S test_str -- path_containing_change
    git log -Stest_str -- path_containing_change
    git log -Stest_str --since=2009.1.1 --until=2010.1.1 -- path_containing_change
    
    # check difference between two releases
    git diff e35924b83dd8f3ff1676c6f44abe85ef6b2867bf -- host019.yaml
    git diff e35924b83dd8f3ff1676c6f44abe85ef6b2867bf HEAD host019.yaml
    git diff 86ffd0a11cd4992977ceaaeb8826cc0e74483e41 dee3f341d31adbb8706883dfa50580278a6d7ff1 host019.yaml

    # getting part of repo
    #!/bin/bash
    DIR="repo"
    REPO="ssh://git@git.domain.com/projectname/reponame.git"
    BRANCH="master"
    CHECKOUT_DIR="examples/example1/"
    mkdir -p ${DIR}
    if [ -d "${DIR}" ]; then
      cd ${DIR}
      git archive --format=tgz --remote=${REPO} ${BRANCH} -- ${CHECKOUT_DIR} | tar zxvf -
    fi

    # cheking out part of repo
    #!/bin/bash
    DIR="repo"
    REPO="ssh://git@git.domain.com/projectname/reponame.git"
    BRANCH="master"
    CHECKOUT_DIR="examples/"
    mkdir -p ${DIR}
    if [ -d "${DIR}" ]; then
      cd ${DIR}
      git init
      git remote add -f origin ${REPO}
      git config core.sparseCheckout true
      echo ${CHECKOUT_DIR} > .git/info/sparse-checkout
      git pull origin ${BRANCH}
    fi

    # fixing not-up-to-date master issues
    git checkout master
    git pull
    git checkout some/branch
    git merge master
    git push -u origin some/branch

    # merge branch with latest tag
    git checkout my-branch
    git merge $(git describe --tags $(git rev-list --tags --max-count=1))
    
##### working with many users

Config

    # content of ~/.ssh/config
    
    Host fake-A
      HostName git.company.com
      User git
      IdentityFile /home/someuser/.ssh/id_rsa.A
      IdentitiesOnly yes
    
    Host fake-B
      HostName git.company.com
      User git
      IdentityFile /home/someuser/.ssh/id_dsa.B
      IdentitiesOnly yes

Testing

    ssh -vT git@fake-A

Usage

    git remote add alice git@fake-A:repo.git
    git remote add bob git@fake-as-B:repo.git

##### customizing git diff

Use vimdiff as diff tool

    git config --global diff.tool vimdiff
    git config --global difftool.prompt false
    git config --global alias.d difftool
    git d someFile.with.changes.md

##### meaning of symobls ^ ~
    
Both ~ and ^ on their own refer to the parent of the commit (~~ and ^^ both refer to the grandparent commit, etc.)
But they differ in meaning when they are used with numbers:

 * ~2 means up two levels in the hierarchy, via the first parent if a commit has more than one parent
 * ^2 means the second parent where a commit has more than one parent (i.e. because it's a merge)

These can be combined, so HEAD~2^2 means HEAD's grandparent commit's 2nd parent commit
    

##### debug
    
    GIT_CURL_VERBOSE=1 \
    GIT_TRACE_SETUP=1 \
    GIT_TRACE=1 \
    git clone ...


##### git on windows

When using mobaxterm git clone is not wroking, use standard git/bash shortuc provided by git to run git and then it works

    export https_proxy=
    git clone https://github.com....
    git config --global core.eol=lf           # dealing with endOfLines
    git config --global core.autocrlf=input   # dealing with endOfLines
    

##### reports for git

Current month

    #repoRoot="~/git/current_code"
    #author='LastN, FirstN'
    
    reposRoot="$1"
    author="$2"
    
    for repoRoot in $(find ${reposRoot}  -mindepth 1 -maxdepth 1 -type d)
    do
     echo ""
     echo ".................... [${repoRoot}] ...................."
     cd ${repoRoot}
     git log --shortstat --date=short --format='NEW_LINE%ad#%s#%H'  --author="${author}" --after=$(date +'%Y.%m.01') --before=$(date --date='1 day' +'%Y.%m.%d') . | tr -d '\n' | sed 's/NEW_LINE/\n/g' | sort | column -t -s'#'
    done

Previous month

    reposRoot="$1"
    author="$2"
    
    for repoRoot in $(find ${reposRoot}  -mindepth 1 -maxdepth 1 -type d)
    do
     echo ""
     echo ".................... [${repoRoot}] ...................."
     cd ${repoRoot}
     git log --shortstat --date=short --format='NEW_LINE%ad#%s#%H'  --author="${author}" --after=$(date --date '1 month ago' +'%Y.%m.01') --before=$(date +'%Y.%m.01') . | tr -d '\n' | sed 's/NEW_LINE/\n/g' | sort | column -t -s'#'
    done

