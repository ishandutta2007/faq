#### Docker

##### install

    sudo yum check-update
    curl -fsSL https://get.docker.com/ | sh
    sudo systemctl start docker
    #sudo service docker status
    sudo systemctl status docker
    sudo systemctl enable docker
        

##### configuration

    # check deamon config
    cat /etc/docker/daemon.json


##### setup validation

    # check version
    docker version
    # check if validtion (hello-world) image is available
    docker image ls | grep hello
    # run validation (runs basic containter and exits)
    docker run hello-world
    # verify it exited
    docker ps --filter "status=exited"

##### basic operations

    # list remote repo with curl
    export repoProto='https'
    export repoHost='docker-img-repo.domain.com'
    export repoPort='12345'
    export repoUser='John'
    export repoPass='secret'
    curl ${repoProto}://${repoUser}:${repoPass}@${repoHost}:${repoPort}/v2/_catalog
    #curl -u ${repoUser}:${repoPass} ${repoProto}://${repoHost}:${repoPort}/v2/_catalog

    # list repo tags
    curl ${repoProto}://${repoUser}:${repoPass}@${repoHost}:${repoPort}/v2/_catalog/

    # search for image of centos in default repo
    docker search centos

    # login to different repo
    docker login ${repoHost}:${repoPort} -u ${repoUser} -p ${repoPass}
    #echo ${repoPass} | docker login ${repoHost}:${repoPort} -u ${repoUser} --password-stdin

    # list only running containers
    docker ps | grep hello
    # list running and stopped containers
    docker ps --all | grep hello
    # list stopped containers
    docker ps -f "status=exited"


##### first deploy

    # create docker file

    # Use the official image as a parent image.
    FROM node:current-slim
    # Set the working directory.
    WORKDIR /usr/src/app
    # Copy the file from your host to your current location.
    COPY package.json .
    # Run the command inside your image filesystem.
    RUN npm install
    # Inform Docker that the container is listening on the specified port at runtime.
    EXPOSE 8080
    # Run the specified command within the container.
    CMD [ "npm", "start" ]
    # Copy the rest of your app's source code from your host to your image filesystem.
    COPY . .

    # build from dir with Dockerfile
    docker build --tag bulletinboard:1.0 .

    # run image as container
    docker run --publish 8338:8080 --detach --name userX_bb bulletinboard:1.0

    # remove image and container
    docker rm --force userX_bb

##### cleanup

    # remove container
    docker rm ${containerId}
    # remove image
    docker rmi ${imageId}
    
    # list orphan images
    sudo docker images -f dangling=true
    # remove orphan images
    docker rmi $(docker images -f dangling=true -q)

    # clean up any resources (images, containers, volumes, networks) that are dangling (not associated with a container)
    docker system prune
    # remove any stopped containers and all unused images (not just dangling images)
    docker system prune -a

##### Oneliners

    # creating, running and accessing the container
    appName='some_webservice_wordpress'
    appInstance=$(docker ps | grep ${appName} | sed 's/.* //' | head -n1)  # get name to connect to
    docker inspect ${appInstance}                                          # get all details
    echo 'ps -ef' | docker exec -i  ${appInstance} bash                    # execute command on the instance
    docker exec -i -t ${appInstance} bash                                  # connect to the instanace

