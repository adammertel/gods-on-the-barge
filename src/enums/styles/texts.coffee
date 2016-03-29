define 'TextStyle', ['Colors', 'FontStyle'], (Colors, FontStyle) ->
  TextStyle =
    HEADER: {'font': FontStyle.HEADER, 'textAlign': 'left'}
    BOLD: {'font': FontStyle.BOLDNORMAL, 'textAlign': 'left'}
    NORMAL: {'font': FontStyle.NORMAL, 'textAlign': 'left'}
    DT: {'font': FontStyle.BOLDNORMAL, 'textAlign': 'right'}
    DD: {'font': FontStyle.NORMAL, 'textAlign': 'left'}
