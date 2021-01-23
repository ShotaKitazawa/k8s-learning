# About

K8s勉強会用初期環境構築スクリプト

# Create

環境の作成

* GCPの各リソースの作成
    * NAME 変数に参加者の名前をスペース区切りで記述してください
        * 名前は、先頭が小文字で、その後に最大 62 文字の小文字、数字、ハイフンで構成します。末尾をハイフンにすることはできません。 (TODO: スクリプトにバリデーションチェックを組み込む)

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
ansible-playbook -i inventory site.yml --private-key=$HOME/.ssh/google_compute_engine \
-e 'ansible_python_interpreter=/usr/bin/python3'
```

## 作成が完了したら..?

docsディレクトリに移動し，k8s hardwayを進めていきます

```
cd ../docs
cloudshell edit 00-ssh.md
```

# Delete

環境の削除

```
bash ./construct.sh delete
```
