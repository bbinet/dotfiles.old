pkgs:
  {% if grains['os'] == 'Ubuntu' %}
  firefox: firefox
  {% elif grains['os_family'] == 'Debian' %}
  firefox: iceweasel
  {% endif %}
