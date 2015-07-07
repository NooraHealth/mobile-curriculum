this.allModulesComplete = ()->
  numModules = (Session.get "modules sequence").length
  numCorrect = (Session.get "correctly answered").length
  console.log "Checking whether all modules complete"
  console.log numCorrect
  console.log numModules
  currentModule = getCurrentModule()
  if !currentModule
    return false
  if isAQuestion(currentModule)
    console.log "Is a questions!"
    return numCorrect == numModules
  else
    console.log "Not a questions"
    return numCorrect == numModules - 1

this.isAQuestion = (module)->
  return module.type == "SCENARIO" or module.type=="BINARY" or module.type=="MULTIPLE_CHOICE" or module.type == "GOAL_CHOICE"

this.stopAllAudio = ()->
  for audioElem in $("audio")
    audioElem.pause()

this.buttonDisabled = (btn)->
  return $(btn).hasClass('faded') or $(btn).hasClass('expanded')

this.handleResponse = (response)->
  moduleSequence = Session.get "modules sequence"
  currentModuleIndex = Session.get "current module index"
  module = moduleSequence[currentModuleIndex]

  hideIncorrectResponses(module)
  
  if isCorrectResponse(event.target)
    displayToast "correct"
    playAudio "correct", module
    handleSuccessfulAttempt(module, 0)
    updateModuleNav "correct"
  else
    displayToast "incorrect"
    playAudio "incorrect", module
    handleFailedAttempt module, [$(event.target).attr "value"], 0
    updateModuleNav "incorrect"

  showNextModuleBtn()

this.displayToast = (type)->
  if Meteor.Device.isPhone()
    if type=="correct"
      Session.set "success toast is visible", true
    else
      Session.set "fail toast is visible", true
  else
    classes = "left valign rounded"
    if type=="correct"
      Materialize.toast "<i class='mdi-navigation-check medium'></i>", 5000, classes+ " green"
    else
      Materialize.toast "<i class='mdi-navigation-close medium'></i>", 5000, classes+ " red"

this.hideIncorrectResponses = ()->
  responseBtns =  $(".response")
  for btn in responseBtns
    if not $(btn).hasClass "correct"
      $(btn).addClass "faded"
      
    else
      $(btn).addClass "z-depth-2"
      $(btn).addClass "expanded"
    $(btn).unbind "click"

this.updateModuleNav = (responseStatus)->
  moduleIndex = Session.get "current module index"
  correctAnswers = Session.get "correctly answered"
  incorrectlyAnswered = Session.get "incorrectly answered"

  if responseStatus == "correct"
    if moduleIndex in correctAnswers
      return
    #Remove the index from the array of incorrect answers
    if moduleIndex in incorrectlyAnswered
      incorrectlyAnswered = incorrectlyAnswered.filter (i) -> i isnt moduleIndex
      Session.set "incorrectly answered", incorrectlyAnswered
    correctAnswers.push Session.get "current module index"
    Session.set "correctly answered", correctAnswers

  if responseStatus == "incorrect"
    if moduleIndex in incorrectlyAnswered
      return
    incorrectlyAnswered.push Session.get "current module index"
    Session.set "incorrectly answered", incorrectlyAnswered

this.isCorrectResponse = (response) ->
  return $(response).hasClass "correct"
#
###
# Handler for all failed attempts on a module
#
# - Inserts a failed attempt into the Attempts collection
# - Appends this module to the module sequence for the user to 
# try again.
#
# module            Module document object 
# responses         user's incorrect response
# time_to_complete  the time to complete the module in ms
###
this.handleFailedAttempt = (module, responses, time_to_complete) ->
  #Attempts.insert {
    #user: Meteor.user()._id
    #responses: responses
    #passed: false
    #date: new Date().getTime()
    #nh_id: module.nh_id
  #}, (error, _id) ->
    #if error
      #console.log "There was an error inserting the incorrect attempt into the database", error
    #else
      #console.log "Just inserted this incorrect attempt into the DB: ", Attempts.findOne {_id: _id}


###
# Handler for all successful attempts on a module
#
# -Inserts a successful attempt into the Attempts collection
#
# module            Module document object 
# responses         user's incorrect response
# time_to_complete  time to complete the module in ms
###
this.handleSuccessfulAttempt = (module, time_to_complete)->
  #Attempts.insert {
    #user: Meteor.user()._id
    #passed: true
    #date: new Date().getTime()
    #nh_id: module.nh_id
  #}, (error, _id) ->
    #if error
      #console.log "There was an error inserting the CORRECT attempt into the database"
    #else
      #console.log "Just inserted this CORRECT attempt into the DB: ", Attempts.findOne {_id: _id}


this.nextBtnShouldHide = ()->
  currentModule = this.getCurrentModule()
  console.log "This is the current module"
  console.log currentModule
  if !currentModule
    return
  if currentModule.type == "VIDEO" or currentModule.type == "SLIDE"
    return false
  else
    #return Session.get "next button is hidden"
    return true
###
# Plays the audio associated with the answer
#
# type      Either "correct" or "incorrect"
# module    The module to play the answer audio for
###
this.playAudio = (type, module)->
  nh_id = module.nh_id
  console.log "playing the audio ", module
  console.log "type: ", type
  elem = $("audio[name=audio#{nh_id}][class=question]")[0]
  if elem and type =="question"
    elem.play()
    return
  else if elem
    elem.currentTime = 0
    elem.pause()

  if type== "correct"
    elem =  $("audio[name=audio#{nh_id}][class=correct]")[0]
  else
    elem =  $("audio[name=audio#{nh_id}][class=incorrect]")[0]
  if elem
    console.log "The next thing will be the elem"
    console.log elem
    console.log "This is the elem"
    console.log elem?
    #elem.currentTime = 0
    #elem.play()
#
###
# Stop all module media and prepare to show the next module
#
# previousModule        The module to clear, in preparation for the next module
###

this.resetModules = (previousModule) ->
  nh_id = previousModule.nh_id

  #Pause all playing audio
  audioArr = $("audio[name=audio#{nh_id}]")
  for audioElem in audioArr
    $(audioElem)[0].pause()

  #Hide the stickers
  $("#sticker_incorrect").addClass "hidden"
  $("#sticker_correct").addClass "hidden"
  

###
# Go to the next module in the sequence
###
this.goToNext = ()->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    resetModules(moduleSequence[currentIndex])

    if currentIndex == moduleSequence.length - 1
      goBackToChapterPage()
      Session.set "previous module index", currentIndex
      Session.set "current module index", null
    else
      Session.set "previous module index", currentIndex
      Session.set "current module index", ++currentIndex

###
# Go to the previous module in the sequence
###
this.goToPreviousModule = () ->
    currentIndex = Session.get "current module index"
    moduleSequence = Session.get "module sequence"
    resetModules(moduleSequence[currentIndex])
    
    Session.set "previous module index", currentIndex
    Session.set "current module index", --currentIndex

###
# Show the button that leads to the next module
#
# module        The module on which to show the "next" button
###

this.showNextModuleBtn = (module) ->
  $("#nextbtn").fadeIn()
  Session.set "next button is hidden", false

###
# Go back to the chapter page of the current chapter
###
this.goBackToChapterPage = ()->
  currentChapter = Session.get "current chapter"
  Router.go "/chapter/"  + currentChapter.nh_id

this.getCurrentModule = ()->
  moduleSequence = Session.get "modules sequence"
  currentIndex = Session.get "current module index"
  if !moduleSequence or !currentIndex
    return

  return moduleSequence[currentIndex]
