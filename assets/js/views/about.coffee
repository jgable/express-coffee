define [
  'views/base'
  'text!/templates/about.hbs'
], (View, template) ->
  'use strict'

  class AboutView extends View

    # Save the template string in a prototype property.
    # This is overwritten with the compiled template function.
    # In the end you might want to used precompiled templates.
    template: template
    template = null

    className: 'aboutPage'

    # Automatically append to the DOM on render
    container: '#page-container'
    # Automatically render after initialize
    autoRender: true