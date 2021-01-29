# 1 号機の kube-controller-managerを設定し、起動する。


## kube-controller-managerの設定
* 設定ファイルは /etc/kubernetes/kube-controller-manager.conf です。当ファイルにオプションを追記していき、kube-controller-managerを起動してください。
    * `systemctl restart kube-controller-manager` で設定反映（プロセス再起動）

* 設定ファイルにて、kube-controller-manager のbind Address、kube-apiserverのurl指定、kubeconfigの指定、秘密鍵の指定 (`--service-account-private-key-file`) が必要
    * 新しく秘密鍵を作成するコマンドは以下

```
openssl genrsa -out sa.key 2048
```

## kube-controller-managerの確認

* `systemctl status kube-controller-manager` を複数回実行して、正常に起動していることを確認
* 以下のマニフェストをapplyしてPodが動作することを確認
    * 当リポジトリ manifests/06-manifest.yaml を参照
    * Deployment Resource 等が使えるようになった

# 理解度チェックリスト

- [ ] kube-controller-manager があると何ができるようになる？
- [ ] `--service-account-private-key-file` オプションは何のために必要？
