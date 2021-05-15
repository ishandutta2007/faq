#### bash

##### finding proc by script name


script ./testX.bash

    #!/bin/bash

    countProc=$(pstree -pal -N user | grep testX | grep -v grep | wc -l)
    #countProc=$(pgrep autoscaler --count)
    echo $countProc
    sleep 1000

execution

    ./testX.bash
    2
    
    bash ./testX.bash
    2

If the subshell contains a pipeline then we get the forked copy of the script waiting for the pipeline to finish
Without hashbang finding the proc by script name may not be possible

##### subshells and pipelines

Example of forking shell for pipielines

    $ echo $$ $BASHPID | cat -
    11656 31528
    $ echo $$ $BASHPID
    11656 11656
    $ echo $$ | while read line; do echo $line $$ $BASHPID; done
    11656 11656 31497
    $ while read line; do echo $line $$ $BASHPID; done <<< $$
    11656 11656 11656
