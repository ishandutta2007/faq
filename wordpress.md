#### WORDPRESS

##### Installing

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

##### Plugins 

Useful plugins used befire:

 * [set up header-based authentication](https://wordpress.org/plugins/header-login/)
 * [shiboleth authentication via REMOTE_USER server parameter](https://wordpress.org/plugins/http-authentication/)
 * [search engine](https://wordpress.org/plugins/search-in-place/)
 * [roles management](https://wordpress.org/plugins/multiple-roles/)
 * [stats](https://wordpress.org/plugins/wp-slimstat/)
 * [external docs](https://wordpress.org/plugins/tgn-embed-everything/)
	

##### Debugging

Issues logging

    # add in /wp-config.php followig
    define('WP_DEBUG', true);
    define('WP_DEBUG_LOG', true);

    # add in the code:
    error_log("your message");
	
##### Maintenance

Can't connect to DB

 # fix for Host 'host-xyz' is blocked because of many connection errors; unblock with 'mysqladmin flush-hosts'
mysqladmin -u root -pwp_admin flush-hosts

Command line management with [wp-cli](https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar)


##### SQLs

Check users meta

    SELECT
     fn.user_id,
     fn.meta_value,
     ln.meta_value
    FROM
     wp_usermeta fn,
     wp_usermeta ln
    WHERE
     fn.meta_key ='first_name'
     and ln.meta_key ='last_name'
     and fn.user_id = ln.user_id
    
    -- mysql> describe wp_usermeta;
    -- +------------+---------------------+------+-----+---------+----------------+
    -- | Field      | Type                | Null | Key | Default | Extra          |
    -- +------------+---------------------+------+-----+---------+----------------+
    -- | umeta_id   | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
    -- | user_id    | bigint(20) unsigned | NO   | MUL | 0       |                |
    -- | meta_key   | varchar(255)        | YES  | MUL | NULL    |                |
    -- | meta_value | longtext            | YES  |     | NULL    |                |
    -- +------------+---------------------+------+-----+---------+----------------+

Check users

    SELECT
     user_login,
     user_nicename,
     user_email,
     display_name
     FROM wp_users ;
    
    -- mysql> describe wp_users;
    -- +---------------------+---------------------+------+-----+---------------------+----------------+
    -- | Field               | Type                | Null | Key | Default             | Extra          |
    -- +---------------------+---------------------+------+-----+---------------------+----------------+
    -- | ID                  | bigint(20) unsigned | NO   | PRI | NULL                | auto_increment |
    -- | user_login          | varchar(60)         | NO   | MUL |                     |                |
    -- | user_pass           | varchar(255)        | NO   |     |                     |                |
    -- | user_nicename       | varchar(50)         | NO   | MUL |                     |                |
    -- | user_email          | varchar(100)        | NO   | MUL |                     |                |
    -- | user_url            | varchar(100)        | NO   |     |                     |                |
    -- | user_registered     | datetime            | NO   |     | 0000-00-00 00:00:00 |                |
    -- | user_activation_key | varchar(255)        | NO   |     |                     |                |
    -- | user_status         | int(11)             | NO   |     | 0                   |                |
    -- | display_name        | varchar(250)        | NO   |     |                     |                |
    -- +---------------------+---------------------+------+-----+---------------------+----------------+

Simple test

    SELECT
    
     SUBSTRING_INDEX(
      REPLACE(
       REPLACE(
        wp_users.user_email, '@domain.com', '' -- remove mail part
       ), '.', ' '                            -- remove dot between names
      ), ' ', 1                               -- pick 1st name
     ) as 1st,
     
     SUBSTRING_INDEX(
      REPLACE(
       REPLACE(
        REPLACE(
         REPLACE(
          wp_users.user_email, '@domain.com', '' -- remove mail part
         ), '.', ' '                            -- remove dot between names
        ), ' X ', ' '                           -- remove X from contarctors
       ), ' ctr', ''                            -- remove ctr from contractors
      ), ' ', -1                                -- pick 2nd name
     ) as 2nd
    
    FROM
     wp_users,
     wp_usermeta
    WHERE
     wp_users.ID = wp_usermeta.user_id
     and wp_usermeta.meta_key = 'first_name'
     -- and wp_users.ID = 2
    ;

Update user display name

    UPDATE
     wp_users
    SET
     display_name = REPLACE( REPLACE(user_email, '@domain.com', '') , '.', ' ');

Update first and last name

    UPDATE
     wp_usermeta,
     wp_users 
    SET
     wp_usermeta.meta_value = SUBSTRING_INDEX(
      REPLACE(
       REPLACE(
        wp_users.user_email, '@domain.com', '' -- remove mail part
       ), '.', ' '                            -- remove dot between names
      ), ' ', 1                               -- pick 1st name
     )
    WHERE
     wp_users.ID = wp_usermeta.user_id
     and wp_usermeta.meta_key = 'first_name'
     -- and wp_users.ID = 2
    ;
    
    UPDATE
     wp_usermeta,
     wp_users 
    SET
     wp_usermeta.meta_value = SUBSTRING_INDEX(
      REPLACE(
       REPLACE(
        REPLACE(
         REPLACE(
          wp_users.user_email, '@domain.com', '' -- remove mail part
         ), '.', ' '                            -- remove dot between names
        ), ' X ', ' '                           -- remove X from contarctors
       ), ' ctr', ''                            -- remove ctr from contractors
      ), ' ', -1                                -- pick 2nd name
     )
    WHERE
     wp_users.ID = wp_usermeta.user_id
     and wp_usermeta.meta_key = 'last_name'
     -- and wp_users.ID = 2
    ;

##### wp-cli

Install client

    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

Update client
    
    echo ''
    echo 'Old version details:'
    echo '....................................'
    ./wp-cli.phar --info
    
    echo ''
    echo 'Updating'
    echo '....................................'
    rm wp-cli.phar
    curl -q -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod 0755 wp-cli.phar
    version=`./wp-cli.phar --info | grep 'WP-CLI version' | sed 's/.*\t//'`
    mv wp-cli.phar wp-cli.phar.${version}
    ln -s wp-cli.phar.${version} wp-cli.phar
    
    echo ''
    echo 'New version details:'
    echo '....................................'
    ./wp-cli.phar --info

Samples of usage

    ./wp-cli.phar core check-update --path=/apps/wordpress/

    ./wp-cli.phar plugin search "${1}" --path=/apps/wordpress/
    ./wp-cli.phar plugin install "${1}" --path=/apps/wordpress/
    ./wp-cli.phar plugin activate "${1}" --path=/apps/wordpress/
    ./wp-cli.phar plugin status --path=/apps/wordpress/ | grep '^ U'
    ./wp-cli.phar plugin delete "${1}" --path=/apps/wordpress/

    ./wp-cli.phar theme status --path=/apps/wordpress/ | grep '^ U'
    
Manage plugins

    for myPlugin in \
     customer-area
    do
     #./wp-cli.phar plugin install ${myPlugin} --path=/apps/wordpress/
     #./wp-cli.phar plugin activate ${myPlugin} --path=/apps/wordpress/
     ./wp-cli.phar plugin deactivate ${myPlugin} --path=/apps/wordpress/
     ./wp-cli.phar plugin delete ${myPlugin} --path=/apps/wordpress/
    done

    #wp-private-content-plus
    # press-permit-core
    # user-access-manager \
    # capability-manager-enhanced \
    # user-role-editor \
    # role-scoper \
    # members \
    # advanced-access-manager \
    # user-management-tools

Update all plugins

    ./wp-cli.phar plugin update --all --path=/apps/wordpress/

Update all plugins manually

    cd `dirname $0`
    myLocation='/tmp/wp_latest_plugins'
    mkdir -p ${myLocation}
    rm ${myLocation}/*.zip
    
    for myPlugin in `./wp-cli.phar plugin status --path=/apps/wordpress/ | grep '^ U' | awk '{print $2}'`
    do
     cd ${myLocation}
     echo ${myPlugin}
     wget https://downloads.wordpress.org/plugin/${myPlugin}.zip
    done
    cd `dirname $0`

Update core

    ./wp-cli.phar core update --path=/apps/wordpress/

Bash completion for the `wp` command

    _wp_complete() {
    	local OLD_IFS="$IFS"
    	local cur=${COMP_WORDS[COMP_CWORD]}
    
    	IFS=$'\n';  # want to preserve spaces at the end
    	local opts="$(wp cli completions --line="$COMP_LINE" --point="$COMP_POINT")"
    
    	if [[ "$opts" =~ \<file\>\s* ]]
    	then
    		COMPREPLY=( $(compgen -f -- $cur) )
    	elif [[ $opts = "" ]]
    	then
    		COMPREPLY=( $(compgen -f -- $cur) )
    	else
    		COMPREPLY=( ${opts[*]} )
    	fi
    
    	IFS="$OLD_IFS"
    	return 0
    }
    complete -o nospace -F _wp_complete wp

Other smaples of usage

    my_path='/apps/wordpress/'
    
    ./wp-cli.phar core version --path=${my_path}
    ./wp-cli.phar core check-update --path=${my_path}
    ./wp-cli.phar core update --path=${my_path}
    
    ./wp-cli.phar plugin status --path=${my_path}
    ./wp-cli.phar plugin update --all --path=${my_path}
    
    plugin='saml-20-single-sign-on'
    ./wp-cli.phar plugin search "ajax search lite" --path=${my_path}
    ./wp-cli.phar plugin search "ajax search lite" --path=${my_path} --skip-plugins
    ./wp-cli.phar plugin deactivate ${plugin} --path=${my_path}
    ./wp-cli.phar plugin delete ${plugin} --path=${my_path}
    ./wp-cli.phar plugin install ${plugin} --path=${my_path}
    ./wp-cli.phar plugin activate ${plugin} --path=${my_path}
    
    ./wp-cli.phar theme status --path=${my_path}
    ./wp-cli.phar theme update --all --path=${my_path}

Sample yaml config

    # Global parameter defaults
    path: /apps/wordpress/
    #url: http://example.com
    #user: admin
    color: false
    #disabled_commands:
    # - db drop
    # - plugin install
    #require:
    # - path-to/command.php
    
    # Subcommand defaults (e.g. `wp core config`)
    core config:
     #dbuser: root
     #dbpass: 
     extra-php: |
      define( 'WP_DEBUG', true );
    
    ## Aliases to other WordPress installs (e.g. `wp @staging rewrite flush`)
    ## An alias can include 'user', 'url', 'path', 'ssh', or 'http'
    #@staging:
    # ssh: wpcli@staging.wp-cli.org
    # user: wpcli
    # path: /srv/www/staging.wp-cli.org
    #@production
    # ssh: wpcli@wp-cli.org:2222
    # user: wpcli
    # path: /srv/www/wp-cli.org
