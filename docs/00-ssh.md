# 前準備

* GCP上に `k8s-learning-$NAME-0[1-3]` という名前でVMが起動しています。以下環境情報
    * OS: Ubuntu 1804 LTS (Bionic Beaver)
    * type: n1-standard-1
        * vCPU 1 core
        * Memory 3.75 GB
    * Network: 以下
    * Kubernetes: v1.15.0
```
                    | floating IP *3 (GlobalAddr)
                +---+---+
                |Gateway|
                +---+---+
                    |.1
                    |
 -------+-----------+-+-------------+---------
        |             |             |     10.n.0.0/24
        |             |             |
        |.2           |.3           |.4
   +----*----+   +----*----+   +----*----+
   |         |   |         |   |         |
   |  Master |   |  Node   |   |  Node   |
   |  & Node |   |         |   |         |
   +---------+   +---------+   +---------+
      1号機         2号機         3号機
```

## ログイン

* 以下のコマンドで対象のインスタンスへログインできます。

```
gcloud compute ssh $INSTANCE_NAME
```

* 今後の作業はrootユーザで行います。パスワード無しでrootユーザに昇格可能

```
sudo su -
```

## MEMO

以降に使いそうなコマンドの列挙

* systemdに管理されているサービスのログをすべて表示

```
journalctl -u $SERVICE_NAME --no-pager
```

* Podの強制削除
```
kubectl delete xxx --grace-period=0 --force
```

