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

* etcd v2 の場合は、--storage-backend=etcd2が必要

* ログレベルの変更は -v 1 とか -v 5 とかで可能

* 設定ファイルは以下みたいになるはず
    * コマンドラインにて `kube-apiserver --help 2>&1 | less`
    * ブラウザにて https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/

```
KUBE_OPTS=" \
--v=1 \
--insecure-bind-address=XXX \
--etcd-servers=XXX \
--storage-backend=etcd2（必要な人だけ） \
--service-cluster-ip-range=XXX \
"
```

* Admission Controller は Kubernetes が提供する拡張機能のようなものです。 ココらへんに各機能の特徴が載っています
    * https://kubernetes.io/docs/admin/admission-controllers/#how-do-i-turn-on-an-admission-controller
    * v1.10より、推奨機能はデフォルトで有効化されています。
        * https://kubernetes.io/docs/admin/admission-controllers/#is-there-a-recommended-set-of-admission-controllers-to-use

## kube-apiserver の確認

* 1 号機上で `kubectl get nodes` してエラーが無いことを確認します。
    * node はまだ作ってないので、出力は `Not found` 的なものになるはず


