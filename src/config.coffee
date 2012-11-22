
prodUrl = "FILLMEIN"
devUrl = "mongodb://localhost/express-coffee"

dbUrl = if process.env.NODE_ENV == "production" then prodUrl else devUrl

module.exports =
    dbServer: dbUrl
    twitter:
        consumerKey: ""
        consumerSecret: ""
        callbackUrl:
            dev: ""
            prod: ""
    facebook:
        consumerKey: ""
        consumerSecret: ""
        callbackUrl:
            dev: ""
            prod: ""