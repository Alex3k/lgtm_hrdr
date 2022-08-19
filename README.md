# Introduction
This project uses GCP to deploy a K8s cluster and deploy GEM, GEL, and Grafana within it and all the require components for that to work across two regions. With this, you can see GEM, GEL and GE working in a fully HA and DR resistant environment. This can be verified by deploying everything and then destroying a region and noticing that everything still works.

**You can only use this project if you work at Grafana Labs and have the ability to create licenses or you are working with Grafana Labs and can request a license**

For each region this project will deploy spread 
- Grafana Enterprise Metrics (GEM) deployed across three zones
- Grafana Enterprise Logs (GEL) deployed across three zones
- Grafana Enterprise (GE) deployed across three zones
- Grafana Agent pushing metrics from the kubernetes cluster to both regions GEM (Dual write)

# Worked around required within Terraform for Grafana Enterpise Global Load Balancer
Within the Grafana Helm Chart, we add an annotation to the service ` cloud.google.com/neg: '{"exposed_ports":{"3000":{}}}'` this created Network Endpoint Groups (NEG) in GCP. This is required to have a Global Load Balancer. The challenge is that this is created automagically and therefore Terraform is unaware of it. To this end, we need to use the "scripts/get-gcp-negs.sh" script which uses the gcloud CLI tool to get the Network Endpoint Groups which are magically created by GKE. JQ is required for this to parse the response from the gcloud CLI tool. This is then used to created a GCP backend service.

# Resources created in GCP per region
- Kubernetes cluster with 1 node in 3 zones
- CloudSQL MySQL instance & user
- Static IP for the GEM AuthProxy
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
## Step 1) Install required Software
- Terraform - https://learn.hashicorp.com/tutorials/terraform/install-cli
- GCP GCloud - https://cloud.google.com/sdk/docs/install
- JQ - https://stedolan.github.io/jq/download/

## Step 2) Creating the GCP Service Account
To run any of this within GCP, you will need to create a GCP service account which will be used throughout. I have only tested using "Editor" permissions due to limited time however the "Resources created in GCP per region" section above lists what is created to narrow the permissions as you see fit. 
1) Create the service account with Editor permissions
2) Download the JSON file and update the below variables within ge_infra/vars.tfvars, ge_lb/vars.tfvars and stack/vars.tfvars
	- gcp_svc_acc_file_path - The file path to your downloaded service account file
	- gcp_project_id - The GCP project ID

## Step 3) Authenticate GCloud on the CLI
1. Read the docs at https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account
2. Take the below template command and apply your settings to it:
	`gcloud auth activate-service-account {SERVICE_ACCOUNT@DOMAIN.COM} --key-file={PATH TO YOUR CREATED GCP SERVICE ACCOUNT} --project={THE PROJECT ID}` 
3. Run it :) 

## Step 4) Getting a Static IP address for the global grafana load balancer
1. Go into the ge_infra folder
2. Within vars.tfvars:
	- Ensure that you have updated gcp_svc_acc_file_path and gcp_project_id from the above Step 2
	- Update owner_name with your name without any spaces. This variable is used throughout ge_infra, ge_lb and stack. This is going to be prefixed in front of everything created within GCP to clearly identify the owner. This is required as not all GCP components allow labels to be created through terraform.
3. `terraform init`
4. `terraform apply -var-file vars.tfvars`
5. This will output one ip addresses which is for the global load balancer. Create one GE license with the Grafana Enterprise Metrics & Logs Plugin. The URL should be "http://{IP}/". Don't add a port. Download the license 
6. Update stack/vars.tfvars
	- grafana_global_license_file - this should point to your GE license file
	- grafana_global_ip_address - this should be the output from terraform and be the global load balance IP
7. Update ge_lb/vars.tfvars
	- grafana_global_ip_address - this should be the output from terraform and be the global load balance IP
8. Create four more licenses for GEM and GEL. Use your initials as a prefix. For me that is akc. For both the license and cluster name set it to the below value
	- For GEM in Europe use akc-gem-europe
	- For GEM in US use akc-gem-uscentral
	- For GEL in Europe use akc-gel-europe
	- For GEL in US use akc-gel-uscentral
9) Download those licenses one by one and name them to be the name of the license with a .jwt file type. Update stack/vars.tfvars to point at each respective license. The variables that need updating are:
	- gem_a_license_file (for uscentral)
	- gem_b_license_file (for europe)
	- gel_a_license_file (for uscentral)
	- gel_b_license_file (for europe)

## Step 5) GEX OIDC Set Up
To set up OIDC, I am using a free Keycloak service hosted by https://www.cloud-iam.com/. This saves deploying Keycloak within this process as that's out of scope. OIDC is a core backbone for DR. Grafana, GEM, GEL and Grafana Agent use it.
1. Create a free account on https://www.cloud-iam.com/ 
2. Create a new deployment and give a name such as "keycloak-gex-ha-dr-test". It takes a while for them to deploy it, check your emails reguarly. Once created open the KeyCloak Console with the credentials they emailed you.
3. Create a new client by opening Clients from the menu. Create one called "gex_ge" by setting the new clients "Client ID" to "gex_ge" and set the protocol to "openid-connect". Ignore the Root URL
	- Within the client settings, set the following and ignore the rest:
		- Access Type: Confidential
		- Valid Redirect URLS: *
		- Direct Grant Flow (found under Authentication Flow Overrides): direct grant
	- Click Save
	- Within the Credentials tab:
		- Take note of the secret, you will need it later
4. Create a new Role called "Grafana/Admin" by using the Role option from the main left hand menu. When you click save it may show an error but still worked.
5. Create a new Group called "Grafana/Admin" by using the Group option from the main left hand menu. When you click save it may show an error but still worked.
6. Within the Group, go to Role Mappings and add Grafana/Admin role to the Assigned Roles table. No need to save it, it happens automagically.
7. Create a User using the main left hand menu option. This user will be who logs into Grafana.
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
	- Within Role Mappings remove the "default-roles-gem-oidc" from Assigned Roles
	- Click on the Credentials tab, input a password and ensure Temporary is Off. Click Set Password
8. Create a Client Scope. To do this use the Client Scope on the main menu
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
		- Ensure "add to ID token", "Add to access token",  "Multivalued" and "Add to userinfo" are on
		- Click Save
9. Using the main left hand menu, open Client Scopes, select the "roles" scope, click on the "Mappers" tab, click on the "realm roles" mapper, ensure that "Add to ID token", "Add to Access token" and "Add to userinfo" are set to "On".
10. Go back to your client called "gex_ge" and click on the Client Scopes tab
	- Add "Grafana/access_policies" to the "Assigned Default Client Scopes" box
	- Click on "Evaluate" under Client scopes, select the user you created - in my case "akc" and click evaluate. Under "Generated User Info" you should see "realm_access.roles" contained "Grafana/Admin" and "Grafana/access_policies" containing "tenant1-ap". If not, revaluate the above, you can't proceed without this. When clicking on Evaluate an error often showed but didn't mean anything.
11. We need to add the Identity Provider. Click on Identity Providers and add a new OpenID Connect provider
	- Set the alias to be "gex_ge"
	- Ensure "Enabled" is set to On
	- In a new tab, open the Realm Settings option on the left hand side Configure menu and click on the "OpenID Endpoint Configuration" Endpoint. 
	- Within the configuration from the above step, search for "authorization_endpoint", copy the value and paste it within the OpenID Connect Config Authorization URL within the identity provider. 
	- Do the same for Token URL (token_endpoint) and User Info URL (userinfo_endpoint)
	- Set client Authentication to "Client secret at jwt"
	- Set the Client ID to the ID of your previously created client. Following this guide it would be "gex_ge"
	- Set the Client Secret to be the secret from your client. If you have lost it you can find it by going to the client and the credentials tab
	- Set "Client Assertion Signature Algorithm" to "HS256"
	- Click Save
12. Create a new client called "data_shipper_tenant1" and (only) follow step 3 from above. Within Settings make sure "Service Accounts Enabled" is set to on.
13. Still within the Client, go to Mappers and create a new one:
	- Set the Name to be Grafana/access_policies
	- Set the Mapper Type to Hardcoded Claim
	- Set the Token Claim name to be "Grafana/access_policies"
	- Set the Claim value to be "tenant1-ap"
	- Set the Claim JSON type to string
	- Set Add to ID token, Add to access token, Add to userinfo and add to access token response to On
14. Follow step 11 above and set the alias to "data_shipper_tenant1"
	- Make sure to set the "Client Authentication" to be "client secret sent as basic auth"
	- Set "Hide on Login Page" to on
15. To configure GEM, Grafana and GEL to use this settings, please go into stack/vars.tfvars and update the below variables. Also in a new tab, open the Realm Settings option on the left hand side Configure menu and click on the "OpenID Endpoint Configuration" Endpoint.
	- oidc_issuer_url - Within the Realm Settings config, search for "issuer" and use this value. For me it is https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc"
	- oidc_client_secret - This is the secret for the ge_gex client. You can find this by going to Keycloak, clicking on Clients on the left menu, selecting the "gex_ge" client and then clicking the credentials tab
	- oidc_token_url - Take the oidc_issuer_url from above and append "/protocol/openid-connect/token". For me it looks like "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc/protocol/openid-connect/token" 
	- oidc_userinfo_url  = Take the oidc_issuer_url from above and append "/protocol/openid-connect/userinfo". For me it looks like "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc/protocol/openid-connect/userinfo" 
	- oidc_auth_url - Take the oidc_issuer_url from above and append "/protocol/openid-connect/auth". For me it looks like "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc/protocol/openid-connect/auth" 
	- data_shipper_oidc_client_secret = This is the secret for the data_shipper_tenant1 client. You can find this by going to Keycloak, clicking on Clients on the left menu, selecting the "data_shipper_tenant1" client and then clicking the credentials tab
	- data_shipper_oidc_token_url     = This is the same as the oidc_token_url from above

## Step 6) Deploy GEM/GEL/GE/GA
1. Go into the stack folder
2. Update the vars.tfvars file:
	- Do a find on "akc" and replace it with your initials without any spaces
	- Ensure "gcp_project_id" is set to your GCP project ID
	- Ensure "gcp_svc_acc_file_path" is pointing to your GCP Service account file from step 2 
	- Set "owner_name" to be your full name without any spaces
	- Ensure "gem_a_license_file" is pointing to your USCentral GEM license file
	- Ensure "gem_b_license_file" is pointing to your Europe GEM license file
	- Ensure "gel_a_license_file" is pointing to your USCentral GEL license file
	- Ensure "gel_b_license_file" is pointing to your Europe GEL license file
	- Ensure "grafana_global_ip_address" is the IP address created and outputted from the ge_infra terraform project 
	- Ensure "grafana_global_license_file" is pointing to your GE license file
	- Ensure you have set the OIDC settings from step 5.15
3. `terraform init`
4. `terraform apply -var-file vars.tfvars` - This will take 30 to 45 minutes. 
5. **Note: The Grafana Agent won't ship data until you've configured the Enterprise Metrics/Logs Plugin (see below)**

## Step 7) Deploy the GE Global Load Balancer
To make it easier to destroy regions, I have separated this out into it's own Terraform project.
1. Go in the ge_lb folder
2. Update the vars.tfvars file:
	- Do a find on "akc" and replace it with your initials without any spaces
	- Ensure "gcp_project_id" is set to your GCP project ID
	- Ensure "gcp_svc_acc_file_path" is pointing to your GCP Service account file from step 2 
	- Set "owner_name" to be your full name without any spaces                             
	- Ensure "grafana_global_ip_address" is the IP address created and outputted from the ge_infra terraform project                                 
3. `terraform init`
4. `terraform apply -var-file vars.tfvars`
5. It will take a few minutes before the global IP routes to Grafana

## Step 8) Configure Enterprise Metrics Plug in
1. Get the IP address of grafana from running `terraform output` within the ge_lb directory. 
2. Get all of details by running `terraform output` within the stack directory
3. Log in with your configured OAuth user. You may need to use an Incognito window 
4. Open the GEM Plugin Configuration window and set the access token to be the output from terraform called "gem_token_override". You will have to click Reset for the token. Set the "Grafana Enterprise Metrics URL" to be gem_a_admin_endpoint from terraform output. You may have to refresh the page a few times when going to the tenant page to make sure that Grafana has the correct cluster. This is especially the case when configuring GEM B after configuring GEM A.
5. Create a tenant, I will call it "tenant1". 
6. Create an access policy for this tenant. I will call it tenant1-ap. I have also ticked all permissions and selected the tenant1 tenant
7. Create a prometheus data source for this tenant with the name "Prometheus". Set the URL to be gem_a_datasource_endpoint from terraform,  enable "Forward OAuth Identity" and add a custom header with the name of "x-scope-orgid" and the value of the tenant you previously created. In my case "tenant1"
8. Reconfigure the plugin (open the plugin and click on the "Configuration tab") and apply the same steps from step 3 but using gem_b instead of gem_a. 

## Step 9) Configure Enterprise Logs Plug in
1. Get the IP address of grafana from running `terraform output` within the ge_lb directory. 
2. Get all of details by running `terraform output` within the stack directory
3. Log in with your configured OAuth user
4. Open the GEL Plugin Configuration window and set the access token to be the output from terraform called "gel_token_override". You will have to click Reset for the token. Set the "Grafana Enterprise Logs URL" to be gel_a_endpoint from terraform output. You may have to refresh the page a few times when going to the tenant page to make sure that Grafana has the correct cluster. This is especially the case when configuring GEL B after configuring GEL A.
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

