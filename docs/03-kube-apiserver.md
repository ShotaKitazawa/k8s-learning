# 1 号機の kube-apiserver を設定し、起動する。

## kubectl の設定

* kubectlの設定
    * $HOME/.kube/config に kubectl 用の kubeconfig が生成される

```
MASTER_ADDR=XXX
kubectl config set-credentials my-user
kubectl config set-cluster my-cluster --server=http://$MASTER_ADDR:8080
kubectl config set-context my-context --cluster=my-cluster --user=my-user
kubectl config use-context my-context
```

## kube-apiserverの設定

* 設定ファイルは /etc/kubernetes/kube-apiserver.conf です。当ファイルにオプションを追記していき、kube-apiserverを起動してください。
    * `systemctl restart kube-apiserver` で設定反映（プロセス再起動）
    * Unit XXX not found. と表示された場合は `systemctl daemon-reload` してください

* etcd v2 の場合は、--storage-backend=etcd2が必要

* ログレベルの変更は -v 1 とか -v 5 とかで可能

* 設定ファイルは以下みたいになるはず
    * コマンドラインにて `kube-apiserver --help 2>&1 | less`
        * `--insecure-bind-address` コマンドは v1.10 より Deprecated ですが、今回は簡易クラスタを構築するため当オプションを利用します

```
KUBE_OPTS=" \
--v=1 \
--insecure-bind-address=0.0.0.0 \
--etcd-servers=XXX \
--storage-backend=etcd2（必要な人だけ） \
--service-cluster-ip-range=XXX \
"
```

## kube-apiserver の確認

* 1 号機上で `kubectl get nodes` してエラーが無いことを確認します。
    * node はまだ作ってないので、出力は `Not found` 的なものになるはず

# 理解度チェックリスト

- [ ] kube-apiserver に対してマニフェストファイルを適用するとその設定はどこに保存される？
