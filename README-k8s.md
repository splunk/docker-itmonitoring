# Kubernetes (k8s) Monitoring & Troubleshooting
The following OSS contribution includes the following:
1. Technical Add-On (TA) to collect logs - ta-k8s-logs
2. Technical Add-On (TA) to collect k8s api metadata - ta-k8s-meta
3. Splunk Enterprise with a new k8s app package and deployed in a k8s cluster
4. A k8s App and TA packaged targeted to be deployed on a Splunk Enterprise instance outside of the k8s cluster - app-k8s-external

Minimum Requirements:
- kubectl v1.8
- minikube v0.24
- kubernetes v1.8

## Splunk UF with logs collection TA: ta-k8s-logs
Splunk UF daemonset to collect docker json logs. 

Default configuration is to monitor /var/log/containers/*.log, also contains input for kubernetes advanced audit /var/log/kube-apiserver-audit.log

New inputs can be added via config map in the yaml or by editing the app and rebuilding the docker container. 

Does not currently provide collection from journald

## Splunk UF with metadata collection TA:ta-k8s-meta
Splunk UF Deployment to collect k8s metadata from API Server from within the k8s cluster.

A very simple collection of bash scripts, to provide a glimpse of what k8s API integration can provide for log and metric enrichment.

The polling of the API defaults to 30 seconds but is configurable (under ta-k8s-meta/default/inputs.conf), and should be set to a suitable value for your environment. 

TO DO: look at using watch instead of get  

Dependencies: bash & jq are reguired.  

Commands from a k8s client or kubectl itself could easily be integrated here as well.  

## Deployment YAML - k8s-splunk-full-demo.yaml
Deploys a single instance of Splunk Enterprise in the Kubernetes cluster with the k8s demo app pre-configured. 

The k8s app currently configures an index called k8s that is hardcoded into the overview dash for simplicity. 

TO DO : update the dash with macros to allow easy configuration of different indexes.

The app currently contains props/transform configurations:
1.sourcetype=kubernetes - index docker JSON driver logs in JSON or by using a SEDCMD to "unwrap" your stderr/stdout logs and a custom linebreaker to provide multiline logging support.
2.sourcetype=k8s:api:* - INDEXED_EXTRACTIONS for the API metadata

The exact configuration for your environment will vary greatly on your logging practices. See props.conf

Defaults to using SEDCMD. 

TO DO : add an example of source based transforms, renaming kubernetes to access_combined,  which will allow the application of exiting field extractions.  

## app-k8s-external
The same app that runs in the demo, but for install on a Splunk instance running outside the kubernetes cluster.

You will need to update the apiserver.txt (./app-k8s-external/bin/apiserver.txt) and token.txt(./app-k8s-external/bin/token.txt) files in the bin directory with your k8s API URL and Service Account Token to allow your Splunk instance to talk to the k8s API.

Please protect your credentials and configure the Service Account Permissions accordingly.  

## docker-images
Contains the Dockerfiles to build the 3 new images used e.g.,
1. splunk/universalforwarder:7.0.0-monitor-k8s-logs
2. splunk/universalforwarder:7.0.0-monitor-k8s-meta
3. splunk/splunk:7.0.0-monitor-k8s

# Getting Started
## Create a secret for your Service Account to use for dockerhub image pulls
You will need to create a docker secret to pull the images for your trusted registery.

kubectl create secret docker-registry yourdockerhubsecret --docker-server=https://index.docker.io/v1/ --docker-username=yourDockerhubUsername --docker-password=yourDockerhubPassword --docker-email=yourDockerhubEmail

## Prepare your k8s cluster
You will require a functioning k8s cluster.

We have tested against Heptio's AWS Quickstart (1.8.4):
https://aws.amazon.com/quickstart/architecture/heptio-kubernetes/ 

And against Minikube on OSX Sierra(1.8.0):
https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-curl

## Deploying Splunk Enterprise and the 2 Splunk UFs
1. Update these parameters in the k8s-splunk-full-demo.yaml yaml files
i) <yourdockerhubsecret>: secret to allow image pulls from a dockerhub repo

ii) Splunk Enterprise host - splunkenterprise: the Splunk host name used to by the UF to forward logs and metadata. The two Universal Forwarders (UFs) (1 deployed as a daemonset and the other as a Deployment type) require a value for the SPLUNK_FORWARD_SERVER.  If you use the k8s-splunk-full-demo.yaml, the assumption is that you will be sending the data to the instance of Splunk Enterprise created as a Deployment type in the yaml. 

2. Build the 3 required images:
i) ta-k8s-logs: docker build -t splunk/universalforwarder:7.0.0-monitor-k8s-logs -f ./docker-images/ta-k8s-logs-image/Dockerfile
ii) ta-k8s-meta: docker build -t splunk/universalforwarder:7.0.0-monitor-k8s-meta -f ./docker-images/ta-k8s-meta-image/Dockerfile
ii) app-k8s-external: docker build -t splunk/splunk:7.0.0-monitor-k8s -f ./docker-images/enterprise-k8s/Dockerfile

3. Publish the 3 images to the trusted registery of your choice, e.g., docker push splunk/universalforwarder:7.0.0-monitor-k8s-meta, docker push splunk/universalforwarder:7.0.0-monitor-k8s-logs.

4. Update the 3 image names you created in the k8s-splunk-full-demo.yaml.  Search for "image:" and replace the existing images for your own image names.

5. Deploy Splunk Enterprise and the two Splunk UFs: kubectl create -f k8s-splunk-full-demo.yaml 

6. Create port forwarding to access Splunk Web UI
i) Run the following command: kubectl get pods
ii) Copy the name for the Splunk Enterprise pod and run the following command: kubectl port-forward <pod_name> 8000:8000
ii) Go to the following web URL using your browser: http://localhost:8000 

Note, if you want to deploy the sample app to your own Splunk Enterprise instance / cluster, simply run the following commands to create an SPL file:
i) gtar -cvf ./app-k8s.tar ./app-k8s-external/
ii) gzip ./app-k8s.tar
iii) mv ./app-k8s.tar.gz ./app-k8s.spl
