#### Xterm

Font resizing

~/.Xresources

    XTerm*faceName: DejaVu Sans Mono
    XTerm*faceSize: 12
    XTerm.vt100.translations: #override \n\
      Ctrl <Key> minus: smaller-vt-font() \n\
      Ctrl <Key> plus: larger-vt-font()


Color scheme example with gray background

~/.Xresources

    ! form http://web.archive.org/web/20090130061234/http://phraktured.net/terminal-colors/
    XTerm*background: rgb:67/67/67
    XTerm*foreground: rgb:ff/ff/ff
    XTerm*color0:     rgb:00/00/00
    XTerm*color1:     rgb:bf/46/46
    XTerm*color2:     rgb:67/b2/5f
    XTerm*color3:     rgb:cf/c4/4e
    XTerm*color4:     rgb:51/60/83
    XTerm*color5:     rgb:ca/6e/ff
    XTerm*color6:     rgb:92/b2/f8
    XTerm*color7:     rgb:d5/d5/d5
    XTerm*color8:     rgb:00/00/00
    XTerm*color9:     rgb:f4/8a/8a
    XTerm*color10:    rgb:a5/d7/9f
    XTerm*color11:    rgb:e1/da/84
    XTerm*color12:    rgb:a2/bb/ff
    XTerm*color13:    rgb:e2/b0/ff
    XTerm*color14:    rgb:ba/cd/f8
    XTerm*color15:    rgb:d5/d5/d5
