resource "vsphere_tag_category" "category" {
  name        = "general_info"
  cardinality = "SINGLE"
  description = "General Info"

  associable_types = [
    "VirtualMachine",
    "Datastore",
  ]
}

resource "vsphere_tag" "Application" {
  name        = "Application"
  category_id = "${vsphere_tag_category.category.id}"
  description = "Apache"
}

resource "vsphere_tag" "BusinessService" {
  name        = "BusinessService"
  category_id = "${vsphere_tag_category.category.id}"
  description = "Digital App"
}

resource "vsphere_tag" "CostCenter" {
  name        = "CostCenter"
  category_id = "${vsphere_tag_category.category.id}"
  description = "Devteam"
}

resource "vsphere_tag" "UserGroup" {
  name        = "UserGroup"
  category_id = "${vsphere_tag_category.category.id}"
  description = "ITOM EMEA PLSC"
}

resource "vsphere_tag" "User" {
  name        = "User"
  category_id = "${vsphere_tag_category.category.id}"
  description = "Mark Radonic"
}
