#!/bin/bash

docker build -t gatsby .

docker container run -d -m 1024M -p 8000:8000 --restart always --name gatsby gatsby:latest

# Test
# curl --insecure http://192.168.1.64:8000
