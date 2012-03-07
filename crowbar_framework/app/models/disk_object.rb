# Copyright 2012, Dell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author: Chris Dearborn
#

class Disk
  attr_reader :name, :model, :removable, :rev, :size, :state, :timeout, :usage, :vendor, :vendor_id, :device_id, :driver_type

  def initialize(disk_name, disk_data, disk_config)
    @name = "/dev/#{disk_name}"
    @model = disk_data["model"] || "Unknown"
    @removable = disk_data["removable"] != "0"
    @rev = disk_data["rev"] || "Unknown"
    @size = (disk_data["size"] || 0).to_i
    @state = disk_data["state"] || "Unknown"
    @timeout = (disk_data["timeout"] || 0).to_i
    @usage = disk_data["usage"] || "Unknown"
    @vendor = disk_data["vendor"] || "NA"
    @vendor_id = disk_config["vendor_id"]
    @device_id = disk_config["device_id"]
    @driver_type = disk_config["driver_type"]
  end

  def self.size_to_bytes(s)
    case s
      when /^([0-9]+)$/
      return $1.to_f

      when /^([0-9]+)[Kk][Bb]$/
      return $1.to_f * 1024

      when /^([0-9]+)[Mm][Bb]$/
      return $1.to_f * 1024 * 1024

      when /^([0-9]+)[Gg][Bb]$/
      return $1.to_f * 1024 * 1024 * 1024

      when /^([0-9]+)[Tt][Bb]$/
      return $1.to_f * 1024 * 1024 * 1024 * 1024
    end
    -1
  end

  def is_internal_disk?( internal_disk_config )
    # Check to see if the driver type of the disk controller is in our config
    internal_disk_config["driver_types"].each do |driver_type|
      return true if @driver_type.casecmp( driver_type ) == 0
    end

    # Check to see if the vendor ID/device ID of the disk controller is in our config
    internal_disk_config["pci_ids"].each do |pci_id|
      return true if @vendor_id.casecmp( pci_id["vendor_id"] ) == 0 &&
          @device_id.casecmp( pci_id["device_id"] ) == 0
    end

    false
  end
end
