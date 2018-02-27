credstash-pkgs:
  pkg.installed:
    - pkgs:
      - build-essential
      - libssl-dev
      - libffi-dev
      - python-dev
      - python-pip

install-pip-deps:
  pip.installed:
    - names:
      - boto3
      - jmespath
      - credstash
    - reload_modules: True
    - require:
      - pkg: credstash-pkgs

update-modules:
  module.run:
    - name: saltutil.sync_modules
    - reload_modules: True
    - require:
      - pip: install-pip-deps

update-grains:
  module.run:
    - name: saltutil.sync_grains
    - reload_modules: True
    - require:
      - pip: install-pip-deps
