define 'Events', ['Colors'], (Colors) ->
  Events =
    WAR:
      frequency: 80
      length: [5, 15]
      name: 'war'
      description: "there is a war going on this island. Ships are banned to visit it's port and the population is not growing"
      short: 'W'
      color: Colors.EVENTWAR
      condition: (island) ->
        true
    INFESTATION:
      frequency: 150
      length: [10,20]
      name: 'infestation'
      description: 'the agricultural production of this island is shattered due to infestation'
      short: 'I'
      color: Colors.EVENTINFESTATION
      condition: (island) ->
        !island.state.buildings.granary
    FESTIVAL:
      length: [2,5]
      frequency: 70
      name: 'festival'
      description: 'festival will attract more people and ships to this island'
      short: 'F'
      color: Colors.EVENTFESTIVAL
      condition: (island) ->
        island.state.buildings.amphiteater
