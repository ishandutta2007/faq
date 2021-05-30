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
