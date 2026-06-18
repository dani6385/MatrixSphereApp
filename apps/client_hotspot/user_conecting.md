:local identity [/system identity get name]
:local newHosts [/ip hotspot host find authorized=no]

:foreach h in=$newHosts do={
    :local rawIp [/ip hotspot host get $h address]
    :local rawMac [/ip hotspot host get $h mac-address]
    
    # Sanitasi IP
    :local ipAddress ""
    :for i from=0 to=([:len $rawIp]-1) do={
        :local char [:pick $rawIp $i ($i+1)]
        :if ($char = ".") do={ set $ipAddress ($ipAddress . "_") } else={ set $ipAddress ($ipAddress . $char) }
    }

    # Sanitasi MAC
    :local macAddress ""
    :for i from=0 to=([:len $rawMac]-1) do={
        :local char [:pick $rawMac $i ($i+1)]
        :if ($char = ":") do={ set $macAddress ($macAddress . "_") } else={ set $macAddress ($macAddress . $char) }
    }

    :local url ("https://matrixsphere-project-default-rtdb.asia-southeast1.firebasedatabase.app/mikrotik_data/" . $identity . "/wait/" . $ipAddress . ".json")
    
    # MEMPERBAIKI DATA JSON: Gunakan tanda petik tunggal untuk pembungkus luar
    # Ini sering kali menghilangkan error 'expected end of command'
    :local jsonData "{\"status\":\"menunggu\",\"ip\":\"$rawIp\",\"mac\":\"$rawMac\"}"
    
    /tool fetch mode=https http-method=put url=$url http-data=$jsonData output=none
}