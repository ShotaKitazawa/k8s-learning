# etcd を 1 号機にインストールする。

* etcd は v2/v3 2種類がある
    * etcd v2 を使う場合には、kube-apiserver を起動する際に、--storage-backend=etcd2 のオプションが必要


## Download
```bash
wget -q --show-progress --https-only --timestamping   "https://github.com/etcd-io/etcd/releases/download/v3.4.10/etcd-v3.4.10-linux-amd64.tar.gz"
```

