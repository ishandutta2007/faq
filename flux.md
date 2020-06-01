#### flux

Utility script to run flux queries

    query="$(cat influx.query.flux | grep -v '#' | tr -d '\n')"
    echo http_proxy='' curl ${influxUrl}/api/v2/query -XPOST -sS \
     -H 'accept:application/csv' \
     -H 'content-type:application/vnd.flux' \
     -d "'${query}'"
    http_proxy='' curl ${influxUrl}/api/v2/query -XPOST -sS \
     -H 'accept:application/csv' \
     -H 'content-type:application/vnd.flux' \
     -d "${query}"

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

