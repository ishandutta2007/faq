#### MQ

##### tools

Tools to work with MQ

 - mq explorer(open source) available from [here](http://www.capitalware.com/dl/java/mqjexplorer.zip)
   To connect specify host and port e.g. mqbox(9999) and MQ mgr, eg. MQMGR
 - runmqsc command line tool provided by WS MQ
 - MQSeriesExplorer gui tool provided by WS MQ 

##### setup
        
Basic setup validation

 - /opt/mqm/bin/mqconfig

       mqconfig: Analyzing Red Hat Enterprise Linux Server release 6.9 (Santiago)
                 settings for WebSphere MQ V7.5
       
       System V Semaphores
         semmsl     (sem:1)  500 semaphores                     IBM>=500          PASS
         semmns     (sem:2)  106 of 256000 semaphores   (0%)    IBM>=256000       PASS
         semopm     (sem:3)  250 operations                     IBM>=250          PASS
         semmni     (sem:4)  27 of 2048 sets            (1%)    IBM>=1024         PASS
       
       System V Shared Memory
         shmmax              68719476736 bytes                  IBM>=268435456    PASS
         shmmni              403 of 4096 sets           (9%)    IBM>=4096         PASS
         shmall              535634 of 4294967296 pages (0%)    IBM>=2097152      PASS
       
       System Settings
         file-max            8976 of 6550713 files      (0%)    IBM>=524288       PASS
         tcp_keepalive_time  300 seconds                        IBM<=300          PASS
       
       Current User Limits (mqm)
         nofile       (-Hn)  30000 files                        IBM>=10240        PASS
         nofile       (-Sn)  30000 files                        IBM>=10240        PASS
         nproc        (-Hu)  unlimited processes                IBM>=4096         PASS
         nproc        (-Su)  unlimited processes                IBM>=4096         PASS
        

To cleanup of old no longer needed files implement in cron:

    find /var/mqm/errors -name "AMQ*.FDC" -mtime +60 -exec rm -f "{}" \;
    rm -f /var/mqm/trace/AMQ*TR* /var/mqm/trace/AMQ*.FMT

based on http://www-01.ibm.com/support/docview.wss?uid=swg21670876 and https://www.ibm.com/support/pages/cleaning-ibm-mq-files

##### working with queues and managers


    export MQ_MGR='MYMQMGR'
    export MQ_PRT='9999'
    export MQ_CHA='TEST.CHANNEL'
    export MQ_QUE='TEST.QUEUE'
    export MQ_ERR='AMQ7316'
    export MQ_MSG='sample message'
     
    ###########################
    # general/box
    ###########################
     
    #check what listener processes are running on MQ server host
    ps -ef | grep runmqlsr
     
    #show MQ mgr version
    dspmqver
    
    #validate MQ configuration as mqm user
    mqconfig
    
    #check status for all MQ mgrs running on the box
    dspmq
     
    #list MQ mgrs with issues on host01 host02
    for box in host01 host02; do ssh $box "echo '';hostname -s; dspmq | grep -v 'Running'"; done
     
     
    ###########################
    # creation & startup
    ###########################
     
    #create MQ mgr for testing
    crtmqm "${MQ_MGR}"
     
    #start MQ mgr
    strmqm "${MQ_MGR}"
     
    #create MQ mgr listener that will start/stop with it
    echo "define listener('LISTEN_${MQ_PRT}') trptype(tcp) port(${MQ_PRT}) control(qmgr)" | runmqsc ${MQ_MGR}
     
    #start MQ mgr listener manually
    runmqlsr -m ${MQ_MGR} -t tcp -p ${MQ_PRT}
     
    #start MQ mgr listener manually if previously defined
    echo "start listener('LISTEN_${MQ_PRT}')" | runmqsc ${MQ_MGR}
     
    #create channel
    echo "define channel('${MQ_CHA}') chltype(SVRCONN)" | runmqsc ${MQ_MGR}
     
    #start channel
    echo "start channel('${MQ_CHA}')" | runmqsc ${MQ_MGR}
     
    #create queue
    echo "define qlocal('${MQ_QUE}') descr ('test queue')" | runmqsc ${MQ_MGR}
     
     
    ###########################
    # display commands
    ###########################
     
    #show MQ mgr details
    echo "display qmgr" | runmqsc ${MQ_MGR}
     
    #show MQ mgr status (if running, when started, how many connections, paths)
    echo "display qmstatus all" | runmqsc ${MQ_MGR}
     
    #show MQ mgr listener
    echo "display lsstatus (*) all" | runmqsc ${MQ_MGR}
     
    #list channels
    echo "display channel (*) type" | runmqsc ${MQ_MGR}
     
    #list queues
    echo "display queue(*) type" | runmqsc ${MQ_MGR}
     
    #show queue depth
    echo "display queue('${MQ_QUE}') curdepth" | runmqsc ${MQ_MGR} | grep 'CURDEPTH' | grep -v 'DISPLAY'
     
    #list all connections to MQ server: shows IPs and application names connected per channel and queues(OBJNAME)
    echo "display conn (*) where (conname nl '') type (all)" \
     | runmqsc ${MQ_MGR} \
     | grep -e APPLTAG -e CHANNEL -e CONNAME -e UOWSTDA -e OBJNAME -e OBJTYPE \
     | sed s'/APPLTAG/\nAPPLTAG/'
     
    #list statistics
    echo 'DISPLAY QMGR STATQ STATINT MONQ' | runmqsc ${MQ_MGR}
    amqsmon -m ${MQ_MGR} -t statistics -a
    amqsmon -m ${MQ_MGR} -t statistics -q ${MQ_QUE}
    amqsmon -m ${MQ_MGR} -t statistics -s '2005-04-30 15.30.00'
    amqsmon -m ${MQ_MGR} -t accounting -s '2005-04-30' -e '2005-04-30'
     
    ###########################
    # errors
    ###########################
     
    #check for errors:
    cat /var/mqm/qmgrs/${MQ_MGR}/errors/*  | grep AMQ  | sort | uniq -c
     
    #check what does the error code mean
    mqrc ${MQ_ERR}
     
     
    ###########################
    # dev tools
    ###########################
     
    #write messages to queue
    echo "{MQ_MSG}" | /opt/mqm/samp/bin/amqsput  '${MQ_QUE}' '${MQ_MGR}'
     
    #list existing messages in the queue
    /opt/mqm/samp/bin/amqsbcg '${MQ_QUE}' '${MQ_MGR}'
     
    #read messages from queue (analogue of tail -f on txt file)
    /opt/mqm/samp/bin/amqsget '${MQ_QUE}' '${MQ_MGR}'
     
     
    ###########################
    # backups
    ###########################
     
    #dump current configuration (make backup)
    dmpmqcfg -m ${MQ_MGR} | tee /opt/backup/mq/mq-cfg/${MQ_MGR}.mq.cfg
     
     
    ###########################
    # stoping & cleanup
    ###########################
     
    #clear queue
    # you can't do this when:
    #  there are uncommitted messages
    #  there is a queue opened with OPEN API.
    echo "clear qlocal ('${MQ_QUE}')" | runmqsc ${MQ_MGR}
     
    #delete queue
    echo "delete qlocal ('${MQ_QUE}')" | runmqsc ${MQ_MGR}
     
    #stop channel
    echo "start channel('${MQ_CHA}')" | runmqsc ${MQ_MGR}
     
    #delete channel
    echo "delete channel('${MQ_CHA}')" | runmqsc ${MQ_MGR}
     
    #stop MQ mgr listener
    #endmqlsr -m ${MQ_MGR}
    echo "stop listener('LISTEN_${MQ_PRT}')" | runmqsc ${MQ_MGR}
     
    #delete MQ mgr listener
    echo "delete listener('LISTEN_${MQ_PRT}') " | runmqsc ${MQ_MGR}
     
    #stop MQ mgr (wait for completion)
    endmqm -w "${MQ_MGR}"
     
    #stop MQ mgr (immediately)
    endmqm -i "${MQ_MGR}"
     
    #delete MQ after testing
    dltmqm "${MQ_MGR}"
     
     
    ###########################
    # extras/tracing
    ###########################
     
    #note: tracnig may create GBs of data quickly
    #      don't forget to stop it, 
     
    #start tracing
    strmqtrc -t all -t detail -m ${MQ_MGR}
     
    #stop tracing
    endmqtrc -a
     
    #check trace files
    cd /var/mqm/trace; dspmqtrc *.TRC
     
    #trace for cases where errors are seen before MQ mgr started
    strmqtrc -e
    endmqtrc -e
    
    ###########################
    # security
    ###########################
    
    #show prvileges
    dspmqaut -m ${MQ_MGR} -t qmgr -p ${MQ_USR}
    dspmqaut -m ${MQ_MGR} -t qmgr -g ${MQ_GRP}
    
    #set MQ mgr user privileges
    #TOCHEK# setmqaut -m ${MQ_MGR} -t qmgr -p ${MQ_USR} REPLACE_PLUS_OR_MINUS_PRIVILEGE
    
    #set MQ mgr group privileges 
    #TOCHECK# setmqaut -m ${MQ_MGR} -t qmgr -g ${MQ_GRP} REPLACE_PLUS_OR_MINUS_PRIVILEGE
    
    #disable authentication for channels
    echo "alter qmgr chlauth(disabled)" | runmqsc ${MQ_MGR}
    
    
Sample of procedure for MQ mgr removal
    
    stop mqmgr
    mqMgr='MQMGRNAME'
    mqPort='12345'
    
    endmqcsv ${mqMgr}
    endmqlsr -m ${mqMgr}
    endmqm -i ${mqMgr}
    # if endmqm -i hangs, use -p = preemptive (last resort!) 
    #endmqm -p ${mqMgr}
    # if you have to use -p option, cleanup shared resources before starting queue manager: 
    #/opt/mqm/bin/amqiclen -ivx -m ${mqMgr}
    
    # delete MQ mgr
    endmqm ${mqMgr}
    
    # remove what last
    cd /var/mqm
    find . -type d | grep ${mqMgr}
    ./qmgrs/${mqMgr}
    ./log/${mqMgr}
    ./sockets/${mqMgr}
    rm -rf /var/mqm/*/${mqMgr}
    
    # remove manually entries for deleted MQ mgr
    vim /var/mqm/mqs.ini
    
Sample of procedure to re-create MQ mgr from backup

    mqMgr='MQMGRNAME'
    mqPort='12345'
    
    dmpmqcfg -m ${mqMgr} > /opt/backup/mq/dmpmqcfg/${mqMgr}_BKP
    crtmqm -u SYSTEM.DEAD.LETTER.QUEUE ${mqMgr}
    strmqm ${mqMgr}
    runmqsc ${mqMgr} < /opt/backup/mq/dmpmqcfg/${mqMgr}_BKP
    strmqcsv ${mqMgr} 
    runmqlsr -m ${mqMgr} -t TCP -p ${mqPort} 
    
Sample of procedure to create MQ mgr manually

    mqMgr='MQMGRNAME'
    mqPort='12345'
    
    crtmqm -lc -lf 16384 -lp 2 -ls 2 ${mqMgr}
    
    mkdir -p /var/mqm/qmgrs/${mqMgr}
    cp /opt/backup/mq/mq-ini/$(hostname -s)/${mqMgr}/qm.ini /var/mqm/qmgrs/${mqMgr}/qm.ini
    export MIRRORQ_LOG_CONFIG=/var/mqm/log/mirrorq.config
    /opt/mqm/bin/amqiclen -m ${mqMgr} -x
    strmqm ${mqMgr}
    strmqcsv ${mqMgr}
    runmqlsr -m ${mqMgr} -t tcp -p ${mqPort}
    
    cat /opt/backup/mq/mq-cfg/${mqMgr}.config | runmqsc ${mqMgr}
    

##### security

Security issues with connection from mqjexplorer like

    MQJExplorer
    Copyright 2001,2002 Neil Kolban, All Rights Reserved.
    New Queue Manager selection!
    Path: [IBM MQSeries, Queue Managers]
    New Queue Manager selection!
    Path: [IBM MQSeries, Queue Managers, MYMQMGR on host02.domain.com(9999)]
    Security exit invoked: reason: MQXR_INIT
    Security exit invoked: reason: MQXR_INIT_SEC
    connectSelected: com.ibm.mq.MQException: Completion Code 2, Reason 2063
    Path: [IBM MQSeries, Queue Managers, MYMQMGR on host02.domain.com(9999)]
    Security exit invoked: reason: MQXR_TERM
    New Queue Manager selection!
    Path: [IBM MQSeries, Queue Managers, MYMQMGR on host01.domain.com(9999)]
    Security exit invoked: reason: MQXR_INIT
    Security exit invoked: reason: MQXR_INIT_SEC
    ** Refreshing all queues --
    ** Refreshing all channels --
    ** Refreshing all Namelists --
    ** Refreshing all processes --
    ** Refreshing queue manager --
    Path: [IBM MQSeries, Queue Managers, MYMQMGR on host01.domain.com(9999)]
    New Queue Manager selection!


##### other hints

Clear-up space taken by messages on queue:


    1. get all messages from queue
    mqQueue=QUEUE.NAME
    mqMgr=MQMGRNAME
    
    ./amqsget0 "${mqQueue}" "${mqMgr}" 2>/dev/null 1>/dev/null &
    
    2. check if there are any left
    echo "DIS Q(${mqQueue}) CURDEPTH" | runmqsc ${mqMgr}
    5724-H72 (C) Copyright IBM Corp. 1994, 2011.  ALL RIGHTS RESERVED.
    Starting MQSC for queue manager MYMQMGR.
    
    
         1 : DIS Q(OUTGOING.RO.FLIGHT12) CURDEPTH
    AMQ8409: Display Queue details.
       QUEUE(QUEUE.NAME)             TYPE(QLOCAL)
       CURDEPTH(0)
    One MQSC command read.
    No commands have a syntax error.
    All valid MQSC commands were processed.
    
    3. check how many space is taken by queue
    ls -al /var/mqm/qmgrs/${mqMgr}/queues/ | grep ${mqQueue}
    -rw-rw----  1 mqm mqm 10006964224 Nov  9 04:55 QUEUE!NAME
    
    4. clear queue
    echo "CLEAR QLOCAL(${mqQueue})" | runmqsc ${mqMgr}
    
    5. check space again
    ls -al /var/mqm/qmgrs/${mqMgr}/queues/ | grep ${mqQueue}
    -rw-rw----  1 mqm mqm   1712 Nov  9 05:00 QUEUE!NAME
        

Sample of communication

    SRC
    MSG TYPE
    MSG CONTENT
    DST
    mq srv
    MQ/ASYNC_MESSAGE
    
    app
    app
    MQ/MQPUT
    
    mq srv
    mq srv
    MQ/MQPUT_REPLY
    
    app


Checking logs

 * 1st, you need to stop your MQ mgr, otherwise you will see

       AMQ7701: DMPMQLOG command is starting.
       AMQ7005: The queue manager is running.
       AMQ7716: DMPMQLOG command has finished unsuccessfully.

 * when stopped:

       dmpmqlog -m QMGRNAME


 * more details [here](http://www.mqseries.net/phpBB2/viewtopic.php?t=23863)


Sample of error debug 

 * get error log

       find /var/mqm/errors -name "AMQ*.FDC" -ctime -1 -exec egrep --with-filename " Comment1          :- '27 - File too large'|QueueManager      :" "{}" \;   | grep QueueManager | sed 's/.*://' | sort | uniq -c
       1440 - ESECMGR02
 
 * from a sample of your FDC files you can see e.g.

       | LVLS              :- 7.5.0.3                                                |
       | Probe Id          :- XY324103                                               |
       | Component         :- xstGetSubpoolsLock                                     |
       | Probe Description :- AMQ6119: An internal WebSphere MQ error has occurred   |
       |   ('27 - File too large' from semop.)                                       |

 * try search on web for similar issues (site:www-01.ibm.com)


##### client libraries

For version 8 and 9 you will need:

 - com.ibm.mq.allclient.jar

For version 7.5.x you will need:

 - com.ibm.mq.headers.jar
 - com.ibm.mq.jar
 - com.ibm.mq.jmqi.jar
 - com.ibm.mqjms.jar
 - dhbcore.jar
 - jms.jar


##### known issues

No access after upgrade (more details [here](https://developer.ibm.com/answers/questions/193536/why-am-i-unable-to-connect-to-mq-after-upgrading-t/)

 - MQ 8.0+ : CONNAUTH added, use runmqsc to make following changes

       ALTER QMGR CONNAUTH(' ')
       REFRESH SECURITY TYPE(CONNAUTH)

 - MQ 7.1+ : CHLAUTH added, use runmqsc to make following changes

       ALTER QMGR CHLAUTH(DISABLED)

##### other resources

Perl:

 - https://metacpan.org/pod/MQSeries

       yum install perl-CPAN
       cpan MQSeries

Python:

 - https://github.com/dsuch/pymqi

       yum install python-pip
       pip install pymqi

   Sample usage:

       import pymqi
       
       mqmgr = ''
       mqchannel = 'CHANNEL.TEST.A'
       mqtransport = 'TCP'
       mqconnection = 'mq75.domain.com(7777)'
       #mqcipher = 'TLS_RSA_WITH_AES_256_CBC_SHA'
       #mqkey = '/var/mqm/ssl-db/client/KeyringClient'
       
       # simple connection
       #qmgr = pymqi.connect(mqmgr, mqchannel, mqconnection)
       
       # conenction with options
       cd = pymqi.CD()
       cd.ChannelName = mqchannel
       cd.ConnectionName = mqconnection
       cd.TransportType = pymqi.CMQC.MQXPT_TCP
       cd.ChannelType = pymqi.CMQC.MQCHT_CLNTCONN
       #cd.SSLCipherSpec = mqcipher
       
       sco = pymqi.SCO()
       #sco.KeyRepository = mqkey
       
       qmgr = pymqi.QueueManager(None)
       qmgr.connect_with_options(mqmgr, cd, sco)
       print "connected to [" + mqchannel +"/"+ mqtransport +"/"+ mqconnection + "]"
       
       attr = pymqi.CMQC.MQCA_Q_MGR_NAME
       attrvalue = qmgr.inquire(attr)
       print "value of MQCA_Q_MGR_NAME is [" + attrvalue.replace(' ','') + "]"
       
       attr = pymqi.CMQC.MQIA_ACCOUNTING_INTERVAL
       attrvalue = qmgr.inquire(attr)
       print "value of MQIA_ACCOUNTING_INTERVAL is [" + str(attrvalue) + "]"
      

PHP:

 - https://www.php.net/manual/en/book.mqseries.php, https://pecl.php.net/package/mqseries
   Notes: does not support security (mqcsp)

       rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
       yum install php56w-devel
       wget http://pear.php.net/go-pear.phar
       php go-pear.phar
       pecl install mqseries

   Sample usage

       <?php
       
           /* USER_AUTHENTICATION_MQCSP and similar support -> mqcsp not supported in this php library */
       
           $mqmanager  = '';
           $mqchannel = 'CHANNEL.TEST.A';
           $mqtransport = 'TCP';
           $mqtransport_code = MQSERIES_MQXPT_TCP;
           $mqconnection = 'mq75.domain.com(7777)';
       
           /* section for connx
           */
           $mqcno = array(
               'Version' => MQSERIES_MQCNO_VERSION_2,
               'Options' => MQSERIES_MQCNO_STANDARD_BINDING,
               'MQCD' => array('ChannelName' => $mqchannel,
                               'ConnectionName' => $mqconnection,
                               'TransportType' => $mqtransport_code
                               )
           );
           mqseries_connx($mqmanager, $mqcno, $conn, $comp_code, $reason);
       
           putenv("MQSERVER=" + $mqchannel + "/" + $mqtransport + "/" + $mqconnection);

           /* section for simple conn

           mqseries_conn($mqmanager, $conn, $comp_code, $reason);

           */
           if ($comp_code !== MQSERIES_MQCC_OK) {
               printf("conn CompCode:%d Reason:%d Text:%s<br>\n", $comp_code, $reason, mqseries_strerror($reason));
               exit;
           }
           printf ("Connected to MQ [%s]\n", getenv("MQSERVER"));
       
       
           $mqods = array('ObjectType' => MQSERIES_MQOT_Q_MGR);
           $mqopt = MQSERIES_MQOO_INQUIRE;
           mqseries_open($conn, $mqods, $mqopt, $obj, $comp_code, $comp_code);
           if ($comp_code !== MQSERIES_MQCC_OK) {
               printf("open CompCode:%d Reason:%d Text:%s<br>\n", $comp_code, $reason, mqseries_strerror($reason));
               exit;
           }
           printf ("MQ mgr opened for inquiring\n");
       
       
           $int_query = array(MQSERIES_MQIA_ACCOUNTING_INTERVAL);
           $int_query_size = sizeof($int_query);
           $int_attr = array();
           $int_attr_size = $int_query_size;
           $char_attr = null;
           $char_attr_size = 0;
           mqseries_inq($conn, $obj, $int_query_size, $int_query, $int_attr_size, $int_attr, $char_attr_size, $char_attr, $comp_code, $reason);
           if ($comp_code !== MQSERIES_MQCC_OK) {
               printf("INQ CompCode:%d Reason:%d Text:%s<br>\n", $comp_code, $reason, mqseries_strerror($reason));
               exit;
           }
           printf ("Value for MQIA_ACCOUNTING_INTERVAL is [%d]\n",$int_attr[0]);
       
       
           $int_query = array(MQSERIES_MQCA_Q_MGR_NAME);
           $int_query_size = sizeof($int_query);
           $int_attr = null;
           $int_attr_size = 0;
           $char_attr = "";
           $char_attr_size = 48;
           mqseries_inq($conn, $obj, $int_query_size, $int_query, $int_attr_size, $int_attr, $char_attr_size, $char_attr, $comp_code, $reason);
           if ($comp_code !== MQSERIES_MQCC_OK) {
               printf("INQ CompCode:%d Reason:%d Text:%s<br>\n", $comp_code, $reason, mqseries_strerror($reason));
               exit;
           }
           $char_attr = preg_replace('[ ]', '', $char_attr);
           printf ("Value for MQCA_Q_MGR_NAME is [%s]\n",$char_attr);
       
       
       ?>

C:

 - sample applications are ususally provided with MQ distribuition, under /opt/mq/samp

   Way to compile scripts from /opt/mqm/samp


       // As example let's change buffer size from MQBYTE   buffer[65536]  to MQBYTE   buffer[1048576] to accomodate bigger messages
       // Current location:  host01.domain.com :/opt/mqm/samp.username/username
   
       gcc  -o amqsget0   -I/opt/mqm/inc  -Wl,-rpath=/opt/mqm/lib  -lmqm_r   amqsget0.c
       gcc  -o amqsget0c  -I/opt/mqm/inc  -Wl,-rpath=/opt/mqm/lib  -lmqic_r  amqsget0.c
       
       # man gcc & man ld
       
       # -o file
       #  Place output in file file
       
       # -I dir
       #  Add the directory dir to the list of directories to be searched for header files
       
       # -Wl,-rpath
       #  Pass option -rpath as an option to the linker
       #  -rpath=dir
       #   Add a directory to the runtime library search path
       
       # -l library
       #  Search the library named library when linking

   Sample patch

       88c88,89
       <    MQBYTE   buffer[65536];          /* message buffer                */
       ---
       >    /* increasing buffer */
       >    MQBYTE   buffer[1048576];        /* message buffer                */
       186c187,189
       <    gmo.WaitInterval = 15000;          /* 15 second limit for waiting */
       ---
       >    /* icreasing time limit */
       >    /*gmo.WaitInterval = 15000;          15 second limit for waiting */
       >    gmo.WaitInterval = 900000;          /* 15 minutes limit for waiting */

   Sample patching

       patch amqsget0.c -i amqsget0.c.patch -o amqsget0.c.updated
       mv amqsget0.c amqsget0.c.old
       mv amqsget0.c.updated amqsget0.c

   Sample code usage:

       //export MQSERVER='CHANNEL.TEST.A/TCP/mq75.domain.com(7777)
       #include <stdio.h>
       #include <stdlib.h>
       #include <string.h>
       #include <cmqc.h>
      
       int main(int argc, char **argv)
       {
      
        /*   Declare MQI structures needed                                        */
         MQOD     od = {MQOD_DEFAULT};           /* Object Descriptor             */
         MQCNO   cno = {MQCNO_DEFAULT};          /* connection options            */
         MQCSP   csp = {MQCSP_DEFAULT};          /* security parameters           */
      
        /*   Declare MQI structures needed                                        */
         MQHCONN  Hcon;                          /* connection handle             */
         MQLONG   O_options;                     /* MQOPEN options                */
         MQLONG   C_options;                     /* MQCLOSE options               */
         MQLONG   CompCode;                      /* completion code               */
         MQLONG   OpenCode;                      /* MQOPEN completion code        */
         MQLONG   Reason;                        /* reason code                   */
         MQLONG   CReason;                       /* reason code for MQCONNX       */
         MQLONG   ExpiryInterval;                /* Expiry Interval value         */
         MQCHAR   QMName[MQ_Q_MGR_NAME_LENGTH];  /* queue manager name            */
         MQHOBJ   Hobj;                          /* object handle, server queue   */
         MQLONG   Select[1];                     /* integer attribute selectors   */
         MQLONG   IAV[1];                        /* integer attribute values      */
         MQLONG   Selector;                      /* single attribute selector     */
      
      
         printf("[start]\n");
      
         /****************************************************************/
         /* Set the connection options to use the security structure and */
         /* set version information to ensure the structure is processed.*/
         /****************************************************************/
         cno.SecurityParmsPtr = &csp;
         //cno.Version = MQCNO_VERSION_5;
         csp.AuthenticationType = MQCSP_AUTH_NONE;
      
      
         /******************************************************************/
         /*                                                                */
         /*   Connect to queue manager                                     */
         /*                                                                */
         /******************************************************************/
         MQCONNX(QMName,                 /* queue manager                  */
                &cno,                    /* connection options             */
                &Hcon,                   /* connection handle              */
                &CompCode,               /* completion code                */
                &CReason);               /* reason code                    */
      
         /* report reason and stop if it failed     */
         if (CompCode == MQCC_FAILED) {
           printf("MQCONNX ended with reason code %d\n", CReason);
           exit( (int)CReason );
         }
      
         /* if there was a warning report the cause and continue */
         if (CompCode == MQCC_WARNING)
         {
           printf("MQCONNX generated a warning with reason code %d\n", CReason);
           printf("Continuing...\n");
         }
      
         printf("\n_MQCONNX ok_\n");
      
      
         /******************************************************************/
         /*                                                                */
         /*   Open QM for querying                                         */
         /*                                                                */
         /******************************************************************/
         O_options = MQOO_INQUIRE;
         od.ObjectType = MQOT_Q_MGR;
      
         MQOPEN(Hcon,                      /* connection handle            */
                &od,                       /* object descriptor for queue  */
                O_options,                 /* open options                 */
                &Hobj,                     /* object handle                */
                &OpenCode,                 /* completion code              */
                &Reason);                  /* reason code                  */
      
         /* report reason, if any; stop if failed      */
         if (Reason != MQRC_NONE){
           printf("MQOPEN ended with reason code %d\n", Reason);
         }
      
         if (OpenCode == MQCC_FAILED){
           printf("unable to open queue for input\n");
         }
      
         if (CompCode == MQCC_OK){
           printf("\n_MQOPEN ok_\n");
         }
      
      
         /**************************************************************/
         /*                                                            */
         /*   Inquire an interger attribute                            */
         /*                                                            */
         /**************************************************************/
      
         //Select[0] = MQIA_EXPIRY_INTERVAL;       /* attribute selectors  */
         Select[0] = MQIA_ACCOUNTING_INTERVAL;       /* attribute selectors  */
      
         MQINQ(Hcon,            /* connection handle                 */
               Hobj,            /* object handle                     */
               1,               /* Selector count                    */
               Select,          /* the selector to inquire           */
               1,               /* integer attribute count           */
               IAV,             /* integer attribute array           */
               0,               /* character attribute count         */
               NULL,            /* character attribute array         */
               /*  note - can use NULL because count is zero         */
               &CompCode,       /* completion code                   */
               &Reason);        /* reason code                       */
      
         if (CompCode == MQCC_OK){
           printf("\n_MQINQ ok_\n");
         }else{
           printf("MQINQ ended with reason code %d\n", Reason);
         }
      
         if (Reason == MQRC_NONE){
           printf("MQIA_ACCOUNTING_INTERVAL is set to [%d]\n", IAV[0]);
         }else{
           printf("MQINQ ended with reason code %d\n", Reason);
         }
      
      
      
         /**************************************************************/
         /*                                                            */
         /*   Inquire a string attribute                               */
         /*                                                            */
         /**************************************************************/
         Selector = MQCA_Q_MGR_NAME;
      
         MQINQ(Hcon,                     /* connection handle            */
               Hobj,                     /* object handle for q manager  */
               1,                        /* inquire only one selector    */
               &Selector,                /* the selector to inquire      */
               0,                        /* no integer attributes needed */
               NULL,                     /* so no buffer supplied        */
               MQ_Q_MGR_NAME_LENGTH,     /* inquiring a q manager name   */
               QMName,                   /* the buffer for the name      */
               &CompCode,                /* MQINQ completion code        */
               &Reason);                 /* reason code                  */
      
         if (CompCode == MQCC_OK){
           printf("\n_MQINQ ok_\n");
         }else{
           printf("MQINQ ended with reason code %d\n", Reason);
         }
      
         if (Reason == MQRC_NONE){
           printf("Connection established to queue manager [%-48.48s]\n", QMName);
         }else{
           printf("MQINQ ended with reason code %d\n", Reason);
         }
      
      
         /******************************************************************/
         /*                                                                */
         /*   Disconnect from MQM  (unless previously connected)           */
         /*                                                                */
         /******************************************************************/
         if (CReason != MQRC_ALREADY_CONNECTED){
           MQDISC(&Hcon,                   /* connection handle            */
                  &CompCode,               /* completion code              */
                  &Reason);                /* reason code                  */
      
           if (CompCode == MQCC_OK){
             printf("\n_MQDISC ok_\n");
           }
           if (Reason != MQRC_NONE){
             printf("MQDISC ended with reason code %d\n", Reason);
           }
         }
      
         /******************************************************************/
         /*                                                                */
         /* Confirm end of the case                                        */
         /*                                                                */
         /******************************************************************/
         printf("[end]\n");
         return(0);
       }


##### links

MQ API useful links

 * https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_7.5.0/com.ibm.mq.javadoc.doc/WMQJavaClasses/com/ibm/mq/MQMessage.html
 * https://www.ibm.com/support/knowledgecenter/SSFKSJ_7.0.1/com.ibm.mq.javadoc.doc/WMQJavaClasses/com/ibm/mq/MQGetMessageOptions.html
 * https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_7.5.0/com.ibm.mq.ref.dev.doc/q096780_.htm

Pages 

 * http://usuaris.tinet.cat/sag/mq_admin.htm


