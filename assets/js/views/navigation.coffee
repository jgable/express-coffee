define [
  'views/base'
  'text!/templates/navigation.hbs'
], (View, template) ->
  'use strict'

  class NavigationView extends View

    # Save the template string in a prototype property.
    # This is overwritten with the compiled template function.
    # In the end you might want to used precompiled templates.
    template: template
    template = null

    tagName: "ul"
    className: 'nav'

    # Automatically append to the DOM on render
    container: '#navigation'
    # Automatically render after initialize
    autoRender: true