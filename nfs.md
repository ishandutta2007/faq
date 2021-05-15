#### NFS

##### examples

checkInOutTraffic.bash

    box=$1
    share=$2
    delay=$3
    sshOps='-o ConnectionAttempts=1 -o ConnectTimeout=1 -o BatchMode=yes -o StrictHostKeyChecking=no'
    
    #cat /proc/self/mountstats | grep -e device -e bytes | grep -A1 '/ifs/sharename'
    #device location1.domain.com:/ifs/sharename mounted on /apps/nfs1 with fstype nfs statvers=1.1
    #        bytes:  365519302561 101004739949 0 0 101366786069 101284672112 24794404 24894835
    #Bytes (linux/nfs_iostat.h: nfs_stat_bytecounters)
    #normalreadbytes
    #normalwritebytes
    #directreadbytes
    #directwritebytes
    #serverreadbytes
    #serverwritebytes (serverwrittenbytes)
    #readpages
    #writepages
    # * NFS byte counters
    # *
    # * 1.  SERVER - the number of payload bytes read from or written
    # *     to the server by the NFS client via an NFS READ or WRITE
    # *     request.
    # *
    # * 2.  NORMAL - the number of bytes read or written by applications
    # *     via the read(2) and write(2) system call interfaces.
    # *
    # * 3.  DIRECT - the number of bytes read or written from files
    # *     opened with the O_DIRECT flag.
    
    data="$(ssh ${sshOps} ${box} 'cat /proc/self/mountstats')"
    timing1=$(date +%s.%N)
    timing1sec=$(echo ${timing1} | sed 's/\..*//')
    timing1ns=$(echo ${timing1} | sed 's/.*\.//')
    inb1=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $2}')
    onb1=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $3}')
    idb1=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $4}')
    odb1=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $5}')
    isb1=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $6}')
    osb1=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $7}')
    
    sleep ${delay}
    
    data="$(ssh ${sshOps} ${box} 'cat /proc/self/mountstats')"
    timing2=$(date +%s.%N)
    timing2sec=$(echo ${timing2} | sed 's/\..*//')
    timing2ns=$(echo ${timing2} | sed 's/.*\.//')
    inb2=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $2}')
    onb2=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $3}')
    idb2=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $4}')
    odb2=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $5}')
    isb2=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $6}')
    osb2=$(echo "${data}" | grep -e 'device' -e 'bytes:' | grep -A1 "${share}" | grep 'bytes:' | awk '{print $7}')
    
    date1=$(date -d@${timing1sec} +"%F %T.${timing1ns}")
    date2=$(date -d@${timing2sec} +"%F %T.${timing2ns}")
    duration=$(echo "${timing2} - ${timing1}" | bc)
    inkBs=$(echo "(${inb2} - ${inb1})/1000/${duration}"|bc)
    onkBs=$(echo "(${onb2} - ${onb1})/1000/${duration}"|bc)
    idkBs=$(echo "(${idb2} - ${idb1})/1000/${duration}"|bc)
    odkBs=$(echo "(${odb2} - ${odb1})/1000/${duration}"|bc)
    iskBs=$(echo "(${isb2} - ${isb1})/1000/${duration}"|bc)
    oskBs=$(echo "(${osb2} - ${osb1})/1000/${duration}"|bc)
    
    echo "Timig : [${date1} - ${date2}] -> [${duration}] seconds"
    echo "Read NORMAL traffic for [${box}:${share}] : [${inb2} - ${inb1}] -> [${inkBs}] kB/s"
    echo "Read DIRECT traffic for [${box}:${share}] : [${idb2} - ${idb1}] -> [${idkBs}] kB/s"
    echo "Read SERVER traffic for [${box}:${share}] : [${isb2} - ${isb1}] -> [${iskBs}] kB/s"
    echo "Write NORMAL traffic for [${box}:${share}] : [${onb2} - ${onb1}] -> [${onkBs}] kB/s"
    echo "Write DIRECT traffic for [${box}:${share}] : [${odb2} - ${odb1}] -> [${odkBs}] kB/s"
    echo "Write SERVER traffic for [${box}:${share}] : [${osb2} - ${osb1}] -> [${oskBs}] kB/s"
