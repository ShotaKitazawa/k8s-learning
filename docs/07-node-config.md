# 2 号機、3 号機の kubelet を設定し、起動する。

* 1 号機と同様です。

* 2号機、3号機だけおかしい場合には、ネットワークの接続性の問題が上げられます。
    * 例えば、`ss -naptl | grep etcd` などを実行して etcd が 127.0.0.1 や`ss -naptl | grep etcd` などを実行して kube-apiserver などが 127.0.0.1 になっている場合、外からのアクセスができなくなっています。
    * 外からのアクセスが出来るように /etc/kubernetes/kube-apiserver.conf や etcd の 設定を 0.0.0.0 などに変えてみて下さい。

* 動作確認
    * 以下のマニフェストをapplyしてPodが動作することを確認
        * 当リポジトリ manifests/06-manifest.yaml を参照
        * 全nodeにPodが配置されるようになった
