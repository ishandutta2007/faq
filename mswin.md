#### MSwin

##### networking

Workstation details

    NET CONFIG WORKSTATION

User details

    NET USER username /DOMAIN | FIND /I " name "

How many users are logged on/connected to a server?

    NET SESSION | FIND /C "\\"

    PSEXEC \\servername NET SESSION | FIND /C "\\"

Who is logged on to a computer?

    NBTSTAT -a remotecomputer | FIND "<03>" | FIND /I /V "remotecomputer"
    WMIC /Node:remotecomputer ComputerSystem Get UserName
    PSLOGGEDON -L \\remotecomputer
    PSEXEC \\remotecomputer NET CONFIG WORKSTATION | FIND /I "User " 

Password reset

    NET USER loginname newpassword /DOMAIN

Acount unlock

    NET USER loginname /DOMAIN /ACTIVE:YES

Make sure a local user's password will not expire

    WMIC.EXE /Node:remotecomputer Path Win32_UserAccount Where Name="user" Set PasswordExpires="FALSE"

Make sure a local user's password will expire

    WMIC.EXE /Node:remotecomputer Path Win32_UserAccount Where Name="user" Set PasswordExpires="TRUE"

List all domains and workgroups in the network

    NET VIEW /DOMAIN

List computers

    NET VIEW
    FOR /F "skip=3 delims=\	 " %%A IN ('NET VIEW') DO ECHO.%%A

List updates

    WMIC QFE List

List domain controllers

    nslookup -type=any %userdnsdomain%

List variables

    set

List DC in domain

    nltest /dclist:domain


##### working with disks

DiskPart (disk administration, partition a disk, valid for 7/8/2008/2012 R2 version)

Syntax: `DISKPART`

Commands you can issue at the DISKPART prompt:

 - `ACTIVE` : Set the current in-focus partition to be the system partition.
 - `ADD` : Add a mirror to a simple mirror

       ADD disk=n [align=n] [wait] [noerr]

 - `ASSIGN` : Assign a drive letter or mount point to the volume with focus.
   If no arguments given, the next available drive letter is assigned.

       ASSIGN [{LETTER=D  | mount=path}] [noerr]

 - `ATTACH` : Mount a virtual hard disk (VHD) so that it appears on the host computer as a local hard disk drive. 

       ATTACH vdisk [readonly] { [sd=SDDL] | [usefilesd] } [noerr]

 - `ATTRIBUTES` : Display, set, or clear the attributes of a disk or volume

       ATTRIBUTES DISK [{set | clear}] [readonly] [noerr]

 - `ATTRIBUTES VOLUME` : [{set | clear}] [{hidden | readonly | nodefaultdriveletter | shadowcopy}] [noerr]
 - `AUTOMOUNT` : Enable or disable the automount feature:

       AUTOMOUNT [enable] [disable] [scrub] [noerr]

 - `BREAK` :  Break a mirror set

       BREAK disk=n [nokeep] [noerr]

 - `CLEAN` :  Remove any and all partition or volume formatting from the disk with focus, 'all' will Zero the disk.

       CLEAN [all]

 - `COMPACT VDISC` :  Reduce the physical size of a dynamically expanding virtual hard disk (VHD) file.
 - `CONVERT` : Convert a disk from one disk type to another

       CONVERT basic [noerr]
       CONVERT dynamic [noerr]
       CONVERT gpt [noerr]
       CONVERT mbr [noerr]

 - `CREATE` : Create a volume, partition or virtual disk

       CREATE partition efi [size=n] [offset=n] [noerr]
       CREATE partition extended [size=n] [offset=n] [align=n] [noerr]
       CREATE partition logical [size=n] [offset=n] [align=n] [noerr]
       CREATE partition msr [size=n] [offset=n] [noerr]
       CREATE partition primary [size=n] [offset=n] [id={ byte | guid }] [align=n] [noerr]

 - `CREATE` : volume raid [size=n] disk=n,n,n[,n,...] [align=n] [noerr]

       CREATE volume simple [size=n] [disk=n] [align=n] [noerr]
       CREATE volume stripe [size=n] disk=n,n[,n,...] [align=n] [noerr]
       CREATE volume mirror [size=n] disk=n,n[,n,...] [align=n] [noerr]

 - `CREATE` : vdisk file=filepath {[type={fixed|expandable}] | [parent=filepath] | [source=filepath]}

              [maximum=n] [sd=SDDL] [noerr]

 - `DELETE` : Delete a partition, volume or a dynamic disk from the list of disks:

       DELETE disk [noerr] [override]
       DELETE partition [noerr] [override]
       DELETE volume [noerr]

 - `DETACH` : Stop the selected VHD from appearing as a local hard disk drive (Win7/2008 R2 only).

       DETACH vdisk [noerr]

 - `DETAIL` : Provide details about an object

       DETAIL Disk
       DETAIL Partition
       DETAIL volume

 - `EXIT` : Exit DISKPART
 - `EXPAND` : Expand the max size (in MB) available on a virtual disk (Win7/2008 R2 only).

       EXPAND vdisk maximum=n

 - `EXTEND` : Extend a volume or partition with focus and its file system into free (unallocated) space on a disk.

       EXTEND [size=n] [disk=n] [noerr]
       EXTEND filesystem [noerr]

 - `FILESYSTEMS` : Display current and supported file systems on the volume (Use 'Select Volume' first)

 - `FORMAT` : Format the system or pertition:

       FORMAT [{fs=<ntfs|fat|fat32>] [revision=x.xx] | recommended}] [label=label]
              [unit=n] [quick] [compress] [override] [duplicate] [nowait] [noerr]

 - `GPT` : Assign attributes to the selected GUID partition table (GPT) partition:

       GPT attributes=n

 - `HELP` : [command]
 - `IMPORT` : Import a foreign disk group into the disk group of the local computer:

       IMPORT [noerr]

 - `INACTIVE` : Mark a system/boot partition as inactive [don’t boot], (use 'Select Partition' first)
 - `LIST` : Display a list of objects:

        LIST Disk
        LIST Partition
        LIST Volume
        LIST vdisk  (Windows 7/Server 2008 R2 only)

 - `MERGE` : Merge a child disk with its parents. depth=1 will merge with parent. (Windows 7/Server 2008 R2 only)

       MERGE vdisk depth=n

 - `OFFLINE` : Take an online disk or volume to the offline state, use 'Select Disk' first)

        OFFLINE disk [noerr]
        OFFLINE volume [noerr]

 - `ONLINE` : Take an offline disk or volume to the online state.

        ONLINE disk [noerr]
        ONLINE volume [noerr]

 - `RECOVER` : Refresh the state of all disks in a disk group,
    attempt to recover disks in an invalid disk group, and resynchronize mirrored volumes and RAID-5 volumes that have stale data.
 - `REM` : (remark/comment)
 - `REMOVE` : Remove a drive letter or mount point from a volume

        REMOVE letter=E [dismount] [noerr]  (Remove drive letter E from the in-focus partition)
        REMOVE mount=path [dismount] [noerr]  (Remove mount point from the in-focus partition)
        REMOVE all [dismount] [noerr]       (Remove ALL current drive letters and mount points)

 - `REPAIR` : Repair a RAID-5 volume with a failed member by replacing with a specified dynamic disk

        REPAIR disk=n [align=kb] [noerr]   (align = KB from disk beginning to the closest alignment boundary.)

 - `RESCAN` : Locate new disks and volumes that have been added to the computer.
 - `RETAIN` : Prepare an existing dynamic simple volume to be used as a boot or system volume.
 - `SAN` :    Display or set the SAN policy for the currently booted OS.

        SAN [policy={OnlineAll | OfflineAll | OfflineShared}] [noerr]

 - `SELECT` : Shift the focus to an object

        SELECT Disk={ n | diskpath | system | next }
        SELECT Partition={ n | d }   (Volume number or Drive letter)
        SELECT Volume={ n | d } [noerr] (Volume number or Drive Letter)
        SELECT vdisk file=fullpath [noerr]

 - `SETID` :  Change the partition type for the partition with focus (for OEM use)

        SET ID={ byte | GUID } [override] [noerr]

 - `SHRINK` : Reduce the size of the selected volume

        SHRINK [desired=n] [minimum=n] [nowait] [noerr]  (Reduce the size of the in-focus volume)

 - `SHRINK` : querymax [noerr]
 - `UNIQUEID` : Display or set the GUID partition table identifier or MBR signature for
   the (basic or dynamic) disk with focus

        UNIQUEID disk [id={dword | GUID}] [noerr]

Commands to Manage Basic Disks:

    ASSIGN MOUNT=path  (Choose a mount point path for the volume)
    CREATE PARTITION Primary Size=50000  (50 GB)
    CREATE PARTITION Extended Size=25000
    CREATE PARTITION logical Size=25000
    DELETE Partition
    EXTEND Size=10000
    GPT attributes=n   (assign GUID Partition Table attributes)
    SET id=byte|GUID [override] [noerr]   (Change the partition type)

Commands to Manage Dynamic Disks:

    ADD disk=n   (Add a mirror to the in-focus SIMPLE volume on the specified disk see 'Diskpart Help' for more.)
    BREAK disk=n  (Break the current in-focus mirror)
    CREATE VOLUME Simple Size=n Disk=n
    CREATE VOLUME Stripe Size=n Disk=n,n,...
    CREATE VOLUME Raid Size=n Disk=n,n,...
    DELETE DISK
    DELETE PARTITION
    DELETE VOLUME
    EXTEND Disk=n [Size=n]
    EXTEND Filesystem [noerr]
    IMPORT [noerr]   (Import a foreign disk group, use 'Select disk' first)
    RECOVER [noerr]  (Refresh disk pack state, attempt recovery on an invalid pack, & resynchronize stale plex/parity data.)
    REPAIR disk=n [align=n] [noerr]  (Repair the RAID-5 volume with focus, replace with the specified dynamic disk)
    RETAIN   (Prepare an existing dynamic simple volume to be used as a boot or system volume)

When setting up a new drive, create in this order:
 - Create Partition
 - Format drive
 - Assign drive letter

The diskpart commands can be placed in a text file (one command per line) and used as an input file to diskpart.exe:

    DiskPart.exe < myscript.txt

When selecting a volume or partition, you can use either the number or drive letter or the mount point path.

The Windows GUI interface can also be used to assign a mount-point folder path to a drive.
In Disk Manager, right-click the partition or volume, and click Change Drive Letter and Paths
Then click Add and then type the path to an empty folder on an NTFS volume.

The Windows Recovery Console, includes a simplified DISKPART command. It only provides functionality for adding and deleting partitions, but not for setting an active partition.
Always back up the hard disk before running diskpart. Examples:

    SELECT DISK=0
    CREATE PARTITION PRIMARY
    SELECT PARTITION=1
    FORMAT FS=NTFS LABEL="New Volume" QUICK
    ASSIGN LETTER=E
    EXIT 

The default SAN policy in Windows Server 2008 / R2 is now VDS_SP_OFFLINE_SHARED for all non boot SAN disks.
This means that the disks will be offline at server startup (even if the drive contains a paging file).
This Disk Management error message indicates that the drive is offline:
	"the disk is offline because of policy set by an administrator".
Query the current SAN policy to see if it is Offline Shared

    DISKPART.EXE 
    DISKPART> san 
    SAN Policy : Offline Shared

To manually bring the disks online: 
Computer Management > Storage > Disk Management, right-click the disk and choose Online.
If these are not part of a cluster, than an alternative is to make a SAN policy change, select the offline disk, clear its readonly flag and bring it online:

    DISKPART> san policy=OnlineAll 
    DiskPart successfully changed the SAN policy for the current operating system. 
    
    DISKPART> LIST DISK 
    Disk ### Status        Size    Free    Dyn Gpt
    -------- ------------- ------- ------- --- ---
    Disk 0   Online         80 GB     0 B
    * Disk 1 Offline        20 GB  1024 KB 
    
    DISKPART> select disk 1 
    Disk 1 is now the selected disk. 
    
    DISKPART> ATTRIBUTES DISK CLEAR READONLY
    DISKPART> ONLINE DISK
    DiskPart successfully onlined the selected disk.

based on [article](https://ss64.com/nt/diskpart.html)
