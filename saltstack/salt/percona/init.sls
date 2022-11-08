repository_package:
  pkg.installed:
    - sources:
      - percona-release: https://repo.percona.com/apt/percona-release_latest.generic_all.deb
    - refresh: True

percona_release_8:
  cmd.run:
    - name: percona-release setup pxc80

install_percona:
  pkg.installed:
    - pkgs:
      - percona-xtradb-cluster
