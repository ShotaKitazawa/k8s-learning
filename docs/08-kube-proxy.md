# 全台の kube-proxyを設定し、起動する

* kube-proxy の設定ファイルはそれぞれ /etc/kubernetes/kube-proxy.conf と /etc/flannel/flanneld.conf
	* systectl restart kube-proxyで設定反映（プロセス再起動）できます。

* 設定ファイルにて、kube-proxyのbind Address、kube-apiserverのurl指定、kubeconfigの指定 で動くはず

* 動作確認
    * `systemctl status kube-proxy` を複数回実行して、正常に起動していることを確認
    * 以下のマニフェストをapplyして、外部からPodへ通信できることを確認
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
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
  selector:
    app: hello-world
  type: NodePort
```

* 疎通の確認
    * NodePort への通信は、指定したnodeにあるPodにしか着弾しないことに注意
        * NodeをまたいだPod間ネットワークが張れてないため

```
# curl k8s-learning-kanata-01:30080
<html>
<body>
        <h1>Host: hello-world-57dc97c7f9-w7d9d</h1>
        Version: 1.1
</body>
</html>
```

