Template.chapter.helpers
  imageURL: ()->
    if _.isEmpty(@)
      return ""
    else
      return MEDIA_URL+ @.image
    

Template.chapter.events
  "click .thumbnail" : (event, template)->
    id = $(event.target).parent('a').attr('id')
    console.log id
    Router.go '/chapter/'+id




