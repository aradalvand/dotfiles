function hostproxy
    if test -z $argv[1]
        echo "Usage: hostproxy <port>"
        return 1
    end

    set HOST_IP (ip route show | grep -i default | awk '{ print $3}')
    set -x https_proxy http://$HOST_IP:$argv[1]
    set -x http_proxy http://$HOST_IP:$argv[1]
    export https_proxy
    export http_proxy
    
    echo "Proxy set to http://$HOST_IP:$argv[1]"
end
