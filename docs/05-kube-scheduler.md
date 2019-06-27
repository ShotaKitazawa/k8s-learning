# 1 号機の kube-schedulerを設定し、起動する。

* 設定ファイルは /etc/default/kube-scheduler です。 systectl restart kube-scheduler で設定反映（プロセス再起動）できます。

* 設定ファイルにてkube-scheduler のbind Address、kube-apiserverのurl指定、kubeconfigの指定をすれば動くはず

* 動作確認
    * systemctl status kube-scheduler を複数回実行して、正常に起動していることを確認
    * 以下のマニフェストをapplyしてPodが動作することを確認
        * pod.spec.nodeName が要らなくなった

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test
  namespace: default
  selfLink: /api/v1/namespaces/default/serviceaccounts/test
  uid: 721ab723-13bc-11e5-aec2-42010af0021e
secrets:
- name: test-secret
---
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
  annotations:
    kubernetes.io/service-account.name: test
type: kubernetes.io/service-account-token
---
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  serviceAccountName: test
  containers:
  - image: zembutsu/docker-sample-nginx:latest
    name: hello-world
    ports:
    - containerPort: 80
```

* MEMO: もしかしたら以下のコマンドが必要 (TODO: 原因究明)
```
kubectl taint node $NODENAME node.kubernetes.io/not-ready:NoSchedule-
```
