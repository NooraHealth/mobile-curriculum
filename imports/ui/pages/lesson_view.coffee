
Lessons = require('../../api/lessons/lessons.coffee').Lessons

require './lesson_view.html'
require '../components/lesson/modules/binary.coffee'
require '../components/lesson/modules/scenario.coffee'
require '../components/lesson/modules/multiple_choice.coffee'
require '../components/lesson/modules/slide.html'
require '../components/lesson/modules/video.coffee'
require '../components/lesson/footer/footer.coffee'

Template.Lesson_view_page.onCreated ()->
  @state = new ReactiveDict()
  @state.setDefault {
    moduleIndex: 0
  }
  console.log @state

  @isCurrent = (moduleId) =>
    modules = @getLesson().modules
    index = @state.get "moduleIndex"
    return index == modules.indexOf moduleId

  @isCompleted = (moduleId) =>
    console.log "Getting the lesson", @getLesson()
    modules = @getLesson()?.modules
    index = @state.get "moduleIndex"
    return index > modules?.indexOf moduleId

  @getPagesForPaginator = =>
    modules = @getModules()
    console.log "MODULES", modules
    getPageData = (module, i) =>
      data = {
        completed: @isCompleted module._id
        current: @isCurrent module._id
        index: i
      }
    pages = getPageData(module, i) for module, i in modules?

  @getModules = =>
    return @getLesson()?.getModulesSequence()

  @getLesson = =>
    id = FlowRouter.getParam "_id"
    lesson = Lessons.findOne { _id: id }
    console.log "Getting the lesson", id
    console.log Lessons.find({}).count()
    return lesson

  @onClickNext = =>
    index = @state.get "moduleIndex"
    @state.set "moduleIndex", ++index

Template.Lesson_view_page.helpers
  footerArgs: ()->
    instance = Template.instance()
    return {
      onHomeButtonClicked: ->
        FlowRouter.go "home"
      onNextButtonClicked: =>
        index = @state.get "moduleIndex"
        @state.set "moduleIndex", ++index
      onReplayButtonClicked: =>
      pages: instance.getPagesForPaginator()
    }

  lessonTitle: ()->
    instance = Template.instance()
    return instance.getLesson()?.title

  moduleArgs: (module) ->
    return { module: module }

  modules: ->
    instance = Template.instance()
    return instance.getModules()

  getTemplate: (module) ->
    if module?.type == "BINARY"
      return "Lesson_view_page_binary"
    if module?.type == "MULTIPLE_CHOICE"
      return "Lesson_view_page_multiple_choice"
    if module?.type == "SCENARIO"
      return "Lesson_view_page_scenario"
    if module?.type == "VIDEO"
      return "Lesson_view_page_video"
    if module?.type == "SLIDE"
      return "Lesson_view_page_slide"

Template.Lesson_view_page.onRendered ()->
  mySwiper = App.swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      nextButton: '.swiper-button-next',
  }
