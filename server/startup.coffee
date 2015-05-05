Meteor.startup ()->

  Slingshot.createDirective "s3",Slingshot.S3Storage, {
    bucket: BUCKET
    acl: "public-read",
    AWSAccessKeyId: process.env.AWS_ACCESS_KEY
    AWSSecretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    region: REGION,
    authorize: () ->
      #Deny uploads if user is not logged in.
      if not Meteor.user()?
        message = "Please login before posting files"
        throw new Meteor.Error("Login Required", message)

      return true

    key:(file) ->
      #Store file into a directory by the user's username.
      pattern = /// image/ ///
      if file.type.match pattern
        prefix = CONTENT_FOLDER + IMAGE_FOLDER
      return prefix + file.name

  }
