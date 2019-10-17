#### RPM

##### onliners

    rpm -qis package-name                                       # info about package and files inside
    rpm -qa --last >~/RPMS_by_Install_Date                      # query package install order and dates
    rpm2cpio logrotate.rpm | cpio -ivd etc/logrotate.conf       # extract one file
    rpm -qd mypkg                                               # show you the documentation in rpm
    rpm -qdf /path/to/file                                      # show the documentation in the package, owner of that file
    rpm -qa release="*rf*"                                      # find packages from rpmforge (uses rf as identifier)
    rpm -qa packager="JohnStone*"                               # show packages built by JohnStone
    rpm -q --changelog <packagename> | less                     # changelog check
    rpm -q --changelog -p /tmp/pkgs/mypkg.rpm | less            # changelog check
    rpm -q --changelog -p http://host.com/mypkg.rpm | less      # changelog check
