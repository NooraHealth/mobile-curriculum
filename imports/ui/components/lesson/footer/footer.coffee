
require '../../shared/button.coffee'
require './paginator.coffee'
require './footer.html'

Template.Lesson_view_page_footer.onCreated ->
  # data context validation
  @autorun =>
    new SimpleSchema({
      "homeButton.onClick": {type: Function}
      "homeButton.shouldShow": {type: Function}
      "homeButton.text": {type: String}
      "replayButton.onClick": {type: Function}
      "replayButton.shouldShow": {type: Function}
      "nextButton.onClick": {type: Function}
      "nextButton.onRendered": {type: Function}
      "nextButton.animated": {type: Boolean}
      "nextButton.text": {type: String}
      "pages.$.current": {type: Boolean}
      "pages.$.completed": {type: Boolean}
      "pages.$.incorrect": {type: Boolean}
      "pages.$.index": {type: Number}
      language: {type: String}
    }).validate Template.currentData()

Template.Lesson_view_page_footer.helpers
  goHomeButtonArgs: (data) ->
    classes = 'link gohome-btn button footer-button color-green button-rounded button-fill'
    if not data.shouldShow()
      classes += " hidden"
    console.log "The home button text", data.text
    return {
      attributes: {
        id: "homeBtn"
        class: classes
      }
      content: data.text
      onClick: data.onClick
    }
    
  nextButtonArgs: (data) ->
    instance = Template.instance()
    classes = 'link next-module-btn footer-button button color-orange button-fill swiper-button-next'
    if data.animated then classes += ' slide-up'
    return {
      attributes: {
        id: "nextModuleBtn"
        class: classes
      }
      content: data.text
      onClick: data.onClick
      onRendered: data.onRendered
    }

  nextButtonWrapperClasses: (animated) ->
    classes = ''
    if animated then classes += ' animate-scale'
    return classes

  replayButtonArgs: (data) ->
    classes = 'link footer-button button button-rounded color-pink button-fill'
    if not data.shouldShow()
      classes += " hidden"
    return {
      attributes: {
        id: "replayBtn"
        class: classes
      }
      content: '<i class="fa fa-repeat fa-2x"></i>'
      onClick: data.onClick
    }

  paginatorArgs: (pages) ->
    return {
      pages: pages
    }
