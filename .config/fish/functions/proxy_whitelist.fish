function proxy_whitelist --description "Whitelist current IP for port 443 via SSH on the proximate server"
	echo "Fetching public IP address..."

    # Fetch the host machine's public IP address
    set HOST_IP (curl --noproxy '*' -s ifconfig.co)

    # Check if the IP address was fetched successfully
    if test -z "$HOST_IP"
        echo "Failed to fetch public IP address. Exiting."
        return 1
    end

    # Display the fetched IP address
    echo "Detected IP address $HOST_IP"

    # Define the remote server credentials
    set REMOTE_USER "ubuntu"
    set REMOTE_HOST "37.32.12.91"

    echo "SSHing into $REMOTE_USER@$REMOTE_HOST..."

    # SSH into the remote server and add UFW rule to whitelist the IP
    ssh $REMOTE_USER@$REMOTE_HOST "sudo ufw allow from $HOST_IP to any port 443 proto tcp"

    # Check if the command was successful
    if test $status -eq 0
        echo "Successfully added UFW rule to allow $HOST_IP on port 443."
    else
        echo "Failed to add UFW rule. Please check the SSH connection and permissions."
    end
end
