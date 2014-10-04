{% set home = pillar.get('nginx', {}).get('home', '/nginx') -%}
nginx_conf:
  file.managed:
    - name: {{home}}/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/config_media.jinja
    - makedirs: true 
    - require: 
      - sls: nginx