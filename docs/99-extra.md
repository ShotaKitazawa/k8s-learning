# 時間が余ったら

例えば以下などに取り組んでみてください

---

* kube-apiserver への通信を https 化 & 認証の有効化
    * Kubernetes の各コンポーネントから kube-apiserver への https 通信の有効化
    * Pod から kube-apiserver への通信も https 化
        * ServiceAccount に結びついた secret に ca.srt を埋め込んで Pod に渡す必要がある

* etcd への通信の https 化、データ暗号化

* Multi Master 構成
    * etcd cluster & ha-proxy & keepalived

* Kubernetes 各種コンポーネント+αのコンテナ化
    * kube-apiserver
    * kube-scheduler
    * kube-controller-manager
    * kube-proxy
    * etcd
    * flannel

* 認可の有効化
    * RBAC

* Metrics Server + HorizontalPodAutoscaling の有効化

* Flannel の設定の違いを試す
    * hostgw / udp (vxlan)

* Flannel 以外の CNI プラグインのインストール
    * Calico
    * Weave
    * Cilium
    * Multus
    * etc. (https://kubernetes.io/docs/concepts/cluster-administration/networking/)

* Cluster DNS (kube-dns の代替) のインストール
    * CoreDNS

* Service (type LoadBalancer) Controller のインストール
    * MetalLB

* Ingress Controller のインストール
    * ingress-nginx
    * Traefik
    * HAProxy
    * Contour
    * Envoy
    * etc. (https://kubernetes.io/ja/docs/concepts/services-networking/ingress-controllers/)

