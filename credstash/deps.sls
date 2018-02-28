{% from "credstash/map.j2" import credstash with context %}
{% from "credstash/map.j2" import aws with context %}

echo-credstash-things:
  cmd.run:
    - name: "echo {{ credstash }}"

echo-aws-things:
  cmd.run:
    - name: "echo {{ aws }}"

install-prereqs:
  pkg.installed:
    - pkgs: {{ credstash.packages }}
    - refresh: True

install-pip:
  cmd.run:
{% if grains['os_family'] == 'RedHat' %}
    - name: cd /tmp && curl https://bootstrap.pypa.io/get-pip.py -O && python2.7 get-pip.py
{% elif grains['os_family'] == 'Debian' %}
    - name: pip --version
{% endif %}
    - require:
      - install-prereqs

install-pip-deps:
  pip.installed:
    - names:
      - boto3
      - jmespath
      - credstash
      - salt-aws-boto3
    - reload_modules: True
    - require:
      - install-pip
