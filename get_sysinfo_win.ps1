try {
    $System = Get-CimInstance -ClassName Win32_ComputerSystem
    $Bios = Get-CimInstance -ClassName Win32_BIOS
    $Processor = Get-CimInstance -ClassName Win32_Processor
    $Ram = Get-CimInstance -ClassName Win32_PhysicalMemory
    $Storage = Get-PhysicalDisk
    $Os = Get-CimInstance -ClassName Win32_OperatingSystem

    $ramSerial = (Get-WmiObject -Class Win32_PhysicalMemory | ForEach-Object { $_.SerialNumber }) -join ","
    $diskSerial = (Get-PhysicalDisk | ForEach-Object { $_.SerialNumber }) -join ","

    $Output = [PSCustomObject]@{
        "Device Name" = $System.Name
        "Device Manufacturer" = $System.Manufacturer
        "Device Model" = $System.Model
        "Device Serial Number" = $Bios.SerialNumber
        "Processor" = $Processor.Name
        "RAM Capacity" = '{0:N1} GB' -f (($Ram | Measure-Object -Property Capacity -Sum).sum / 1GB)
        "Storage Capacity" = ($Storage.Size | ForEach-Object { '{0:N1} GB' -f ($_ / 1GB) }) -join ", "
        "Storage Type" = $Storage.MediaType -join ", "
        "Storage BusType" = $Storage.BusType -join ", "
        "OS" = $Os.Caption
        "OS Version" = $Os.Version
        "OS Build" = $Os.BuildType
        "OS Architecture" = $Os.OSArchitecture
        "RAM Serial Number" = $ramSerial
        "Hard Disk Serial Number(PhysicalDisk)" = $diskSerial
    }

    $Output | Export-Csv -Path "System_Info.csv" -NoTypeInformation -Encoding utf8
}
catch {
    Write-Host "Error occurred: $_"
}

Write-Host "Okay!"


