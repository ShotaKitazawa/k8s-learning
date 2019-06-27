# 1 号機の kube-apiserver を設定し、起動する。

* 設定ファイルは /etc/default/kube-apiserver に存在、 systectl restart kube-apiserver で設定反映（プロセス再起動）
    * `systemctl status kube-apiserver` を複数回実行しエラーがないことを確認

* kubectlの設定
    * $HOME/.kube/config に kubectl 用の kubeconfig が生成される

```
kubectl config set-credentials my-user
kubectl config set-cluster my-cluster --server=http://k8s01:8080
kubectl config set-context my-context --cluster=my-cluster --user=my-user
kubectl config use-context my-context
```

* 1 号機上で `kubectl get nodes` してエラーが無いことを確認します。(node はまだ作ってないので、出力は `Not found` 的なものになるはず)

* etcd v2 の場合は、--storage-backend=etcd2が必要

* ログレベルの変更は -v 1 とか -v 5 とかで可能

* 設定ファイルは以下みたいになるはず

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


<!--
* `--service_account_key_file` には秘密鍵または公開鍵を入れる必要がある
    * openssl コマンドなどで適当に作る
    * 以下コマンドで設定ができているかの確認
```
# ServiceAccountの作成
$ kubectl create sa hogefuga
```

```
# ServiceAccountに紐付けられたsecretを確認
$ kubectl describe sa hogefuga
```

```
# secret の内容を確認 (SA key がないとsecretは自動生成されない)
$ kubectl describe secrets default-token-525ww
Name:         default-token-525ww
Namespace:    lab2charlie-app-monitoring
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: default
              kubernetes.io/service-account.uid: fe14efc4-93ff-11e9-a054-42010a92003b

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1119 bytes
namespace:  26 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ......
```
-->
