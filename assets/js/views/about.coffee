define [
  'views/base'
], (Views, template) ->
  'use strict'

  class AboutView extends Views.PageView

    constructor: (props) ->
      super props, "aboutPage", 'about.hbs'