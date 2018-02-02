define 'TextStyle', ['Colors', 'FontStyle'], (Colors, FontStyle) ->
  TextStyle =
    HEADER: {'font': FontStyle.HEADER, 'textAlign': 'left'}
    BOLD: {'font': FontStyle.BOLDNORMAL, 'textAlign': 'left'}
    NORMAL: {'font': FontStyle.NORMAL, 'textAlign': 'left'}
    SMALL: {'font': FontStyle.SMALL, 'textAlign': 'left'}
    DT: {'font': FontStyle.BOLDNORMAL, 'textAlign': 'right'}
    DD: {'font': FontStyle.NORMAL, 'textAlign': 'left'}
    RIGHTBOLD: {'font': FontStyle.BOLDNORMAL, 'textAlign': 'right'}
    RIGHTBOLDSMALL: {'font': FontStyle.BOLDSMALL, 'textAlign': 'right'}
    CENTEREDSMALLHEADER: {'font': FontStyle.SMALLHEADER, 'textAlign': 'center'}
