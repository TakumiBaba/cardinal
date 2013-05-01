exports.SiteEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Follow = app.settings.models.Follow
  Status = app.settings.models.Status
  helper = app.settings.helper
  Crypto = require 'crypto'
  DebugEvent = app.settings.events.DebugEvent


  index: (req, res)->
    res.render 'index',
      req: req

  login: (req, res)->
    params = req.body
    id = req.body.id
    console.log params
    # User.findOne({facebook_id: id}).populate("candidates").exec (err, user)=>
    console.log 'login'
    User.findOne({facebook_id: id}).exec (err, user)=>
      throw err if err
      console.log user
      if user && !user.isFirstLogin
        console.log 'user is exist'
        req.session.userid = user.id
        return res.send user.id if user.isSupporter
        exclusion = []
        Status.find({ids: {$in: [user.id]}}).exec (err, statuses)=>
          throw err if err
          if statuses.length > 0
            _.each statuses, (status)=>
              console.log status
              id = if status.ids[0] is user.id then status.ids[1] else status.ids[0]
              exclusion.push id
          stateZero = _.filter statuses, (status)=>
            return (status.one_status is false) and (status.two_status is false)
          console.log "StateZero is #{stateZero.length}"
          num = stateZero.length
          if num < 20
            exclusion.push user.id
            User.find({}).where('id').nin(exclusion).exec (err, users)->
              throw err if err
              if !users || users.length < 20-num
                return false
              users = _.shuffle users
              _.each [num..20], (i)=>
                console.log i
                status = new Status()
                status.one = user._id
                status.two = users[i]._id
                status.ids = [user.id, users[i].id]
                status.save()
                user.statuses.push status
                users[i].statuses.push status
                user.save()
                users[i].save()

        #   User.find({}).where('id').nin(exclusion).where("profile.gender").ne(user.profile.gender).exec (err, users)=>
        #     throw err if err
        #     shuffled = _.shuffle users
        #     stateZero = _.filter user.statuses, (status)=>
        #       return status.one_status is false and status.two_status is false
        #     return res.send user.id if stateZero.length > 10
        #     maxNum = 20-stateZero.length
        #     console.log maxNum
        #     _.each [0..maxNum], (i)=>
        #       console.log user._id, shuffled[i]._id
        #       status = new Status()
        #       status.one = user._id
        #       status.two = shuffled[i]._id
        #       status.ids = [user.id, shuffled[i].id]

        #       user.statuses.push status
        #       shuffled[i].statuses.push status
        #       console.log status
        #       shuffled[i].save()
        #       status.save()
        #     user.save()
        json =
          id: user.id
          isCheck: false
        return res.send user.id
      else
        console.log 'create user'
        console.log user
        if user is null || user.isFirstLogin is false
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
        user.isFirstLogin = false
        user.profile.image_url = "https://graph.facebook.com/#{params.id}/picture?type=large"
        user.save()
        req.session.userid = user.id
        # json =
        #   id: user.id
        #   isCheck: true
        return res.send user.id

  failure: (req, res) ->
    res.statusCode = 404
    res.render 'site_failure', env: arguments