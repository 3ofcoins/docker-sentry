etcd_get () {
    curl -s -L "${ETCD_URL}/v1/keys/${ETCD_PREFIX}/$1" \
        | python -c 'import json, sys ; v = json.load(sys.stdin).get("value", None) ; v and sys.stdout.write(v)'
}
