# 全台の kube-proxyを設定し、起動する

* kube-proxy の設定ファイルはそれぞれ /etc/kubernetes/kube-proxy.conf
	* systectl restart kube-proxyで設定反映（プロセス再起動）できます。

* 設定ファイルにて、kube-proxyのbind Address、kube-apiserverのurl指定、kubeconfigの指定 で動くはず

* 動作確認
    * `systemctl status kube-proxy` を複数回実行して、正常に起動していることを確認
    * 以下のマニフェストをapplyして、外部からPodへ通信できることを確認
        * 当リポジトリ manifests/08-manifest.yaml を参照

* 疎通の確認
    * NodePort への通信は、指定したnodeにあるPodにしか着弾しないことに注意
        * NodeをまたいだPod間ネットワークが張れてないため

```
# curl k8s-learning-kanata-01:30080
<html>
<body>
        <h1>Host: hello-world-57dc97c7f9-w7d9d</h1>
        Version: 1.1
</body>
</html>
```

