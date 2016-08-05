
{ AppState } = require('../../api/AppState.coffee')
{ TAPi18n } = require("meteor/tap:i18n")

# TEMPLATE
require './select_language.html'

# COMPONENTS
require '../../ui/components/shared/navbar.html'
require '../../ui/components/select_language/menu/menu.coffee'

Template.Select_language_page.onCreated ->
  @onLanguageSelected = (language) =>
    analytics.track "Changed Language", {
      fromLanguage: AppState.getLanguage()
      toLanguage: language
      condition: AppState.getCondition()
    }

    AppState.setLanguage language
    #FlowRouter.go "introduction"
    @swiper.slideTo 1
    #$("video")[0].play()
    levels = AppState.getLevels()
    AppState.setLevel levels[0].name

Template.Select_language_page.helpers

  menuArgs: ->
    instance = Template.instance()
    return {
      onLanguageSelected: instance.onLanguageSelected
      languages: ["English", "Hindi", "Kannada"]
    }

Template.Select_language_page.onRendered ->
  instance = Template.instance()
  console.log "The instance"
  console.log instance
  instance.swiper = AppState.getF7().swiper '.swiper-container', {
    lazyLoading: true,
    preloadImages: false,
    speed: 700,
    shortSwipes: false
    longSwipes: false
    followFinger: false
  }
