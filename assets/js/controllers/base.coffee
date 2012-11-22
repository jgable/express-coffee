define [
	'chaplin'
], (Chaplin) ->

	class BaseController extends Chaplin.Controller
		title: ""

	class AuthController extends BaseController

		_updateUserLoginInfo: ->
			if APPLICATION_SETTINGS.user
		        Chaplin.mediator.publish "login:twitter", APPLICATION_SETTINGS.user.displayName, APPLICATION_SETTINGS.user.token

		show: (params) ->
			@_updateUserLoginInfo()

	{BaseController, AuthController}