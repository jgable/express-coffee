requirePaths = 
  jquery: "//cdnjs.cloudflare.com/ajax/libs/jquery/1.7.2/jquery.min"
  underscore: "//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min"
  backbone: "//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.2/backbone-min"
  hogan: "//cdnjs.cloudflare.com/ajax/libs/hogan.js/2.0.0/hogan"
  
  bootstrap: "/js/lib/bootstrap"
  text: "/js/lib/text"
  chaplin: "/js/lib/chaplin"
  persona: "https://login.persona.org/include"

# Fixes for referencing "production" mode assets with hashes.
if connectAssets
  for own key, value of connectAssets
    # Fix up the lib references
    key = key.slice 4 if key.slice(0, 4) == "lib/"
    requirePaths[key] = value 

require.config 
  paths: requirePaths
  shim:
    hogan:
      exports: "Hogan"
    persona: 
      exports: "navigator"
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