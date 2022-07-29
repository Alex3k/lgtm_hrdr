gcp_project_id="solutions-engineering-248511"

gcp_svc_acc_file_path="/Users/akc/Desktop/Playground/dr/gcp-svc-acc.json"

oidc_client_id = "gem"
oidc_client_secret = "hfQDPJIHd1SuxlyjbTUJt3SFpowJzfLt"
oidc_auth_url = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/auth"
oidc_token_url = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/token"
oidc_userinfo_url = "https://lemur-14.cloud-iam.com/auth/realms/gem-oidc/protocol/openid-connect/userinfo"

owner_name="alexkirtleyclose"

grafana_role_attribute_path = "contains(realm_access.roles[*], 'Grafana/Admin') && 'Admin' || contains(realm_access.roles[*], 'Grafana/Editor') && 'Editor' || 'Viewer'"


grafana_a_gcp_region="us-central1"

grafana_a_deployment_name= "ge-uscentral"

grafana_a_gke_cluster_name="akc-gem-uscentral"

grafana_a_ip_address = "34.136.247.91"

grafana_a_license_file = "/Users/akc/Desktop/Playground/dr/ge/uscentral_license.jwt"

grafana_a_mysql_database_name = "akc-uscentral-ge-database"


grafana_b_gcp_region="europe-west2"

grafana_b_deployment_name= "ge-europe"

grafana_b_gke_cluster_name="akc-gem-europe"

grafana_b_ip_address = "34.89.92.217"

grafana_b_license_file = "/Users/akc/Desktop/Playground/dr/ge/europe_license.jwt"

grafana_b_mysql_database_name = "akc-europe-ge-database"


