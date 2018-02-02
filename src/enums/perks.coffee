define 'Perks', [], () ->
  Perks =
    [
      {label: 'faster ships'
      effect: (cult) -> app.game.getCultStats(cult).ships.baseSpeed += 0.1
      text: 'make your ships a little faster'}

      {label: 'bigger ships'
      effect: (cult) -> app.game.getCultStats(cult).ships.maxCargo += 10000
      text: 'make your ships bigger'}

      {label: 'resistance of religion'
      effect: (cult) -> app.game.getCultStats(cult).religion.conversionResistance += 0.05
      text: 'your followers will not be converted so easy'}

      {label: 'better trade effectivity'
      effect: (cult) -> app.game.getCultStats(cult).trade.tradeEffectivity += 0.05
      text: 'you will be selling grain for more gold'}

      {label: 'better politics'
      effect: (cult) -> app.game.getCultStats(cult).politics.pointRegeneration += 1
      effect: (cult) -> app.game.getCultStats(cult).politics.maxFreePoints += 1
      text: 'you can influence more'}

      {label: 'mana regeneration'
      effect: (cult) -> app.game.getCultStats(cult).mana.baseRegeneration += 0.2
      text: 'more mana - more spells'}

      {label: 'spell level'
      effect: (cult) -> app.game.getCultStats(cult).spell.lvl += 1
      text: 'better spells'}
    ]
