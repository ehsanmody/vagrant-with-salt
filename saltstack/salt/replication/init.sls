stop_percona:
    service.dead:
        - name: mysql

cluster_settings:
    file.line:
        - name: "/etc/mysql/mysql.conf.d/mysqld.cnf"
        - mode: "insert"
        - pattern: "wsrep_cluster_address"
        - content: ips