

module.exports = 
	init: (app) ->

		app.get ['/', '/about'], (req, resp) ->
			resp.render 'index'