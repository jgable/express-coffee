define [
  'handlebars'
  'chaplin'
  # 'lib/view_helper' # Just load the view helpers, no return value
], (Handlebars, Chaplin) ->
  'use strict'

  # A basic template base view that auto renders
  class TemplateView extends Chaplin.View

    # Keep a copy of the mediator
    mediator: Chaplin.mediator

    # Automatically render after initialize
    autoRender: true

    constructor: (props, @template) ->
      super props
      template = null

    getTemplateFunction: ->

      # Template compilation
      # --------------------

      # This demo uses Handlebars templates to render views.
      # The template is loaded with Require.JS and stored as string on
      # the view prototype. On rendering, it is compiled on the
      # client-side. The compiled template function replaces the string
      # on the view prototype.
      #
      # In the end you might want to precompile the templates to JavaScript
      # functions on the server-side and just load the JavaScript code.
      # Several precompilers create a global JST hash which stores the
      # template functions. You can get the function by the template name:
      #
      # templateFunc = JST[@templateName]

      template = @template

      if typeof template is 'string'
        # Compile the template string to a function and save it
        # on the prototype. This is a workaround since an instance
        # shouldn’t change its prototype normally.
        templateFunc = Handlebars.compile template
        @constructor::template = templateFunc
      else
        templateFunc = template

      templateFunc

    # Sets a models values by passing in an object with the attribute name and the selector|method to use to get the value from the $el
    setModel: (newVals) ->

      setters = {}
      for own attributeName, selectVal of newVals
        # Default the selectVal to #attributeName if null
        selectVal or= "#"

        # Add the attribute name if it's just #
        selectVal += attributeName if selectVal == "#"

        # Parse out the selector and value getting method
        [selector, valGet] = selectVal.split "|"
        valGet or= "val"

        # Aggregate up the setters
        setters[attributeName] = @$el.find(selector)[valGet]()

      @model.set setters

    setView: (vals) ->

      for own modelAttribute, selector of vals
        selector or= "#"

        selector += modelAttribute if selector == "#"

        setMethod = "text"
        el = @$el.find selector
        setMethod = "val" if el.is("input, textarea, select, button")

        el[setMethod] @model.get(modelAttribute)

  # A basic template base view that auto renders
  class TemplateCollectionView extends Chaplin.CollectionView

    # Keep a copy of the mediator
    mediator: Chaplin.mediator

    autoRender: true

    constructor: (props, @template) ->
      super props
      template = null

      @on "addedToDOM", @_handleAddedToDOM

    dispose: ->
      super

      @off "addedToDOM", @_handleAddedToDOM

    _handleAddedToDOM: ->
      @afterAddedToDOM?()

    getTemplateFunction: TemplateView::getTemplateFunction

  class PageView extends TemplateView

    container: '#page-container'
    containerMethod: 'html'
    
    constructor: (props, @className = "page", @template) ->
      super props, @template

  
  TemplateView: TemplateView
  TemplateCollectionView: TemplateCollectionView
  PageView: PageView