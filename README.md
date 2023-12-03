# istio-playground

A simplisitc playground that deploys two service to Kubernetes and fronts them with Istio Ingress via Helmfile.

Designed to work with Minikube or other K8S environment.

The two services are http-echo and tcp-echo

## Prerequisites

Install / configure the following tools:

* K8S environment (e.g. Minkube, use `minikube_start.sh` for a reasonable default)
* kubectl
* helm
* helmfile

Minikube should be started with metrics-server and dashboard addons - you may need registry too.

Run `minikube tunnel` and `minikube dashboard --url` in separate terminals

## Installation of Istio and Echo Services

This installs:
* cert-manager, with self-signed CA, Cluster Issuer and wildcard certificate in istio-ingress namespace
* istio
* istio-ingress
* http-echo (visible at http-echo.dev.local, http (80) and https(443))
* tcp-echo (visible at tcp-echo.dev.local, tcp (2702) and tls (2703))

For DNS resolution, add the istio-ingress load balancer IP into `/etc/hosts` resolving for `http-echo.dev.local` and `tcp-echo.dev.local`

Install the entire set by:
```
helmfile [apply|sync] -f helmfile/
```

Known Issues:

* Cert Manager webhook may fail, simply wait a few seconds and repeat the install
* Istio Ingress may fail to pull - enable the registry addon in Minikube or delete the pod to recreate it and retry earlier.

## Testing

*Important*: Ensure istio-ingress load balancer IP is in `/etc/hosts` and resolves for `http-echo.dev.local` and `tcp-echo.dev.local`

### HTTP(S) tests

1. Using curl or browser go to http://http-echo.dev.local (unencrypted). System should resolve and echo service should give a valid response
2. Using curl or browser go to https://http-echo.dev.local (encrypted, bypass CA warnings). System should resolve and echo service should give a valid response.

### TCP/TLS tests

1. Using netcat (`nc`) access unencrypted: `nc tcp-echo.dev.local 2702`. System should resolve and echo service should give a valid response. Anything you type should be sent back.
2. Using openssl client (`openssl s_client`) `openssl s_client -k -connect tcp-echo.dev.local:2703` (encrypted, bypass CA warnings). System should resolve and echo service should give a valid response. Anything you type should be sent back.
