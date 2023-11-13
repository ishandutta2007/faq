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

##### installing game from CD

    > dosbox
    DOSBOX: mount c ~/dos
    DOSBOX: mount d /media/user/gamecd -t cdrom
    DOSBOX: d:
    DOSOBX: SETUP.EXE
    # note you can also copy data from cdrom and mount it like
    # mount d ~/games/cdcontent -t cdrom

##### using autoexec

    cd ~/.dosbox
    vi dosbox-*.conf
    # edit [autoexec] section, example below
    mount C ~/dos
    mount D ~/games/mygame -t cdrom
    #mount -u D:
    C:
    cd installedGame
    RUN.exe

