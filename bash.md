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

##### running multiple processes

Handling two processes in a nice way:

    prog1 & prog2 && fg

This will:

 * start prog1.
 * send it to background, but keep printing its output.
 * start prog2, and keep it in foreground, so you can close it with ctrl-c.
 * when you close prog2, you'll return to prog1's foreground, so you can also close it with ctrl-c.

The above is the same as 

    prog1 & prog2

There are more possible combinations like e.g.

    prog1 & prog2 & prog 3

