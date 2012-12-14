# TODO: npm install passport passport-twitter passport-browserid mongoose connect-mongo --save

passport = require "passport"
mongoose = require "mongoose"
express = require "express"
MongoStore = require("connect-mongo")(express)

config = require "./config"
{Users, connect} = require "./data"
appSettings = require "./connect-appSettings"

users = new Users

# TODO: Change these in the config
callbackUrl = if process.env.NODE_ENV == "production" then config.twitter.callbackUrl.prod else config.twitter.callbackUrl.dev

twitterOpts = 
    consumerKey: config.twitter.consumerKey
    consumerSecret: config.twitter.consumerSecret
    callbackURL: callbackUrl

authenticate = -> passport.authenticate

init = (app) ->

    # Twitter Auth
    # initTwitter app

    # Persona Auth
    initBrowserId app

    app.use express.cookieParser("cookie fart")
    app.use express.bodyParser()

    initSession app

    app.use passport.initialize()
    app.use passport.session()

    # Make our app settings accessible to the page (user data)
    app.use appSettings
        data: (req, resp) ->
            return unless req.user

            {id, displayName, type} = req.user
            userData = 
                user: {id, displayName, type}

            return userData

initTwitter = (app) ->
    TwitterStrategy = (require "passport-twitter").Strategy

    passport.serializeUser (user, done) ->
        # Serialize our users by id
        done null, user.id

    passport.deserializeUser (id, done) ->
        # Retrieve our users by id
        users.findOne { id }, done
    
    strat = new TwitterStrategy twitterOpts, (token, tokenSecret, profile, done) ->
        { id, displayName } = profile
        type = "twitter"
        users.findOrCreate {id, displayName, type, token, tokenSecret}, done

    passport.use strat

initBrowserId = (app) ->
    BrowserIDStrategy = require("passport-browserid").Strategy

    passport.serializeUser (user, done) ->
        done null, user.id

    passport.deserializeUser (email, done) ->
        users.findOne { id: email }, done

    persona_audience = "http://#{config.server.host}:80"

    personaOpts =
        audience: persona_audience

    strat = new BrowserIDStrategy personaOpts, (email, done) ->
        token = ''
        tokenSecret = ''
        type = 'browserid'
        id = email

        isEmail = email.indexOf '@' > 0 # using 0 on purpose, can't have empty
        displayName = if isEmail then email.split('@')[0] else email

        users.findOrCreate {id, displayName, type, token, tokenSecret}, done

    passport.use strat

initSession = (app) ->
    # Use the existing mongoose connection
    unless mongoose.connection?
        connect()

    # Set up the express session provider to use mongo
    app.use express.session
        cookie: {maxAge: 60000 * 180} # 3 Hours 
        secret: "unicorn fart"
        store: new MongoStore {mongoose_connection: mongoose.connection}, (err) ->
            throw err if err

registerRoutes = (app) ->
    # Redirect the user to Twitter for authentication.  When complete, Twitter
    # will redirect the user back to the application at
    # /auth/twitter/callback
    app.get '/auth/twitter', passport.authenticate('twitter')

    # Twitter will redirect the user to this URL after approval.  Finish the
    # authentication process by attempting to obtain an access token.  If
    # access was granted, the user will be logged in.  Otherwise,
    # authentication has failed.
    app.get '/auth/twitter/callback', passport.authenticate('twitter', { successRedirect: '/games', failureRedirect: '/' })

    app.post '/auth/browserid', passport.authenticate('browserid'), (req, resp, next) ->
        # Unnecessary?
        return next() unless req.user

        resp.json req.user

    app.get '/logout', (req, res) ->
      req.logOut()
      res.redirect '/'

module.exports = { init, authenticate, registerRoutes }