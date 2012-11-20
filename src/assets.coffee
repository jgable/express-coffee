assets = require 'connect-assets'
jsPathify = require 'connect-assets-jspaths'

module.exports = 
	init: (app, done) ->
		app.use assets()

		onFileChanged = (err, filePath) ->
			# Want to do something special when a file changes?

		if process.env.NODE_ENV == "production"
			jsPathify assets
			done null, null
		else
			jsPathify assets, console.log, onFileChanged, done