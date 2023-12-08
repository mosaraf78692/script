# #!/bin/bash
 
# # Function to get system information
# get_system_info() {
#     echo "Device Name: $(hostname)"
#     echo "Device Manufacturer: Apple"
#     echo "Device Model: $(sysctl -n hw.model)"
#     echo "Device Serial Number: $(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')"
#     echo "Processor: $(sysctl -n machdep.cpu.brand_string)"
#     echo "RAM Capacity: $(system_profiler SPHardwareDataType | awk '/Memory/ {print $2$3}')"
#     echo "Storage Capacity: $(df -H / | awk 'NR==2 {print $2}')"
#     echo "Storage Type: $(diskutil info / | awk '/Media Type/ {print $3}')"
#     echo "Storage BusType: $(system_profiler SPSerialATADataType | awk '/Medium Type/ {print $3}')"
#     echo "OS: $(sw_vers -productName)"
#     echo "OS Version: $(sw_vers -productVersion)"
#     echo "OS Build: $(sw_vers -buildVersion)"
#     echo "OS Architecture: $(uname -m)"
# }
 
# # Call the function to get and display system information
# get_system_info




#!/bin/bash

# Function to get system details
get_system_details() {
    echo "\"Device Name\",\"Device Manufacturer\",\"Device Model\",\"Device Serial Number\",\"Processor\",\"RAM Capacity\",\"Storage Capacity\",\"Storage Type\",\"Storage Bus Type\",\"OS\",\"OS Version\",\"OS Build\",\"OS Architecture\",\"RAM Serial Number\",\"Hard Disk Serial Number\""

    device_name=$(uname -n)
    manufacturer=$(system_profiler SPHardwareDataType | awk '/Manufacturer/ {print $3}')
    model=$(system_profiler SPHardwareDataType | awk '/Model Identifier/ {print $3}')
    serial_number=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
    processor=$(sysctl -n machdep.cpu.brand_string)
    ram_capacity=$(sysctl -n hw.memsize | awk '{print $0/1024^3 " GB"}')
    storage_capacity=$(df -h / | awk 'NR==2 {print $2}')
    storage_info=$(diskutil info / | grep "Media Name" | awk -F: '{print $2}' | sed 's/^[ \t]*//')
    storage_type="Unknown" # Mac doesn't explicitly specify disk type in diskutil output
    storage_bus_type="Unknown" # Mac doesn't explicitly specify bus type in diskutil output
    os=$(sw_vers -productName)
    os_version=$(sw_vers -productVersion)
    os_build=$(sw_vers -buildVersion)
    os_architecture=$(uname -m)
    ram_serial_number="N/A" # Mac doesn't provide RAM serial number
    hard_disk_serial_number=$(diskutil info / | grep "Serial Number" | awk -F: '{print $2}' | sed 's/^[ \t]*//')

    echo "\"$device_name\",\"$manufacturer\",\"$model\",\"$serial_number\",\"$processor\",\"$ram_capacity\",\"$storage_capacity\",\"$storage_type\",\"$storage_bus_type\",\"$os\",\"$os_version\",\"$os_build\",\"$os_architecture\",\"$ram_serial_number\",\"$hard_disk_serial_number\""
}

# Get system details and write to CSV file
get_system_details > system_details.csv

echo "System details written to system_details.csv"







