#### gcloud

Basic commands

    # install
    cd /opt
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-305.0.0-linux-x86_64.tar.gz 
    tar zxf google-cloud-sdk-305.0.0-linux-x86_64.tar.gz
    cd google-cloud-sdk
    ./install.sh

    # after shell restart
    gcloud init --console-only

    # sdk basic information
    gcloud version

    # sdk setup summary
    gcloud info

    # list of configs related to projects and accounts
    gcloud config configurations list

    # list gcloud client configuration
    gcloud config list

    # list accounts
    gcloud auth list

    # login with console only
    gcloud auth login user.name@domain.com --no-launch-browser

    # provide details about project using its name or number
    gcloud projects describe proj-name-123
    gcloud projects describe 123123123123
