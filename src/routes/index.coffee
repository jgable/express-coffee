api = require "./api"
views = require "./views"

module.exports = 
	init: (app) ->
		views.init app
		api.init app