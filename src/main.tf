module "subnetwork" {
  source             = "../../terraform-modules/azure/subnetwork"
  md_metadata        = var.md_metadata
  region             = var.region
  network_mask       = trim(var.network_mask, "/") # see comment in the variables file of the module
  virtual_network_id = var.virtual_network.data.infrastructure.id
}
