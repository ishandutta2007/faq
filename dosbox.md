#### Dosbox

##### running on Linux

    # check midi port
    > pmidi -l
    Port   Client name      Port name
    14:0   Midi Through     Midi Through Port-0

    # update config with correct midi port
    > cat ~/.dosbox/dosbox-*.conf | grep 'midiconfig=' 
    ...
    midiconfig=14:0
    ...

    # setup directory for hosting dosbox data
    > mkdir ~/dos

    # run dosbox and mount dos directory
    > dosbox
    DOSBOX: mount c ~/dos 
