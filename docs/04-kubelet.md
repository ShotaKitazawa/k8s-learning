# 1 号機の kubelet を設定し、起動する。

* 設定ファイルは /etc/kubernetes/kubelet.conf です。 systectl restart kubelet で設定反映（プロセス再起動）できます。

* `systemctl status kubelet` を複数回実行して正常に起動していることを確認。また、1 号機上で `kubectl get nodes` してノードが登録されていることを確認。

* 設定ファイルは以下みたいになるはず
```
KUBE_OPTS=" \
--v=1 \
--kubeconfig=XXXXXXX \
--container-runtime=docker \
--cluster-dns XXXXX \
"
```

* kube-config は Kubernetes API サーバの場所（アドレス、ポート）、認証情報などが記載されているファイルです。kubectl, kubelet, kube-scheduler, kube-controller-manager, kube-proxy などが API サーバとやり取りする際に利用します。
    * $HOME/.kube/config を指せば、 `kubectl` 実行時と同じ context で kubeletからkube-apiserverへ接続できる

* `--container-runtime` に docker を指定しているため、別途Dockerをインストールする必要がある

* --cluster-dns は コンテナが使うクラスタデフォルトの DNS サーバの指定です。
    * とりあえず 8.8.8.8 等何でも良い

* 動作確認
    * この時点で、SA, Secret を手動作成の上でpod.spec.nodeNameに `$NODE_ADDRESS` を記述すれば、Podが配置されることを確認
        * kube-controller-manager が居ないため、default ServiceAccount すら存在しない > 手動で SA, SAに紐づくsecret を作る必要がある

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test
  namespace: default
  selfLink: /api/v1/namespaces/default/serviceaccounts/test
  uid: 721ab723-13bc-11e5-aec2-42010af0021e
secrets:
- name: test-secret
---
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
  annotations:
    kubernetes.io/service-account.name: test
type: kubernetes.io/service-account-token
---
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  nodeName: k8s-learning-kanata-01
  serviceAccountName: test
  containers:
  - image: zembutsu/docker-sample-nginx:latest
    name: hello-world
    ports:
    - containerPort: 80
```

* MEMO: Podの強制削除
```
kubectl delete xxx --grace-period=0 --force
```
