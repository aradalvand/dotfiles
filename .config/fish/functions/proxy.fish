function proxy --description "Manage proxy settings and whitelist IPs"
    # Check for subcommand
    if test (count $argv) -lt 1
        echo "Usage: proxy [set|unset|whitelist]"
        return 1
    end

    set subcommand $argv[1]

    switch $subcommand
        case set
            # Start proxy
            gost -L=http://:8080 -F=socks5://37.32.12.91:443 > /dev/null 2>&1 &

            echo "Gost process started."

            echo $last_pid > $HOME/.gost-process-id

            export http_proxy="http://localhost:8080"
            export https_proxy="http://localhost:8080"

            echo "Proxy set."

        case unset
            # Stop proxy
            set gost_process_id (cat $HOME/.gost-process-id)

            sudo kill -s TERM $gost_process_id

            echo "Stopped Gost process."

            set -e http_proxy
            set -e https_proxy

            echo "Proxy unset."

        case whitelist
            # Whitelist current IP
            echo "Fetching public IP address..."

            set HOST_IP (curl --noproxy '*' -s ifconfig.co)

            if test -z "$HOST_IP"
                echo "Failed to fetch public IP address. Exiting."
                return 1
            end

            echo "Detected IP address $HOST_IP"

            set REMOTE_USER "ubuntu"
            set REMOTE_HOST "37.32.12.91"

            echo "SSHing into $REMOTE_USER@$REMOTE_HOST..."

            ssh $REMOTE_USER@$REMOTE_HOST "sudo ufw allow from $HOST_IP to any port 443 proto tcp"

            if test $status -eq 0
                echo "Successfully added UFW rule to allow $HOST_IP on port 443."
            else
                echo "Failed to add UFW rule. Please check the SSH connection and permissions."
            end

        case '*'
            echo "Unknown subcommand: $subcommand"
            echo "Usage: proxy [set|unset|whitelist]"
            return 1
    end
end
