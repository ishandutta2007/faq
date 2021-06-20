#### Docker

##### install

    sudo yum check-update
    curl -fsSL https://get.docker.com/ | sh
    sudo systemctl start docker
    #sudo service docker status
    sudo systemctl status docker
    sudo systemctl enable docker
        
##### install on WSL1 and win10

Install Hyper-v

Only when Hyper-v installed, install Docker Desktop for windows

Update docker desktop settings (only 'Expose daemon on tcp://localhost:2375 without TLS' should be checked')

Setup docker on Ubuntu on WSL1 as described in https://docs.docker.com/engine/install/ubuntu/
    
    $ sudo apt-get update
    $ sudo apt-get install \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg \
       lsb-release
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    $ apt-cache policy docker-ce
    $ sudo apt install docker-ce
    $ sudo systemctl status docker
    $ usermod -aG docker youruser
    $ systemctl status docker
    $ apt-get install docker.io
    $ export DOCKER_HOST=tcp://127.0.0.1:2375
    
##### Image basic operations

    $ mkdir -p ~/docker/test
    $ cd ~/docker/test
    
    $ echo "
    #!/usr/bin/env python3
    print("Docker smoker")
    " > main.py
    
    $ echo "
    FROM python:latest
    COPY main.py /tmp
    CMD [ "python", "/tmp/main.py" ]
    " > Dockerfile
    
    $ cd ..
    $ docker build -t python-test test
    Sending build context to Docker daemon  3.584kB
    Step 1/3 : FROM python:latest
    ---> 5b3b4504ff1f
    Step 2/3 : COPY main.py /tmp
    ---> Using cache
    ---> 5a976075747a
    Step 3/3 : CMD [ "python", "/tmp/main.py" ]
    ---> Using cache
    ---> d113c64212ff
    Successfully built d113c64212ff
    Successfully tagged python-test:latest
    
    $ #docker image ls
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    python-test         latest              d113c64212ff        2 minutes ago       886MB
    python              latest              5b3b4504ff1f        2 weeks ago         886MB
    
    $ docker run python-test
    Docker smoker

List containers

    $ docker container ls -a
    CONTAINER ID        IMAGE               COMMAND                 CREATED             STATUS                      PORTS               NAMES
    98442f1a030d        python-test         "python /tmp/main.py"   4 minutes ago       Exited (0) 6 minutes ago                        flamboyant_murdock

Get image from repo

    #docker save python-test:latest > /tmp/python-test.latest.tar
    docker save python-test:latest | gzip > /tmp/python-test.latest.tar.gz

Delete container

    docker rm 98442f1a030d


Rename image

    docker tag python-test:latest python-test:2021.01

Delete not needed image tag
    
    docker rmi python-test:latest

Delete image

    docker rmi python-test:2021.01

Import image

    docker load < /tmp/python-test.latest.tar.gz

Verify again

    docker run python-test

Exmamine docker image content 

    docker run -it python-test sh

Exmamine docker image history 

    docker image history --no-trunc python-test > image_history.txt

Create dockerfile from image with following script:

    docker history --no-trunc --format "{{.CreatedBy}}" $1  | # extract information from layers
     tac                                                    | # reverse the file
     sed 's,^\(|3.*\)\?/bin/\(ba\)\?sh -c,RUN,'             | # change /bin/(ba)?sh calls to RUN
     sed 's,^RUN #(nop) *,,'                                | # remove RUN #(nop) calls for ENV,LABEL...
     sed 's,  *&&  *, \\\n \&\& ,g'                           # pretty print multi command lines following Docker best practices

##### moving image from local to remote repo

Push image to remote repository and verify

    localImage='python-test'
    localTag='2021.01'
    
    remotePath='mycompany/myprj'
    remoteImage=${localImage}
    remoteTag=${localTag}
    
    curl -s -u ${repoUser}:${repoPass} ${repoProto}://${repoHost}:${repoPort}/v2/${remotePath}/${remoteImage}/tags/list \
     | jsonlint --format
    
    docker login ${repoHost}:${repoPort} --username ${repoUser} --password ${repoPass}
    docker image tag ${localImage}:${localTag} ${repoHost}:${repoPort}/${remotePath}/${remoteImage}:${remoteTag}
    docker image push ${repoHost}:${repoPort}/${remotePath}/${remoteImage}:${remoteTag}
    
    curl -s -u ${repoUser}:${repoPass} ${repoProto}://${repoHost}:${repoPort}/v2/${remotePath}/${localImage}/tags/list \
     | jsonlint --format


##### bascis of container

List containers

    docker container ls -a

Remove not used ones

    docker container prune

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

    # login to different repo, may be required to pull image from that repo
    docker login ${repoHost}:${repoPort} -u ${repoUser} -p ${repoPass}
    #echo ${repoPass} | docker login ${repoHost}:${repoPort} -u ${repoUser} --password-stdin

    # list only running containers
    docker ps | grep hello
    # list running and stopped containers
    docker ps --all | grep hello
    # list stopped containers
    docker ps -f "status=exited"


##### first deploy

Create docker file

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

Build from dir with Dockerfile

    docker build --tag bulletinboard:1.0 .

Run image as container

    docker run --publish 8338:8080 --detach --name userX_bb bulletinboard:1.0

Remove image and container

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

