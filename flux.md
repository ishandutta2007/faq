#### flux

Utility script to run flux queries

    query="$(cat influx.query.flux | grep -v '#' | tr -d '\n')"
    echo http_proxy='' curl ${influxUrl}/api/v2/query -XPOST -sS \
     -H 'content-type:application/vnd.flux' \
     -d "'${query}'"
    http_proxy='' curl ${influxUrl}/api/v2/query -XPOST -sS \
     -H 'content-type:application/vnd.flux' \
     -d "${query}"

Example queries

    #range='start: -24h'
    #range='start: 2021-04-09T06:00:00Z, stop: 2021-04-09T07:00:00Z'

    allMeasurementData='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> filter(fn: (r) => r._measurement == "'"${measurement}"'")
      |> yield()
    '

    countData='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> filter(fn: (r) => r._measurement == "'"${measurement}"'")
      |> count()
      |> yield()
    '

    countData='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> keep(columns: ["_measurement"])
      |> map(fn: (r) => ({_value: r._measurement}))
      |> count()
      |> yield()
    '

    listMeasurements='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> keep(columns: ["_measurement"])
      |> map(fn: (r) => ({_value: r._measurement}))
      |> unique()
      |> yield()
    '

    countMeasurementData='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> filter(fn: (r) => r._measurement == "'"${measurement}"'")
      |> keep(columns: ["_measurement"])
      |> map(fn: (r) => ({_value: r._measurement}))
      |> count()
      |> yield()
    '
    
    probeMeasurementData='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> filter(fn: (r) => r._measurement == "'"${measurement}"'")
      |> limit(n:10,offset: 0)
      |> yield()
    '

    listFields='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> filter(fn: (r) => r._measurement == "'"${measurement}"'")
      |> keep(columns: ["_field"])
      |> map(fn: (r) => ({_value: r._field}))
      |> unique()
      |> yield()
    '

    probeMeasurementFieldData='
     from(bucket: "myBucket")
      |> range('"${range}"')
      |> filter(fn: (r) => r._measurement == "'"${measurement}"'" and r._field == "'"${field}"'")
      |> limit(n:10,offset: 0)
      |> yield()
    '
    
    listTags='
     import "influxdata/influxdb/v1"
     v1.tagKeys(bucket: "myBucket")
    '
    
    listTags='
     import "influxdata/influxdb/v1"
     v1.measurementTagKeys(bucket: "myBucket", measurement: "${measurement}")
    '
    
    
    listTagsNew='
     import "influxdata/influxdb/schema"
     schema.tagKeys(bucket: "myBucket")
    '


Get TPS for jmeter backend listener

    selectedData = from(bucket:"myBucket")
     |> range(start: 2019-11-04T21:03:28Z, stop: 2019-11-04T21:13:32Z)
     |> filter(fn: (r) => r._measurement == "jmeter" and r.transaction == "myRequest" and r.status == "all" and r._field == "count" and r.testId == "myTestId")
    # |> yield(name: "selectedData")
    
    totalCount = selectedData
     |> sum(column: "_value")
     |> map(fn: (r) => ({field: "data", totalCount: r._value}) )
    # |> yield(name: "totalCount")
    
    first = selectedData
     |> first()
     |> keep(columns: ["_time"])
     |> map(fn: (r) => ({field: "data", startT: r._time, startTS: int(v: r._time)/1000000000}) )
    # |> yield(name: "first")
    
    last = selectedData
     |> last()
     |> keep(columns: ["_time"])
     |> map(fn: (r) => ({field: "data", stopT: r._time, stopTS: int(v: r._time)/1000000000}) )
    # |> yield(name: "last")
    
    timing = join(tables: {first: first, last: last}, on: ["field"])
     |> map(fn: (r) =>  ({field: "data", startT: r.startT, stopT: r.stopT, startTS: r.startTS, stopTS: r.stopTS, durationSec: (r.stopTS - r.startTS)}))
    # |> yield(name: "timing")
    
    tps = join(tables: {timing: timing, totalCount: totalCount}, on: ["field"])
     |> map(fn: (r) =>  ({field: "data", tps: (float(v: r.totalCount) / float(v: r.durationSec))}))
     |> yield(name: "tps")

Get TPS after enabling duration without calculation in flux

    #duration = 599.0
    #duration = 599
    tps = from(bucket:"myBucket")
     |> range(start: 2019-11-04T21:03:28Z, stop: 2019-11-04T21:13:32Z)
     |> filter(fn: (r) => r._measurement == "jmeter" and r.transaction == "myRequest" and r.status == "all" and r._field == "count" and r.testId == "myTestId")
     |> sum()
    # |> map(fn: (r) =>  ({tps: float(v: r._value) / 599.0 }))
    # |> map(fn: (r) =>  ({tps: float(v: r._value) / float(v: duration) }))
     |> map(fn: (r) =>  ({tps: float(v: r._value) / float(v: 599) }))
     |> yield()


Get average response time

    avgRt = from(bucket:"myBucket")
     |> range(start: 2019-11-04T21:03:28Z, stop: 2019-11-04T21:13:32Z)
     |> filter(fn: (r) => r._measurement == "jmeter" and r.transaction == "myRequest" and r.status == "all" and (r._field == "count" or r._field == "avg" ) and r.testId == "myTestId")
     |> pivot( rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
     |> filter(fn: (r) => r.count > 0)
     |> map(fn: (r) => ({totalTime: r.count * r.avg, count: r.count}) )
     |> reduce( fn: (r, accumulator) => ({ totalTime: r.totalTime + accumulator.totalTime, totalCount: r.count + accumulator.totalCount }), identity: {totalTime: 0.0, totalCount: 0.0} )
     |> map(fn: (r) => ({avgRt: r.totalTime/r.totalCount}) )
     |> yield(name: "avgRt")

Get unique list of column values

    from(bucket: "myBucket")
     |> range(start: 2019-11-04T21:03:28Z, stop: 2019-11-04T21:13:32Z)
     |> filter(fn: (r) =>  r._measurement == "monitoring" and r.App == "coolApp")
     |> keep(columns: ["Service"])
     |> unique(column: "Service")
     |> map(fn: (r) => ({_value: r.Service}))

Calculate coefficient of variation

    tps=from(bucket: "myBucket")
     |> range(start: 2022-04-22T14:12:45Z, stop: 2022-04-22T18:45:20Z)
     |> filter(fn: (r) => r._measurement == "logging.googleapis.com/user/ssg"
         and r.FromEndPoint == "pointStart"
         and r.ToEndPoint == "pointStop"
         and r.Status == "SUCCESS"
         and r._field == "status_count"
         and r._value !=0
         and r.test_id == "ZX9938277" )
     |> keep(columns: ["_time","_value"])
     |> map(fn: (r) => ({ time: r.time, _value: float(v: r._value) / 60.0}))
    
    tps_stddev = tps
     |> stddev()
     |> set(key:"_field", value:"stddev")
     |> set(key:"_measurement", value:"tps")
    
    tps_mean = tps
     |> mean()
     |> set(key:"_field", value:"mean")
     |> set(key:"_measurement", value:"tps")
    
    union(tables: [tps_stddev,tps_mean])
     |> pivot(rowKey:["_measurement"], columnKey: ["_field"], valueColumn: "_value")
     |> map(fn: (r) => ({ r with cov: r.stddev/r.mean}))
     |> yield()


Using wget intead of curl

    wget -O - ${influxUrl}/query?db=myDb --post-data "q=SHOW MEASUREMENTS"
    wget -O - ${influxUrl}/api/v2/query --header 'content-type:application/vnd.flux' --post-data 'from(bucket: "myDb") |> range(start: 2021-01-01T00:00:00Z, stop: 2021-01-02T00:00:00Z) |> yield()'

Samples of InfluxQL vs flux

    # InfluxQL:
    SHOW TAG VALUES WITH KEY="Site"

    #Flux:    
    from(bucket: "mybucket")
     |> range(start: v.timeRangeStart)
     |> keyValues(keyColumns: ["Site"])
     |> group()

Importing flux data back to influxDb via grafana

Tool for convertion to line protocol: https://github.com/mispdev/csv2lp


    grafanaHost='http://grafana.domain.com'
    influxDbId='111'
    range='start: 2021-12-13T14:21:10Z, stop: 2021-12-13T15:22:13Z'
    measurement='custom.googleapis.com'
    influxDbBucket='myDb'

    allMeasurementData='
    from(bucket: "'${influxDbBucket}'")
     |> range('"${range}"')
     |> filter(fn: (r) => r._measurement =~ /'"${measurement}"'/)
     |> yield()
    '

    fluxQuery="${allMeasurementData}"

    curl -k -L -sS \
     -H 'content-type:application/vnd.flux' \
     ${grafanaHost}/api/datasources/proxy/${influxDbId}/api/v2/query \
     -XPOST -d "${fluxQuery}" \
     > import.csv

    /opt/csv2lp/csv2lp import.csv > import.lp
    gzip import.lp

    influxDbId='123'
    influxDbBucket='myDb'
    
    # send gzip data from flux query
    curl -k -L -sS \
     -X POST "${grafanaHost}/api/datasources/proxy/${influxDbId}/api/v2/write?bucket=${influxDbBucket}" \
     -H "Content-Encoding: gzip" \
     -H "Content-Type: text/plain; charset=utf-8" \
     -H "Accept: application/json" \
     --data-binary @import.lp.gz
    fi
