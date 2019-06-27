# 2 号機、3 号機の kubelet を設定し、起動する。

* 1 号機と同様です。

* 2号機、3号機だけおかしい場合には、ネットワークの接続性の問題が上げられます。
    * 例えば、`ss -naptl | grep etcd` などを実行して etcd が 127.0.0.1 や`ss -naptl | grep etcd` などを実行して kube-apiserver などが 127.0.0.1 になっている場合、外からのアクセスができなくなっています。
    * 外からのアクセスが出来るように /etc/default/etcd や /etc/default/kube-apiserver などの設定を 0.0.0.0 などに変えてみて下さい。

