#### Javascript

##### samples

Automatic gallery

    <!DOCTYPE html>
    <html>
    
    <head>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    </head>
    
    <body>
    Gallery from images subdir of current directory<br/>
    <script type="text/javascript">
    var folder = "images/";
    
    $.ajax({
        url : folder,
        success: function (data) {
            $(data).find("a").attr("href", function (i, val) {
                if( val.match(/\.(jpe?g|png|gif)$/) ) {
                    $("body").append( val +"<br/>" );
                    $("body").append( "<img src=\""+ folder + val +"\"><br/><br/>" );
                }
            });
        }
    });
    </script>
    </body>
    
    </html>


##### links

Some API doc for objects and events

 * https://developer.mozilla.org/en-US/docs/Web/API
 * https://developer.mozilla.org/en-US/docs/Web/Events
