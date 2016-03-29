define 'ButtonStyle', ['Colors', 'FontStyle', 'TextStyle'], (Colors, FontStyle, TextStyle) ->
  ButtonStyle =
    NORMALACTIVE: {'text': Colors.BUTTONNORMALTEXTCOLOR, 'fill': Colors.BUTTONACTIVE, 'font': FontStyle.BOLDNORMAL}
    NORMALINACTIVE: {'text': Colors.BUTTONNORMALTEXTCOLOR, 'fill': Colors.BUTTONINACTIVE, 'font': FontStyle.BOLDNORMAL}
    NORMALDISABLED: {'text': Colors.BUTTONNORMALDISABLEDTEXTCOLOR, 'fill': Colors.BUTTONDISABLED, 'font': FontStyle.NORMAL}
    MENUACTIVE: {'text': Colors.BUTTONNORMALTEXTCOLOR, 'fill': Colors.BUTTONACTIVE, 'font': FontStyle.SMALL}
    MENUINACTIVE: {'text': Colors.BUTTONNORMALTEXTCOLOR, 'fill': Colors.BUTTONMENUINACTIVE, 'font': FontStyle.SMALL}
