#### Remote access

##### Examples

basic server

    while [[ 1 -eq 1 ]]
    do
     nc -vlp 8080 -c '(
      read a
      echo -e "HTTP/1.0 200 OK\n\n"
      echo $(date)
      echo "Enter command to execute"
      cmd=$(echo $a | sed "s/GET //;s/ HTTP.*//;s/^\///;s/%20/ /g")
      echo [$cmd]
      $cmd 2>&1
     )'
    done

httpd servers

    # python 2
    if [[ 1 -eq 1 ]]; then
     python -m SimpleHTTPServer 8000
    fi
    
    # python 3
    if [[ 0 -eq 1 ]]; then
     python3 -m http.server 8000
    fi
    
    # php
    if [[ 0 -eq 1 ]]; then
     php -S localhost:8000
    fi
    
    # ruby
    if [[ 0 -eq 1 ]]; then
     ruby -run -e httpd . -p 8080
    fi


