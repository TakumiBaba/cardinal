exports.SiteEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  helper = app.settings.helper
  Crypto = require 'crypto'
  DebugEvent = app.settings.events.DebugEvent


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
        exclusion = user.candidates
        User.find({}).nin(exclusion).exec (err, users)->
          throw err if err
          shuffled = _.shuffle users
          _.each [0..40], (i)=>
            if user.candidates.length < 30
              status = 0
              if i < 20
                status = _.random(1,2)
              else if 20 < i < 22
                status = 3
              else
                status = 0
              candidate = new Candidate
                user: shuffled[i]._id
                status: status
                isSystemMatching: true
              candidate.save()
              user.candidates.push candidate._id
            else if 30 < i < 40
              user.following.push shuffled[i]._id if user.following.length < 10
              user.follower.push shuffled[i]._id if user.follower.length < 10
            user.save()
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
        User.find({}).exec (err, users)->
          throw err if err
          shuffled = _.shuffle users
          _.each [0..40], (i)=>
            if user.candidates.length < 30
              status = 0
              if i < 20
                status = _.random(1,2)
              else if 20 < i < 22
                status = 3
              else
                status = 0
              candidate = new Candidate
                user: shuffled[i]._id
                status: status
                isSystemMatching: true
              candidate.save()
              user.candidates.push candidate._id
            else if 30 < i < 40
              user.following.push shuffled[i]._id if user.following.length < 10
              user.follower.push shuffled[i]._id if user.follower.length < 10
            user.save()
        return res.send user.id

  failure: (req, res) ->
    res.statusCode = 404
    res.render 'site_failure', env: arguments