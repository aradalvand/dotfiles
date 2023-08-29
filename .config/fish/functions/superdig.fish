function superdig
	set -l nameServers (dig +short $argv ns)
	set -l aRecords (dig +short $argv a)
	echo "Nameservers: $nameServers"
	echo "A Records: $aRecords"
	curl -s "ifconfig.co/json?ip=$aRecords[1]" | jq
end
