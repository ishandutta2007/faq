#### Docker

##### install

    sudo yum check-update
    curl -fsSL https://get.docker.com/ | sh
    sudo systemctl start docker
    sudo systemctl status docker
    sudo systemctl enable docker
        

##### Oneliners

    # creating, running and accessing the container
    appName='some_webservice_wordpress'
    appInstance=$(docker ps | grep ${appName} | sed 's/.* //' | head -n1)  # get name to connect to
    docker inspect ${appInstance}                                          # get all details
    echo 'ps -ef' | docker exec -i  ${appInstance} bash                    # execute command on the instance
    docker exec -i -t ${appInstance} bash                                  # connect to the instanace

