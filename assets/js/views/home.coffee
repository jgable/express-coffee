define [
  'views/base'
], (Views, template) ->
  'use strict'

  class HomeView extends Views.PageView
    
    constructor: (props) ->
      super props, "homePage", 'home.hbs'