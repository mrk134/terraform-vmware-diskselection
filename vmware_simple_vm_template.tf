provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.host}"
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "dc" {
  name = "${var.region}"
}
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster}/Resources"
datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_network" "network" {
  name          = "${var.network_interface}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
# Retrieve template information on vsphere
data "vsphere_virtual_machine" "template" {
  name          = "${var.templateName}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
#resource "vsphere_virtual_disk" "myDisk" {
 # size         = "${var.disksize}"
 # vmdk_path    = "${var.diskpath}"
 # datacenter = "${data.vsphere_datacenter.dc.name}"
 # datastore    = "${var.datastore}"
 # type         = "thin"
#}
#### VM CREATION ####
# Set vm parameters
resource "vsphere_virtual_machine" "vm-one" {
  name                 = "${var.vmname}"
  num_cpus             = "${var.vmcpu}"
  memory               = "${var.vmmemory}"
  datastore_id         = "${data.vsphere_datastore.datastore.id}"
  #host_system_id      = "${data.vsphere_host.host.id}"
  resource_pool_id     = "${data.vsphere_resource_pool.pool.id}"
  guest_id             = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type            = "${data.vsphere_virtual_machine.template.scsi_type}"
  folder               = "${var.region}/vm/${var.foldername}"
  tags = ["${data.vsphere_tag.Application.id}",
	  "${data.vsphere_tag.BusinessService.id}",
	  "${data.vsphere_tag.CostCenter.id}",
	  "${data.vsphere_tag.UserGroup.id}",
	  "${data.vsphere_tag.User.id}"]
	# Set network parameters
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  # Use a predefined vmware template has main disk
 # disk {
  #  size ="${var.disksize}"
   # label="demodisk1"
    #attach = true
    #datastore_id     = "${data.vsphere_datastore.datastore.id}"
    #path = "${vsphere_virtual_disk.myDisk.vmdk_path}"
    #unit_number = 1
    #thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
 # }
disk {
    label="testdisk1.vmdk"
    size = "${var.disksize}"
thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.hostname}"
        domain    = "${var.domain}"
      }
      network_interface {
	    ipv4_address = "${var.vmipaddress}"
	    ipv4_netmask = "24"
      }
      ipv4_gateway = "139.178.75.1"
      #dns_server_list = ["156.54.205.68","156.54.240.134"]
    }
  }
}

data "vsphere_tag_category" "category" {
  name        = "general_info"
  #cardinality = "SINGLE"
  #description = "General Info"

 #associable_types = [
   # "VirtualMachine",
   # "Datastore",
  #]
}

data "vsphere_tag" "Application" {
  name        = "Application"
  category_id = "${data.vsphere_tag_category.category.id}"
  #description = "Apache"
}

data "vsphere_tag" "CostCenter" {
  name        = "CostCenter"
  category_id = "${data.vsphere_tag_category.category.id}"
  #description = "Digital App"
}

data "vsphere_tag" "BusinessService" {
  name        = "BusinessService"
  category_id = "${data.vsphere_tag_category.category.id}"
  #description = "Devteam"
}

data "vsphere_tag" "UserGroup" {
  name        = "UserGroup"
  category_id = "${data.vsphere_tag_category.category.id}"
  #description = "ITOM EMEA PLSC"
}

data "vsphere_tag" "User" {
  name        = "User"
  category_id = "${data.vsphere_tag_category.category.id}"
  #description = "Mark Radonic"
}
