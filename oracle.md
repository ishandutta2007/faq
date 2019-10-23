#### Oracle

##### ASM

Identify disk size occupied by oracle ASM disks

    ls -1 /dev/oracleasm/disks/* \
     | xargs -I{} readlink -e {} \
     | xargs -I{} fdisk -l {} \
     | grep bytes \
     | grep Disk \
     | sed 's/,.*//' \
     | sort -k3 -n \
     | awk 'BEGIN {sum=0}; {sum=sum+$3;print$0} END {print "TOTAL disk space available[G]:",sum}'

Check asm disk occupancy

OS level (as oracle user)

     asmcmd lsdg
     State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
     MOUNTED  EXTERN  N         512   4096  4194304   8191864     9732                0            9732              0             N  DATA/
     MOUNTED  EXTERN  N         512   4096  4194304   3481464  3285224                0         3285224              0             N  FLASH/
     MOUNTED  EXTERN  N         512   4096  1048576    102399      924                0             924              0             N  GOLDENGATE/
     MOUNTED  NORMAL  N         512   4096  1048576     30714    29983            10238            9872              0             Y  GRID1/

DB level (when logged into DB)

     set linesize 200;
     set pagesize 100;
     set wrap off;
    
     select
      name,
      state,
      total_mb as t_mb,
      free_mb as f_mb,
      hot_used_mb as hu_mb,
      cold_used_mb as cu_mb,
      required_mirror_free_mb as rmf_mb,
      usable_file_mb as uf_mb
     from v$asm_diskgroup;
    
     NAME                           STATE             T_MB       F_MB      HU_MB      CU_MB     RMF_MB      UF_MB
     ------------------------------ ----------- ---------- ---------- ---------- ---------- ---------- ----------
     GRID1                          MOUNTED          30714      29983          0        731      10238       9872
     GOLDENGATE                     MOUNTED         102399        924          0     101475          0        924
     FLASH                          CONNECTED      3481464    3285080          0     196384          0    3285080
     DATA                           CONNECTED      8191864       9732          0    8182132          0       9732

This may not be seen with common disk usage utilities e.g.

    df -P
    Filesystem                                                     1024-blocks         Used   Available Capacity Mounted on
    /dev/mapper/VolGroup00-root                                       51475068      8186000    40667628      17% /
    tmpfs                                                             70207596      2022116    68185480       3% /dev/shm
    /dev/sda1                                                           528876       158336      342844      32% /boot
    /dev/mapper/VolGroup00-grid                                       65924860        53064    62516356       1% /grid
    /dev/mapper/VolGroup00-tmp                                        54376900     43434504     8173500      85% /tmp
    /dev/mapper/VolGroup00-u00                                        32896880       465936    30753224       2% /u00
    /dev/mapper/VolGroup00-u01                                        65924860     42402636    20166784      68% /u01

##### storage

Check what's available on the box:

    multipath -ll \
    | egrep 'dm-|size' \
    | sed 's/G / /;s/ features.*//;s/size=/size[G]: /' \
    | awk 'NR%2{printf "%s ",$0;next;}1' \
    | column -t \
    | sort -k6,1 -n \
    | awk 'BEGIN {sum=0}; {sum=sum+$6;print$0} END {print "TOTAL disk space available[G]:",sum}'

##### users and accounts

Unlock user and fix password expiration time

    -- PASSWORD_LIFE_TIME UNLIMITED      the number of days the same password can be used for authentication
    -- PASSWORD_REUSE_TIME UNLIMITED     the number of days before which a password cannot be reused
    -- PASSWORD_REUSE_MAX UNLIMITED      the number of password changes required before the current password can be reused
    -- PASSWORD_VERIFY_FUNCTION NULL     password complexity verification script be passed as an argument to the CREATE PROFILE statement
    -- PASSWORD_LOCK_TIME UNLIMITED      the number of days an account will be locked after the specified number of consecutive failed login attempts
    -- PASSWORD_GRACE_TIME UNLIMITED     the number of days after the grace period begins during which a warning is issued and login is allowed
    -- FAILED_LOGIN_ATTEMPTS UNLIMITED   the number of failed attempts to log in to the user account before the account is locked


    sqlplus / as sysdba;
    alter user zabbix account unlock;
    alter profile DEFAULT limit
     PASSWORD_REUSE_TIME unlimited
     PASSWORD_REUSE_MAX unlimited
     PASSWORD_LIFE_TIME unlimited
    ;
    select '[' || username || '] ['  || account_status || '] [' ||expiry_date || ']' from dba_users where lower(username)='user1';

Reset user to same or new password (e.g. fix EXPIRING(GRACE) status)

    set linesize 500
    
    -- same password
    select 'alter user ' || su.name || ' identified by values' || ' ''' || spare4 || ';'    || su.password || ''';' from sys.user$ su where  su.name='SOME_USER';
    
    -- new password
    alter user 'SOME_USER' identified by SOME_PASSWORD;
    
    -- check status
    select '[' || username || '] ['  || account_status || '] [' ||expiry_date || ']' from dba_users where lower(username) like '%trp%';

Get user data e.g. to recreate password

    set linesize 500
    set long 500
    select DBMS_METADATA.GET_DDL('USER','SOME_USER') from dual;

##### export/import

Usage of expdp

    myName='some_tables'
    expdp \"/ as sysdba\" \
     tables=TRP_PROPOSAL,TRP_PROPOSAL_HSTRY,TRP_PROPOSAL_SRCH \
     directory=DATA_PUMP_DIR \
     dumpfile=${myName}_tables.dmp \
     logfile=${myName}_tables.log

##### links

General good referenece with examples

 * http://psoug.org/reference/sys_context.html

