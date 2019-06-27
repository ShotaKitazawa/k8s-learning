# 時間が余ったら

* Secure Cluster (secure-port, secure-bind-address)
    * kube-apiserverへの通信をhttps化 & 認証の有効化
        * Pod から kube-apiserver への通信もhttpsを使用しなければいけない
            * ServiceAccount に結びついたsecretに ca.srt を埋め込んでPodに渡す
* RBAC, ABAC
    * 認可の有効化
* Flannel の設定の違い
    * hostgw / vxlan
* Flannel 以外のNetworkプラグイン
    * Calico
    * Weave
    * etc. (https://kubernetes.io/docs/concepts/cluster-administration/networking/)
* Multi Master 構成
    * etcd cluster & ha-proxy & keepalived だけ

* coredns
    * kube-dns の代替
* Helm
* MetalLB
    * Service Resource の type LoadBalancer が使えるようになる
* nginx-ingress
    * Ingress Resourceが使えるようになる
* Istio ServiceMesh

* 外部 Persistent Volume の有効化
    * https://kubernetes.io/docs/concepts/storage/persistent-volumes/#mount-options
* Dynamic Volume Provisioning
    * https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/
* vitess, rook, storageos などの永続化ソリューション（Persistent Volume）
