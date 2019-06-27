# kube-dns Pod を起動する

* https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns/kube-dns

* kube-dns の引数に `--kube-master-url=http://$ADDR:8080` を指定する
    * これがないとkube-dnsはkube-apiserverへhttpsで接続しに行こうとしてしまうためコケる

* kube-dns service の clusterIPには、kubeletで指定した値を入れる
