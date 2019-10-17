#### MySQL

How to avoid errors like: connection to database DBNAME failed: [1040] Too many connections

Permanent

    #/etc/my.cnf
    [mysqld]
    max_connections=1000
    interactive_timeout=120
    wait_timeout=120

On the fly

    dbUser='root'
    echo "Accesing mysql DB as root user, please enter the password"
    read -s dbPass

    echo "
    SET GLOBAL max_connections = 1000;
    SET GLOBAL interactive_timeout=120;
    SET GLOBAL wait_timeout=120;
    " | mysql --user=${dbUser} --password=${dbPass}

 
How to list global parameters

All parameters:

    dbUser='root'
    echo "Listing parameters from mysql DB as root user, please enter the password"
    read -s dbPass
    
    #mysqladmin --user=${dbUser} --password=${dbPass} variables \
    # | grep -v '+-' | tr -d ' '| awk -F'|' '{print $2": ["$3"]"}'
    
    mysql --user=${dbUser} --password=${dbPass} --execute="show variables;" \
     | grep -v '+-' | tr -d ' '| awk '{print $1": ["$2"]"}'

A few parameters

    dbUser='root'
    echo "Listing parameters from mysql DB as root user, please enter the password"
    read -s dbPass
    
    #echo "select @@GLOBAL.wait_timeout,@@GLOBAL.interactive_timeout, @@GLOBAL.max_connections;" \
    # | mysql --user=${dbUser} --password=${dbPass}
    
    echo "
    show variables
    where variable_name in (
      'interactive_timeout',
      'max_connections',
      'wait_timeout'
     );
    " | mysql --user=${dbUser} --password=${dbPass} | column -t


List existing tables

    echo "show tables"|mysql test

Restore root password

    service mysql stop
    mysqld_safe --skip-grant-tables &
    mysql -u root
    mysql> use mysql;
    mysql> update user set password=PASSWORD("NEW-ROOT-PASSWORD") where User='root';
    mysql> flush privileges;
    mysql> quit
    service mysql stop
    service mysql start
    mysql -u root -p

Basic user & DB management

    CREATE USER 'daisy'@'localhost' IDENTIFIED BY 'password';
    GRANT ALL PRIVILEGES ON db_database1.* To 'user1'@'localhost' IDENTIFIED BY 'password';
    FLUSH PRIVILEGES;
    
    CREATE DATABASE IF NOT EXISTS foo
    CREATE USER 'daisy'@'localhost' IDENTIFIED BY 'mypass'
    GRANT ALL ON theDB.* TO 'daisy'@'localhost'
    FLUSH PRIVILEGES
    SHOW GRANTS FOR 'daisy'@'localhost'
    DROP USER 'daisy'@'localhost'
    DROP DATABASE IF EXISTS foo

Create and load dump

    mysqldump --add-drop-table db_name > $(date +'%F').db_name.sql
    mysqldump --add-drop-table -h db.host.com -u db_user -pdb_pass db_name > $(date +'%F').db_name.sql 
    
    cat db_dump.sql | mysql -u db_user -pdb_pass
    cat db_dump.sql | mysql -h db.host.com -u db_user -pdb_pass




