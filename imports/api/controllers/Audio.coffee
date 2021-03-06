
{ Audio } = require('../../ui/components/shared/audio.coffee')
{ Analytics } = require '../../api/analytics/Analytics.coffee'

class AudioController
  constructor: ->
    Howler.unload()
    @liveAudio = []

    @setCurrentAudio = (audio) ->
      @currentAudio = audio
      @

    @getCurrentAudio = ->
      return @currentAudio

  stopAudio: ->
    @getCurrentAudio().stop()

  replayCurrentAudio: ->
    @getCurrentAudio().replay()

  destroyAudio: ->
    console.log Howler
    for audio in @liveAudio
      audio.destroy()
    @liveAudio = []

  playAudio: ( filename, volume, isSoundEffect, whenFinished, whenPaused )->
    onLoadError = ( error )->
      swal {
        title: "Error loading audio"
        text: error
      }
    audio = new Audio filename, volume, whenFinished, whenPaused, onLoadError
    audio.play()
    @liveAudio.push audio
    if not isSoundEffect
      @setCurrentAudio audio
    return audio

  trackAudioStopped: ( module, lesson, language, condition, completedAudio, filename, duration ) ->
    text = if module?.title then module?.title else module?.question
    Analytics.registerEvent "TRACK", "Audio Stopped", {
      moduleText: text
      filename: filename
      moduleId: module?._id
      language: language
      condition: condition
      completedAudio: completedAudio
      duration: duration
      lessonTitle: lesson?.title
      lessonId: lesson?._id
    }
    @


module.exports.AudioController = AudioController
