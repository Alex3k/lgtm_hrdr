// --------------------------------------------------------
// Common Safe Default Variables 
gcp_region_a             = "us-central1"
gcp_region_b             = "europe-west2"
gcp_gke_cluster_name_a   = "akc-hadr-uscentral"
gcp_gke_cluster_name_b   = "akc-hadr-europe"
oidc_access_policy_claim = "Grafana/access_policies"

// --------------------------------------------------------
// Common Variables That Need Changing
gcp_project_id        = "solutions-engineering-248511"                         
gcp_svc_acc_file_path = "/Users/akc/Desktop/Playground/dr/gcp-svc-acc.json"    
owner_name            = "alexkirtleyclose"                                     
oidc_issuer_url       = "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc" 

// --------------------------------------------------------
// GEM Safe Default Variables
authproxy_name_prefix    = "akc"
gem_admin_token_override = "X19hZG1pbl9fLTBmZDQ1ZTc2ZDVhNTkyOWE6XzJsajMifTckNTYrXypmOC9RMVw2NSo5"
gem_a_cluster_name       = "akc-gem-uscentral"
gem_b_cluster_name       = "akc-gem-europe"

// --------------------------------------------------------
// GEM Variables That Need Changing
gem_a_license_file = "/Users/akc/Desktop/Playground/dr/stack/gem_uscentral_license.jwt" 
gem_b_license_file = "/Users/akc/Desktop/Playground/dr/stack/gem_europe_license.jwt"    

// --------------------------------------------------------
// GEL Safe Default Variables
gel_admin_token_override = "X19hZG1pbl9fLTBmZDQ1ZTc2ZDVhNTkyOWE6XzJsajMifTckNTYrXypmOC9RMVw2NSo5"
gel_a_cluster_name       = "akc-gel-uscentral"
gel_b_cluster_name       = "akc-gel-europe"

// --------------------------------------------------------
// GEL Variables That Need Changing
gel_a_license_file = "/Users/akc/Desktop/Playground/dr/stack/gel_uscentral_license.jwt" 
gel_b_license_file = "/Users/akc/Desktop/Playground/dr/stack/gel_europe_license.jwt"    

// --------------------------------------------------------
// Grafana Enterprise Safe Default Variables
oidc_client_id                = "gex_ge"
grafana_role_attribute_path   = "contains(realm_access.roles[*], 'Grafana/Admin') && 'Admin' || contains(realm_access.roles[*], 'Grafana/Editor') && 'Editor' || 'Viewer'"
grafana_a_deployment_name     = "akc-ge-uscentral"
grafana_a_mysql_database_name = "akc-uscentral-ge-database"
grafana_b_deployment_name     = "akc-ge-europe"
grafana_b_mysql_database_name = "akc-europe-ge-database"


// --------------------------------------------------------
// Grafana Enterprise Safe Default Variables
oidc_client_secret = "Qmsl8zAVdDmvZt3861D0yft9Vq9LjrWA"                                                      
oidc_token_url     = "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc/protocol/openid-connect/token"    
oidc_userinfo_url  = "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc/protocol/openid-connect/userinfo" 
oidc_auth_url      = "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc/protocol/openid-connect/auth"     

// --------------------------------------------------------
// Grafana Enterprise Variables That Need Changing
grafana_global_ip_address   = "34.110.135.205"                                        
grafana_global_license_file = "/Users/akc/Desktop/Playground/dr/stack/ge_license.jwt" 

// --------------------------------------------------------
// Grafana Agent Safe Default Variables
data_shipper_tenant_name    = "tenant1"
data_shipper_oidc_client_id = "data_shipper_tenant1"

// --------------------------------------------------------
// Grafana Agent Variables That Need Changing
data_shipper_oidc_client_secret = "nvbcoab4AmjFxWIks0zWESSDGpX3t493"                                                   
data_shipper_oidc_token_url     = "https://lemur-14.cloud-iam.com/auth/realms/hadr_oidc/protocol/openid-connect/token" 

