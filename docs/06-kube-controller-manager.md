# 1 号機の kube-controller-managerを設定し、起動する。

* 設定ファイルは /etc/default/kube-controller-manager です。 systectl restart kube-controller-manager で設定反映（プロセス再起動）できます。

* 設定ファイルにて、kube-scheduler のbind Address、kube-apiserverのurl指定、kubeconfigの指定、serviceaccountを作成するための秘密鍵の指定 が必要
    * 新しく秘密鍵を作成

* 動作確認
    * `systemctl status kube-controller-manager` を複数回実行して、正常に起動していることを確認
    * 以下のマニフェストをapplyしてPodが動作することを確認
        * Deployment Resource 等が使えるようになった
```
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-world
  labels:
    app: hello-world
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - image: zembutsu/docker-sample-nginx:latest
        name: hello-world
        ports:
        - containerPort: 80
```
