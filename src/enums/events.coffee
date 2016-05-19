define 'Events', ['Colors'], (Colors) ->
  Events =
    WAR:
      frequency: 30
      length: [5, 15]
      name: 'war'
      description: "there is a war going on this island. Ships are banned to visit it's port and the population is not growing"
      short: 'W'
      color: Colors.EVENTWAR
    INFESTATION:
      frequency: 25
      length: [3,20]
      name: 'infestation'
      description: 'the agricultural production of this island is shattered due to infestation'
      short: 'I'
      color: Colors.EVENTINFESTATION
    FESTIVAL:
      length: [2,5]
      frequency: 30
      name: 'festival'
      description: 'festival will attract more people and ships to this island'
      short: 'F'
      color: Colors.EVENTFESTIVAL
