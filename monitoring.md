#### Monitoring

##### OS (Linux)

Basic stuff

    vmstat

Per process

    for i in $(seq 3);do (sleep 1; date +'%FT%T'"   $(ps --no-headers -p 10444 -o pcpu,vsz)") ;done

##### JVM (Oracle)

Local process

    jstat -gc -t PID 1000 2

Remote process

    # setup jstatd policy file on hostX
    echo 'grant codebase "file:${java.home}/../lib/tools.jar" {permission java.security.AllPermission; };' > jstatd.policy.file

    # run jstatd on hostX
    jstatd -p 1099 -J-Djava.security.policy=jstatd.policy.file &

    # check if this can be connected on hostY
    jps -l -m -v hostX
    #jps -l -m -v rmi://hostX:1099

    # on hostX run the process you want to track from hostY
    ./run.my.proc.with.params.bash    

    # check process list again from hostY
    jps -l -m -v hostX
    32497 mockserver-netty-5.8.1-jar-with-dependencies.jar -serverPort 43210
    31715 sun.tools.jstatd.Jstatd -p 1099 -Dapplication.home=/home/user/java/jdk1.8.0_131 -Xms8m -Djava.security.policy=jstatd.policy.file

    # track your process from hostY
    jstat -gcutil -t 32497@hostX 2000 3
    Timestamp         S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT     GCT
              329.4   0.00   0.00  56.00   0.00  17.29  19.76      0    0.000     0    0.000    0.000
              331.4   0.00   0.00  56.00   0.00  17.29  19.76      0    0.000     0    0.000    0.000
              333.4   0.00   0.00  56.00   0.00  17.29  19.76      0    0.000     0    0.000    0.000


Alternative way for remote process

    # run your java proc on hostX
    ./run.my.proc.with.params.bash
    jps -l -m -v
    32497 mockserver-netty-5.8.1-jar-with-dependencies.jar -serverPort 43210
    3809 sun.tools.jps.Jps -lmv -Dapplication.home=/home/user/java/jdk1.8.0_131 -Xms8m

    # set up nc server on hostY
    nc -l 10001 > gc.log
    #nc -k -l 10001 > gc.log

    # send data locally from hostX to remote file on hostY
    jstat -gcutil -t 32497 1000 3600 | nc hostY 10001

Monitoring on github:
 * https://github.com/micrometer-metrics/micrometer/archive/refs/heads/main.zip
 * https://github.com/sematext/sematext-agent-integrations
