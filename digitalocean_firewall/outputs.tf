output "firewall_id" {
  value = digitalocean_firewall.firewall.id
  description = "The ID of the firewall"
}
