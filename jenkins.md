#### jenkins

##### internal links

 * configuration: https://${jenkinsUrl}/configure
 * script console: https://${jenkinsUrl}/script

        get session timeout:
        import org.kohsuke.stapler.Stapler;
        Stapler.getCurrentRequest().getSession().getMaxInactiveInterval()
        
        set session timeout:
        import org.kohsuke.stapler.Stapler;
        Stapler.getCurrentRequest().getSession().setMaxInactiveInterval(86400)

 * user config: https://${jenkinsUrl}/user/user-name/configure


##### api


 * print whole available tree

       curl --silent --insecure --location ${jenkinsUrl}/api/json?pretty=true

 * print name of all known jobs

       curl --silent --insecure --location ${jenkinsUrl}/api/json?tree=jobs[name]&pretty=true

 * enable a job

       curl --silent --insecure --location -X POST ${jenkinsUrl}/${jobName}/enable

 * run job without parameters

       curl --silent --insecure --location -X POST ${jenkinsUrl}/${jobName}/build

 * run job with parameters

       curl --silent --insecure --location -X POST ${jenkinsUrl}/${jobName}/buildWithParameters?<params>

 * get latest build id

       curl --silent --insecure --location ${jenkinsUrl}/${jobName}/lastBuild/buildNumber

 * get latest build log text with user authentication

       curl --silent --insecure --location --user ${user}:${userToken} ${jenkinsUrl}/job/${jobName}/lastBuild/logText/progressiveText?start=0


TOCHECK
${jenkinsUrl}/job/${jobName}/api/json?pretty=true&depth=2&tree=builds[builtOn,changeSet,duration,timestamp,id,building,actions[causes[userId]]]
${jenkinsUrl}/api/json?tree=jobs[name,lastBuild[building,timestamp]]

http://jenkins/job/myjob/../api/json?tree=artifacts[*]
or list specific properties within the braces.

For changeSet, use

http://jenkins/job/myjob/../api/json?tree=changeSet[*[*]]
to retrieve everything.

Use nested square braces for specific sub-subproperties, e.g.:

http://jenkins/job/myjob/../api/json?tree=changeSet[items[revision]]


Get Build Status
Specific build number

$ curl -s http://<jenkins_url>/job/<job_name>/<specific_build_number>/api/json --user <user_name>:<api_token>
Last build

$ curl -s http://<jenkins_url>/job/<job_name>/lastBuild/api/json --user <user_name>:<api_token>
Last successful build

$ curl -s http://<jenkins_url>/job/<job_name>/lastSuccessfulBuild/api/json --user <user_name>:<api_token>
Last failed build

$ curl -s http://<jenkins_url>/job/<job_name>/lastFailedBuild/api/json --user <user_name>:<api_token>
Filter only desired output, e.g. build id, duration etc

$ curl -s http://<jenkins_url>/job/<job_name>/lastBuild/api/json\?tree\=number,building,result,timestamp --user <user_name>:<api_token>
Administer a Build
NOTE: To prevent CSRF, Jenkins require POST requests to include a crumb, which is specific to each user. The command to obtain the crumb is:

$ curl http://<jenkins_url>/crumbIssuer/api/xml\?xpath\=concat\(//crumbRequestField,%22:%22,//crumb\) --user <user_name>:<api_token>
Start a build

$ curl -H ".crumb:<crumb_string>" -X POST http://<jenkins_url>/job/<job_name>/build --user <user_name>:<api_token>
Start a parameterised build

$ curl -H ".crumb:<crumb_string>" -X POST http://<jenkins_url>/job/<job_name>/buildWithParameters --data-urlencode json='{"parameter":[{"<key>":"<value>"}]}' --user <user_name>:<api_token>
Stop a build (need specific build number)

$ curl -H ".crumb:<crumb_string>" -X POST http://<jenkins_url>/job/<job_name>/<build_number>/stop --user <user_name>:<api_token>
Get scheduled build(s) currently in queue

$ curl -s http://<jenkins_url>/queue/api/json --user <user_name>:<api_token>
Cancel scheduled build from the queue

$ curl -H ".crumb:<crumb_string>" -X POST http://<jenkins_url>/queue/cancelItem\?id\=<queue_number> --user <user_name>:<api_token>
