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




#### Links

 * [rest api example](https://cloud.google.com/iam/docs/reference/rest)
