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
