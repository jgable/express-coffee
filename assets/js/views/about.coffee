define [
  'views/base'
  'text!/templates/about.hbs'
], (Views, template) ->
  'use strict'

  class AboutView extends Views.PageView

    constructor: (props) ->
      super props, "aboutPage", template

    