#### Zabbix

##### Debug

Sample of zabbix agent (running on host345 & port 10050) output/reponse debug

    zabbix_get -s host345 -p 10050 -k 'proc.cpu.util[,nmvfunc,user,41410]'

Discovery rules debug

    zabbix_get -s host345 -p 10050 -k vfs.fs.discovery

