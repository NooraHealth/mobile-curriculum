
{ AppConfiguration } = require '../../api/AppConfiguration.coffee'
{ Facilities } = require("../../api/collections/schemas/facilities.js")
{ Conditions } = require("../../api/collections/schemas/conditions.js")

require './configure.html'

Template.Configure_app_page.onCreated ->
  console.log "Creating a configure page"

  @configureApp = ->
    # if not Meteor.status().connected
    #   swal {
    #     title: "Oops!"
    #     text: "You aren't connected to data! Please connect to wifi or data in order to download your curriculums. You can disconnect once your content has downloaded"
    #   }
    # else
    analytics.track "Configured App", {
      condition: condition
      hospital: hospital
    }

    hospital = $("#hospital_select").val()
    condition = $("#condition_select").val()
    AppConfiguration.setConfiguration {
      hospital: hospital
      condition: condition
    }

    # if Meteor.isCordova
    #   console.log "Going to load"
    #   FlowRouter.go "load"
    # else
    #   FlowRouter.go "home"
    FlowRouter.go "home"

Template.Configure_app_page.helpers
  subscriptionsReady: ()->
    instance = Template.instance()
    return instance.subscriptionsReady()

  hospitals: ->
    return AppConfiguration.getSupportedHospitals()

  conditions: ->
    return AppConfiguration.getSupportedConditions()

  buttonArgs: ->
    instance = Template.instance()
    return {
      onClick: instance.configureApp
      content: 'CONFIGURE'
      attributes: {
        id: "configureBtn"
        class: 'full-width link button button-rounded color-blue  button-fill'
      }
    }
