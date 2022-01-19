# thousandeyes-kubernetes-examples
Various example configurations for deploying ThousandEyes Enterprise Agent on Kubernetes. These examples are validated on GCP Kubernetes Engine.
# Usage
You must have Kubernetes cli (`kubectl`) setup on your local machine and connected to a Kubernetes cloud instance (like GCP) or running a local engine line `minikube`.
## Set your ThousandEyes Account Group Token
Your account token is located in ThousandEyes app under **Cloud and Enterprise Agents --> Agent Settings --> Add New Agent**. Run the `set-token.sh` script; this will prompt you to enter your account token and will automatically update the `te-credentials.yaml` file for you.
```
> ./set-token.sh
Setting ThousandEyes Account Token
Enter your ThousandEyes Account Group Token: kntb8ywxbfe345f6pvurfbdxpqi
Created base64 ThousandEyes token in ./te-credentials.yaml
```
## Set You Kubernetes Context
This step is optional; it specifies what Kubernetes cluster you will deploy to. In this example, we have 3 clusters - 1 on Docker Desktop, 2 in GCP Kubernetes Engine (GKE). We'll select cluster-2 in GKE.

```
> kubectl config get-contexts
docker-desktop
gke_pmm-se-demo_us-central1-c_cluster-1
gke_pmm-se-demo_us-central1-c_cluster-2

> kubectl config use-context gke_pmm-se-demo_us-central1-c_cluster-2
```

## Deploy ThousandEyes Agent
First we'll deploy the credentials file with account token we created above.
```
kubectl apply -f te-credentials.yaml
```
Then we'll deploy an Enterprise Agent. The `te-agent-statefulset.yaml` will deploy the ThousandEyes agent as a StatefulSet as well as provision a Persistent Volume.

```
kubectl apply -f te-agent-statefulset.yaml
```
## Helpful Commands
View Logs
```
kubectl logs te-agent-statefulset-0
```
Connect to Running Instance
```                       
kubectl exec --stdin --tty te-agent-statefulset-0 -- /bin/bash
```

Delete Agent
```
kubectl delete -f te-agent-statefulset.yaml
```
Delete Persistent Volume Claim
```
kubectl delete pvc vol-agent-statefulset-te-agent-statefulset-0
```

Labeling Nodes
```
kubectl get nodes
kubectl label nodes gke-cluster-2-pool-1-160e9d8b-4vmr host=host1
```

