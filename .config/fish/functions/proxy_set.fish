function proxy_set --description "Set proxy"
    gost -L=http://:8080 -F=socks5://37.32.12.91:443 > /dev/null 2>&1 &

    echo "Gost process started."

    echo $last_pid > $HOME/.gost-process-id

    export http_proxy="http://localhost:8080"
    export https_proxy="http://localhost:8080"

    echo "Proxy set."
end
