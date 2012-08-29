define [
  'chaplin',
  'models/base'
], (Chaplin, BaseModel) ->
  'use strict'

  class AboutModel extends BaseModel

    defaults:
      message: 'Hello World!'

    #initialize: (attributes, options) ->
      #super
      #console.debug 'HelloWorld#initialize'