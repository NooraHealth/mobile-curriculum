ContentInterface = require('../../../../api/content/ContentInterface.coffee').ContentInterface

Modules = require('../../../../api/modules/modules.coffee').Modules
require "../../audio/audio.coffee"
require "./binary.html"

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @autorun =>
    console.log Template.currentData()
    new SimpleSchema({
      module: {type: Modules._helpers}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
      onWrongAnswer: {type: Function}
      onCorrectAnswer: {type: Function}
      "explanationData.onFinish": {type: Function, optional: true}
      "explanationData.onPause": {type: Function, optional: true}
      "explanationData.playing": {type: Boolean}
      "explanationData.src": {type: String}
      "audioData.onFinish": {type: Function, optional: true}
      "audioData.onPause": {type: Function, optional: true}
      "audioData.playing": {type: Boolean}
      "audioData.src": {type: String}
    }).validate(Template.currentData())
    @data = Template.currentData()

  #set the state
  @state = new ReactiveDict()
  @state.setDefault {
    selected: null
    buttonAttributes: {}
  }

  @getOnSelected = (instance, option) ->
    return (event)->
      module = instance.data.module
      instance.state.set "selected", option
      if module.isCorrectAnswer option
        instance.data.onCorrectAnswer(instance.data.module)
      else
        instance.data.onWrongAnswer(instance.data.module)

  @questionComplete = ->
    selected = @state.get "selected"
    complete = selected? and @data.module.isCorrectAnswer selected
    return complete

  @autorun =>
    instance = @
    module = instance.data.module
    data = instance.data
    map = {}
    selected = instance.state.get "selected"

    getClasses = (option) ->
      classes = 'response button button-fill button-big color-lightblue'
      if option is selected
        if module.isCorrectAnswer option
          classes += " #{data.correctlySelectedClasses}"
        else
          classes += " #{data.incorrectlySelectedClasses}"
          classes += " #{data.incorrectClasses}"
      else if instance.questionComplete()
        classes += " #{data.incorrectClasses}"
      return classes
    
    mapData = (option, i) ->
      map[option] = {
        class: getClasses(option)
        value: option
      }
    mapData(option, i) for option, i in module.options
    instance.state.set "optionAttributes", map

Template.Lesson_view_page_binary.helpers
  buttonArgs: (option) ->
    instance = Template.instance()
    attributes = instance.state.get "optionAttributes"
    return {
      attributes: attributes[option]
      content: option.toUpperCase()
      onClick: instance.getOnSelected(instance, option)
    }

  audioArgs: (data) ->
    return {
      attributes: {
        src: ContentInterface.get().getUrl data.src
      }
      playing: data.playing
      whenFinished: data.onFinish
      whenPaused: data.onPause
    }
