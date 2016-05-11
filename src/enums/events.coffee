define 'Events', [], () ->
  Events =
    WAR:
      frequency: 20
      length: [5, 15]
      name: 'war'
      description: "there is a war going on this island. Ships are banned to visit it's port and the population is not growing"
    INFESTATION:
      frequency: 8
      length: [3,20]
      name: 'infestation'
      description: 'the agricultural production of this island is shattered due to infestation'
    FESTIVAL:
      length: [2,5]
      frequency: 15
      name: 'festival'
      description: 'festival will attract more people and ships to this island'
