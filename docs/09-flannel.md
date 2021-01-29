# 全台の flannel を設定し、起動する

## kubeletの設定

* kubelet の設定に以下を追記

```
KUBE_OPTS=" \
...
--network-plugin=cni \
--cni-conf-dir=/etc/cni/net.d \
--cni-bin-dir=/opt/cni/bin \
...
```

* `network-plugin` にて指定した CNI (Common Network Interface) は Kubernetes が様々なネットワーク構成を利用できるようにするための仕組みです。 CNI を利用することで、様々な Network プラグインを利用することが可能です。今回は中でも Flannel を利用します。
    * CNI のプラグイン用バイナリは以下からダウンロードして `/opt/cni/bin/` 以下に配置
        * https://github.com/containernetworking/plugins/releases
    * `cni` でなく `kubenet` も指定可能
        * 参考: https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/

* systemctl restart kubelet で設定反映 (プロセス再起動)

## flannelの設定

* /etc/flannel/flanneld.conf にて、kube-apiserverのurl指定、kubeconfigの指定、etcdのurl指定 で動くはず
    * MEMO: `-etcd-endpoints` の引数にホスト名を指定するとエラーするため IP Address を書く (原因不明)

* etcd に flannel の持つネットワークの情報を登録
    * https://coreos.com/flannel/docs/latest/configuration.html

```
# 1号機にて
ETCDCTL_API=2 etcdctl set /coreos.com/network/config '{ "Network": "10.0.0.0/16", "SubnetLen": 24, "Backend": { "Type": "udp", "Port": 7890 } }'
```

```
# 以下のメッセージが出力される場合、etcd v2 を有効化 (etcd 実行時オプションにて `--enable-v2=true` を指定) する必要がある
Error:  client: response is invalid json. The endpoint is probably not valid etcd cluster endpoint
```

* /etc/cni/net.d/ 以下に、flannel CNI に食わせる設定を配置
    * https://www.cni.dev/plugins/meta/flannel/
```
cat << '_EOF_' > /etc/cni/net.d/flannel.conf
{
    "name": "mynet",
    "type": "flannel",
    "delegate": {
        "isDefaultGateway": true
    }
}
_EOF_
```

* systemctl restart flanneld で設定反映（プロセス再起動）

## flannelの確認

* `systemctl status flanneld` を複数回実行して、正常に起動していることを確認
* 以下のマニフェストをapplyして、外部からPodへ通信できることを確認
    * 当リポジトリ manifests/08-manifest.yaml を参照

* 疎通の確認: NodePort Service から各 Node 上の Pod に通信が振り分けられる
    * Pod の数だけ出力が出ることを確認

```
# for i in $(seq 1 10); do curl http://127.0.0.1:30080 2> /dev/null | grep Host; done | sort | uniq
        <h1>Host: hello-world-57dc97c7f9-6pllt</h1>
        <h1>Host: hello-world-57dc97c7f9-72fzk</h1>
        <h1>Host: hello-world-57dc97c7f9-rpfqj</h1>
```

* 疎通の確認: Pod から別 Node 上に存在する Pod に通信可能
    * 例. `kubectl get pod -o wide` で Pod のアドレスを確認し、 `kubectl exec` で Pod の中に入り別 Pod へ curl を打ってみる

# 理解度チェックリスト

- [ ] flannel により何ができるようになった？
- [ ] /etc/flannel/flanneld.conf と /etc/cni/net.d/flannel.conf と etcdctl で入力した設定内容はそれぞれ何の意味がある？違いは？
- [ ] flannel により実現されるネットワーキングではどのようなプロトコルが利用されている？
- [ ] CNI とは？
