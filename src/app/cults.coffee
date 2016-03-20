define 'Cults', ['Base'], (Base) ->
  class Cults
    state:
      playerCult: ''
      cults:
        'Serapis':
          no: 1
          label: 'Serapis'
          iconLabel: 'serapis'
          color: '#377eb8'
          text: 'Serapis was a god of blablabla...'
        'Isis':
          no: 2
          iconLabel: 'isis'
          label: 'Isis'
          color: '#4daf4a'
          text: 'Isis was a goddess of something else and blablabla...'
        'Anubis':
          no: 3
          iconLabel: 'anubis'
          label: 'Anubis'
          color: '#a65628'
          text: 'And also Anubis was here. We is blablabla...'
        'Bastet':
          no: 4
          iconLabel: 'bastet'
          label: 'Bastet'
          color: '#e41a1c'
          text: 'Bastet is the last one here but not blablabla...'

    constructor: ->
      @loadIcons()




    loadIcons: () ->
      _.each @state.cults, (cult, cultLabel) =>
        xhr = Base.doXhr './sprites/' + cult.iconLabel + '.svg'
        img = new Image()
        svg = new XMLSerializer().serializeToString xhr.responseXML.documentElement
        svg = svg.replace(new RegExp('#666666', 'g'), cult.color) # change color
        img.src = 'data:image/svg+xml;base64,' + btoa unescape encodeURIComponent svg
        cult.logo = img
        return
      return
