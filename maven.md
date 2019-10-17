#### Maven


##### Basic tasks

Compiling with maven from command line over proxy

    export JAVA_HOME='/opt/tools/java/x86-GNU_Linux_64bit/jdk1.8.0'
    /opt/tools/maven/bin/mvn --settings ./maven-settings.xml dependency:tree
    /opt/tools/maven/bin/mvn --settings ./maven-settings.xml clean package
    #if you wanto to skip tests:
    /opt/tools/maven/bin/mvn --settings ./maven-settings.xml clean package -DskipTests

Content of maven-setting.xml

    <settings>
    
      <profiles>
       <profile>
        <id>myprofile</id>
    
         <repositories>
    
          <repository>
           <id>domain-maven-releases</id>
           <url>http://maven.domain.com/content/repositories/releases/</url>
          </repository>
    
          <repository>
           <id>central</id>
           <url>https://repo.maven.apache.org/maven2/</url>
          </repository>
    
         </repositories>
    
       </profile>
     </profiles>
    
     <activeProfiles>
      <activeProfile>myprofile</activeProfile>
     </activeProfiles>
    
     <proxies>
      <proxy>
       <active>true</active>
       <protocol>http</protocol>
       <host>www-proxy.company.com</host>
       <port>80</port>
       <username>theUser</username>
       <password>thePass</password>
       <nonProxyHosts>*.company.com</nonProxyHosts>
      </proxy>
     </proxies>
    
    </settings>



