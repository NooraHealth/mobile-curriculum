require './button.html'

Template.Button.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      onClick: {type: Function, optional: true}
      onRendered: {type: Function, optional: true}
      content: {type: String}
      "attributes.id": {type: String}
      "attributes.class": {type: String, optional: true}
      "attributes.value": {type: String, optional: true}
      "attributes.name": {type: String, optional: true}
      "attributes.disabled": {type: Boolean, optional: true}
    }).validate(Template.currentData())

  @removeActiveState = ->
    active = @find(".active-state")
    if active?
      $(active).removeClass "active-state"

  @onClick = (e, data) =>
    data.onClick e
    @removeActiveState()

    analytics.track "Pressed Button", {
      id: data.attributes.id
    }

Template.Button.helpers
  getAttributes: ( attributes )->
    newAttributes = {}
    for key, value of attributes
      if key == "disabled" and value == false
        continue
      else
        newAttributes[key] = value
    return newAttributes

Template.Button.events
  'click': (e) ->
    instance = Template.instance()
    instance.onClick e, Template.currentData()

Template.Button.onRendered ->
  Template.currentData().onRendered?()
