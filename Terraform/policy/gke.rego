package terraform

# Rule to check if any GKE cluster is in us-central
is_us_central_cluster {
    some i
    input.resource_changes[i].type == "google_container_cluster"
    input.resource_changes[i].change.after.location == "us-central"
}

# Rule to deny if no GKE cluster is in us-central
deny[msg] {
    not is_us_central_cluster
    msg = "GKE cluster region must be set to us-central"
}