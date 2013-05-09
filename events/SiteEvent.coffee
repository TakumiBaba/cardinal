exports.SiteEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Follow = app.settings.models.Follow
  Status = app.settings.models.Status
  helper = app.settings.helper
  Crypto = require 'crypto'
  DebugEvent = app.settings.events.DebugEvent
  Config = app.settings.config
  https = require 'https'

  index: (req, res)->
    res.render 'index',
      req: req

  login: (req, res)->
    params = req.body
    id = req.body.id
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
        json =
          id: user.id
          isFirst: false
        return res.send json
      else
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
        json =
          id: user.id
          isFirst: true
        return res.send json

  failure: (req, res) ->
    res.statusCode = 404
    res.render 'site_failure', env: arguments

  appAccessToken:
    fetch: (req, res)->
      host  = "https://graph.facebook.com"
      path  = "/oauth/access_token?"
      query = "client_id=#{Config.appId}&client_secret=#{Config.appSecret}&grant_type=client_credentials"

      # AppAccessToken は、ここで取ってくる。
      # httpsじゃないとダメらしい、めんどい。
      options =
        host: host
        path: path+query
      console.log host+path+query
      https.get(options, (response)->
        data = ""
        console.log response
        response.on 'data', (chunk)->
          data += chunk
          console.log data
        response.on 'end', ->
          console.log data
          return res.send data

      ).on('error', (e)->
        console.log "error: #{e}"
        return res.send e
      ).end()