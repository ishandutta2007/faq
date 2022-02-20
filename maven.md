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


Compiling jars with all dependencies (non-executable)

    mvn package -DskipTests -Dmaven.javadoc.skip=true  -Dmaven.source.skip=true

Code

    <plugins>
      <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
        </configuration>
        <executions>
          <execution>
            <id>make-assembly</id> <!-- this is used for inheritance merges -->
            <phase>package</phase> <!-- bind to the packaging phase -->
            <goals>
              <goal>single</goal>
            </goals>
          </execution>
        </executions>
      </plugin>

Compiling jars with all dependencies (executable)

    mvn package -DskipTests -Dmaven.javadoc.skip=true  -Dmaven.source.skip=true

Code

    <plugins>
      <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
          <archive>
            <manifest>
              <mainClass>org.sample.App</mainClass>
            </manifest>
          </archive>
        </configuration>
        <executions>
          <execution>
            <id>make-assembly</id> <!-- this is used for inheritance merges -->
            <phase>package</phase> <!-- bind to the packaging phase -->
            <goals>
              <goal>single</goal>
            </goals>
          </execution>
        </executions>
      </plugin>

Reference: https://maven.apache.org/plugins/maven-assembly-plugin/usage.html
