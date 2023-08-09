# 3600 printer driver installation for redacted
# written by Regan Kouchoo @ redacted.net.au
# define what and where we want to install this printer

$drivername = "HP DesignJet XL 3600 V4"
$printername = "HP DesignJet XL 3600"
$ip = "REDACTED"
$driverpath = "\\REDACTED\temp\V4\PCL3\x64\hpi2144.inf"
$tcpportid = "TCPPort:REDACTED"

# check if the printer is already installed (inverse boolean)
$nameinst = ($null -eq (Get-Printer -name $printername -ErrorAction SilentlyContinue))
$tcpinst = ($null -eq (Get-PrinterPort -name $tcpportid -ErrorAction SilentlyContinue))
$driverinst = ($null -eq (Get-PrinterDriver -name $drivername -ErrorAction SilentlyContinue))

mapPrinter

# check the tested values, install if something is missing
function mapPrinter {
    if ($driverinst) {
        PnPutil /a $driverpath | Out-Null
        Write-Host "Installed printer driver"
        Add-PrinterDriver -Name $drivername
    } else {
        Write-Host "Driver is already installed"
    }

    if ($tcpinst) {
        Add-PrinterPort -Name $tcpportid -PrinterHostAddress $ip
        Write-Host "Installed printer port"
    } else {
        Write-Host "Printer port is already installed"
    }

    if ($nameinst) {
        Add-Printer -Name $printername -DriverName $drivername -PortName $tcpportid
        Write-Host "Installed printer" 
    } else {
        Write-Host "Printer is already installed"
    }
}

# testing
function removePrinter {
    Remove-Printer $printername
    Remove-PrinterPort $tcpportid
    Remove-PrinterDriver $drivername
}
