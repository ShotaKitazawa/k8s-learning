# 1 号機の kube-controller-managerを設定し、起動する。

* 設定ファイルは /etc/default/kube-controller-manager です。 systectl restart kube-controller-manager で設定反映（プロセス再起動）できます。

* systemctl status kube-controller-manager を複数回実行して、正常に起動していることを確認します。
