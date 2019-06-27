# kube-dns Pod を起動する

* https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns/kube-dns
    * 追加で、kube-dns の引数に `--kube-master-url=http://$ADDR:8080` を指定する
        * これがないとkube-dnsはkube-apiserverへhttpsで接続しに行こうとしてしまうためコケる
    * kube-dns service の clusterIPには、kubeletで設定した値を入れる
        * 他Podはkubeletに設定された値を見て DNS のアドレスを把握するため

* kubelet の設定を変更
    * pod の向くDNSをkube-dnsのアドレスにする
```
...
--cluster-dns XXXXX \
```

* Ubuntu 18.04 の場合、以下のissueのような事があるので注意 (dnsmasq Pod のupstream DNSにホストのresolv.confに書かれた127.0.0.53を指定してしまいunreachableする)
    * https://github.com/kubernetes/kubernetes/issues/45828

