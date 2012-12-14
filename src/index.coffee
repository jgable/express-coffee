express = require 'express'
stylus = require 'stylus'

assets = require "./assets"
routes = require "./routes"
auth = require "./auth"

{connect} = require "./data"

app = express()

# Connect the mongo db
connect()

# Add Connect Assets
assets.init app, (err, watcher) ->
	throw err if err

	console.log "Watching connect-assets for changes" if watcher

	# Set the public directory as static
	app.use express.static(process.cwd() + "/public")

	# Set View Engine
	app.set 'view engine', 'jade'

	auth.init app

	# Set our routes
	routes.init app

	auth.registerRoutes app

	# Connect to the mongo db
	connect()

	# Define Port
	port = process.env.PORT or process.env.VMC_APP_PORT or 3000
	# Start Server
	app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."