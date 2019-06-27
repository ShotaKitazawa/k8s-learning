# 全台の kube-proxy、flanneld を設定し、起動する

* 設定ファイルは /etc/default/kube-proxy と /etc/default/flanneld です。
	* systectl restart kube-proxy と systemctl restart flanneld で設定反映（プロセス再起動）できます。

* 事前に kubernetes-cni のインストールも行うようにして下さい。
    * CNI は以下からダウンロード
        * https://github.com/containernetworking/plugins/releases

* /etc/cni/net.d/ に以下のような設定ファイルを配置する
```
{
    "name": "podnet",
    "type": "flannel",
    "delegate": {
        "isDefaultGateway": true
    }
}
```


