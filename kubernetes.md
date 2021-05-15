#### kubernetes

##### sample cluster related commands

    kubectl config view
    kubectl config current-context
    kubectl config get-contexts
    kubectl config use-context some-name
    kubectl config get-clusters
    kubectl top pod --all-namespaces
    kubectl get ns
    kubectl -n some-ns top pods

##### sample pod related commands

    kubectl get pods
    kubectl get pods -A -o wide
    kubectl -n test123 describe pod mytype-myproject-123b123123-xy8ab
    kubectl get svc -A
    kubectl get ns
    kubectl delete ns test123
    kubectl get pv
    kubectl get pvc
    kubectl get nodes --show-labels
    kubectl -n test123 get events
    kubectl -n test123 create -f pvc_test123.yaml
    kubectl -n test123 edit pvc test123
    kubectl -n test123 get pvc test123 -o yaml --export > pvc_test123.yaml
    kubectl -n test123 delete pvc test123
    kubectl -n test123 apply -f https://k8s.io/examples/application/shell-demo.yaml
    kubectl -n test123 run nginx-pod --image=nginx
    kubectl -n test123 attach nginx-pod -i
    kubectl -n test123 exec nginx-pod -it /bin/bash
    kubectl -n test123 exec --stdin --tty nginx-pod -- /bin/bash
    kubectl -n test123 attach nginx-pod -c my-container -i -t

##### oneliners

    # get master node IP
    kubectl -n myNs get node -o json | jq -r '.items[] | select (."metadata"."labels"."node-role.kubernetes.io/master" == "master") | ."status"."addresses" | .[] | select (."type" == "InternalIP")."address"'

##### sample setup

Single pod from docker image

    # get image from repo
    docker pull rodolpheche/wiremock

    # run image in namespace    
    kubectl -n test123 run wiremock-pod --image=rodolpheche/wiremock:latest

    # check IP
    kubectl -n test123 get pod -o wide

    # verify deployment
    kubectl -n test123 describe pod wiremock-pod

    # check logs (wiremock logo should be there)
    kubectl -n test123 logs wiremock-pod

    # test deployment (empty response)
    curl -v 10.244.44.44:8080/__admin

    # list files on pod
    kubectl -n test123 exec wiremock-pod -- ls /

    # access shell on pod
    kubectl -n test123 exec --stdin --tty wiremock-pod -- /bin/bash

    # remove pod
    kubectl -n test123 delete pod wiremock-pod

    # get check image id
    docker images

    # remove image not needed
    docker image rm 0e2fcbe166e7

Deployment from file based on docker image (https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

httpbin-deployment.yaml

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      namespace: test123
      name: httpbin-deployment
      labels:
        app: httpbin
        owner: A.Becede
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: httpbin
      template:
        metadata:
          labels:
            app: httpbin
            owner: A.Becede
        spec:
          containers:
          - name: httpbin
            image: kennethreitz/httpbin
            ports:
            - containerPort: 80

httpbin-service.html

    kind: Service
    apiVersion: v1
    metadata:
      namespace: test123
      name: httpbin-service
    spec:
      selector:
        app: httpbin
      type: LoadBalancer
      ports:
        - port: 8080
          targetPort: 80


Applay settings from file:

     kubectl apply -f httpbin-service.yaml
     kubectl apply -f httpbin-deployment.yaml

Check deployment

     kubectl -n test123 get services
     kubectl -n test123 get deployments
     kubectl -n test123 get replicaset
     kubectl -n test123 get pods -o wide
     kubectl -n test123 get pods --show-labels

Remove resources

     kubectl delete deployment httpbin-deployment
     kubectl delete service httpbin-deployment

##### examples

Links

 * https://medium.com/better-programming/kubernetes-a-detailed-example-of-deployment-of-a-stateful-application-de3de33c8632
