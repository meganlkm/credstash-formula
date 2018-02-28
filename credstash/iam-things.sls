copy_iam_read_role:
  file.managed:
    - name: /opt/iam_read_role.json
    - source: salt://credstash/files/iam_read_role.json.j2
    - template: jinja

copy_iam_write_role:
  file.managed:
    - name: /opt/iam_write_role.json
    - source: salt://credstash/files/iam_write_role.json.j2
    - template: jinja

copy_iam_setup_policy:
  file.managed:
    - name: /opt/iam_setup_policy.json
    - source: salt://credstash/files/iam_setup_policy.json.j2
    - template: jinja

copy_iam_setup_role_policy:
  file.managed:
    - name: /opt/iam_setup_role_policy.json
    - source: salt://credstash/files/iam_setup_role_policy.json.j2
    - template: jinja
