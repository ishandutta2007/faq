#### Linux

##### basic environment

Making files writeable to group (assuming current umask value is default 0022) e.g.

    echo 'umask 0002' >>  ~/.profile
    echo 'umask 0002' >>  ~/.bash_profile
    touch abc.txt; ls -al abc.txt
    # -rw-rw-r--  1 user group   9921 Jul 23  2014 abc.txt

Checking system limits for application user

    ssh user@box "echo \$USER; ulimit -a"
         
List all cron jobs from the box

    sudo less /etc/cron.*/*
    for user in $(cut -f1 -d: /etc/passwd); do output=`sudo crontab -u $user -l 2>/dev/null`; test $? -eq 0 && echo -e "\ncrontab for [${user}]\n\n$output" ; done

Good history tracking

    # in ~/.profile
    
    ##history per box
    #mkdir -p ${HOME}/.hist_per_box
    #export HISTFILE="${HOME}/.hist_per_box/bash_history.`hostname`"
    
    ##history shared
    HISTFILE="${HOME}/.bash_history"
    HISTTIMEFORMAT="[%Y.%m.%d-%T] "
    HISTSIZE=1000000

Implementing extended history (multiple boxes & NAS home)

    #========== /etc/prompt.bash START ==========
    #echo [$HOSTNAME][$USER][$PWD][$(date +'%F %T')] : $(fc -nlr | /bin/sed '1q;d') >> $HOME/.exteneded_history.log
    #echo [$HOSTNAME][$USER][$PWD][$(date +'%F %T')] : $(fc -nlr | /bin/sed '1q') >> $HOME/.exteneded_history.log
    echo [$HOSTNAME][$USER][$PWD][$(date +'%F %T')] : $(fc -nlr | head -n1) >> $HOME/.exteneded_history.log
    #
    #========== /etc/prompt.bash END ==========
    
    PROMPT_COMMAND="/etc/prompt.bash"

General accounting setup

    # RHEL
    yum install -y psacct; chkconfig psacct on; /etc/init.d/psacct start;  /etc/init.d/psacct status
    # CENTOS
    yum install -y psacct; chkconfig psacct on; systemctl enable psacct; systemctl start psacct; systemctl status psacct 
    
    # last commands by user
    lastcomm user
    # last commands by command
    lastcomm command
    
    # processes by time
    sa -m
    # processes by number
    sa -m
    # processes by user
    sa -u
    
    # print connect time stats by user and day
    ac -d -p
    # print stats about general CPU usage by command
    sa -c -d
    # print stats about general CPU usage by user
    sa -m -c

Updating user when need to change uid or guid
    
    olduid=51234
    oldgid=54321
    myusr=testusr
    mygrp=${myusr}
    newuid=50101
    newgid=${newuid}
    sed -i "s/${myusr}:x:${oldgid}/${myusr}:x:${newgid}/" /etc/group
    usermod -u ${newuid} ${myusr}
    usermod -g ${newgid} ${mygrp}
    userDirs="/apps/coolapp/inst1/ /logs/coolapp/"
    chown -R ${myusr} ${userDirs}
    chgrp -R ${mygrp} ${userDirs}

Patching

    # patching single file
    diff originalfile updatedfile > patchfile.patch
    patch originalfile -i patchfile.patch -o updatedfile
    
    diff -c originalfile updatedfile
    patch -i patchfile.patch -o updatedfile
    
    # patching multiple files
    diff -c originaldirectory/ updateddirectory/ > patchfile.patch
    patch -p0 -i patchfile.patch
    
    # revert patching
    patch -p0 -R -i patchfile.patch


##### X & xterm look & feel

List available colors:

    showrgb

List available fonts:

    fc-list | sort  -t ':' -k2 | column -ts':'

Set it

    xterm -vb -bg 'light gray'  -fs 12 -fa 'Utopia'


XFCE basic setup for VNC access

    #!/bin/sh
    # content of ~/.vnc/xstartup
    
    # Uncomment the following two lines for normal desktop:
    # unset SESSION_MANAGER
    # exec /etc/X11/xinit/xinitrc
    
    [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
    [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
    xsetroot -solid grey
    vncconfig -iconic &
    #xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" -bg white &
    xterm \
     -vb \
     -bg "gray" \
     -geometry "80x24+0+0" \
     -fn "-*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1" \
     -title "$VNCDESKTOP Desktop" &
    
    #openbox &
    xfwm4 &
    #xfdesktop &
    xfce4-panel &
    #xfce4-terminal &


##### networking

SSH connection timeout

    # server side: /etc/ssh/sshd_config
    # VPN disconnecting fix
    
    # don't send keep alives
    TCPKeepAlive no
    # send info to clinet exch 30 sec
    ClientAliveInterval 30
    # disconnect if no 120x30 sec response back => 1h
    ClientAliveCountMax 120
    Fixing issues with automount fs
    
    umount -l -f /some_share # old mount point
    service autofs restart
    ls /some_share


##### memory

Checking available memory:

    free
    #             total       used       free     shared    buffers     cached
    #Mem:      24314812   18079460    6235352     232708     361924    4341988
    #-/+ buffers/cache:   13375548   10939264
    #Swap:      2113528     544460    1569068

Clearing buffers & cache

    # to free pagecache only
    echo 1 > /proc/sys/vm/drop_caches
    # to free dentries and inodes only:
    echo 2 > /proc/sys/vm/drop_caches
    # to free pagecache, dentries and inodes:
    echo 3 > /proc/sys/vm/drop_caches
    
    free && sync && echo 3 > /proc/sys/vm/drop_caches && free

Checking what's in buffers and cache

    fincore --pages=false --summarize --only-cached

Disabling/enabling swap

    swapoff -a
    swapon -a


##### working with MS win

List shares

    smbclient -L 10.164.254.64 -U 'DOMAIN\USER

List remote content

    smbclient '//10.164.254.64/shared' -U 'DOMAIN\USER' -c ls

Mount shares (windows setup should be correct for this)

 - MSwin

    - general: no read-only set
    - sharing: advanced shareing: permissions: r/w for everyone group
    - security: permissions for user should have r/w options

 - Linux

       # make sure that dir is 0711 via chmod
       winIp=`finger | grep username | grep '10\.' | sed 's/.* //; s/[)(]//g' | head -1`
       sudo umount ~/win
       sudo mount.cifs "//${winIp}/shared" ~/win -v -o domain=DOMAIN.AD.COMPANY.COM,username=USER,rw,uid=${userId},gid=${groupId},vers=2.1

Identify win machine by IP

    nbtscan 10.123.123.123
    Doing NBT name scan for addresses from 10.123.123.123
    
    IP address       NetBIOS Name     Server    User             MAC address
    ------------------------------------------------------------------------------
    10.123.123.123   H1231231231231   <server>  <unknown>        00-01-12-12-12-12


##### os management

Checking for release notes for currently used kernel

    sudo rpm -q --changelog kernel-`uname -r` | grep futex | grep ref

Installing new OS on the fly

    #!/bin/bash
    `_DISK_FOR_FSTAB=$(df / | awk 'NR==2{print$1}')
    cd /
     
    # Stop all services
    for s in udev dbus rsyslog whoopsie acpid cron atd nginx php5-fpm php7-fpm xinetd redis-server sd-agent log-courier nginx-config-reloader postfix hypernode-kamikaze mysql blackfire-agent ncr fail2ban ntp newrelic-daemon hhvm php7.0-fpm; 
    do service $s stop || true; done
     
    # Kill any active processes that might get in our way
    pkill sleep
    pkill chronic
    pkill dpkg
    pkill apt-get
     
    # Ensure debootstrap is installed
    apt-get -y update &amp;&amp; apt-get -yq install debootstrap
     
    # Unmount all (special) filesystems
    for x in /sys/fs/fuse/connections /sys/kernel/debug /sys/kernel/security /run/lock /run/shm /data /mnt; 
    do umount $x || true; done
     
    # Remount root as read/write. Required on latest DigitalOcean precise images
    mount -o rw,remount /
     
    # Create the in memory target
    mkdir /tmproot
    mount -t tmpfs none /tmproot  # Mount tmproot in RAM
    mkdir /tmproot/{proc,sys,dev,run,usr,var,tmp,oldroot,bin}
     
    # Hack debootstrap to work for Xenial on our older (our) precise images
    ln -s gutsy /usr/share/debootstrap/scripts/xenial || true
     
    # Install Xenial in memory
    debootstrap --arch amd64 --no-check-gpg --variant=minbase --include=debootstrap xenial /tmproot http://ubuntu.example.com
     
    # Apparently, we only need network, hostname, ssh keys to identify the host
    mkdir -p /tmproot/old-etc
    cp /etc/hostname /tmproot/old-etc
    cp -a /etc/network/interfaces* /tmproot/old-etc
    cp -a /root/.ssh /tmproot/root
    cp /etc/ssh/ssh_*key* /tmproot/old-etc
     
    # Switch to running Linux in RAM
    echo "Pivoting root to /tmp/oldroot"
    pivot_root /tmproot /tmproot/oldroot
    for i in dev proc sys run; do mount --move /oldroot/$i /$i; done
    echo "Removing old root dirs"
    for i in bin debian-binary etc initrd.img lib64 media opt root sbin srv dev proc run sys tmp usr vmlinuz boot home lib mnt selinux var debootstrap lost+found initrd.img.old vmlinuz.old;
    do rm -rf /oldroot/$i; done
     
    # Should have cleared everything except /data.image and special fs
    echo "Writing nameservers to /run/resolvconf"
    mkdir -p /run/resolvconf
    echo -e "nameserver 8.8.8.8\\nnameserver 8.8.4.4" &gt; /run/resolvconf/resolv.conf
    cd /
    echo "Installing the new, clean system"
    debootstrap --arch amd64 --no-check-gpg --variant=minbase --include=python-minimal,openssh-server,grub-legacy-ec2,libpython2.7-stdlib,sudo,ifupdown,resolvconf,iproute2,rsyslog,acpid,grub2-common,grub-pc-bin,isc-dhcp-client xenial /oldroot http://ubuntu.example.com/
     
    # Restore network settings
    cp -a /old-etc/interfaces* /oldroot/etc/network
    cp /old-etc/hostname /oldroot/etc/hostname
    cp -a /old-etc/ssh_*key* /oldroot/etc/ssh/
     
    # Ensure uninterrupted root ssh logins
    mkdir -p /oldroot/root/.ssh
    chmod 700 /oldroot/root/.ssh
    cat &gt; /oldroot/root/.ssh/authorized_keys &lt; /tmp/repo.key &lt; /etc/resolv.conf
    export DEBIAN_FRONTEND=noninteractive
    export LC_ALL=C
    echo "root:some_hash" | chpasswd
    echo "Installing screen for reboot and lsb_release for grub distribution config"
    apt-get -y install screen python3 lsb-release
     
    # Amazon EC2 specific code
    if test -e /dev/xvda; then
        echo "Running AWS specific code"
        cat &gt; /etc/fstab &lt; /etc/default/grub &lt; /dev/null || echo Debian`
    GRUB_CMDLINE_LINUX_DEFAULT="console=tty1 console=ttyS0 net.ifnames=0 biosdevname=0"
    GRUB_CMDLINE_LINUX=""
    GRUB_TERMINAL=console
    GRUB_HIDDEN_TIMEOUT=0.1
    GRUB_RECORDFAIL_TIMEOUT=0
    EOM
        apt-get -y install linux-virtual
        grub-install /dev/xvda
    fi
     
    # DigitalOcean specific config
    if test -e /data.image; then
        echo "Running Digital Ocean specific code"
        cat &gt; /etc/fstab &lt; /etc/default/grub &lt;&lt; 'EOM' GRUB_DEFAULT=0 GRUB_HIDDEN_TIMEOUT_QUIET=true GRUB_TIMEOUT=1 GRUB_DISTRIBUTOR=`lsb_release -i -s 2&gt; /dev/null || echo Debian`
    GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0"
    GRUB_CMDLINE_LINUX=""
    EOM
        apt-get -y install linux-virtual
    fi
     
    update-grub
    sync
     
    # Reboot doesn't work, as systemd is not yet running. So we hit the sysrq trigger:
    screen -d -m sh -c 'sleep 1; echo 1 &gt; /proc/sys/kernel/sysrq'
    screen -d -m sh -c 'sleep 2; echo b &gt; /proc/sysrq-trigger'

based on [article](https://www.byte.nl/blog/dont-run-this-on-any-system-you-expect-to-be-up-they-said-but-we-did-it-anyway)


##### debug

Strace - trace a process/program for an event examples and write data to file

    strace -e trace=option1,option2 -p PID  -o /tmp/strace.PID.debug.txt

Some common examples:

 - `-e trace=network`
 - `-e trace=signal` 
 - `-e trace=ipc`
 - `-e trace=desc`     # file descriptor related system calls
 - `-e trace=memory`   # memory mapping related system calls

Other goodies:

 -  for timing use -T option
 -  for timestamping each line use -t option
 -  get process summary status
 -  strace -c -p PID





