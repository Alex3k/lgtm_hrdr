// Common Variables
gcp_project_id = "solutions-engineering-248511"

gcp_svc_acc_file_path = "/Users/akc/Desktop/Playground/dr/gcp-svc-acc.json"
owner_name            = "alexkirtleyclose"

gcp_region_a           = "us-central1"
gcp_region_b           = "europe-west2"
gcp_gke_cluster_name_a = "akc-hadr-uscentral"
gcp_gke_cluster_name_b = "akc-hadr-europe"

// --------------------------------------------------------
// GEM Specific Variables
authproxy_name_prefix    = "akc"
oidc_access_policy_claim = "Grafana/access_policies"
gem_admin_token_override = "X19hZG1pbl9fLTBmZDQ1ZTc2ZDVhNTkyOWE6XzJsajMifTckNTYrXypmOC9RMVw2NSo5"
oidc_issuer_url          = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc"


gem_a_license_file      = "/Users/akc/Desktop/Playground/dr/stack/gem_uscentral_license.jwt"
gem_a_cluster_name      = "akc-gem-uscentral"
gcp_gcs_bucket_prefix_a = "akc-uscentral"


gem_b_license_file      = "/Users/akc/Desktop/Playground/dr/stack/gem_europe_license.jwt"
gem_b_cluster_name      = "akc-gem-europe"
gcp_gcs_bucket_prefix_b = "akc-europe"


// --------------------------------------------------------
// Grafana Enterprise Specific Variables

oidc_auth_url      = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/auth"
oidc_client_id     = "gem"
oidc_client_secret = "hfQDPJIHd1SuxlyjbTUJt3SFpowJzfLt"
oidc_token_url     = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/token"
oidc_userinfo_url  = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/userinfo"

grafana_role_attribute_path = "contains(realm_access.roles[*], 'Grafana/Admin') && 'Admin' || contains(realm_access.roles[*], 'Grafana/Editor') && 'Editor' || 'Viewer'"


grafana_a_deployment_name     = "akc-ge-uscentral"
grafana_a_ip_address          = "34.136.247.91"
grafana_a_license_file        = "/Users/akc/Desktop/Playground/dr/stack/ge_uscentral_license.jwt"
grafana_a_mysql_database_name = "akc-uscentral-ge-database"


grafana_b_deployment_name     = "akc-ge-europe"
grafana_b_ip_address          = "34.89.92.217"
grafana_b_license_file        = "/Users/akc/Desktop/Playground/dr/stack/ge_europe_license.jwt"
grafana_b_mysql_database_name = "akc-europe-ge-database"

// --------------------------------------------------------
// Grafana Agent Specific Variables

data_shipper_tenant_name        = "tenant1"
data_shipper_oidc_client_id     = "data_shipper_tenant1"
data_shipper_oidc_client_secret = "8ukCPNmwSDKCk0ziwWcFYjLDck4QvNZC"
data_shipper_oidc_token_url     = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/token"

