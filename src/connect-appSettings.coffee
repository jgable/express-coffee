defaults = 
    data: (req, resp) -> 
        isLoggedIn: resp.user?
        user: resp.user
        
    name: "APPLICATION_SETTINGS"

_extend = (child, parent) ->
    for own key, val of parent
        child[key] = val

    child

makeAppSettingsHandler = (opts) ->
    settings = _extend defaults, opts

    (req, resp, next) ->
        global.appSettings = settings.data req, resp

        global.exportAppSettings = ->
            """
            <script type="text/javascript">
                var #{settings.name} = #{JSON.stringify(global.appSettings || {})};
            </script>
            """

        next()

module.exports = makeAppSettingsHandler