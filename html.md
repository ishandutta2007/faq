#### HTML

##### Including other content

Iframes

Simple way:

    <iframe src="some.html" style="border: none; display:block; width:100%; height:100vh;">
    </iframe>

Better solution

    <script>
      function resizeIframe(obj) {
        obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
        obj.style.width = obj.contentWindow.document.body.scrollWidth + 'px';
      }
    </script>
    <iframe src="some.html" style="border: none" onload="resizeIframe(this)">
    </iframe>

##### Easy html to text

    links -dump -width 300 [URL|file.html]
