// Instructions - READ ME!
// To save updating many of these manually:
// 	- Do a find and replace on "akc" and replace that with a no spaces unique identifier. Your initials maybe.
//	- All other variables that need replacing are found under the heading "That Need Changing". Variables under the "Safe Default" heading 	will either be updated by the "akc" find and replace or don't need changing. All of these variables have a comment post fixed "update_me"

// --------------------------------------------------------
// Common Safe Default Variables 
gcp_region_a           = "us-central1"
gcp_region_b           = "europe-west2"
gcp_gke_cluster_name_a = "akc-hadr-uscentral"
gcp_gke_cluster_name_b = "akc-hadr-europe"

// --------------------------------------------------------
// Common Variables That Need Changing
gcp_project_id = "solutions-engineering-248511" // update_me
gcp_svc_acc_file_path = "/Users/akc/Desktop/Playground/dr/gcp-svc-acc.json" // update_me
owner_name            = "alexkirtleyclose" // update_me

// --------------------------------------------------------
// GEM Safe Default Variables
authproxy_name_prefix    = "akc"
oidc_access_policy_claim = "Grafana/access_policies"
gem_admin_token_override = "X19hZG1pbl9fLTBmZDQ1ZTc2ZDVhNTkyOWE6XzJsajMifTckNTYrXypmOC9RMVw2NSo5"
gem_a_cluster_name      = "akc-gem-uscentral"
gcp_gcs_bucket_prefix_a = "akc-uscentral"
gem_b_cluster_name      = "akc-gem-europe"
gcp_gcs_bucket_prefix_b = "akc-europe"

// --------------------------------------------------------
// GEM Variables That Need Changing
oidc_issuer_url          = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc" // update_me
gem_a_license_file      = "/Users/akc/Desktop/Playground/dr/stack/gem_uscentral_license.jwt" // update_me
gem_b_license_file      = "/Users/akc/Desktop/Playground/dr/stack/gem_europe_license.jwt" // update_me

// --------------------------------------------------------
// Grafana Enterprise Safe Default Variables
oidc_client_id     = "gem"
grafana_role_attribute_path = "contains(realm_access.roles[*], 'Grafana/Admin') && 'Admin' || contains(realm_access.roles[*], 'Grafana/Editor') && 'Editor' || 'Viewer'"
grafana_a_deployment_name     = "akc-ge-uscentral"
grafana_a_mysql_database_name = "akc-uscentral-ge-database"
grafana_b_deployment_name     = "akc-ge-europe"
grafana_b_mysql_database_name = "akc-europe-ge-database"


// --------------------------------------------------------
// Grafana Enterprise Safe Default Variables
oidc_client_secret = "hfQDPJIHd1SuxlyjbTUJt3SFpowJzfLt" // update_me
oidc_token_url     = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/token" // update_me
oidc_userinfo_url  = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/userinfo" // update_me
oidc_auth_url      = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/auth" // update_me

// --------------------------------------------------------
// Grafana Enterprise Variables That Need Changing
grafana_a_ip_address          = "34.136.247.91" // update_me
grafana_a_license_file        = "/Users/akc/Desktop/Playground/dr/stack/ge_uscentral_license.jwt" // update_me

grafana_b_ip_address          = "34.89.92.217" // update_me
grafana_b_license_file        = "/Users/akc/Desktop/Playground/dr/stack/ge_europe_license.jwt" // update_me

// --------------------------------------------------------
// Grafana Agent Safe Default Variables
data_shipper_tenant_name        = "tenant1"
data_shipper_oidc_client_id     = "data_shipper_tenant1"

// --------------------------------------------------------
// Grafana Agent Variables That Need Changing
data_shipper_oidc_client_secret = "8ukCPNmwSDKCk0ziwWcFYjLDck4QvNZC" // update_me
data_shipper_oidc_token_url     = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/token" // update_me

