{% from "credstash/map.jinja" import credstash with context %}

install_prereqs:
  pkg.installed:
    - pkgs: {{ credstash.packages }}
    - refresh: True
