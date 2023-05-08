#--------------------------------------
# General Options
#--------------------------------------
variable "alternate_guest_name" {
  description = "(Optional) The guest name for the operating system when guest_id is otherGuest or otherGuest64."
  default     = null
}

variable "annotation" {
  description = "(Optional) A user-provided description of the virtual machine."
  default     = null
}

variable "cdrom" {
  description = "(Optional) A specification for a CD-ROM device on the virtual machine."
  default     = {}
}

variable "clone" {
  description = "(Optional) When specified, the virtual machine will be created as a clone of a specified template. Optional customization options can be submitted for the resource."
  default     = {}
}

variable "extra_config_reboot_required" {
  description = "(Optional) Allow the virtual machine to be rebooted when a change to extra_config occurs. Default: true."
  default     = null
}

variable "custom_attributes" {
  description = "(Optional) Map of custom attribute ids to attribute value strings to set for virtual machine. Please refer to the vsphere_custom_attributes resource for more information on setting custom attributes."
  default     = {}
}

variable "datastore_id" {
  description = "(Optional) The managed object reference ID of the datastore in which to place the virtual machine. The virtual machine configuration files is placed here, along with any virtual disks that are created where a datastore is not explicitly specified."
  default     = null
}

variable "datastore_cluster_id" {
  description = "(Optional) The managed object reference ID of the datastore cluster in which to place the virtual machine. This setting applies to entire virtual machine and implies that you wish to use vSphere Storage DRS with the virtual machine."
  default     = null
}

variable "datacenter_id" {
  description = "(Optional) The datacenter ID. Required only when deploying an OVF/OVA template."
  default     = null
}

variable "disk" {
  description = "(Required) A specification for a virtual disk device on the virtual machine."
}

variable "extra_config" {
  description = "(Optional) Extra configuration data for the virtual machine. Can be used to supply advanced parameters not normally in configuration, such as instance metadata and userdata."
  default     = {}
}

variable "firmware" {
  description = "(Optional) The firmware for the virtual machine. One of bios or efi."
  default     = null
}

variable "folder" {
  description = "(Optional) The path to the virtual machine folder in which to place the virtual machine, relative to the datacenter path (/<datacenter-name>/vm). For example, /dc-01/vm/foo"
  default     = null
}

variable "guest_id" {
  description = "(Optional) The guest ID for the operating system type. For a full list of possible values, see here. Default: otherGuest64."
  default     = null
}

variable "hardware_version" {
  description = "(Optional) The hardware version number. Valid range is from 4 to 19. The hardware version cannot be downgraded."
  default     = null
}

variable "host_system_id" {
  description = "(Optional) The managed object reference ID of a host on which to place the virtual machine."
  default     = null
}

variable "name" {
  description = "(Required) The name of the virtual machine."
}

variable "network_interface" {
  description = "(Required) A specification for a virtual NIC on the virtual machine."
}

variable "pci_device_id" {
  description = "(Optional) List of host PCI device IDs in which to create PCI passthroughs."
  default     = null
}

variable "ovf_deploy" {
  description = "(Optional) When specified, the virtual machine will be deployed from the provided OVF/OVA template."
  default     = null
}

variable "replace_trigger" {
  description = "(Optional) Triggers replacement of resource whenever it changes."
  default     = null
}

variable "resource_pool_id" {
  description = "(Required) The managed object reference ID of the resource pool in which to place the virtual machine."
}

variable "scsi_type" {
  description = "(Optional) The SCSI controller type for the virtual machine. One of lsilogic (LSI Logic Parallel), lsilogic-sas (LSI Logic SAS) or pvscsi (VMware Paravirtual). Default: pvscsi."
  default     = null
}

variable "scsi_bus_sharing" {
  description = "(Optional) The type of SCSI bus sharing for the virtual machine SCSI controller. One of physicalSharing, virtualSharing, and noSharing. Default: noSharing."
  default     = null
}

variable "storage_policy_id" {
  description = "(Optional) The ID of the storage policy to assign to the home directory of a virtual machine."
  default     = null
}

variable "tags" {
  description = "(Optional) The IDs of any tags to attach to this resource. Please refer to the vsphere_tag resource for more information on applying tags to virtual machine resources."
  default     = null
}

variable "vapp" {
  description = "(Optional) Used for vApp configurations. The only sub-key available is properties, which is a key/value map of properties for virtual machines imported from and OVF/OVA."
  default     = null
}

#--------------------------------------
# CPU and Memory Options
#--------------------------------------
variable "cpu_hot_add_enabled" {
  description = "(Optional) Allow CPUs to be added to the virtual machine while it is powered on."
  default     = null
}

variable "cpu_hot_remove_enabled" {
  description = "(Optional) Allow CPUs to be removed to the virtual machine while it is powered on."
  default     = null
}

variable "memory" {
  description = "(Optional) The memory size to assign to the virtual machine, in MB. Default: 1024 (1 GB)."
  default     = null
}

variable "memory_hot_add_enabled" {
  description = "(Optional) Allow memory to be added to the virtual machine while it is powered on."
  default     = null
}

variable "num_cores_per_socket" {
  description = "(Optional) The number of cores per socket in the virtual machine. The number of vCPUs on the virtual machine will be num_cpus divided by num_cores_per_socket. If specified, the value supplied to num_cpus must be evenly divisible by this value. Default: 1."
  default     = null
}

variable "num_cpus" {
  description = "(Optional) The total number of virtual processor cores to assign to the virtual machine. Default: 1."
  default     = null
}

#--------------------------------------
# Boot Options
#--------------------------------------
variable "boot_delay" {
  description = "(Optional) The number of milliseconds to wait before starting the boot sequence. The default is no delay."
  default     = null
}

variable "boot_retry_delay" {
  description = "(Optional) The number of milliseconds to wait before retrying the boot sequence. This option is only valid if boot_retry_enabled is true. Default: 10000 (10 seconds)."
  default     = null
}

variable "boot_retry_enabled" {
  description = "(Optional) If set to true, a virtual machine that fails to boot will try again after the delay defined in boot_retry_delay. Default: false."
  default     = null
}

variable "efi_secure_boot_enabled" {
  description = "(Optional) Use this option to enable EFI secure boot when the firmware type is set to is efi. Default: false."
  default     = null
}

#--------------------------------------
# VMware Tools Options
#--------------------------------------
variable "run_tools_scripts_after_power_on" {
  description = "(Optional) Enable post-power-on scripts to run when VMware Tools is installed. Default: true."
  default     = null
}

variable "run_tools_scripts_after_resume" {
  description = "(Optional) Enable ost-resume scripts to run when VMware Tools is installed. Default: true."
  default     = null
}

variable "run_tools_scripts_before_guest_reboot" {
  description = "(Optional) Enable pre-reboot scripts to run when VMware Tools is installed. Default: false."
  default     = null
}

variable "run_tools_scripts_before_guest_shutdown" {
  description = "(Optional) Enable pre-shutdown scripts to run when VMware Tools is installed. Default: true."
  default     = null
}

variable "run_tools_scripts_before_guest_standby" {
  description = "(Optional) Enable pre-standby scripts to run when VMware Tools is installed. Default: true."
  default     = null
}

variable "sync_time_with_host" {
  description = "(Optional) Enable the guest operating system to synchronization its clock with the host when the virtual machine is powered on or resumed. Requires vSphere 7.0 Update 1 and later. Requires VMware Tools to be installed. Default: false."
  default     = null
}

variable "sync_time_with_host_periodically" {
  description = "(Optional) Enable the guest operating system to periodically synchronize its clock with the host. Requires vSphere 7.0 Update 1 and later. On previous versions, setting sync_time_with_host is will enable periodic synchronization. Requires VMware Tools to be installed. Default: false."
  default     = null
}

variable "tools_upgrade_policy" {
  description = "(Optional) Enable automatic upgrade of the VMware Tools version when the virtual machine is rebooted. If necessary, VMware Tools is upgraded to the latest version supported by the host on which the virtual machine is running. Requires VMware Tools to be installed. One of manual or upgradeAtPowerCycle. Default: manual."
  default     = null
}

#--------------------------------------
# Resource Allocation Options
#--------------------------------------
variable "cpu_limit" {
  description = "(Optional) The maximum amount of CPU (in MHz) that the virtual machine can consume, regardless of available resources. The default is no limit."
  default     = null
}

variable "cpu_reservation" {
  description = "(Optional) The amount of CPU (in MHz) that the virtual machine is guaranteed. The default is no reservation."
  default     = null
}

variable "cpu_share_level" {
  description = "(Optional) The allocation level for the virtual machine CPU resources. One of high, low, normal, or custom. Default: custom."
  default     = null
}

variable "cpu_share_count" {
  description = "(Optional) The number of CPU shares allocated to the virtual machine when the cpu_share_level is custom."
  default     = null
}

variable "memory_limit" {
  description = "(Optional) The maximum amount of memory (in MB) that th virtual machine can consume, regardless of available resources. The default is no limit."
  default     = null
}

variable "memory_reservation" {
  description = "(Optional) The amount of memory (in MB) that the virtual machine is guaranteed. The default is no reservation."
  default     = null
}

variable "memory_share_level" {
  description = "(Optional) The allocation level for the virtual machine memory resources. One of high, low, normal, or custom. Default: custom."
  default     = null
}

variable "memory_share_count" {
  description = "(Optional) The number of memory shares allocated to the virtual machine when the memory_share_level is custom."
  default     = null
}