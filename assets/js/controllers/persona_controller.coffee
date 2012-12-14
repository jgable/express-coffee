define [
	'jquery'
	'underscore'
	'chaplin'
	'persona'
], ($, _, Chaplin, navigator) ->
	'use strict'

	class PersonaController
		mediator: Chaplin.mediator

		constructor: ->
			_.bindAll this, "loggedIn", "loggedOut"
			
			loggedInUser = APPLICATION_SETTINGS?.user?.id

			# Set up the login watch
			navigator.id.watch 
				loggedInUser: loggedInUser
				onlogin: @loggedIn
				onlogout: @loggedOut

			@mediator.subscribe "persona.login", @login
			@mediator.subscribe "persona.logout", @logout

		login: ->
			navigator.id.request()

		loggedIn: (assertion) ->
			$.ajax
				url: "/auth/browserid"
				data: {assertion}
				type: "POST"
				success: (user) =>
					@mediator.publish "persona.loggedIn", user

				error: =>
					alert "Sorry, there was a problem logging you in"
					# window.location.reload()

		logout: ->
			navigator.id.logout()

		loggedOut: ->
			@mediator.publish "persona.loggedOut"

		dispose: ->
			@mediator.unsubscribe "persona.login", @login
			@mediator.unsubscribe "persona.logout", @logout

			@mediator = null

