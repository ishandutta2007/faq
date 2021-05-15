#### Phantomjs

##### Examples

bash script

    webPage='http://some.page.with.js.com'
    
    cd $(dirname $0)
    echo ''
    echo '############### page source ###############'
    wget --quiet -O wget.html ${webPage} > nojs.html
    
    echo ''
    echo '############### js code execution ###############'
    phantomjs getFullPageWithJs.js ${webPage} > phantomjs.html

getFullPageWithJs.js

    var system = require('system');
    var page = require('webpage').create();
    //var fs = require('fs');
    //var path = 'index.html';
    
    //page.includeJs("lib/jquery-3.2.1.min.js")
    page.open(system.args[1], function (status) {
        if(status !== 'success')
            console.log('Connection failed, page was not loaded!');
        else
            var content = page.content;
            console.log(content);
            //fs.write(path, content ,'w')
            phantom.exit();
    });

getGceasyioReport.js

    var system = require('system');
    var webPage = require('webpage');
    var page = webPage.create();
    
    var fs = require('fs');
    var reportZipFile = 'gc.log.zip';
    var postData = fs.read(reportZipFile);
    
    //request main
    var requestUrl = 'http://gceasydumps.s3.amazonaws.com/';
    var postBody = '';
    var settings = {
      operation: "POST",
      encoding: "utf8",
      headers: {
       "User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 OPR/45.0.2552.898",
       "Referer": "http://gceasy.io/",
       "Origin": "null"
      data:{}
    };
    
    page.open(requestUrl, settings, function (status) {
        if(status !== 'success')
            console.log('Connection failed, page was not loaded!');
        else
            var content = page.content;
            console.log(content);
            //fs.write(path, content ,'w')
            phantom.exit();
    });
    
    phantom.exit();

