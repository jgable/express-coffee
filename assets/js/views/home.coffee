define [
  'views/base'
  'text!/templates/home.hbs'
], (Views, template) ->
  'use strict'

  class HomeView extends Views.PageView
    
    constructor: (props) ->
      super props, "homePage", template