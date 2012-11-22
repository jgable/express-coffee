define [
  'chaplin',
  'models/base'
], (Chaplin, BaseModel) ->
  'use strict'

  class UserModel extends BaseModel

    defaults: 
      loggedIn: false
      displayName: 'Not Logged In'

