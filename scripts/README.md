# About

K8s勉強会用初期環境構築スクリプト

# Create

環境の作成

* GCPの各リソースの作成
    * NAME 変数に参加者の名前をスペース区切りで記述してください

```
NAMES="hoge fuga piyo" bash ./construct.sh create
```

* Ansible 用 inventory ファイルの自動生成
    * インスタンス作成後初回実行時、 `first connect? [y/n]` に `y` を入力してください
        * インスタンスに公開鍵を配置します。

```
bash ./generate-inventory.sh
```

* Ansible Playbook の実行

```
ansible-playbook -i inventory site.yml --private-key=$HOME/.ssh/google_compute_engine
```

# Delete

環境の削除

```
bash ./construct.sh delete
```
