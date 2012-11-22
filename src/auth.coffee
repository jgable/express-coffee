# TODO: npm install passport passport-twitter mongoose connect-mongodb --save

passport = require "passport"
TwitterStrategy = (require "passport-twitter").Strategy
mongoose = require "mongoose"
MongoStore = require "connect-mongodb"
express = require "express"

config = require "./config"
Users = require "./data/users"
appSettings = require "./connect-appSettings"

users = new Users

# TODO: Change these in the config
callbackUrl = if process.env.NODE_ENV == "production" then config.twitter.callbackUrl.prod else config.twitter.callbackUrl.dev

twitterOpts = 
    consumerKey: config.twitter.consumerKey
    consumerSecret: config.twitter.consumerSecret
    callbackURL: callbackUrl

authenticate = -> passport.authenticate

init = (app, sessionUrl = config.dbServer) ->

    passport.serializeUser (user, done) ->
        # Serialize our users by id
        done null, user.id

    passport.deserializeUser (id, done) ->
        # Retrieve our users by id
        users.findOne { id }, done
    
    strat = new TwitterStrategy twitterOpts, (token, tokenSecret, profile, done) ->
        { id, displayName } = profile
        users.findOrCreate {id, displayName, token, tokenSecret}, done

    passport.use strat

    app.use express.cookieParser("cookie fart")
    app.use express.bodyParser()

    # Set up the express session provider to use mongo
    app.use express.session
        secret: "unicorn fart"
        maxAge: new Date(Date.now() + 3600000)
        store: new MongoStore {url: sessionUrl}, (err) ->
            console.log err or "connect-mongodb setup ok"

    app.use passport.initialize()
    app.use passport.session()

    # Make our app settings accessible to the page (user data)
    app.use appSettings
        data: (req, resp) ->
            return unless req.user

            userData = 
                user: req.user

            return userData

registerRoutes = (app) ->
    # Redirect the user to Twitter for authentication.  When complete, Twitter
    # will redirect the user back to the application at
    # /auth/twitter/callback
    app.get '/auth/twitter', passport.authenticate('twitter')

    # Twitter will redirect the user to this URL after approval.  Finish the
    # authentication process by attempting to obtain an access token.  If
    # access was granted, the user will be logged in.  Otherwise,
    # authentication has failed.
    app.get '/auth/twitter/callback', passport.authenticate('twitter', { successRedirect: '/shows', failureRedirect: '/' })

    app.get '/logout', (req, res) ->
      req.logOut()
      res.redirect '/'

module.exports = { init, authenticate, registerRoutes }