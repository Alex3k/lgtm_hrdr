# Introduction
This project uses GCP to deploy a K8s cluster and deploy GEM and Grafana within it and all the require components for that to work across two regions. With this, you can see GEM and GE working in a fully HA and DR resistant environment. This can be verified by deploying everything and then destroying a region and noticing that everything still works

# This that still need to be worked on
- GEM zone HA
- Data reconsilation after a failure
- Grafana Agent HA
- Automating the GE global LB

# Configuration
## Setting up OIDC in Keycloak
For this project, I am using Keycloak as my OIDC provider. You can spin up a free realm through Cloud IAM (https://www.cloud-iam.com/). Sadly the Terraform provider requires a paid version. A provider for Keycloak was chosen instead of hosting within this project is because this is purely focusing on managing our technologies over third parties.

### GEM Client
This client will be used as the common client that Grafana and GEM will use for common authentication and authorization.
1. Create a new client called "gem" by setting the new clients "Client ID" to "gem" and set the protocol to "openid-connect". Ignore the Root URL
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
7. Go back to your client called "gem" and click on the Client Scopes tab
	- Add "Grafana/access_policies" to the "Assigned Default Client Scopes" box
	- Click on "Evaluate" under Client scopes, select the user you created - in my case "akc" and click evaluate. Under "Generated User Info" you should see "realm_access.roles" contained "Grafana/Admin" and "Grafana/access_policies" containing "tenant1-ap". If not, revaluate the above, you can't proceed without this.
8. Finally, we need to add the Identity Provider. Click on Identity Providers and add a new OpenID Connect provider
	- Set the name to be "gem-oidc"
	- Ensure "Enabled" is set to On
	- In a new tab, open the Realm Settings option on the left hand side Configure menu and click on the "OpenID Endpoint Configuration" Endpoint. 
	- Within the configuration from the above step, search for "authorization_endpoint", copy the value and paste it within the OpenID Connect Config Authorization URL within the identity provider. 
	- Do the same for Token URL (token_endpoint) and User Info URL (userinfo_endpoint)
	- Set client Authentication to "Client secret at jwt"
	- Set the Client ID to the ID of your previously created client. Following this guide it would be "gem"
	- Set the Client Secret to be the secret from your client. If you have lost it you can find it by going to the client and the credentials tba
- To configure GEM and Grafana to use this settings, please update the respective vars.tfvars file


### Data Shipper OIDC
1. Create a new client called "data_shipper_tenant1" and (only) follow step 1 in the GEM client details above however within Settings make sure "Service Accounts Enabled" is set to on.
2. Still within the Client, go to Mappers and create a new one:
	- Set the Name to be Grafana/access_policies
	- Set the Mapper Type to Hardcoded Claim
	- Set the Token Claim name to be "Grafana/access_policies"
	- Set the Claim value to be "tenant1-ap"
	- Set the Claim JSON type to string
	- Set Add to ID token, Add to access token, Add to userinfo and Aadd to acess token response to On
3. Follow step 8 above and set the name to "data_shipper_tenant1"
	- Make sure to set the "Client Authentication" to be "client secret sent as basic auth"
	- Set "Hide on Login Page" to on

## Deploying GEM
1. terraform init
2. terraform apply -var-file vars.tfvars

## Deploying Grafana
1. Go into the ge_infra directory
2. Verify vars.tfvars is correct
3. `terraform init`
4. `terraform apply -var-file vars.tfvars`
5. Take the IP addresses outputted from ge_infra and create two licenses. One for each ip address
6. Take the licenses and save them to the ge directory
7. Go into the ge directory
8. Update the vars.tf vars file to use your licenses and verify all other variables are correct
9. `terraform init`
10. `terraform apply -var-file vars.tfvars`

## Destroying one Grafana region
Go into the ge directory and use the below:
1. Destroy Region A - `terraform destroy -target grafana_a -var-file vars.tfvars`
2. Destroy Region B - `terraform destroy -target grafana_b -var-file vars.tfvars`

## Destroying one GEM region
Go into the gem directory and use the below:
1. Destroy Region A - `terraform destroy -target gem_a -var-file vars.tfvars`
2. Destroy Region B - `terraform destroy -target gem_b -var-file vars.tfvars`

## Configure Enterprise Metrics Plug in
You will need to do the following for both gem_a and gem_b. I will use the below steps for gem_a, please repeat accordingly for gem_b replacing grafana_a and gem_a with grafana_b and gem_b respectively.
1. Get the IP address and grafana password of grafana_a from running `terraform output` within the ge directory. To get the password you will need to use `terraform output grafana_a_password`
2. Log in to that instance using the username admin and the password from the above. 
3. Install the metrics plugin
4. Log back out of admin and log in using your configured oauth user
5. Go back to the gem directory and run `terraform output`
6. Enable the plugin using your oauth user and set the token to be the output from terraform called "gem_token_override". Also set the "Grafana Enterprise Metrics URL" to be gem_a_endpoint from terraform output
7. Create a tenant, I will call it "tenant1"
8. Create an access policy for this tenant. I will call it tenant1-ap. I have also ticked all permissions and selected the tenant1 tenant
9. Log out and back in with your OAuth user within Grafana to get the updated Access Token which includes this attribute
10. Create a prometheus data source for this tenant with the name "Prometheus Global". Set the URL to be gem_a_datasource_endpoint from terraform,  enable "Forward OAuth Identity" and add a custom header with the name of "tenant" and the value of the tenant you previously created. In my case "tenant1"

## Creating new Tenants
- For each tenant you create, you will need to create a new client following the same instructions outlined above for Data Shipper OIDC. Furthermore, for each user using that tenant you need to add the access policy id to the users attributes under Grafana/access_policies. Like how we did for tenant1-ap. Realistically you would do this as a Group as we did for the Grafana/Admin role. 

## Deploying Grafana Agent
1. Go into the gem directory and run `terraform output`
2. Go into the grafana_agent directory and update the vars.tfvars accordingly. 
	- The oidc settings are found from setting up oidc
	- The agent gcp_region and gke_cluster_name variables should match the regions from deploying GE and GEM
	- The remote_write_url variables should be the authproxy_*_external_ip variables from the gem terraform output
	- The tenant name should be the tenant created when configuring the Enterprise Metrics plugin
3. Run `terraform init`
4. Run `terraform apply -var-file vars.tfvars`



# Keeping all the Grafana's in sync
- TO DO
See chat with Aengus in chat

# Reconsiling data after a failure
- TO DO
Git Ops

