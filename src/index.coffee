express = require 'express'
stylus = require 'stylus'

assets = require "./assets"
routes = require "./routes"

app = express()

# Add Connect Assets
assets.init app, (err, watcher) ->
	throw err if err

	console.log "Watching connect-assets for changes" if watcher

	# Set the public directory as static
	app.use express.static(process.cwd() + "/public")

	# Set View Engine
	app.set 'view engine', 'jade'

	# Set our routes
	routes.init app

	# Define Port
	port = process.env.PORT or process.env.VMC_APP_PORT or 3000
	# Start Server
	app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."