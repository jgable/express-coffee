
[User] = require "./models/user"
{ModelController} = require "./base"

class UserController extends ModelController
	constructor: ->
		super User

	findOrCreate: (opts, done) ->
		@findOne { id: opts.id }, (err, user) =>
			done err if err

			if user 
				return done null, user

			@create opts, done

module.exports = UserController
