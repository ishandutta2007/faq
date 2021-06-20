#### gradle

##### properties

When using gladlew behing the proxy, make sure to set up gradle.properties accordingly:

    systemProp.http.proxyHost=donkey.youcompany.com
    systemProp.http.proxyPort=8080
    systemProp.http.proxyUser=userid
    systemProp.http.proxyPassword=password
    systemProp.http.nonProxyHosts=*.nonproxyrepos.com|localhost
     
    systemProp.https.proxyHost=donkey.yourcompany.com
    systemProp.https.proxyPort=8080
    systemProp.https.proxyUser=userid
    systemProp.https.proxyPassword=password
    systemProp.http.nonProxyHosts=*.nonproxyrepos.com|localhost

    org.gradle.java.home=/opt/jdk/jdk1.8.0_291
    org.gradle.jvmargs=-Xmx1g -XX:MaxMetaspaceSize=512m

##### gradle vs gradlew

more or less

    ./gradlew build

should have similar meaning as 

    /opt/gradle-7.0.2/bin/gradle build

