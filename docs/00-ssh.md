# 前準備

* GCP上に `k8s-learning-$NAME-0[1-3]` という名前でVMが起動しています。以下環境情報
    * OS: Ubuntu 1804 LTS (Bionic Beaver)
    * type: n1-standard-1
        * vCPU 1 core
        * Memory 3.75 GB
    * Network: 以下
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
   |  k8s01  |   |  k8s02  |   |  k8s03  |
   |  Master |   |  Node   |   |  Node   |
   |  & Node |   |         |   |         |
   +---------+   +---------+   +---------+
```

* 以下のコマンドで対象のインスタンスへログインできます。

```
gcloud compute ssh $INSTANCE_NAME
```

* 今後の作業はrootユーザで行います。パスワード無しでrootユーザに昇格可能

```
sudo su -
```

* 各インスタンスへホスト名で通信できるよう `/etc/hosts` を修正しておいてください。
    * 以下は例

```
10.1.0.2 kube01
10.1.0.3 kube02
10.1.0.4 kube03
```
