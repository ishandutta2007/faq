#### WORDPRESS

Installing

    mkdir /apps/wordpress/gui
    mkdir /apps/wordpress/db
    cd /apps/wordpress/gui/
    wget https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    
    sudo yum install php php-mysql
    
    sudo yum install mariadb-server
    sudo systemctl start mariadb
    sudo systemctl status mariadb
    
    sudo yum install httpd
    sudo systemctl start httpd
    sudo systemctl status httpd

    echo '
    CREATE DATABASE wordpress;
    GRANT ALL PRIVILEGES ON wordpress.* TO "wordpress"@"localhost" IDENTIFIED BY "wpadminpas";
    FLUSH PRIVILEGES;
    ' | mysql -u root
    echo 'show databases' | mysql -u wordpress -pwpadminpas wordpress
    
    # update secrets from the defaults
    sed 's/database_name_here/wordpress/; s/username_here/wordpress/; s/password_here/wpadminpas/' /apps/wordpress/gui/wordpress/wp-config-sample.php > /apps/wordpress/gui/wordpress/wp-config.php
    dos2unix /apps/wordpress/gui/wordpress/wp-config.php
    wget -q -O - https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/patch
    sed -i "/define('AUTH_KEY'/ r/tmp/patch" /apps/wordpress/gui/wordpress/wp-config.php 
    sed -i '/put your unique phrase here/, 1d' /apps/wordpress/gui/wordpress/wp-config.php
    rm /tmp/patch

Plugins: 

 * set up header-based authentication: https://wordpress.org/plugins/header-login/
 * shiboleth authentication via REMOTE_USER server parameter: https://wordpress.org/plugins/http-authentication/
 * serach engine: https://wordpress.org/plugins/search-in-place/
 * roles management: https://wordpress.org/plugins/multiple-roles/
 * stats: https://wordpress.org/plugins/wp-slimstat/
 * external docs: https://wordpress.org/plugins/tgn-embed-everything/
	

Debugging

    # add in /wp-config.php followig
    define('WP_DEBUG', true);
    define('WP_DEBUG_LOG', true);

    # add in the code:
    error_log("your message");
	
Maintenance

 # fix for Host 'host-xyz' is blocked because of many connection errors; unblock with 'mysqladmin flush-hosts'
mysqladmin -u root -pwp_admin flush-hosts

