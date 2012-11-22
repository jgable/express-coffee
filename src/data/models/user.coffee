goose = require "./goose"

UserSchema = 
	id: String
	displayName: String
	passHash: String
	passSalt: String
	type: String
	token: String
	tokenSecret: String

User = goose.MakeModelWith "User", UserSchema

module.exports = User