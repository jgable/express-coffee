define [
  'chaplin'
  'models/user'
  'views/user'
], (Chaplin, UserModel, UserView) ->
  'use strict'

  ###
    Handles the 
  ###
  class LoginController extends Chaplin.Controller

    mediator: Chaplin.mediator

    initialize: ->
      super

      @registerLoginEvents()
      @createUserView()

    createUserView: ->
      @model = new UserModel
      @view = new UserView {@model}

    registerLoginEvents: ->

      @subscribeEvent "login:twitter", @twitterLoggedIn
      @subscribeEvent "logout:twitter", @twitterLoggedOut

    twitterLoggedIn: (username, token) ->
      @mediator.user = {username, token}      
      # Load another page
      #@mediator.publish '!startupController', 'week', 'show'

    twitterLoggedOut: ->
      @mediator.user = null
      # Load home page.
      @mediator.publish '!startupController', 'home', 'show'  