#!/bin/bash

cd forgejo
bash ./stop.sh
cd ..

cd minikube
bash ./stop.sh
cd ..
