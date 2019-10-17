#### InfluxDB

##### working on db locally

show databases

    influx -execute 'SHOW DATABASES'

##### working on db vi http api (http://host:8086)

health check

    curl --include --silent --insecure --location ${influxUrl}/ping

to check

 * /debug/pprof
 * /debug/requests
 * /debug/vars
 * /ping
 * /query
 * /write


