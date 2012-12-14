define [
	'hogan'
], (Hogan) ->

	class TemplateController
		hoganed: {}

		constructor: (@rawTemplates = APPLICATION_TEMPLATES) ->

		compileTemplates: (templates = @rawTemplates) ->
			for own name, template of templates
				@hoganed[name] = new Hogan.Template template

			@hoganed

		get: (name) ->
			found = @hoganed[name]

			return found if found

			unless @rawTemplates[name]
				throw new Error "Template Not Found: #{name}"

			compiled = new Hogan.Template @rawTemplates[name]

			@hoganed[name] = (data) -> compiled.render data

			@hoganed[name]
