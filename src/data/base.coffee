
class ModelController
    constructor: (@Model) ->
        
    create: (props, done) ->
        created = new @Model props

        created.save (err) ->
            done err, created

    updateSingle: (id, props, done) ->
        @Model.update {_id: id}, props, done

    update: (query, action, done) ->
        @Model.update query, action, done

    single: (id, done) ->
        @findOne {_id: id}, done

    findOne: (props, done) ->
        @Model.findOne props, done

    remove: (id, done) ->
        @Model.remove {_id: id}, done

    all: (done) ->
        @Model.find {}, done

class FindByUserController extends ModelController
    
    forUser: (userId, done) ->
        @Model.find { user: userId }, done

module.exports = { ModelController, FindByUserController }