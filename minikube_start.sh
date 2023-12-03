#!/usr/bin/env bash

minikube start --cpus='4' --memory='16g' --addons='metrics-server,dashboard'
