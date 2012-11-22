mongoose = require "mongoose"

module.exports = 
    ObjectId: mongoose.Schema.ObjectId
    MakeModelWith: (name, props) ->
        schema = new mongoose.Schema props
        model = mongoose.model name, schema
        [model, schema]