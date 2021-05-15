#### adb

Useful oneliners

    # version
    adb version

    # start server
    adb start-server
    
    # kill server
    adb kill-server
    
    # list devices
    adb devices -l

    # get status
    adb get-state
    
    # get serial
    adb get-serialno
    
    # open shell
    adb shell 
    
    # push to system app folder
    adb push example.apk /system/app.
    
    # push to user app folder
    adb push example.apk /data/app.
    
    # pull android apk from device to local folder.
    adb pull /system/app/example.apk /user/app_bak
    
    # install apk
    adb install /tmp/example.apk
    
    # list packages
    adb shell pm list packages -f -3 
    
    # uninstall app
    adb shell uninstall com.app.name
    
    # uninstall app for user, but keep it's data
    adb shell pm uninstall -k --user 0 com.app.name

    # reinstall app
    adb shell cmd package install-existing com.android.fmradio

    # reinstall app
    adp shell pm dump com.android.fmradio | grep path
    adp shell pm install -r --user 0 /system/priv-app/FMRadio/FMRadio.apk

    # block app
    adp shell pm clear com.package.name
    adp shell pm hide com.package.name
    
    # block app
    adp shell pm block com.package.name
    
    # start app
    adb shell am start -n com.package.name/com.package.name.ActivityName
    
    # start app with function
    adb shell am start -a com.example.ACTION_NAME -n com.package.name/com.package.name.ActivityName
    
    # connect via wifi (10-)
    adb tcpip 5555
    # disconnect the USB cable from the target device, check its IP
    adb connect 192.168.1.123
    
    # connect via wifi (11+)
    # on your phone
    #  enable developer options.
    #  enable the wireless debugging option.
    #  on the dialog that asks "Allow wireless debugging on this network?" click Allow.
    #  select "Pair device with pairing code", note down the pairing code, IP address, and port number displayed
    adb pair ipaddr:port
    
    # set port forwarding
    adb forward tcp:6100 tcp:7100

    # get screenshot
    adb shell screencap /sdcard/screen.png

    # record video
    adb shell screenrecord /sdcard/demo.mp4

    # get sys info
    adb shell dumpsys
    adb shell dumpsys window
    adb shell dumpsys power

    # get sys property values
    adb shell getprop ro.sf.lcd_density
    
    # access window manager
    adb shell wm size

    # backup device
    adb backup -all

    # restore device
    adb restore "path/to/backup.adb"

    # reboot in recovery mody
    adb reboot-recovery

    # reboot in bootloader mode
    adb reboot-bootloader

    # reboot in fastbot mode
    adb reboot fastboot

    # list fastboot devices
    fastboot devices

Links:
 * https://developer.android.com/studio/command-line/adb
