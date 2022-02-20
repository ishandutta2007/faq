#### InfluxDB

##### working on db locally

show databases

    influx -execute 'SHOW DATABASES'

##### working on db via http api (http://host:8086)

basic oneliners

    # health check
    curl --include --silent --insecure --location ${influxUrl}/ping
    # db listing
    curl --include --insecure --location "${influxUrl}/query?pretty=true" --data-urlencode 'q=show databases'
    # create db
    curl -XPOST "${influxUrl}/query" --data-urlencode 'q=CREATE DATABASE "mydb"'
    # drop db
    curl -XPOST "${influxUrl}/query" --data-urlencode 'q=DROP DATABASE "mydb"'

utility scrtip to run queries

    query="$(cat influx.query.sql| grep -v '#')"
    myDb='myDb'
    echo "query"
    echo http_proxy='' curl -G ${influxUrl}/query?db=${myDb} --data-urlencode "'${query}'"
    http_proxy='' curl -XPOST ${influxUrl}/query?db=${myDb} --data-urlencode "${query}"

query samples 

    #q=SHOW DATABASES
    #q=SHOW SERIES
    #q=SHOW MEASUREMENTS
    #q=SHOW TAG KEYS ON "myBucket"
    #q=SHOW TAG KEYS FROM "jmeter"
    #q=SHOW TAG VALUES FROM "jmeter" WITH KEY = "application"
    #q=SHOW TAG VALUES WITH KEY = "application" WHERE "application" !~ /test/ AND "application" !~ /all/
    #q=SHOW FIELD KEYS FROM "jmeter"
    #q=SHOW FIELD KEYS ON "myBucket" FROM "jmeter"
    #q=SELECT * FROM "jmeter" LIMIT 30
    #q=SELECT * FROM "jmeter" WHERE "status" = 'all' LIMIT 3
    #q=SELECT * FROM "jmeter" WHERE "application" = 'myReq' LIMIT 3
    #q=SELECT "application","status","value" FROM "jmeter" WHERE "time" = '2019-10-29T21:21:53Z'
    #q=SELECT "application","status","value" FROM "jmeter" WHERE "time" = '2019-10-29T21:21:53Z'
    #q=SELECT "value","bytes" FROM "jmeter" WHERE "time" = '2019-10-29T21:21:53Z'
    #q=SELECT FIRST("value") FROM "jmeter" where "status" = 'all'
    #q=SELECT LAST("value") FROM "jmeter" where "status" = 'all'


More complicated examples

    q=SELECT "value"
     FROM "autogen"."appd"
     WHERE (
            "metric" =~ /.*tx-dev-ecomm-dcmc2-bo.*/
        AND "metric" =~ /.*MB.*/
        AND "project" =~ /^Some_Project_Name/
        AND time >= '2018-09-17T00:00:00Z'
        AND time <= '2018-09-18T00:00:00Z'
     )
     GROUP BY "project","metric"
     LIMIT 5


##### Sample usage for creating vars and graphs in grafana

Vars (based on quries to influx and refreshed for time range change):

 * SELECT DISTINCT("metric") FROM (select MAX("count"), "metric" as "var" from "mydb"."autogen"."appd" WHERE $timeFilter GROUP BY "metric")
 * SELECT DISTINCT("project") FROM (select MAX("count"), "project" as "var" from "mydb"."autogen"."appd" WHERE $timeFilter GROUP BY "project")
 * SELECT DISTINCT("metric") FROM (select MAX("count"), "metric" as "var" from "mydb"."autogen"."appd" WHERE $timeFilter GROUP BY "metric") 
   regex: /.*?\|(.*?)\|.*/
   regex reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions/Cheatsheet
 * SELECT DISTINCT("metric") FROM (select MAX("count"), "metric" as "var" from "mydb"."autogen"."appd" WHERE $timeFilter GROUP BY "metric") 
   regex: /.*?\|.*?\|(.*)/
   regex reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions/Cheatsheet

Graphs:

 * SELECT "value" FROM "autogen"."appd" WHERE ("metric" =~ /.*$host.*$metric.*/ AND "project" =~ /^$project$/) AND $timeFilter GROUP BY "metric"
 * SELECT "value" FROM "autogen"."appd" WHERE ("metric" =~ /^${metric_full}$/ AND "project" =~ /^${project}$/) AND $timeFilter GROUP BY "project", "metric"

to check

 * /debug/pprof
 * /debug/requests
 * /debug/vars
 * /ping
 * /query
 * /write

##### resources

Some internals

 * https://www.influxdata.com/blog/influxdb-internals-101-part-one/
 * https://www.influxdata.com/blog/influxdb-internals-101-part-two/
 * https://www.influxdata.com/blog/tldr-influxdb-tech-tips-optimizing-flux-performance-in-influxdb-cloud/
