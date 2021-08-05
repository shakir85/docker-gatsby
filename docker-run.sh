#!/bin/bash

docker build --add-host 192.168.1.64 -t gatsby .
docker run -m 1024 -p 8000:8000