
[Users] = require "./users"

config = require "../config"

connect = (dbUrl = config.dbServer) ->
    state = mongoose?.connection?.db?._state
    if !state or (state not in ["connected", "connecting"])
        mongoose.connect dbUrl

module.exports = { Users, connect }
