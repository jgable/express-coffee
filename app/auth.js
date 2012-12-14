// Generated by CoffeeScript 1.4.0
var MongoStore, Users, appSettings, authenticate, callbackUrl, config, connect, express, init, initBrowserId, initSession, initTwitter, mongoose, passport, registerRoutes, twitterOpts, users, _ref;

passport = require("passport");

mongoose = require("mongoose");

express = require("express");

MongoStore = require("connect-mongo")(express);

config = require("./config");

_ref = require("./data"), Users = _ref.Users, connect = _ref.connect;

appSettings = require("./connect-appSettings");

users = new Users;

callbackUrl = process.env.NODE_ENV === "production" ? config.twitter.callbackUrl.prod : config.twitter.callbackUrl.dev;

twitterOpts = {
  consumerKey: config.twitter.consumerKey,
  consumerSecret: config.twitter.consumerSecret,
  callbackURL: callbackUrl
};

authenticate = function() {
  return passport.authenticate;
};

init = function(app) {
  initBrowserId(app);
  app.use(express.cookieParser("cookie fart"));
  app.use(express.bodyParser());
  initSession(app);
  app.use(passport.initialize());
  app.use(passport.session());
  return app.use(appSettings({
    data: function(req, resp) {
      var displayName, id, type, userData, _ref1;
      if (!req.user) {
        return;
      }
      _ref1 = req.user, id = _ref1.id, displayName = _ref1.displayName, type = _ref1.type;
      userData = {
        user: {
          id: id,
          displayName: displayName,
          type: type
        }
      };
      return userData;
    }
  }));
};

initTwitter = function(app) {
  var TwitterStrategy, strat;
  TwitterStrategy = (require("passport-twitter")).Strategy;
  passport.serializeUser(function(user, done) {
    return done(null, user.id);
  });
  passport.deserializeUser(function(id, done) {
    return users.findOne({
      id: id
    }, done);
  });
  strat = new TwitterStrategy(twitterOpts, function(token, tokenSecret, profile, done) {
    var displayName, id, type;
    id = profile.id, displayName = profile.displayName;
    type = "twitter";
    return users.findOrCreate({
      id: id,
      displayName: displayName,
      type: type,
      token: token,
      tokenSecret: tokenSecret
    }, done);
  });
  return passport.use(strat);
};

initBrowserId = function(app) {
  var BrowserIDStrategy, personaOpts, persona_audience, strat;
  BrowserIDStrategy = require("passport-browserid").Strategy;
  passport.serializeUser(function(user, done) {
    return done(null, user.id);
  });
  passport.deserializeUser(function(email, done) {
    return users.findOne({
      id: email
    }, done);
  });
  persona_audience = "http://" + config.server.host + ":80";
  personaOpts = {
    audience: persona_audience
  };
  strat = new BrowserIDStrategy(personaOpts, function(email, done) {
    var displayName, id, isEmail, token, tokenSecret, type;
    token = '';
    tokenSecret = '';
    type = 'browserid';
    id = email;
    isEmail = email.indexOf('@' > 0);
    displayName = isEmail ? email.split('@')[0] : email;
    return users.findOrCreate({
      id: id,
      displayName: displayName,
      type: type,
      token: token,
      tokenSecret: tokenSecret
    }, done);
  });
  return passport.use(strat);
};

initSession = function(app) {
  if (mongoose.connection == null) {
    connect();
  }
  return app.use(express.session({
    cookie: {
      maxAge: 60000 * 180
    },
    secret: "unicorn fart",
    store: new MongoStore({
      mongoose_connection: mongoose.connection
    })
  }, function(err) {
    if (err) {
      throw err;
    }
  }));
};

registerRoutes = function(app) {
  app.get('/auth/twitter', passport.authenticate('twitter'));
  app.get('/auth/twitter/callback', passport.authenticate('twitter', {
    successRedirect: '/games',
    failureRedirect: '/'
  }));
  app.post('/auth/browserid', passport.authenticate('browserid'), function(req, resp, next) {
    if (!req.user) {
      return next();
    }
    return resp.json(req.user);
  });
  return app.get('/logout', function(req, res) {
    req.logOut();
    return res.redirect('/');
  });
};

module.exports = {
  init: init,
  authenticate: authenticate,
  registerRoutes: registerRoutes
};
