
require './list_item.html'

Template.Home_language_menu_list_item.onCreated ->
  # Data context validation
  @autorun =>
    new SimpleSchema({
      onLanguageSelected: {type: Function}
      language: {type: String}
    }).validate(Template.currentData())

Template.Home_language_menu_list_item.events
  'touchend': ( e , template )->
    instance = Template.instance()
    data = Template.currentData()
    data.onLanguageSelected data.language
    App.closePanel("right")

