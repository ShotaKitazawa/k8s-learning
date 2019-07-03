# kube-dns Pod を起動する

* 当リポジトリ manifests/10-manifests.yaml を参照 (参考: https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns/kube-dns)
    * kube-master-urlの行を適宜クラスタのapiserverのURLに置き換え
    * `10.0.0.254` を、kubeletの cluster-dns で指定しているIPに置き換え
    * `cluster.local` を、kubeletの --cluster-domain で 指定しているドメインに置き換え

* kubelet の設定を変更
    * pod の向くDNSをkube-dnsのアドレスにする
```
...
--cluster-dns XXXXX \
```

* Ubuntu 18.04 の場合、以下のissueのような事があるので注意 (dnsmasq Pod のupstream DNSにホストのresolv.confに書かれた127.0.0.53を指定してしまいunreachableする)
    * https://github.com/kubernetes/kubernetes/issues/45828

* 確認
    * `kubectl exec` でPod内に入り、サービス名を指定した通信が出来ることを確認
        * 例: `curl http://hello-world`
