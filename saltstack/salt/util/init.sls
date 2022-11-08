util:
    pkg.installed:
        - pkgs:
            - wget
            - gnupg2
            - lsb-release
            - curl

/home/vagrant/.gitconfig:
    file.managed:
        - source: salt://util/files/gitconfig
