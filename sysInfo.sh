#! /bin/bash

#Prepare variable for echo
toEcho=""

#CPU Usage
toEcho="$[100-$(vmstat|tail -1|awk '{print $15}')]%"

#RAM Usage
memTotal=$(cat /proc/meminfo | grep 'MemTotal')
memTotal="${memTotal/'MemTotal: '/''}"
memTotal="${memTotal/' kB'/''}"
memTotal="${memTotal/'      '/''}"
memFree=$(cat /proc/meminfo | grep 'MemAvailable')
memFree="${memFree/'MemAvailable: '/''}"
memFree="${memFree/' kB'/''}"
memFree="${memFree/'       '/''}"
memUsed=$(echo "(($memTotal-$memFree)/$memTotal)*100" | bc -l)
memUsed=$(printf "%.*f\n" 0 $memUsed)
memUsed="$memUsed%"
toEcho="$toEcho $memUsed"

#Temperature
tempLine="$(sensors | grep 'Core 0:')"
beginningOfTempLine="Core 0:         +"
endOfTempLine="  (high = +80.0°C, crit = +100.0°C)"
tempLine="${tempLine/$beginningOfTempLine/''}"
tempLine="${tempLine/$endOfTempLine/''}"
tempLine="${tempLine/'.0°C'/''}"
#tempLine=$(echo "9*$tempLine/5+32" | bc) #Uncomment this line to convert the temperature to Fahrenheit.
tempLine="$tempLine°"
toEcho="$toEcho $tempLine"

#Return System Info
echo $toEcho
