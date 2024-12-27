function proxy --description "Manage proxy settings and whitelist IPs"
    # Check for subcommand
    if test (count $argv) -lt 1
        echo "Usage: proxy [set|unset|whitelist]"
        return 1
    end

    function _reset
        if test -e "/tmp/gost-proxy.pid"
            sudo kill -s TERM $(cat /tmp/gost-proxy.pid)
        end
    end

    set subcommand $argv[1]

    switch $subcommand
        case set
            _reset

            # NOTE: We use gost to effectively transform a SOCKS proxy as an HTTP proxy, even though we coulud've done `http_proxy="socks5://37.32.12.91:443"`, because SOCKS itself is not supported by all programs that read `$http_proxy`. See https://askubuntu.com/a/1451781/1573432
            gost -L=http://:8080 -F=socks5://37.32.12.91:443 > /dev/null 2>&1 &
            # NOTE: So that the process outlasts the shell instance (this script)
            disown

            echo $last_pid > /tmp/gost-proxy.pid
            echo "Gost process started."

            export http_proxy="http://localhost:8080"
            export https_proxy="http://localhost:8080"

            echo "Proxy set."

        case unset
            _reset

            echo "Stopped Gost process."

            rm /tmp/gost-proxy.pid

            set -e http_proxy
            set -e https_proxy

            echo "Proxy unset."

        case whitelist
            echo "Fetching public IP address..."

            set HOST_IP (curl --noproxy '*' -s ifconfig.co)

            if test -z "$HOST_IP"
                echo "Failed to fetch public IP address. Exiting."
                return 1
            end

            echo "Detected IP address $HOST_IP"

            set REMOTE_USER "ubuntu"
            set REMOTE_HOST "37.32.12.91"

            echo "SSH'ing into $REMOTE_USER@$REMOTE_HOST..."

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
