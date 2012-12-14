
express = require 'express'
assets = require "connect-assets"
jsPaths = require "connect-assets-jspaths"

{AssetsCDN} = require "connect-assets-cdn"

# Either create a config file like here or set this to 
# an object with amazon key, secret and bucket values
# Also should have the assetsRoot; e.g. //s3.amazonaws.com/myBucket
config = require "./config"

primeCSS = (assets) ->
	# We only have one file to pre-compile for css
	# You might need to add more for your situation;
	# whatever you reference in your views should be 
	# referenced like this here
	assets.instance.options.helperContext.css "prod"

upload = (log, done) ->

	# Set up a fake express server so we can load connect-assets
	app = express()

	opts = 
		# TODO: Set your assetsRoot
		servePath: config.assetsRoot

	app.use assets opts

	# Prime the CSS files
	primeCSS assets
	# Prime the JS files
	jsPaths assets
	
	# TODO: Set these from your config
	{key, secret, bucket} = config.amazon

	# Create our cdn manager and upload
	cdn = new AssetsCDN {assets, key, secret, bucket, log}

	cdn.upload done

module.exports = {upload}
