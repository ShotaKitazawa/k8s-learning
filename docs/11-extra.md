# 時間が余ったら

---

* Secure Cluster (secure-port, secure-bind-address)
    * kube-apiserverへの通信をhttps化 & 認証の有効化
        * K8s Cluster 各Nodeから kube-apiserverへのhttps通信の有効化
            * 認証も同時に有効化しなければならない
        * Pod から kube-apiserver への通信もhttpsを使用
            * ServiceAccount に結びついたsecretに ca.srt を埋め込んでPodに渡す
    * etcdへの通信のhttps化、データ暗号化
* Multi Master 構成
    * etcd cluster & ha-proxy & keepalived だけ
* 認可の有効化
    * RBAC, ABAC
* HorizontalPodAutoscaling の有効化
* Flannel の設定の違い
    * hostgw / vxlan
* Flannel 以外のNetworkプラグイン
    * Calico
    * Weave
    * etc. (https://kubernetes.io/docs/concepts/cluster-administration/networking/)

---

* coredns
    * kube-dns の代替
* MetalLB
    * Service Resource の type LoadBalancer が使えるようになる
* nginx-ingress
    * Ingress Resourceが使えるようになる

---

* 外部 Persistent Volume の有効化
    * https://kubernetes.io/docs/concepts/storage/persistent-volumes/#mount-options
* Dynamic Volume Provisioning
    * https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/
