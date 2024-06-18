function Get-SubnetAddresses {
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputIp
    )

    # Validate the input format
    if (-not $InputIp -match '^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$') {
        throw "Invalid input format. Please use the format: IPv4Address/CIDR"
    }

    # Extract IP address and CIDR suffix
    $ip, $cidr = $InputIp.Split('/')
    $ipParts = $ip -split '\.'
    $cidr = [int]$cidr

    # Validate the IP address and CIDR suffix
    if ($cidr -lt 1 -or $cidr -gt 32) {
        throw "CIDR must be between 1 and 32."
    }

    foreach ($part in $ipParts) {
        if ($part -lt 0 -or $part -gt 255) {
            throw "IP address parts must be between 0 and 255."
        }
    }

    # Calculate the network address
    $subnetMask = -bnot ((1 -shl (32 - $cidr)) - 1)
    $ipDecimal = [uint32]0
    for ($i = 0; $i -lt 4; $i++) {
        $ipDecimal = $ipDecimal -shl 8 -bor [byte]$ipParts[$i]
    }
    $networkAddressDecimal = $ipDecimal -band $subnetMask
    $broadcastAddressDecimal = $networkAddressDecimal -bor (-bnot $subnetMask)

    # Generate all IP addresses in the subnet
    $start = $networkAddressDecimal + 1
    $end = $broadcastAddressDecimal - 1
    $addresses = @()
    for ($addr = $start; $addr -le $end; $addr++) {
        $byte1 = ($addr -shr 24) -band 0xFF
        $byte2 = ($addr -shr 16) -band 0xFF
        $byte3 = ($addr -shr 8) -band 0xFF
        $byte4 = $addr -band 0xFF
        $addresses += "$byte1.$byte2.$byte3.$byte4"
    }

    return $addresses
}

# Example usage
$subnet = "192.168.1.1/24"
$addresses = Get-SubnetAddresses -InputIp $subnet
$addresses
