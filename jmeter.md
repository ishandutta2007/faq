#### JMeter

##### compiling

Usual flow:

    ./gradlew runGui
    ./gradlew createDist

##### environment

Resources

A single JMeter client running on a 2-3Ghz CPU (recent cpu) can handle 300-600 threads depending on the type of test. (The exception is the webservices). XML processing is CPU intensive and will rapidly consume all the CPU cycles. As a general rule, the performance of XML centric applications will perform 4-10 slower than applications using binary protocols

##### startup

Get plugins over proxy

JVM:

    -Dhttps.proxyHost=proxy.com
    -Dhttps.proxyPort=80
    -Dhttp.proxyUser=xyz
    -Dhttp.proxyPass=abc

Jmeter:

    --proxyHost proxy.com
    --proxyPort 80
    --username xyz
    --password abc

Clean startup

To get rid JVM warnings related to properties when having non-starndar home directory (e.g. /):

    Dec 20, 2018 7:10:20 PM java.util.prefs.FileSystemPreferences$1 run
    WARNING: Couldn't create user preferences directory. User preferences are unusable.
    Dec 20, 2018 7:10:20 PM java.util.prefs.FileSystemPreferences$1 run
    WARNING: java.io.IOException: No such file or directory

use following:

    export HOME=/tmp/jmeter
    mkdir -p ${HOME}/.java/.systemPrefs
    mkdir -p ${HOME}/.java/.userPrefs
    chmod -R 755 ${HOME}/.java
    java -Djava.util.prefs.systemRoot=${HOME} -Djava.util.prefs.userRoot=${HOME} \
     -jar ApacheJMeter.jar -v -j ${HOME}/jmeter.run.log -p ${HOME}/jmeter.properties

##### debug

Test jmeter regular expression before use

    http://www.regexplanet.com/advanced/java/index.html

##### plugin dependencies

Plugin related jars for jmeter-plugins.org:

    https://github.com/undera/jmeter-plugins/search?q=guava-19.0.0

##### performance

General rules

 - when doing custom coding, ensure it is efficient (more CPU time on creating/processing samples = less CPU time on sampling)
 - no listeners for real command mode testing (post processing instead), otherwise risk of OutOfMemory errors or performance issues
 - use latest version of jmeter software
 - proper JVM configuration (memory and GC, server mode)
 - csv as output for SaveService, e.g. of user.properties

       jmeter.save.saveservice.output_format=csv
       jmeter.save.saveservice.data_type=false
       jmeter.save.saveservice.label=true
       jmeter.save.saveservice.response_code=true
       jmeter.save.saveservice.response_data.on_error=false
       jmeter.save.saveservice.response_message=false
       jmeter.save.saveservice.successful=true
       jmeter.save.saveservice.thread_name=true
       jmeter.save.saveservice.time=true
       jmeter.save.saveservice.subresults=false
       jmeter.save.saveservice.assertions=false
       jmeter.save.saveservice.latency=true
       jmeter.save.saveservice.bytes=true
       jmeter.save.saveservice.hostname=true
       jmeter.save.saveservice.thread_counts=true
       jmeter.save.saveservice.sample_count=true
       jmeter.save.saveservice.response_message=false
       jmeter.save.saveservice.assertion_results_failure_message=false
       jmeter.save.saveservice.timestamp_format=HH:mm:ss
       jmeter.save.saveservice.default_delimiter=;
       jmeter.save.saveservice.print_field_names=true
 - Post-Processor and Assertion may be costly (use JSR223 + groovy)
 - use Regular Expression Extractor wiesly (extract as less data as possible), never check Body(unescaped), use instead

    - Body
    - Headers
    - URL
    - Response Code
    - Response Message
 - avoid XPath Extractor (builds a DOM tree, consumes CPU and memory), use Regular Expression extractor or CSS/JQuery Extractor instead
 - use Response Assertion or Size assertion (low cost of resources)
 - avoid 

   - XML Assertion
   - XML Schema Assertion
   - XPath Assertion

##### gui

To get information about latest, built-in functions use `Function Helper Dialog` from main menu.

##### code samples

 - access files realitive to .jmx scenario in easy way
   File structure

       .:
       test.jmx  test-data
       
       ./test-data:
       data.csv

   1st config element in jmeter

       BASE_DIR             ${__groovy(import org.apache.jmeter.services.FileServer; FileServer.getFileServer().getBaseDir();)}	
       OS_FILE_SEPARATOR    ${__groovy(File.separator,)}
       
   2nd config element in jmeter

       CSV_DIR              ${BASE_DIR}${OS_FILE_SEPARATOR}test-data${OS_FILE_SEPARATOR}

   CSV dataset config filename: `${CSV_DIR}data.csv`

 - check for any occurance in subsamles

       import org.apache.jmeter.samplers.SampleResult;
       
       String assertionText = Parameters;
       String sampleResponseData= "";
       int assertionMatch = 0;
       
       SampleResult[] subSamplesResults = prev.getSubResults();
       for (int i = 0 ; i < subSamplesResults.length ; i++){
         sampleResponseData = subSamplesResults[i].getResponseDataAsString();
         if (sampleResponseData.contains(assertionText)){
           assertionMatch++;
         }
         //log.info("Sample numer [" + String.valueOf(i) + "]");
         //log.info("Sample response data [" + sampleResponseData + "]");
         //log.info("Assertion value [" + String.valueOf(assertionMatch) + "]");
       }
       
       if (assertionMatch == 0){
         AssertionResult.setFailureMessage("Text [" + assertionText + "] not found in subsamples or main sample");
         AssertionResult.setFailure(true);
       }

 - `thread group name` (e.g. `setUp`)

       ${__BeanShell(ctx.getThreadGroup().getName())} 
       ${__javaScript(Java.type("org.apache.jmeter.threads.JMeterContextService").getContext().getThreadGroup().getName())}
       //NOTE: __javaScript this way works only for static classes
       ${__groovy(ctx.getThreadGroup().getName())} 
       ${__jexl2(ctx.getThreadGroup().getName())}
       ${__jexl3(ctx.getThreadGroup().getName())}

 - `thread group name` `?` `thread number` (e.g. `setUp 1-2`)

       ${__BeanShell(threadName)}
       ${__groovy(threadName)}
       ${__javaScript(threadName)}
       ${__jexl2(threadName)}
       ${__jexl3(threadName)}

 - `thread group name` `?` `thread number` `iteration number` (e.g. `setUp 1-2.4)

       ${__javaScript(threadName)}.${__counter(TRUE)}


 - `thread grup iteration`

       ${__javaScript(vars.getIteration())}

 - play with JSR223 sampler and basic actions from https://jmeter.apache.org/api/org/apache/jmeter/samplers/SampleResult.html

       SampleResult.setResponseData("TEST", "UTF-8");
       SampleResult.setResponseOK();
        
 - update result according to required conditions in post processor (JSR223 is recommended + groovy, when you can simple code in Java)

       prev.setResponseCode("ERROR");
       prev.setSuccessful(false);
       prev.setResponseMessage("Missing required framgmet");

 - set/get variables

       String some_value1 = "test";
       vars.put("var_name", some_value1);
       String some_value = vars.get("var_name");
      
       import com.company.some.package.SomeClass;
       SomeClass some_object1 = new SomeClass();
       vars.putObject("var_name", some_object1);
       SomeClass some_object2 = vars.getObject("var_name");

 - sharing vars over threads (variables are not shared between threads, use jmeter properties for sharing)

       String some_value1 = "test";
       props.put("var_name", some_value1);
       String some_value = props.get("var_name");
      
       import com.company.some.package.SomeClass;
       SomeClass some_object1 = new SomeClass();
       props.put("var_name", some_object1);
       SomeClass some_object2 = props.get("var_name");

 - simple utils related with time in JSR223

       import java.time.LocalDateTime;
        
       // 13 chacters, but needed 4chars-12chars in format 000x-xxxxx...
       String timeStampStr=System.currentTimeMillis().toString();
       timeStampStr = "000" + timeStampStr.substring(0,1) + "-" + timeStampStr.substring(1,timeStampStr.length());
       vars.put("var_timestamp_id",timeStampStr);
       
       // user/thread ID in format xxxx
       String threadId = String.format("%04d", ctx.getThreadNum());
       vars.put("var_thread_id",threadId);
       
       // get next year, to be used in scripts
       int nextYear = LocalDateTime.now().getYear() + 1;
       vars.put("var_next_year",nextYear.toString());

 - simple calculations - parameter as variable in user variables (javaScript)

       ${__javaScript( String(Math.round(${DURATION} * 0.75)) )}

 - convert bytes to hexstream (java)

       String bytesToHex(byte[] bytes) {
        //char[] hexArray = "0123456789ABCDEF".toCharArray();
        char[] hexArray = "0123456789abcdef".toCharArray();
        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
         int v = bytes[j] & 0xFF;
         hexChars[j * 2] = hexArray[v >>> 4];
         hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
       }

 - character only incremented counter shared over all threads in a thread group
       
       import java.nio.charset.Charset;
       
       String getHex(byte[] raw) {
           //final String HEXES = "0123456789ABCDEF";
           final String HEXES = "0123456789abcdef";
           StringBuilder hex = new StringBuilder(2 * raw.length);
           for (byte b : raw) {
               hex.append(HEXES.charAt((b & 0xF0) >> 4)).append(HEXES.charAt((b & 0x0F)));
           }
           return hex.toString();
       }
       
       int alignControl=0;
       
       String myHexStr=props.get("myHexStr");
       vars.put("myHexStr",myHexStr);
       int locatorPos = myHexStr.length() - 1;
       //log.info("######################### DEBUG CURRENT [" + myHexStr + "]");
       //log.info("######################### DEBUG CURRENT HEX ASCII ["+ getHex(myHexStr.getBytes(Charset.forName("ASCII"))) +"]");
       //log.info("######################### DEBUG CURRENT HEX EBCDIC ["+ getHex(myHexStr.getBytes(Charset.forName("CP037"))) +"]")
       vars.put("myHexStrEbcdic", getHex(myHexStr.getBytes(Charset.forName("CP037"))))
       
       // increment
       char[] charArray = myHexStr.toCharArray();
       
       while (charArray[locatorPos] == 'Z'){
        charArray[locatorPos] = 'A';
        locatorPos--;
         if (locatorPos < 0){
          alignControl=1;
          locatorPos=myHexStr.length() - 1;
        }
       }
       
       charArray[locatorPos]++;
       if (alignControl==1){
        alignControl=0;
        charArray[myHexStr.length() - 1]='A';
       }
       
       props.put("myHexStr",String.valueOf(charArray));


##### logging

The CSV log format depends on which data items are selected in the configuration.
Only the specified data items are recorded in the file.
The order of appearance of columns is fixed, and is as follows:

 -  timeStamp - in milliseconds since 1/1/1970
 -  elapsed - in milliseconds
 -  label - sampler label
 -  responseCode - e.g. 200, 404
 -  responseMessage - e.g. OK
 -  threadName
 -  dataType - e.g. text
 -  success - true or false
 -  failureMessage - if any
 -  bytes - number of bytes in the sample
 -  sentBytes - number of bytes sent for the sample
 -  grpThreads - number of active threads in this thread group
 -  allThreads - total number of active threads in all groups
 -  URL
 -  Filename - if Save Response to File was used
 -  latency - time to first response
 -  connect - time to establish connection
 -  encoding
 -  SampleCount - number of samples (1, unless multiple samples are aggregated)
 -  ErrorCount - number of errors (0 or 1, unless multiple samples are aggregated)
 -  Hostname - where the sample was generated
 -  IdleTime - number of milliseconds of 'Idle' time (normally 0)
 -  Variables, if specified

based on [manual](https://jmeter.apache.org/usermanual/listeners.html#csvlogformat)

More details on meaning:

 - elapsed time: time from just before sending the request to just after the last response has been received (does not include the time to render the response, nor to process any client code, for example Javascript, as this is not supported by jmeter)
 - latency: from just before sending the request to just after the first response has been received (includes all the processing needed to assemble the request as well as assembling the first part of the response, which in general will be longer than one byte. Protocol analysers such as Wireshark measure the time when bytes are actually sent/received over the interface. The JMeter time should be closer to that which is experienced by a browser or other application client)
 - connect Time: time it tooks to establish the connection, including SSL handshake (connect time is not automatically subtracted from latency. In case of connection error, the metric will be equal to the time it took to face the error, for example in case of Timeout, it should be equal to connection timeout)

based on [glossary](https://jmeter.apache.org/usermanual/glossary.html)

Sample:

    timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,?,?,?
    1529489572162,3,case1,200,OK,case1.payloads 3-12,text,false,,0,0,25,96,0,0,0

Sample of issues with connecion:

    1545389889931,96,sampler1,200,,threadG1 1-8,text,true,,88464,460595,10,10,http://test.com,95,0,22
    1545390165650,3272,sampler1,200,,threadG1 1-5,text,true,,88464,460595,10,10,http://test.com,3271,0,3117

Logging details with JSR sampler (more details @ https://www.pushbeta.com/2019/10/18/jmeter-logging-the-full-request-for-non-gui-access/)

    try{
      var message = "";
      var currentUrl = sampler.getUrl();
      message +=  ". URL = " +currentUrl;
      var requestBody = sampler.getArguments().getArgument(0).getValue();
      message += " --data " + sampler.getArguments();
    
      if(!sampleResult.isSuccessful()){
          log.error(message);
      }
    
    }catch(err){
      //do nothing. this could be a debug sampler. no need to log the error
    }

##### reports

Creating jmeter dashboard report

     ${JAVA_HOME}/bin/java \
      -jar "${JMETER_HOME}/bin/ApacheJMeter.jar" \
      -g "${jmerteCsvResultLog}" \
      -o "${outputDir}/jmeter/`basename ${jmeterCsvResultLog}`.html" \
      -j "${outputDir}/jmeter/`basename ${jmeterCsvResultLog}`.report.log" \
      -J jmeter.reportgenerator.temp_dir="${outputDir}/jmeter/"

Exmaple of usage for log with over 1 million lines

    java -Xms32g -Xmx32g -XX:NewRatio=1 -XX:-UseAdaptiveSizePolicy -server -jar ApacheJMeter.jar -g /tmp/jmeter.log.csv -o /tmp/report 

##### utilities

Converters to JMX format

 - http://converter.blazemeter.com/ : Convert HAR, XML, Selenium, PCAP and JSON to JMX format
 - https://github.com/pmirek/har2jmx
 - https://github.com/pmirek/soapui2jmx TODO


##### references

Books:

 - [Master Apache JMeter From load testing to DevOps](https://leanpub.com/master-jmeter-from-load-test-to-devops/)
