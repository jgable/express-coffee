require.config
  paths:
    text: "/js/lib/text"
    handlebars: "/js/lib/handlebars"
    jquery: "//cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min"
    underscore: "//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min"
    bootstrap: "/js/lib/bootstrap.min"
    backbone: "//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.2/backbone-min"
    chaplin: "/js/lib/chaplin"

  shim:
    jquery:
      exports: "$"
    bootstrap: 
      deps: ["jquery"]
    underscore:
      exports: "_"
    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"
    
require ['app'], (App) ->
    new App().initialize()