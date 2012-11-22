define [
  'controllers/base'
  'models/home'
  'views/home'
], (Base, Home, HomeView) ->
  'use strict'

  class HomeController extends Base.AuthController

    title: 'Home'

    historyURL: (params) ->
      '/'

    show: (params) ->
      super

      @model = new Home()
      @view = new HomeView {@model}