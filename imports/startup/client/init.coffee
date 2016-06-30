
{ BlazeLayout } = require 'meteor/kadira:blaze-layout'
{ AppState } = require('../../api/AppState.coffee')
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
require 'meteor/loftsteinn:framework7-ios'

Meteor.startup ()->
  console.log "starup"
  if (Meteor.isCordova and not AppState.get().isSubscribed()) or Meteor.status().connected
    console.log("Subscribing to all")
    Meteor.subscribe "curriculums.all", ()->
      console.log "in the meteor on ready callback curriculums"
    Meteor.subscribe "lessons.all"
    Meteor.subscribe "modules.all"
    AppState.get().setSubscribed true

  BlazeLayout.setRoot "body"

  condition = AppState.getCondition()
  updateContent = ()->
    console.log "UPDATING THE CONTENT"
    FlowRouter.go "load"

  Curriculums.find({condition: condition}).observe updateContent

  this.App = new Framework7(
    materialRipple: true
    router:false
    tapHold: true
    tapHoldPreventClicks: false
    tapHoldDelay: 1500
  )

