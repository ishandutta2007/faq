#### CentOS

##### Packaging

Get content of remote repo locally

    yum install yum-utils createrepo                            # install utils
    yum repolist                                                # check current repos
    yum repolist -v
    yum repolist enabled
    yum repolist disabled
    
    rpm -Uvh http://repo.domain.com/mypkg-1.0-1.el7.noarch.rpm  # add remote repo
    yum repoinfo mypkg
    
    yum install --downloadonly --downloaddir=//tmp/mypkg mypkg  # get files locally
    yum-config-manager --disable mypkg                          # remove remote repo


##### create local repos

For RPM packages set locally.

With RPM based approach developer can incrementally solve dependencies, and rpm will suggest what the next needed package must provide, and one can build up a 'just enough' solution: 

    rpm -Uvh mypgk.arch.rpm
    rpm -Uvh mypkg1.arch.rpm mypkg2.arch.rpm 

YUM can resolve dependencies and automatically satisfy them from available repositories. 

    yum --nogpgcheck localinstall mypgk.arch.rpm 


##### create local repos and share over NAS

The following procedure will explain how to set up an NFS share containing a repository of locally built/rebuilt/downloaded packages and access them in a uniform manner from other systems of the same distro version. One can follow a similar procedure to enable local mirrors of os, updates, etc. avoiding downloading from external mirror servers, and controlling availability of updates to local machines until they have been tested. 

    yum install createrepo

    mkdir -p /share/CentOS/6/local/i386/RPMS
    rpmbuild --rebuild /path/to/srpm/mypkg.src.rpm
    # this creates
    #/home/builduser/rpmbuild/RPMS/mypkg.rpm
    #/home/builduser/rpmbuild/RPMS/mypkg-devel.rpm
    #/home/builduser/rpmbuild/RPMS/mypkg-docs.rpm

    # move the files to the repo and create metadata: 
    mv /home/builduser/rpmbuild/RPMS/mypkg* /share/CentOS/6/local/i386/RPMS
    chown -R root.root /share/CentOS/6/local
    createrepo /share/CentOS/6/local/i386
    chmod -R o-w+r /share/CentOS/6/local
    # create /etc/yum.repos.d/local.repo 
      [local]
      name=CentOS-$releasever - local packages for $basearch
      baseurl=file:///share/CentOS/$releasever/local/$basearch
      enabled=1
      gpgcheck=0
      protect=1
    yum install mypkg mypkg-devel mypkg-docs
    # share via NAS
    echo "/share 192.168.1.0/24(ro,async)' >>/etc/exports
    exportfs -r
    # on client side
    scp server1:/etc/yum.repos.d/local.repo /etc/yum.repos.d/
    ln -s /net/server1/share /share
    ls /share/CentOS/4/local
    yum install mypkg mypkg-devel mypkg-docs

##### networking

Disable firewall on CentOS

    systemctl disable firewalld
    systemctl stop firewalld
    systemctl status firewalld

