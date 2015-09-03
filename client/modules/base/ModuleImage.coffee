
class @ModuleImage extends BaseNode
  constructor: (@module)->
    super

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .4, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, .8

    img = Scene.get().getContentSrc( @.module.image )
    @.domElement = new DOMElement @, {
      content: "<img src='#{img}' class='binary-image'></img>"
    }