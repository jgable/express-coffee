express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
jsPrimer = require "./jsAssetPrimer"

app = express()
# Add Connect Assets
app.use assets()
# Set the public directory as static
app.use express.static(process.cwd() + "/public")
# Set View Engine
app.set 'view engine', 'jade'

jsPrimer.init js

# All routes return layout.  (Chaplin loads views dynamically)
app.get ['/', '/about'], (req, resp) -> 
  resp.render 'index'

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."