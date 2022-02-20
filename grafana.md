#### Grafana

##### HTTP API specification

[HTTP API](../utils.maintenance/grafana/samples.grafana.http.api.bash)

##### Dashboards

Minimal setup for a dashboard

    {
     "editable": true,
     "panels": [
    
      {
       "datasource": "influx_src", "lines": true, "nullPointMode": "connected",
       "legend": {"avg": false,"current": false,"max": false,"min": false,"show": true,"total": false,"values": false},
       "tooltip": {"shared": true,"sort": 0,"value_type": "individual"},
       "type": "graph",
       "title": "appd||JVM|Garbage_Collection|GC_Time_Spent_Per_Min_(ms)",
       "targets": [{
         "measurement": "appd",
         "tags": [{
           "key": "metric", "operator": "=",
           "value": "Application_Infrastructure_Performance|service|JVM|Garbage_Collection|GC_Time_Spent_Per_Min_(ms)"
          }],
         "groupBy": [{"params": ["$__interval"],"type": "time"},{"params": ["metric"],"type": "tag"}],
         "orderByTime": "ASC",
         "resultFormat": "time_series",
         "select": [[{"params": ["value"],"type": "field"},{"params": [95],"type": "percentile"}]]
       }]
      }
    
     ],
     "refresh": false,
     "style": "light",
     "title": "chart.name.01",
     "uid": "chart.name.01"
    }

##### API examples

    source current.cfg
    
    curlGetOpt='--silent --insecure --location --header "Accept: application/json" --header "Content-Type: application/json" --request GET '
    curlPostOpt='--silent --insecure --location --header "Accept: application/json" --header "Content-Type: application/json" --request POST'
    curlDeleteOpt='--silent --insecure --location --header "Accept: application/json" --header "Content-Type: application/json" --request DELETE'
    
    grafanaUrl=$1
    dataSourceUrl=$2
    
    #set -x -B
    
    #list current datasources
    #eval curl ${curlGetOpt} "${grafanaUrl}/api/datasources"
    
    #get specyfic datasource by id
    #eval curl ${curlGetOpt} "${grafanaUrl}/api/datasources/1"
    
    #get specyfic datasource by name
    #eval curl ${curlGetOpt} "${grafanaUrl}/api/datasources/name/jmeter"
    
    #get specyfic datasource id by name
    #eval curl ${curlGetOpt} "${grafanaUrl}/api/datasources/id/jmeter"
    
    #create datasource
    #cat <<EOF >datasource.json
    #{
    # "name":"testJmeter",
    # "type":"influxdb",
    # "access":"direct",
    # "access":"proxy",
    # "url":"${dataSourceUrl}",
    # "database":"jmeter",
    # "basicAuth":false,
    # "jsonData":{"keepCookies":[],"tlsSkipVerify":true}    
    #}
    #EOF
    #eval curl ${curlPostOpt} "${grafanaUrl}/api/datasources" --data @datasource.json
    #rm json.data
    
    #delete datasource by name
    #eval curl ${curlDeleteOpt} "${grafanaUrl}/api/datasources/name/testJmeter"
    
    #delete datasource by id
    #eval curl ${curlDeleteOpt} "${grafanaUrl}/api/datasources/2"
    
    #get the list of dashboards
    #$HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} curl ${curlGetOpt} http://localhost:3000/api/search?type=dash-db&query=&starred=false
    
    #get dashboard by uid
    #$HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} curl ${curlGetOpt} http://localhost:3000/api/dashboards/uid/nO-xn6Uiz
    
    #get the list of snapshots
    #$HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} curl ${curlGetOpt} http://localhost:3000/api/dashboard/snapshots
    ##eval curl -vvv ${curlGetOpt} "${grafanaUrl}/api/dashboard/snapshots"
    
    #get snapshot by key
    #snapshotKey='pd6e0EmCQq4HSYS4UMOZQYPECAP3r78M'
    #$HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} curl ${curlGetOpt} http://localhost:3000/api/snapshots/${snapshotKey} | tee test.grafana.metrics.jmeter.json
    ##eval curl -vvv ${curlGetOpt} "${grafanaUrl}/api/snapshots/${snapshotKey}"
    
    #create snapshot from .json file
    #jsonFile='test.grafana.metrics.jmeter.json'
    #$HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} rm -f /tmp/${jsonFile}
    #$HOME_DIR_OC/oc cp -c grafana ${jsonFile} ${grafanaPod}:/tmp/
    #$HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} cat /tmp/${jsonFile}
    #echo "#################"
    #eval $HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} curl ${curlPostOpt} http://localhost:3000/api/snapshots -d @/tmp/${jsonFile}
    ##eval curl ${curlPostOpt} "${grafanaUrl}/api/snapshots" --data @snapshot.json
    
    #delete snapshot
    #snapshotKey='sM8wZeaEHbhyNVFl3hcuOmRA5ZAE06Cv'
    #$HOME_DIR_OC/oc -c grafana rsh ${grafanaPod} curl ${curlDeleteOpt} http://localhost:3000/api/snapshots/${snapshotKey}

Interacting with datasources

    host='grafana.domain.com'
    authBearer='AbCdE'
    authBasic="user:user"
    #endpoint='api/dashboards/home'
    #endpoint='api/datasources'
    #endpoint='api/datasources/name/influx_app_flux'
    
    # VALIDATION
    #influxEndpoint='health'

    # INFLUX SQL
    #influxEndpoint='query?db=myDb&q=SHOW%20MEASUREMENTS'
    #influxEndpoint='query?db=myDb&q=SHOW%20FIELD%20KEYS%20FROM%20"jmeter"'

    # FLUX
    #influxEndpoint='api/v2/query'
    #fluxQuery='from(bucket:"myDb") |> range(start: 2021-09-21T12:00:00Z, stop: 2021-09-21T12:00:01Z) |> filter(fn: (r) => r._measurement == "jmeter") |> yield()'

    #endpoint="api/datasources/proxy/3/${influxEndpoint}"

    #set -x

    #curl -H "Authorization: Bearer ${authBearer}" ${host}/${endpoint}
    #curl -H 'content-type:application/vnd.flux' -H "Authorization: Bearer ${authBearer}" ${host}/${endpoint} -XPOST -sS -d "${fluxQuery}"

    #curl -s "${authBasic}@${host}/${endpoint}"
    #curl -H 'content-type:application/vnd.flux' "${authBasic}@${host}/${endpoint}" -XPOST -sS -d "${fluxQuery}"

Variables

Samples for dynamic flux query

    # Flux
    from(bucket: "myBucket")
     |> range($range)
     |> filter(fn: (r) =>  r._measurement == "monitoring" and r.App == "myApp")
     |> keep(columns: ["Service"])
     |> unique(column: "Service")
     |> map(fn: (r) => ({_value: r.Service}))

    # Flux
    from(bucket: "myBucket")
     |> range($range)
     |> filter(fn: (r) => r._measurement == "k8s")
     |> keep(columns: ["container"]) 
     |> map(fn: (r) => ({_value: r.container}))
     |> unique()

    #InfluxQL
    select DISTINCT(var::string)
     FROM (
      select MAX("cpu"), namespace as var from "myNamespace"."autogen"."k8s"
      WHERE $timeFilter
      GROUP BY namespace
     )

    #InfluxQL
    SHOW TAG VALUES WITH KEY="Environment" WHERE Site =~ /$Site_Name/

    #Flux
    from(bucket: "mybucket")
     |> range(start: v.timeRangeStart)
     |> filter(fn: (r) => contains(value: r["Site"], set: ${Site_Name:json}))
     |> keyValues(keyColumns: ["Environment"])
     |> group()

