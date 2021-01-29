# kube-dns Pod を起動する

* kubelet のオプション `--cluster-dns` を変更
    * kube-apiserver にて指定した `--service-cluster-ip-range` のレンジ内の任意のアドレスを指定

```
...
--cluster-dns XXXXX \
```

* 当リポジトリ manifests/10-manifests.yaml を参照 (参考: https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns/kube-dns)
    * kube-master-urlの行を適宜クラスタのapiserverのURLに置き換え
    * `10.0.0.254` を kubelet の `--cluster-dns` で指定している IP に置き換え
    * `10.1.0.2` を Master Node の IP に置き換え
    * `cluster.local` を kubelet の `--cluster-domain` で 指定しているドメインに置き換え (未指定の場合は `cluster.local` のままで良い)

<!--
* Ubuntu 18.04 の場合、以下のissueのような事があるので注意 (dnsmasq Pod のupstream DNSにホストのresolv.confに書かれた127.0.0.53を指定してしまいunreachableする)
    * https://github.com/kubernetes/kubernetes/issues/45828
-->

* 確認
    * `kubectl exec` でPod内に入り、サービス名を指定した通信が出来ることを確認
        * 例: `curl http://hello-world`

# 理解度チェックリスト

- [ ] Kubernetes クラスタ内に kube-dns が無いとどのようなときに困る？
- [ ] kube-dns が解決できるレコードはどのような形？
