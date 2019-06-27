# 1 号機の kubelet を設定し、起動する。

* 設定ファイルは /etc/default/kubelet です。 systectl restart kubelet で設定反映（プロセス再起動）できます。

* `systemctl status kubelet` を複数回実行して正常に起動していることを確認。また、1 号機上で kubectl get nodes してノードが登録されていることを確認。

* 設定ファイルは以下みたいになるはず
```
--v=1
--kubeconfig=XXXXXXX
--require-kubeconfig=true
--container-runtime=docker
--network-plugin=cni
--cni-conf-dir=/etc/cni/net.d
--cni-bin-dir=/opt/cni/bin
--cluster-dns XXXXX
```

* 別途、Dockerをインストールする必要がある

* `network-plugin` 似て指定した CNI (Common Network Interface) は Kubernetes が様々なネットワーク構成を利用できるようにするための仕組みです。 CNI を利用することで、様々な Network プラグインを利用することが可能です。今回は中でも Flannel を利用します。
    * `cni` でなく `kubenet` も指定可能
        * 参考: https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/
    * CNI は以下からダウンロード
        * https://github.com/containernetworking/plugins/releases

* --cluster-dns は コンテナが使うクラスタデフォルトの DNS サーバの指定です。 
    * 今回は、8.8.8.8 等何でもいいです。

* kube-config は kubectl, kubelet, kube-scheduler, kube-controller-manager, kube-proxy などが API サーバとやり取りする際に利用するファイルです。 API サーバの場所（アドレス、ポート）、認証情報などが記載されているファイルです。

* 今回のクラスタは（こちらの想定では） kube-apiserver は $ADDRESS:8080 で起動し、無認証で接続できるようになっています。 kubeconfig もそんな感じで作るとうまくいくはずです。

* この時点で、 spec.nodeNameに `$NODE_ADDRESS` を記述すれば、Podが配置される

