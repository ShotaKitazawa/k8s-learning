# 1 号機の kubelet を設定し、起動する。

## kubeletの設定

* 設定ファイルは /etc/kubernetes/kubelet.conf です。当ファイルにオプションを追記していき、kubeletを起動してください。
    * `systemctl restart kubelet` で設定反映（プロセス再起動）

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
    * $HOME/.kube/config を指すことで、 `kubectl` 実行時と同じクレデンシャルで kubelet から kube-apiserver へ接続できる

* `--container-runtime` にはインストール済みの CRI プラグイン (例. Docker なら `docker`) を指定する

* --cluster-dns は コンテナが使うクラスタデフォルトの DNS サーバの指定です。
    * とりあえず 8.8.8.8 等何でも良い

## kubeletの確認

* この時点で、SA, Secret を手動作成の上でpod.spec.nodeNameに `$NODE_ADDRESS` を記述すれば、Podが配置されることを確認
    * 当リポジトリ manifests/04-manifest.yaml を参照
    * kube-controller-manager が居ないため、default ServiceAccount すら存在しない -> 手動で SA, SAに紐づくsecret を作る必要がある

```
# kubectl apply -f manifests/04-manifest.yaml

# kubectl get pod
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          11s
```

* 確認したら削除

```
# kubectl delete -f manifests/04-manifest.yaml
```

* この時点で `manifests/05-manifests.yaml` , `manifests/06-manifests.yaml` を当ててもちゃんと動かないことを確認してみても良いかも

# 理解度チェックリスト

- [ ] Kubernetes における kubelet コンポーネントの役割は？
