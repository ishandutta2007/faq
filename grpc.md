#### GRPC

##### Basics

Exmaples
 * https://grpc.io/docs/languages/python/quickstart/

Creation of sample messages based on proto files

Testing with grpcurl

    cd /opt/
    # based on https://github.com/fullstorydev/grpcurl/releases
    wget https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz
    tar -zxf go1.17.6.linux-amd64.tar.gz
    # you should have /opt/go/bin/go now
    
    mkdir /opt/grpc && cd /opt/grpc
    # https://github.com/fullstorydev/grpcurl/releases
    wget https://github.com/fullstorydev/grpcurl/releases/download/v1.8.5/grpcurl_1.8.5_linux_x86_64.tar.gz
    tar -zxf grpcurl_1.8.5_linux_x86_64.tar.gz

    # make sure that bin-s are in PATH

    # test with grpc sample -> examples/python/helloworld

    protoDir='/test/grpc/examples/protos'
    protoFile='helloworld.proto'

    grpcurl -plaintext -import-path ${protoDir} -proto ${protoFile} list
    grpcurl -plaintext -import-path ${protoDir} -proto ${protoFile} describe helloworld.Greeter

    endpoint='127.0.0.1:50051'
    msgData='{"name" : "Johny Bravo"}'
    reqType='helloworld.Greeter/SayHello'

    grpcurl  \
     -plaintext \
     -import-path ${protoDir} \
     -proto ${protoFile} \
     -d "${msgData}" \
     "${endpoint}" \
     "${reqType}"

Testing with compiler

    protoDir='/test/grpc/examples/proto'
    protoFile='service.proto'
    protoDirLib='/test/grpc/examples/grpc/protolib'
    
    protoc \
     --proto_path=${protoDir} \
     --proto_path=${protoDirLib} \
     --include_imports \
     --descriptor_set_out=/tmp/delme.bin \
     ${protoDir}/${protoFile}
    
    rm -rf \
     /tmp/polyglot-well-known-types* \
     /tmp/descriptor*.pb.bin \
     /tmp/protocjar*
