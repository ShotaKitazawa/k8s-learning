# 1 号機の kube-schedulerを設定し、起動する。

* 設定ファイルは /etc/default/kube-scheduler です。 systectl restart kube-scheduler で設定反映（プロセス再起動）できます。

* systemctl status kube-scheduler を複数回実行して、正常に起動していることを確認します。
