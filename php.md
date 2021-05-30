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

upload file, part 1

    //upload.php
    <html>
    <head></head>
    <body>
    <h4> File uploads </h4>
    <form enctype="multipart/form-data" action="upload.info.php"
            method="post">
    <p>
    Select File:
    <input type="file" size="35" name="uploadedfile" />
    <br />
    
    <!--Destination
    <input type="text" size="35" name="destination"
           value= "<?php echo $_ENV["USER"];?>" />
    <br />
    -->
    <input type="submit" name="Upload" value="Upload" />
    </p>
    </form>
    </body>
    </html>

upload file, part 2

    //upload.info.php
    <?php
    
    //$destination_path = $_REQUEST["destination"] . "/";
    //$target_path = "/tmp/" . $destination_path;
    //$target_path = $target_path . basename( $_FILES['uploadedfile']['name']);
    $target_path = "/tmp/" . basename( $_FILES['uploadedfile']['name']);
    
    echo "User=" .          $_ENV[USER] . "<br />";
    echo "Source=" .        $_FILES['uploadedfile']['name'] . "<br />";
    //echo "Destination=" .   $destination_path . "<br />";
    echo "Target path=" .   $target_path . "<br />";
    echo "Size=" .          $_FILES['uploadedfile']['size'] . "<br />";
    //echo "Tmp name=" .    $_FILES['uploadedfile']['tmp_name'] . "<br />";
    
    
    if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {
        echo "The file ".  basename( $_FILES['uploadedfile']['name']).
        " has been uploaded";
    } else{
        echo "There was an error uploading the file, please try again!";
    }
    ?>
