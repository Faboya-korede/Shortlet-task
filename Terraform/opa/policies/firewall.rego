package terraform

# Rule to check if port 22 is allowed in firewall rules
is_port_22_allowed {
    some i
    input.resource_changes[i].type == "google_compute_firewall"
    input.resource_changes[i].change.after.allow[_].ports[_] == "22"
}

# Rule to deny if port 22 is allowed in firewall rules
deny[msg] {
    is_port_22_allowed
    msg = "Firewall rules must not allow port 22"
}
