# thousandeyes-kubernetes-examples
This repo provides example configurations for deploying a ThousandEyes Enterprise Agent on Kubernetes. The Thousandeyes Docker Enterprise Agent can be used on Kubernetes, however are a few caveats:
* BrowserBot is not recommended, as it requires additional security permissions and custom configuration of nodes
* Persistent storage is required to ensure ThousandEyes Agent identity persists across pod re-deployments

### Recommended Configuration
The current recommended configuration is to deploy as a **StatefulSet** with **volumeClaimTemplate**, which you can find in [te-agent-statefulset.yaml](./te-agent-statefulset.yaml). This approach ensures that the ThousandEyes Agent identity persists across Pod restarts, redeployments, and supports migration between nodes in the cluster.  
# Try it Out
This example requires that you have Kubernetes cli (`kubectl`) setup on your local machine and have selected a Kubernetes cluster to deploy to.

The example will use the [te-agent-statefulset.yaml](./te-agent-statefulset.yaml) example, which deploys a ThousandEyes agent as a **StatefulSet** along with a **Volume Claim Template** to dynamically provision persistent storage. It will also use a Kubernetes secret to store and access the ThousandEyes Account Group Token.
## Set your ThousandEyes Account Group Token
Your account token is located in ThousandEyes app under **Cloud and Enterprise Agents --> Agent Settings --> Add New Agent**. Run the `set-token.sh` script; this will prompt you to enter your account token and will automatically update the `te-credentials.yaml` file for you with a base64 encoded version of your token.
```
./set-token.sh
Setting ThousandEyes Account Token
Enter your ThousandEyes Account Group Token: <your token>
Created base64 ThousandEyes token in ./te-credentials.yaml
```
## Deploy ThousandEyes Agent
First, deploy the credentials file with the account token created above.
```
kubectl apply -f te-credentials.yaml
```
Then deploy the ThousandEyes Enterprise Agent. The `te-agent-statefulset.yaml` will deploy the ThousandEyes agent as a StatefulSet as well as provision a Persistent Volume.
```
kubectl apply -f te-agent-statefulset.yaml
```

# Notes
## ThousandEyes Cluster Support
The included examples do not provide any means of managing ThousandEyes Agent Clusters. If you are using ThousandEyes Agent Clusters, you will still have to add or remove agents from ThousandEyes Clusters via the UI or the ThousandEyes API.

## BrowserBot Support
BrowserBot is the ThosuandEyes Agent component that allows running Page Load and Synthetic Browser Transaction tests. These examples do not currently include support for running BrowserBot.
# Helpful Commands
### Set Your Kubernetes Context
This specifies what Kubernetes cluster you will deploy to. In this example, we have 3 clusters - 1 on Docker Desktop, 2 in GCP Kubernetes Engine (GKE). 
```
kubectl config get-contexts

docker-desktop
gke_pmm-se-demo_us-central1-c_cluster-1
gke_pmm-se-demo_us-central1-c_cluster-2

kubectl config use-context gke_pmm-se-demo_us-central1-c_cluster-2
```
### View Logs
```
kubectl logs te-agent-statefulset-0
```
### Connect to Running Instance
```                       
kubectl exec --stdin --tty te-agent-statefulset-0 -- /bin/bash
```
### Delete Agent
When using StatefulSet, deleting the agent in Kubernetes will not delete the persistent storage. Therefore, if you redeploy the agent in Kubernetes, it will reuse the existing persistent storage and mainting the same Agent identify in ThousandEyes. 
```
kubectl delete -f te-agent-statefulset.yaml
```
### Delete Persistent Volume Claim
```
kubectl delete pvc agent-data-statefulset-te-agent-statefulset-0
```
### Labeling Nodes
```
kubectl get nodes
kubectl label nodes gke-cluster-2-pool-1-160e9d8b-4vmr host=host1
```