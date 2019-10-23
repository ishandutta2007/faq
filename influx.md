#### InfluxDB

##### working on db locally

show databases

    influx -execute 'SHOW DATABASES'

##### working on db vi http api (http://host:8086)

oneliners

    # health check
    curl --include --silent --insecure --location ${influxUrl}/ping
    # db listing
    curl --include --insecure --location "${influxUrl}/query?pretty=true" --data-urlencode 'q=show databases'
    # create db
    curl -XPOST "${influxUrl}/query" --data-urlencode 'q=CREATE DATABASE "mydb"'
    # show users
    curl -XPOST "${plaasInfluxUrl}/query?db=mydb" --data-urlencode 'q=SHOW USERS'
    # show measurments
    curl -XPOST "${plaasInfluxUrl}/query?db=mydb" --data-urlencode 'q=SHOW MEASUREMENTS'
    # show series
    curl -XPOST "${plaasInfluxUrl}/query?db=mydb" --data-urlencode 'q=SHOW SERIES'
    # drop db
    curl -XPOST "${influxUrl}/query" --data-urlencode 'q=DROP DATABASE "mydb"'



to check

 * /debug/pprof
 * /debug/requests
 * /debug/vars
 * /ping
 * /query
 * /write


