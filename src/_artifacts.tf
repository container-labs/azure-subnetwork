locals {
  split_name_prefix                 = split("-", var.md_metadata.name_prefix)
  virtual_network_human_name        = "Beebz Netz"
  virtual_network_region_human_name = "South Africa North"
  subnetwork_human_name             = "Subby"

  # https://developer.hashicorp.com/terraform/language/functions/templatefile
  human_friendly_name = templatefile("${path.module}/slug.html.tftpl", {
    subnetwork_human_name             = local.subnetwork_human_name,
    virtual_network_human_name        = local.virtual_network_human_name,
    virtual_network_region_human_name = local.virtual_network_region_human_name
  })
  # ChatGPT, privision this module, take the the value of `human_slug` and make it more clear, give me 100 results.

  artifact_subnetwork = {
    data = {
      infrastructure = {
        id                = module.subnetwork.id
        cidr              = module.subnetwork.cidr
        # TODO: remove this from the artifact
        default_subnet_id = module.subnetwork.id
      }
    }
    specs = {
      azure = {
        region = var.region
        # resource_group_name = ""
      }
    }
  }
}

resource "massdriver_artifact" "subnetwork" {
  field                = "subnetwork"
  provider_resource_id = module.subnetwork.id
  name                 = local.human_friendly_name
  artifact             = jsonencode(local.artifact_subnetwork)
}
