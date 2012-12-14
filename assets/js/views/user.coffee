define [
  'views/base'
], (Views, template) ->
  'use strict'

  class UserView extends Views.TemplateView

    tagName: "aside"
    className: 'user'

    # Automatically append to the DOM on render
    container: '#user-holder'
    containerMethod: 'html'

    # Automatically render after initialize
    autoRender: true

    constructor: (props) ->
      super props, 'user.hbs'

    initialize: ->
      @modelBind "change:loggedIn", @render

      @subscribeEvent "login:twitter", @handleTwitterLogin

    handleTwitterLogin: (userName, token) ->
      @model.set
        loggedIn: true
        displayName: userName

    handleTwitterLogout: ->
      @model.set
        loggedIn: false
        displayName: 'Not Logged In'



