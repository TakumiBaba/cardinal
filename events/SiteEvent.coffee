exports.SiteEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Follow = app.settings.models.Follow
  helper = app.settings.helper
  Crypto = require 'crypto'
  DebugEvent = app.settings.events.DebugEvent


  index: (req, res)->
    res.render 'index',
      req: req

  login: (req, res)->
    params = req.body
    id = req.body.id
    # User.findOne({facebook_id: id}).populate("candidates").exec (err, user)=>
    User.findOne({facebook_id: id}).exec (err, user)=>
      throw err if err
      if user && !user.isFirstLogin
        console.log 'user is exist'
        req.session.userid = user.id
        exclusion = []
        _.each user.candidates, (c)=>
          exclusion.push c.id
        # User.find({}).where("id").nin(exclusion).where("profile.gender").ne(user.profile.gender).exec (err, users)->
          # throw err if err
          # shuffled = _.shuffle users
          # state_zero = _.filter user.candidates, (c)=>
          #   return c.state is 0
          # console.log state_zero
          # _.each [state_zero.length..10], (i)=>
          #   candidate = new Candidate
          #     user: shuffled[i]._id
          #     status: 0
          #     isSystemMatching: true
          #   candidate.save()
          #   user.candidates.push candidate._id
            # else if 30 < i < 40
            #   if user.following.length < 15
            #     following = new Follow
            #       approval: false
            #       name: shuffled[i].name
            #       id: shuffled[i].id
            #     following.save()
            #     user.following.push following
              # if user.following.length < 15

              #   user.following.push
              #     approval: false
              #     user: shuffled[i]._id
            #   following = new Follow()
            #   following.approval = false
            #   following.user = shuffled[i]._id
            #   user.following.push following
            #   # user.following.push shuffled[i]._id if user.following.length < 10
            #   # user.follower.push shuffled[i]._id if user.follower.length < 10
            # user.save()
        return res.send user.id
      else
        console.log 'create user'
        if user.isFirstLogin
          user = new User()
        sha1_hash = Crypto.createHash 'sha1'
        sha1_hash.update params.id
        user.id = sha1_hash.digest 'hex'
        user.facebook_id = params.id
        user.name = params.name
        user.first_name = params.first_name
        user.last_name = params.last_name
        user.profile.gender = params.gender
        user.isSuppoter = true
        user.profile.image_url = "https://graph.facebook.com/#{params.id}/picture?type=large"
        user.save()
        req.session.userid = user.id
        # User.find({}).exec (err, users)->
        #   throw err if err
        #   shuffled = _.shuffle users
        #   _.each [0..40], (i)=>
        #     if user.candidates.length < 30
        #       status = 0
        #       if i < 20
        #         status = _.random(1,2)
        #       else if 20 < i < 22
        #         status = 3
        #       else
        #         status = 0
        #       candidate = new Candidate
        #         user: shuffled[i]._id
        #         status: status
        #         isSystemMatching: true
        #       candidate.save()
        #       user.candidates.push candidate._id
            # else if 30 < i < 40
              # following = new Follow()
            #   following = {}
            #   following.approval = false
            #   following.user = shuffled[i]._id
            #   user.following.push following
              # following.approval = false
              # following.user = shuffled[i]._id
              # following.save (err)=>
              #   user.following.push following
              #   user.save()
            #   user.following.push shuffled[i]._id if user.following.length < 10
            #   user.follower.push shuffled[i]._id if user.follower.length < 10
            # user.save()
        return res.send user.id

  failure: (req, res) ->
    res.statusCode = 404
    res.render 'site_failure', env: arguments