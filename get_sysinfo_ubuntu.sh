#!/bin/bash

# Function to get system details
get_system_details() {
    echo "\"Device Name\",\"Device Manufacturer\",\"Device Model\",\"Device Serial Number\",\"Processor\",\"RAM Capacity\",\"Storage Capacity\",\"Storage Type\",\"Storage Bus Type\",\"OS\",\"OS Version\",\"OS Build\",\"OS Architecture\",\"RAM Serial Number\",\"Hard Disk Serial Number\""

    device_name=$(uname -n)
    manufacturer=$(dmidecode -s system-manufacturer)
    model=$(dmidecode -s system-product-name)
    serial_number=$(dmidecode -s system-serial-number)
    processor=$(lscpu | grep "Model name" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    ram_capacity=$(free -h | awk '/Mem:/ {print $2}')
    storage_capacity=$(df -h --total | awk '/total/ {print $2}')
    storage_info=$(lsblk -d -o NAME,SIZE,TYPE,TRAN,SERIAL | grep disk | head -n 1)
    storage_type=$(echo "$storage_info" | awk '{print $3}')
    storage_bus_type=$(echo "$storage_info" | awk '{print $4}')
    os=$(lsb_release -d | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    os_version=$(lsb_release -r | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    os_build=$(lsb_release -a | grep "Codename" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    os_architecture=$(uname -m)
    ram_serial_number=$(dmidecode -t 17 | grep "Serial Number" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    hard_disk_serial_number=$(echo "$storage_info" | awk '{print $5}')

    echo "\"$device_name\",\"$manufacturer\",\"$model\",\"$serial_number\",\"$processor\",\"$ram_capacity\",\"$storage_capacity\",\"$storage_type\",\"$storage_bus_type\",\"$os\",\"$os_version\",\"$os_build\",\"$os_architecture\",\"$ram_serial_number\",\"$hard_disk_serial_number\""
}

# Get system details and write to CSV file
get_system_details > System_Info.csv

echo "System details written to System_Info.csv"






