define [
  'chaplin'
  'models/about'
  'views/about'
], (Chaplin, About, AboutView) ->
  'use strict'

  class AboutController extends Chaplin.Controller

    title: 'About'

    historyURL: (params) ->
      ''

    show: (params) ->
      console.debug 'HomeController#about'
      @model = new About()
      @view = new AboutView model: @model      