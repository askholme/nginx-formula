{% set nginx = pillar.get('nginx', {}) -%}
{% set home = nginx.get('home', '/nginx') -%}
{% set user = nginx.get('user', 'www-data') -%}
{% set group = nginx.get('group', 'www-data') -%}
nginx_group:
  group.present:
    - name: {{group}}

nginx_user:
  file.directory:
    - name: {{ home }}
    - user: {{user}}
    - group: {{group}}
    - mode: 0755
    - require:
      - user: nginx_user
      - group: nginx_group
  user.present:
    - name: {{user}}
    - home: {{ home }}
    - groups:
      - {{group}}
    - require:
      - group: nginx_group

get-nginx:
  file.managed:
    - name: {{ home }}/nginx.tar.gz
    - source: salt://nginx/nginx.tar.gz
  cmd.wait:
    - cwd: {{ home }}
    - name: tar -zxf {{ nginx_package }} -C {{ home }}
    - require:
      - file: nginx_user
      - pkg: get-nginx
    - watch:
      - file: get-nginx

init_file:
  file.managed:
    - name: /service/nginx/run
    - source: salt://nginx/nginx-run

nginx_conf:
  file.managed:
    - name: {{home}}/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/config.jinja
