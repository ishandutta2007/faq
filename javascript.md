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

Toggle element visibility

    function toggle_visibility(id){
      var e = document.getElementById(id);
      if(e.style.display == 'block')
         e.style.display = 'none';
      else
         e.style.display = 'block';
    }

Fitting iframes

    // for iframe you need to add style="border: none" onload="resizeIframe(this)" in properties
    function resizeIframe(obj) {
      obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
      obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';
    }



##### debug

Working with console

    // debug object
    console.log(myObject);

    // debug object as a table
    console.table(myOobject);

    // colorize
    console.todo = function(msg) {
     console.log(' % c % s % s % s', 'color: yellow; background - color: black;', '-', msg, '-');
    }
    console.todo("stop 1");
    
    // colorize 
    console.important = function(msg) {
     console.log(' % c % s % s % s', 'color: brown; font - weight: bold; text - decoration: underline;', '-', msg, '-');
    }
    console.important("stop 1");

    // get timing
    console.time('Timer1');
    // some code bettween
    console.timeEnd('Timer1');

##### links

Some API doc for objects and events

 * https://developer.mozilla.org/en-US/docs/Web/API
 * https://developer.mozilla.org/en-US/docs/Web/Events
