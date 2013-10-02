workstationpkgs:
  pkg.installed:
    - pkgs:

      # System
      - awesome
      - rxvt-unicode-256color
      - gparted

      # Graphics
      - gimp
      - inkscape
      - gcolor2
      - geeqie
      - gtkam
      - fotoxx

      # Media
      - vlc
      - mplayer-gui
      - cheese
      - gtk-recordmydesktop

      # Network
      - {{ pillar['pkgs']['firefox'] }}
      - chromium-browser
      - gajim
      - gftp

      # Office
      - libreoffice
      - epdfview

      # Games
      - gcompris
