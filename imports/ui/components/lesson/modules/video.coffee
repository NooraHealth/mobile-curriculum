
{ Modules } = require("meteor/noorahealth:mongo-schemas")
{ ContentInterface } = require('../../../../api/content/ContentInterface.coffee')
require "./video.html"

Template.Lesson_view_page_video.onCreated ->
  @state = new ReactiveDict()

  @state.setDefault {
    rendered: false
  }

  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      onPlayVideo: {type: Function}
      onStopVideo: {type: Function}
      onVideoEnd: {type: Function}
      playing: {type: Boolean}
    }).validate(Template.currentData())

    @data = Template.currentData()

  @onStopVideo = =>
    @data.onStopVideo()

  @onPlayVideo = =>
    console.log "Playing the video"
    @data.onPlayVideo()

  @onVideoEnd = =>
    @data.onVideoEnd()

  @elem = (template) ->
    if not @state.get("rendered") then return ""
    else
      return template.find "video"

  @autorun =>
    elemRendered = @state.get "rendered"
    if not elemRendered then return
    shouldPlay = Template.currentData().playing
    instance = @
    elem = @elem instance
    if not shouldPlay
      elem.pause()

  @playVideo = =>
    @elem(@).play()


Template.Lesson_view_page_video.helpers
  iframeAttributes: (module) ->
    return {
      title: module.title
      class: "embedded-video center"
      src: "#{module.video_url}?start=#{module.start}&end=#{module.end}"
      frameborder: "0"
      allowfullscreen: true
    }

  videoTagAttributes: (module) ->
    return {
      title: module.title
      class: "video-module center"
      src: ContentInterface.get().getSrc(module.video)
      controls: true
    }
  
  playing: ->
    instance = Template.instance()
    return instance.data.playing

Template.Lesson_view_page_video.events
  'touchend #play_video': ->
    instance = Template.instance()
    instance.playVideo()

Template.Lesson_view_page_video.onRendered ->
  instance = Template.instance()
  instance.state.set "rendered", true

  instance.elem(instance).addEventListener "playing", ->
    instance.onPlayVideo()

  instance.elem(instance).addEventListener "pause", ->
    instance.onStopVideo()

  instance.elem(instance).addEventListener "onended", ->
    instance.onVideoEnd()
  
  
