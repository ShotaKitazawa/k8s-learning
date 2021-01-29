# etcd を 1 号機にインストールする

* etcd v3 を 1 号機にインストールする
    * https://github.com/etcd-io/etcd

* 参考: Systemd Unit file
    * https://github.com/etcd-io/etcd/blob/master/contrib/systemd/etcd.service

```
[Unit]
Description=etcd key-value store
Documentation=https://github.com/etcd-io/etcd
After=network.target

[Service]
#User=etcd
User=root
Type=notify
Environment=ETCD_DATA_DIR=/var/lib/etcd
Environment=ETCD_NAME=%m
ExecStart=/usr/bin/etcd
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
```
