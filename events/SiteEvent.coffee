exports.SiteEvent = (app) ->

  User = app.settings.models.User
  helper = app.settings.helper
  Crypto = require 'crypto'


  index: (req, res)->
    console.log req.body
    res.render 'index',
      req: req

  login: (req, res)->
    params = req.body
    id = req.body.id
    User.findOne facebook_id: id, (err, user)=>
      throw err if err
      if user
        console.log 'user is exist'
        req.session.userid = user.id
        return res.send user.id
      else
        console.log 'create user'
        user = new User()
        sha1_hash = Crypto.createHash 'sha1'
        sha1_hash.update params.id
        user.id = sha1_hash.digest 'hex'
        user.facebook_id = params.id
        user.name = params.name
        user.first_name = params.first_name
        user.last_name = params.last_name
        user.profile.gender = params.gender
        user.profile.image_url = "https://graph.facebook.com/#{params.id}/picture?type=large"
        user.save()
        req.session.userid = user.id
        return res.send user.id

  failure: (req, res) ->
    res.statusCode = 404
    res.render 'site_failure', env: arguments