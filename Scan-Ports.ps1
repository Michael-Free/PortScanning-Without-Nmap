# This is all examples! Please dont run this and expect results!

# Ping Test
Test-NetworkConnection <IP Address>

# Trace Route
Test-NetworkConnection <IP AddresS> -TraceRoute

# Trace Route - Limiting Hop counts
Test-NetworkConnection <IP Address> -TraceRoute -Hops <int>

# Test an open port 
Test-NetworkConnection <IP Address> -port <Port Number>

# Port Scan (slow)
$ip = <IP Address>
$PortStartRange = 1
$PortEndRange = 10000
$result = @()

for ($port = $PortStartRange; $port -le $PortEndRange ; $port ++) {

   $result += (Test-NetworkConnection $ip -port $port) | select remoteport, tcptestsucceeded

   }

# Port Scan - Show Only Open Ports (Slow)
$ip = <IP Address>
$PortStartRange = 1
$PortEndRange = 10000

$result = @()

for ($port = $PortStartRange; $port -le $PortEndRange ; $port ++) {

   $a = (Test-NetworkConnection $ip -port $port) | select remoteport, tcptestsucceeded

   if ($a.tcptestsucceeded ) {

        $result += $a

        }

   }
