# 2 号機、3 号機の kubelet を設定し、起動する。

* 1 号機と同様です。

* 2号機、3号機だけおかしい場合には、ネットワークの接続性の問題が上げられます。
    * 例えば、 `ss -naptl | grep kube-apiserver` などを実行して kube-apiserver の Bind Address が 127.0.0.1 になっている場合、外からのアクセスができなくなっています。
    * 外からのアクセスが出来るように /etc/kubernetes/kube-apiserver.conf の 設定を 0.0.0.0 などに変えてみて下さい。

* 動作確認
    * 以下のマニフェストを apply して Pod が動作することを確認
        * 当リポジトリ manifests/06-manifest.yaml を参照
        * 全 Node に Pod が配置されるようになった
