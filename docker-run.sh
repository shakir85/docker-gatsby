#!/bin/bash

docker build -t gatsby .

docker container run -d -m 1024 -p 8000:8000 --restart always gatsby:latest