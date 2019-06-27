# 1 号機の kube-apiserver を設定し、起動する。

* 設定ファイルは /etc/default/kube-apiserver に存在、 systectl restart kube-apiserver で設定反映（プロセス再起動）

* 起動後、1 号機上で `kubectl get nodes` してエラーが無いことを確認します。(node はまだ作ってないので、出力は `Not found` 的なものになるはず)

* etcd v2 の場合は、--storage-backend=etcd2が必要

* ログレベルの変更は -v 1 とか -v 5 とかで可能

* 設定ファイルは以下みたいになるはず

```
--v=1
--insecure-bind-address=XXX
--etcd-servers=XXX
--storage-backend=etcd2（必要な人だけ）
--service-cluster-ip-range=XXX
--admission-control=XXX,XXX,XXX,……..
--service_account_key_file=XXXXXXXXXXXXX
```

* `service_account_key_file` には秘密鍵を入れて上げる必要がある、
    * kube-apiserver 
    openssl コマンドなどで適当に作ってあげて下さい
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
# secret の内容を確認
$ kubectl describe secrets default-token-525ww
Name:         default-token-525ww
Namespace:    lab2charlie-app-monitoring
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: default
              kubernetes.io/service-account.uid: fe14efc4-93ff-11e9-a054-42010a92003b

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1119 bytes             # SA key がないとこれが生成されない
namespace:  26 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ......
```

* Admission Controller は Kubernetes が提供する拡張機能のようなものです。 ココらへんに各機能の特徴が載っています
    * https://kubernetes.io/docs/admin/admission-controllers/#how-do-i-turn-on-an-admission-controller
* 拡張機能といいつつ、必須な機能ばかりとなっていて、どの機能を有効にするといいかはここらへんに書いてあります。
    * https://kubernetes.io/docs/admin/admission-controllers/#is-there-a-recommended-set-of-admission-controllers-to-use
