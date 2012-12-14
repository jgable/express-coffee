assets = require 'connect-assets'
jsPathify = require 'connect-assets-jspaths'
topRope = require "toprope"

config = require "./config"

isProd = process.env.NODE_ENV == "production"

module.exports = 
	init: (app, done) ->
		opts = 
			servePath: if isProd then config.assetsRoot else ''
		
		app.use assets opts

		onFileChanged = (err, filePath) ->
			# Want to do something special when a file changes?

		topRope process.cwd() + "/public/templates", (err, scriptTag) ->
			throw err if err

			if isProd
				jsPathify assets

				# TODO: S3 Upload?
				# For right now, we will use a seperate cake task to upload to S3
				
				done null, null
			else
				console.log "Compiled Templates"
				jsPathify assets, console.log, onFileChanged, done