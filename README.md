# Introduction
This project uses GCP to deploy a K8s cluster and deploy GEM, GEL, and Grafana within it and all the require components for that to work across two regions. With this, you can see GEM, GEL and GE working in a fully HA and DR resistant environment. This can be verified by deploying everything and then destroying a region and noticing that everything still works.

**You can only use this project if you work at Grafana Labs and have the ability to create licenses or you are working with Grafana Labs and can request a license**

For each region this project will deploy spread 
- Grafana Enterprise Metrics (GEM) deployed across three zones
- Grafana Enterprise Logs (GEL) deployed across three zones
- Grafana Enterprise (GE) deployed across three zones
- Grafana Agent pushing metrics from the kubernetes cluster to both regions GEM (Dual write)

# Required utilities on your machine
- Terraform - https://learn.hashicorp.com/tutorials/terraform/install-cli
- GCP GCloud - https://cloud.google.com/sdk/docs/install
- JQ - https://stedolan.github.io/jq/download/

# Grafana Enterprise Global Load Balancer Terraform K8s Workaround
Within the Grafana Helm Chart, we add an annotation to the service ` cloud.google.com/neg: '{"exposed_ports":{"3000":{}}}'` this created Network Endpoint Groups in GCP. This is required to have a Global Load Balancer. The challenge is that this is created automagically and therefore Terraform is unaware of it. To this end, we need to use the "scripts/get-gcp-negs.sh" script which uses the gcloud CLI tool to get the Network Endpoint Groups which are magically created by GKE. JQ is required for this to parse the response from the gcloud CLI tool. This is then used to created a GCP backend service.

# Resources created in GCP per region
- Kubernetes cluster with 1 node in 3 zones
- CloudSQL MySQL instance & user
- Static IP for the AuthProxy
- 3 GCS buckets for GEM
- 1 GCS buckets for GEL

# Resources created globally
- Global Static IP for Grafana
- Global Load balancer
- Health Check
- Backend Service
- Global forwarding rule
- URL Map
- Target HTTP Proxy

# Configuration
## Creating the GCP Service Account
To run any of this within GCP, you will need to create a GCP service account which will be used throughout. I have only tested using "Editor" permissions due to limited time however the "Resources created in GCP per region" section above lists what is created.

## Setting up OIDC in Keycloak
For this project, I am using Keycloak as my OIDC provider. You can spin up a free realm through Cloud IAM (https://www.cloud-iam.com/). Sadly the Terraform provider requires a paid version. A provider for Keycloak was chosen instead of hosting within this project is because this is purely focusing on managing our technologies over third parties.

### GEM, GEL & Grafana OIDC
This client will be used by Grafana, GEM and GEL for authentication and authorization.
1. Create a new client called "gex_ge" by setting the new clients "Client ID" to "gex_ge" and set the protocol to "openid-connect". Ignore the Root URL
	- Within the client settings, set the following and ignore the rest:
		- Access Type: Confidential
		- Valid Redirect URLS: *
		- Direct Grant Flow (found under Authentication Flow Overrides): direct grant
	- Click Save
	- Within Credentials:
		- Take note of the secret, you will need it later
2. Create a new Role called "Grafana/Admin"
3. Create a new Group called "Grafana/Admin"
4. Within the Group, go to Role Mappings and add Grafana/Admin role to the Assigned Roles table
5. Create a User
	- Set the username to something reasonable - I will use "akc"
	- Set the Email, first and last name. You don't have to use a real email
	- Ensure User Enabled is "On"
	- Set Email Verified to "On"
	- Under groups, select our Grafana/Admin group. You may need to start typing for it to show
	- Ensure Required User Actions is empty
	- Click Save
	- Open the user up and click Attributes
	- Create a new attribute called "Grafana/access_policies" and set the value to be "tenant1-ap", click add on the right and then save
	- Go to Role Mappings and ensure "Grafana/Admin" is under Effective Roles. If not, you may not have added the user to the Grafana/Admin group. Verify this by going to the Groups tab.
6. Create a Client Scope 
	- Set the name to be "Grafana/access_policies" 
	- Ensure the protocol is "openid-connect"
	- Set Display on Consent Screen to "Off"
	- Ensure "Include in Token Scope" if "On"
	- Click Save
	- On the Mapper Tab create a new Mapper with the name "Grafana/access_policies" 
		- Set the Mapper Type to be User Attribute
		- Set the User Attribute to be Grafana/access_policies
		- Set the Token Claim Name to be Grafana/access_policies
		- Ensure Claim JSON type is String
		- Ensure "add to ID token", "Add to access token",  "Multivalued" "Add to userinfo" are on
		- Ensure  are on
		- Click Save
7. Go back to your client called "gex_ge" and click on the Client Scopes tab
	- Add "Grafana/access_policies" to the "Assigned Default Client Scopes" box
	- Click on "Evaluate" under Client scopes, select the user you created - in my case "akc" and click evaluate. Under "Generated User Info" you should see "realm_access.roles" contained "Grafana/Admin" and "Grafana/access_policies" containing "tenant1-ap". If not, revaluate the above, you can't proceed without this.
8. Finally, we need to add the Identity Provider. Click on Identity Providers and add a new OpenID Connect provider
	- Set the name to be "gex_ge"
	- Ensure "Enabled" is set to On
	- In a new tab, open the Realm Settings option on the left hand side Configure menu and click on the "OpenID Endpoint Configuration" Endpoint. 
	- Within the configuration from the above step, search for "authorization_endpoint", copy the value and paste it within the OpenID Connect Config Authorization URL within the identity provider. 
	- Do the same for Token URL (token_endpoint) and User Info URL (userinfo_endpoint)
	- Set client Authentication to "Client secret at jwt"
	- Set the Client ID to the ID of your previously created client. Following this guide it would be "gex_ge"
	- Set the Client Secret to be the secret from your client. If you have lost it you can find it by going to the client and the credentials tba
- To configure GEM, Grafana and GEL to use this settings, please update the respective vars.tfvars file

### Data Shipper OIDC
1. Create a new client called "data_shipper_tenant1" and (only) follow step 1 in steps above however within Settings make sure "Service Accounts Enabled" is set to on.
2. Still within the Client, go to Mappers and create a new one:
	- Set the Name to be Grafana/access_policies
	- Set the Mapper Type to Hardcoded Claim
	- Set the Token Claim name to be "Grafana/access_policies"
	- Set the Claim value to be "tenant1-ap"
	- Set the Claim JSON type to string
	- Set Add to ID token, Add to access token, Add to userinfo and add to access token response to On
3. Follow step 8 above and set the name to "data_shipper_tenant1"
	- Make sure to set the "Client Authentication" to be "client secret sent as basic auth"
	- Set "Hide on Login Page" to on

## Step 1) Authenticate GCloud on the CLI
1. Read the docs at https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account
2. Take the below template command and apply your settings to it:
	`gcloud auth activate-service-account {SERVICE_ACCOUNT@DOMAIN.COM} --key-file={PATH TO YOUR CREATED GCP SERVICE ACCOUNT} --project={THE PROJECT ID}` 
3. Run it :) 

## Step 2) Getting a Static IP address for the global grafana load balancer
1. Go into the ge_infra folder
2. Update the vars.tfvars file to have relevant variables for you. Make sure you read the instructions at the top.
3. `terraform init`
4. `terraform apply -var-file vars.tfvars`
5. This will output one ip addresses which is for the global load balancer. Create one GE license with the Grafana Enterprise Metrics Plugin and Grafana Enterprise modules. The URL should be "http://{IP}/". Don't add a port. Download the license 
6. Make sure you update stack/vars.tfvars "grafana_global_license_file" and "grafana_global_ip_address" variables accordingly. 
7. Make sure you update ge_lb/vars.tfvars "grafana_global_ip_address"

## Step 3) Deploy GEM/GEL/GE/GA
1. Go into the stack folder
2. Update the vars.tfvars file to have relevant variables for you. Make sure you read the instructions at the top.
3. `terraform init`
4. `terraform apply -var-file vars.tfvars`
5. ** Note: The Grafana Agent won't ship data until you've configured the Enterprise Metrics Plugin (see below) **

## Step 4) Deploy the GE Global Load Balance
1. To make it easier to destroy regions, I have separated this out into it's own Terraform project.
2. Go int the ge_lb folder
3. Update the vars.tfvars file to have relevant variables for you. Make sure you read the instructions at the top.
4. `terraform init`
5. `terraform apply -var-file vars.tfvars`
6. It will take a minute or two before the global IP routes to Grafana

## Configure Enterprise Metrics Plug in
1. Get the IP address of grafana from running `terraform output` within the ge_lb directory. 
2. Get all of details by running `terraform output` within the stack directory
3. Log in with your configured OAuth user
4. Set the plugin token to be the output from terraform called "gem_token_override". Also set the "Grafana Enterprise Metrics URL" to be gem_a_admin_endpoint from terraform output
5. Create a tenant, I will call it "tenant1"
6. Create an access policy for this tenant. I will call it tenant1-ap. I have also ticked all permissions and selected the tenant1 tenant
7. Create a prometheus data source for this tenant with the name "Prometheus". Set the URL to be gem_a_datasource_endpoint from terraform,  enable "Forward OAuth Identity" and add a custom header with the name of "x-scope-orgid" and the value of the tenant you previously created. In my case "tenant1"
8. Reconfigure the plugin (open the plugin and click on the "Configuration tab") and apply the same steps from step 3 but using gem_b instead of gem_a

## Configure Enterprise Logs Plug in
1. Get the IP address of grafana from running `terraform output` within the ge_lb directory. 
2. Get all of details by running `terraform output` within the stack directory
3. Log in with your configured OAuth user
4. Set the plugin token to be the output from terraform called "gel_token_override". Also set the "Grafana Enterprise Logs URL" to be gel_a_endpoint from terraform output
5. Create a tenant, I will call it "tenant1"
6. Create an access policy for this tenant. I will call it tenant1-ap. I have also ticked all permissions and selected the tenant1 tenant
7. Create a Loki data source for this tenant with the name "Loki". Set the URL to be gel_a_endpoint from terraform,  enable "Forward OAuth Identity" and add a custom header with the name of "x-scope-orgid" and the value of the tenant you previously created. In my case "tenant1"
8. Reconfigure the plugin (open the plugin and click on the "Configuration tab") and apply the same steps from step 3 but using gel_b instead of gel_a

## Creating new Tenants
- For each tenant you create, you will need to create a new client following the same instructions outlined above for Data Shipper OIDC. Furthermore, for each user using that tenant you need to add the access policy id to the users attributes under Grafana/access_policies. Like how we did for tenant1-ap. Realistically you would do this as a Group as we did for the Grafana/Admin role. 

# Testing the DR Capability
## Destroying a region

You can tell the region you are in by going to the Grafana Login screen. I have configured it to show the current region. To test the DR capability, I recommend killing off that region. Once you have done this it will take a minute or two for the LB to switch over.

Due to Grafana not configuring the plugins correctly (likely an error on my side when configuring the side car) you will most likely need to configure the plugins again. You won't need to create the tenants/access tokens again though.

Go into the stack directory and use the below:
1. Destroy Region A - `terraform destroy -target google_container_cluster.region_a -var-file vars.tfvars`
2. Destroy Region B - `terraform destroy -target google_container_cluster.region_b -var-file vars.tfvars`

# Keeping everything in sync
All updates to Grafana / GEX and the G-Agent need to be through a GitOps workflow to ensure its replicated to both regions.

# Reconciling data after a failure
In the event where there is a major DR event and an entire region goes offline, you would need to perform data reconciliation when the region comes back on line to ensure that both region a and region b are back in sync. This could also happen if the network is unavailable within a region from the data shippers or a regions GEM/GEL cluster goes offline. The agent (if using Grafana Agent/Promtail/etc) should buffer the data for a period of time (depending on settings). So if it's a short outage the agent will ship the buffered data once back online. However this is a finate period of time.

Another option is to deploy Kafka between your data shippers and GEM/GEL to buffer data for as long as required by your Recovery Point Objective (RPO). However that is out of scope of this project.

An alternative option is once both regions are operational again, the object store from the region that stayed live can be duplicated to the object store which went offline. This way it would ensure the historical data is in sync whilst both receive latest data. This could be a very costly and long exercise and is out of scope of this project.

# Known Issues
- When deploying Grafana to GKE, a GCP Network Endpoint Group (NEG) is created for each zone Grafana is deployed in. This is detailed within the "Terraform K8s Workaround" section above. It seems when deleting that service GKE doesn't delete the automatically created NEG and it lingers. This doesn't seem to have any cost implication or performance implication. It's just untidy.

