
isProduction = process.env.NODE_ENV == "production"

prodUrl = "FILLMEIN"
devUrl = "mongodb://localhost/express-coffee"

dbUrl = if isProduction then prodUrl else devUrl

prodHost = "FILLMEIN.com"
devHost = "local.dev"

host = if isProduction then prodHost else devHost

module.exports =
    isProduction: isProduction
    server:
        host: host
    # TODO: Point to your CDN
    assetsRoot: null
    dbServer: dbUrl
    # TODO: Fill with your details
    twitter:
        consumerKey: "FILLMEIN"
        consumerSecret: "FILLMEIN"
        callbackUrl:
            dev: ""
            prod: ""
    facebook:
        consumerKey: ""
        consumerSecret: ""
        callbackUrl:
            dev: ""
            prod: ""