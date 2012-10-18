define [
  'chaplin'
  'models/home'
  'views/home'
], (Chaplin, Home, HomeView) ->
  'use strict'

  class HomeController extends Chaplin.Controller

    title: 'Home'

    historyURL: (params) ->
      '/'

    show: (params) ->
      console.debug 'HomeController#show'
      @model = new Home()
      @view = new HomeView {@model}