define [
  'chaplin'
], (Chaplin) ->
  'use strict'

  class BaseView extends Chaplin.View
    # Keep a copy of the mediator
    mediator: Chaplin.mediator

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


  class TemplateView extends BaseView

    autoRender: true

    constructor: (props, @template) ->
      super props

    getTemplateFunction: ->
      @mediator.templates.get @template
  
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
    
    constructor: (props, @className = "page", @template = '') ->
      super props, @template

  
  {TemplateView, TemplateCollectionView, PageView}