#### wiremock

##### install

Download and test

    wget https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-jre8-standalone/2.28.0/wiremock-jre8-standalone-2.28.0.jar
    export JAVA_HOME=your_jdk_path
    ${JAVA_HOME}/bin/java -jar wiremock-jre8-standalone-2.28.0.jar
    #${JAVA_HOME}/bin/java -jar --port 9999 --root-dir /opt/testing/wiremock/stubs" 2>&1 &
    curl http://127.0.0.1:8080/__admin/mappings
    curl http://127.0.0.1:8080/__admin/requests
    curl http://127.0.0.1:8080/__admin/settings
    curl http://127.0.0.1:8080/__admin/files
    curl -X POST http://127.0.0.1:8080/__admin/shutdown

Documentation: 

 * wiremock self-documentation http://127.0.0.1:8080/__admin/swagger-ui/
 * http://wiremock.org/docs/api/
 * https://github.com/WireMock-Net/WireMock.Net/wiki/Admin-API-Reference

##### import/export

Import

    # upload json file
    curl -v -d @example-stubs.json http://localhost:8080/__admin/mappings/import

    # copy json file to mappiing directory & reset
    cp example-stubs.json ${WIREMOCK_HOME}/mappings
    curl -v -X POST http://localhost:8080/__admin/mappings/reset

Export

    curl --output example-stubs.json http://localhost:8080/__admin/mappings

##### examples

Sample req/res & mapping as in http://wiremock.org/docs/response-templating/

Regex:

 * mapping (mappings/soapExample.json)

       {
        "request": {
          "url": "/server/soapReqResp/soapBody.asmx",
          "method": "POST"
        },
       
        "response":  {
          "status": 200,
          "headers": { "Content-Type" : "application/xml; charset=utf-8" },
          "body": "ACTION [ {{regexExtract request.body 'Action>(.+)<' 'parts'}}{{parts.0}} ]\n"
        }
       }

 * req

       curl \
        --request POST \
        --header "Content-Type: text/xml;charset=UTF-8" \
        --data \
       '<soap-env:Envelope xmlns:eb="http://www.org1.org/namespaces/ns1" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"> \
         <soap-env:Header> \
          <eb:NS eb:version="1.0" soap-env:mustUnderstand="1"> \
          <eb:Action>SomeReq</eb:Action> \
        </soap-env:Header> \
        <soap-env:Body> \
         <SomeData TimeStamp="2011-09-01T13:30:00" xmlns="http://webservices.domain.com/nsXML/2011/10" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/> \
        </soap-env:Body> \
       </soap-env:Envelope> ' \
        http://localhost:8080/server/soapReqResp/soapBody.asmx

 * resp

       ACTION [ SomeReq ]

Same with files usage

 * mapping (mappings/soapReqResp.json)

       {
        "request": {
          "url": "/server/soapReqResp/soapFile.asmx",
          "method": "POST"
        },
       
        "response":  {
          "status": 200,
          "headers": { "Content-Type" : "application/xml; charset=utf-8" },
          "bodyFileName" : "soapReqResp/{{regexExtract request.body  'Action>(.+)<' 'parts'}}{{parts.0}}.resp.xml"
        }
       }

 * file (__files/soapReqResp/SomeReq.resp.xml)

       ACTION [ SomeReq ] from file

 * req

       curl \
        --request POST \
        --header "Content-Type: text/xml;charset=UTF-8" \
        --data \
       '<soap-env:Envelope xmlns:eb="http://www.org1.org/namespaces/ns1" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"> \
         <soap-env:Header> \
          <eb:NS eb:version="1.0" soap-env:mustUnderstand="1"> \
          <eb:Action>SomeReq</eb:Action> \
        </soap-env:Header> \
        <soap-env:Body> \
         <SomeData TimeStamp="2011-09-01T13:30:00" xmlns="http://webservices.domain.com/nsXML/2011/10" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/> \
        </soap-env:Body> \
       </soap-env:Envelope> ' \
        http://localhost:8080/server/soapReqResp/soapFile.asmx

 * resp

       ACTION [ SomeReq ] from file
