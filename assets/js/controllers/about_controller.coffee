define [
  'controllers/base'
  'models/about'
  'views/about'
], (Base, About, AboutView) ->
  'use strict'

  class AboutController extends Base.AuthController

    title: 'About'

    historyURL: (params) ->
      ''

    show: (params) ->
      super

      @model = new About()
      @view = new AboutView model: @model      