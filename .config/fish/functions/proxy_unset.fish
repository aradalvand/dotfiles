function proxy_unset --description "Set proxy"
    set gost_process_id (cat $HOME/.gost-process-id)

    kill -s TERM $gost_process_id

    echo "Stopped Gost process."

    set -e http_proxy
    set -e https_proxy

    echo "Proxy unset."
end
