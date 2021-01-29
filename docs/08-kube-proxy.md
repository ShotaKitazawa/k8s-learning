# 全台の kube-proxyを設定し、起動する

## kube-proxyの設定

* 設定ファイルは /etc/kubernetes/kube-proxy.conf です。当ファイルにオプションを追記していき、kube-proxyを起動してください。
    * `systectl restart kube-proxy` で設定反映（プロセス再起動）できます。

* 設定ファイルにて、kube-proxy の bind Address、kubeconfig の指定 で動くはず

## kube-proxyの確認

* `systemctl status kube-proxy` を複数回実行して、正常に起動していることを確認
* 以下のマニフェストを適用して、外部から Pod へ通信できることを確認
    * 当リポジトリ manifests/08-manifest.yaml を参照

* 疎通の確認
    * NodePort への通信は、指定したnodeにあるPodにしか着弾しないことに注意
        * Node をまたいだ Pod 間ネットワークが張れてないため

```
# curl k8s-learning-kanata-01:30080
<html>
<body>
        <h1>Host: hello-world-57dc97c7f9-w7d9d</h1>
        Version: 1.1
</body>
</html>
```

# 理解度チェックリスト

- [ ] Kubernetes における kube-proxy コンポーネントの役割は？
    - ヒント: iptables
