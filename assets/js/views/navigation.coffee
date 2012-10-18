define [
  'views/base'
  'text!/templates/navigation.hbs'
], (Views, template) ->
  'use strict'

  class NavigationView extends Views.TemplateView

    tagName: "ul"
    className: 'nav'

    # Automatically append to the DOM on render
    container: '#navigation'
    containerMethod: 'html'

    # Automatically render after initialize
    autoRender: true

    constructor: (props) ->
      super props, template