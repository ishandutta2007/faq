#### ServiceNow

##### code samples

Sample usage in python

    def get_results_with_all_attr(api,table,query):
        """
        Return results from snow query
        """
        all_results = []
        classname = 'api.table.' + table
        api_table = eval(classname)
        for result in api_table.search(sysparm_query=query,
                                       sysparm_display_value='true'):    
            sys.stdout.write('.')
            
            # debug part
            #pprint.pprint(vars(result))
            #sys.exit(1)
            all_results.append(result)
     
        sys.stdout.write('\nTotal results found: [' + str(len(all_results)) + ']\n' )
        return all_results
    
    def get_results_with_attr(api,table,query,fields):
        """
        Return results from snow query
        """
        all_results = []
        classname = 'api.table.' + table
        api_table = eval(classname)
        for result in api_table.search(sysparm_query=query,
                                       sysparm_fields=fields,
                                       sysparm_display_value='true'):    
            sys.stdout.write('.')
            
            # debug part
            #pprint.pprint(vars(result))
            #sys.exit(1)
            all_results.append(result)
     
        sys.stdout.write('\nTotal results found: [' + str(len(all_results)) + ']\n' )
        return all_results
    
    
    sysparm_query = 'parentLIKESome name^EQ'
    sysparm_table = 'u_cmdb_ci_some_service'
    sysparm_field_list=('name,' + 
                        'correlation_id,' +
                        'asset_tag,' +
                        'busines_criticality,' +
                        'owned_by,' +
                        'operational_status,' +
                        'sys_created_on,' +
                        'sys_updated_by,' +
                        'sys_updated_on')
    
    
    results=get_results_with_all_attr(api, sysparm_table, sysparm_query)
    results=get_results_with_attr(api, sysparm_table, sysparm_query, sysparm_field_list)
    
Simple request with python:

    import requests
    
    # Set the request parameters
    http_proxy  = "some.proxy.com:port"
    https_proxy = http_proxy
    ftp_proxy   = http_proxy
    proxyDict = {
                 "http"  : http_proxy,
                 "https" : https_proxy,
                 "ftp"   : ftp_proxy
               }
    url  = 'https://some.service-now.com/api/now/table/incident?sysparm_limit=1'
    user = 'someUser'
    pwd  = 'somePass'
    
    # Set proper headers
    headers = {"Accept":"application/json"}
    
    # Do the HTTP request
    response = requests.get(url, auth=(user, pwd), headers=headers, proxies=proxyDict)
    
    # Check for HTTP codes other than 200
    if response.status_code != 200:
        print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
        exit()
    
    # Decode the JSON response into a dictionary and use the data
    print('Status:',response.status_code,'Headers:',response.headers,'Response:',response.json())
    print('Cookies', response.cookies)

Simple request with curl

    export http_proxy="http://user:password@box:port"
    export https_proxy="$http_proxy" ftp_proxy="$http_proxy"
    myUser='someUser'
    myPass='somePass'
    
    set -x
    curl -i --user "${myUser}:${myPass}" \
     --header "Accept: application/json" \
     'https://some.service-now.com/api/now/table/incident?sysparm_limit=1'



##### getting data from gui

Capturing data from GUI

You need to find 

 - what tables you need to query
 - what search you want to run for the table

To do this, you need to run report manually and check what is going on

 - open snow and navigate to reports
 - click ‘create report’
 - pick the table as you think it should be, same for fields and filters (just experiment to get what you need)
 - open developer tools available from your browser (usually F12 will open it)
 - start recording on developer tools network traffic
 - run report
 - stop recording when finished
 - check form data recorded for any of following:

    - sys_report_template.do 
    - report_viewer.do page

You are looking for parameters:

 - sysparm_query : query to be used
 - sysparm_field_list : attributes to be collected
 - sysparm_table : table you should query

This can look like:

 - sysparm_query:assetLIKETEST1 - VMware Virtual Server^EQ
 - sysparm_field_list:name,serial_number,sys_class_name,model_id,manufacturer,location,short_description,discovery_source,correlation_id,sys_updated_on,sys_updated_by,sys_created_on,sys_created_by
 - sysparm_table:cmdb_ci_hardware


##### Links

 * [api](https://docs.servicenow.com/bundle/helsinki-servicenow-platform/page/integrate/inbound-rest/reference/r_TableAPI-GET.html)
 * [curl examples](https://docs.servicenow.com/integrate/inbound_rest/reference/r_TableAPICurlExamples.html)
