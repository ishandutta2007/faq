#### GCP

URL: https://cloud.google.com/

#### Linux

##### setup client

install SDK (ubuntu)

    echo 'setup proxy if needed'
    source ~/cfg/proxy.txt

    echo '# Add the Cloud SDK distribution URI as a package source'
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
    
    echo '# Import the Google Cloud Platform public key'
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    
    echo '# Update the package list and install the Cloud SDK'
    apt-get update && apt-get install google-cloud-sdk

configure client

 * create google account
 * start with gcp (don't go for credit card details)
 * open web console from https://console.cloud.google.com web gui
 * create basic structures

       # verify account and configuration
       gcloud auth list
       gcloud config configurations list

       # create project
       gcloud projects create basic-prj --name="Test project"
       gcloud config set project basic-prj

       # make sure you have owner rights
       gcloud projects get-iam-policy basic-prj
       #gcloud projects add-iam-policy-binding basic-prj --member "serviceAccount:sa-test@basic-prj.iam.gserviceaccount.com" --role "roles/owner"
       
       # create service account
       gcloud iam service-accounts create sa-test \
        --description "test service account" \
        --display-name "test service account"\
        --project "basic-prj"

       gcloud iam service-accounts list
       gcloud iam service-accounts describe sa-test@basic-prj.iam.gserviceaccount.com

       # create service key
       gcloud iam service-accounts keys create ~/key.json --iam-account sa-test@basic-prj.iam.gserviceaccount.com
       gcloud iam service-accounts keys list --iam-account sa-test@basic-prj.iam.gserviceaccount.com

       # authorizing & init with a user account
       gcloud init --console-only

       # authorizing with a service account
       #export GOOGLE_APPLICATION_CREDENTIALS="/home/user/goole.sa.key.json"
       #gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

##### login & looking around

     gcloud compute instances list --format="value(name,disks[].source)"


##### set up VNC on pod

To verify

     # https://cr.yp.to/ucspi-tcp/install.html
     localhost> apt-get install ucspi-tcp
     
     localhost> tcpserver 127.0.0.1 8000 kubectl exec -i remotePod nc 127.0.0.1 8080
     # e.g. to access remotePod:8080 -> curl 127.0.0.1:8000

     localhost> nc 127.0.0.1 8000 | kubectl exec -i remotePod tcpserver 127.0.0.1 8080 cat
     # e.g. to access localhost:8000 from remotePod -> curl 127.0.0.1:8080

Script based on [example](https://webapp.io/blog/container-tcp-tunnel/)

    # e.g. kubetunnel remotePod 8080
    kubetunnel() {
    
        POD="$1"
        DESTPORT="$2"
        if [ -z "$POD" -o -z "$DESTPORT" ]; then
        	echo "Usage: kubetunnel [pod name] [destination port]"
            return 1
        fi
        pkill -f 'tcpserver 127.0.0.1 9999'
        tcpserver 127.0.0.1 9999 kubectl exec -i "$POD" nc 127.0.0.1 "$DESTPORT"&
        echo "Connect to 127.0.0.1:9999 to access $POD:$DESTPORT"
    }

#### Links

 * [rest api example](https://cloud.google.com/iam/docs/reference/rest)
