
# 全台の flannel を設定し、起動する

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
    * CNI のプラグイン用バイナリは以下からダウンロード
        * https://github.com/containernetworking/plugins/releases
    * `cni` でなく `kubenet` も指定可能
        * 参考: https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/

* /etc/flannel/flanneld.conf にて、kube-apiserverのurl指定、kubeconfigの指定、etcdのurl指定 で動くはず
    * MEMO: `-etcd-endpoints` の引数にホスト名を指定するとエラーするため IP Address を書く (原因不明)
* etcd に flannel の持つネットワークの情報を登録
    * https://coreos.com/flannel/docs/latest/configuration.html
* /etc/cni/net.d/ に、cniに食わせる flannel 用の設定を配置
    * https://github.com/containernetworking/plugins/tree/master/plugins/meta/flannel
```
cat << '_EOF_' > /etc/cni/net.d/flannel.conf
{
    "name": "podnet",
    "type": "flannel",
    "delegate": {
        "isDefaultGateway": true
    }
}
_EOF_
```

* systemctl restart flanneld で設定反映（プロセス再起動）


* 動作確認
    * `systemctl status flanneld` を複数回実行して、正常に起動していることを確認
    * 以下のマニフェストをapplyして、外部からPodへ通信できることを確認
        * 当リポジトリ manifests/08-manifest.yaml を参照

* 疎通の確認: Service から各node上のPodに通信が振り分けられる
    * Pod の数だけ出力が出ることを確認

```
# for i in $(seq 1 10); do curl http://127.0.0.1:30080 2> /dev/null | grep Host; done | sort | uniq
        <h1>Host: hello-world-57dc97c7f9-6pllt</h1>
        <h1>Host: hello-world-57dc97c7f9-72fzk</h1>
        <h1>Host: hello-world-57dc97c7f9-rpfqj</h1>
```

* 疎通の確認: Podから別Node上に存在するPodに通信可能
    * 例. `kubectl get pod -o wide` で Podのアドレスを確認し、 `kubectl exec` で Podの中に入り別Podへcurlを打ってみる

