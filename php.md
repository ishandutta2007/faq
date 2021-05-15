#### PHP

##### Exmples

connectToJira

    <?php
    $username = 'xxx';
    $password = 'xxx';
    
    $url = 'https://xxx.atlassian.net/rest/api/2/Issue/Bug-5555';
    
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_USERPWD, "$username:$password");
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
    
    $issue_list = (curl_exec($curl));
    echo $issue_list;
    ?>

check users

    <?php
    
    function check_atts_func($url,$users) {
     foreach ($users as $user){
      echo "\n";
      echo "<br><b>Listing orphan boxes for user [$user]</b>\n<table>\n";
      system ("awk -F ',' '/" . $user . "/ {print ". '"<tr><td>"' ."$2" . '"</td><td>"' . "$6" . '"</td><td>"' . "$5" . '"</td></tr>"' . "}' " . $url);
      echo "</table>\n";
     }
    
    }
    
    // test
    check_atts_func ('~/data/inventory.csv', array('user1','not_set'));
    ?>

