exports.UserEvent = (app) ->

  User = app.settings.models.User
  Follow = app.settings.models.Follow
  Crypto = require 'crypto'

  fetch: (req, res)->
    console.log req.session.userid
    id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
    console.log id
    User.findOne id: id, (err, user)->
      throw err if err
      if user
        res.json user
      else
        res.send "user data missing"

  update: (req, res)->
    id = req.session.userid
    params = req.params
    User.findOne id: id, (err, user)->
      throw err if err
      if user
        _.map params, (v, k)=>
          user.profile[k] = v
        user.save()
        json =
          status: "200"
          user: user
        res.json json
      else
        res.send "user data missing"

  signup: (req, res)->
    id = req.session.userid
    User.findOne id: id, (err, user)->
      throw err if err
      user.isSupporter = false
      user.save()
      return res.send 'signup done'

  profile:
    picture: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne id: id, (err, user)->
        throw err if err
        if user
          return res.redirect user.profile.image_url
        else
          return res.redirect ""
    fetch: (req, res)->
      id = req.session.userid
      User.findOne id: id, (err, user)->
        throw err if err
        if user
          return res.send user.profile
        else
          return res.send 'no data'
    update: (req, res)->
      params = req.body
      id = req.session.userid
      User.findOne id: id, (err, user)->
        throw err if err
        if user
          _.map params, (v, k)=>
            user.profile[k] = v
          user.save()
          return res.send user.profile
        else
          return res.send 'no data'

  followings:
    fetch: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne({id: id}).populate('following').exec (err, user)->
        throw err if err
        console.log user
        if user
          following = []
          _.each user.following, (f)=>
            following.push f.user
          res.send user.following
        else
          res.send []
    create: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      followingId = req.params.facebook_id
      User.findOne({id: id}).populate('following').exec (err, me)->
        throw err if err
        User.findOne({facebook_id: followingId}).exec (err, folowing)->
          throw err if err
          unless following
            following = new User()
            sha1_hash = Crypto.createHash 'sha1'
            sha1_hash.update followingId
            following.id = sha1_hash.digest 'hex'
            following.facebook_id = followingId
            following.name = ""
            following.first_name = ""
            following.last_name = ""
            following.profile.gender = ""
            following.isSuppoter = true
            following.isFirstLogin = true
            following.profile.image_url = "https://graph.facebook.com/#{followingId}/picture?type=large"
            following.save()
          f = _.find me.following, (f)=>
            return f.id is following.id
          if !f
            f = new Follow
              name: following.name
              id: following.id
              approval: false
            f.save (err)=>
              me.following.push f
              me.save (err)=>
                following.request.push f
                following.save()
                return res.send f
          else
            return res.send f
    update: (req, res)->
      id = req.session.userid
      # followingId
    delete: (req, res)->
      console.log 'hoge'
      id = req.session.userid
      deleteId = req.params.deleteId
      console.log id, deleteId
      User.findOne({id: id}).populate("following").exec (err, user)->
        throw err if err
        _.each user.following, (f, i)=>
          if f.id.toString() is deleteId
            user.following[i].remove()
        res.send user.following

  followers:
    fetch: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne({id: id}).populate("follower", "id name profile").exec (err, user)->
        throw err if err
        if user
          console.log user.follower
          return res.send user.follower
        else
          return res.send []
    create: (req, res)->
      id = req.session.userid
      followerId = req.body.followerId
      User.find({id: {$in: [id, followerId]}}).populate('follower').exec (err, users)->
        throw err if err
        if users
          me = _.filter users, (u)=>
            return u.id is id
          follower = _.filter users, (u)=>
            return u.id is followerId
          if _.contains me.follower, follower
            res.send 'already added'
          else
            me.follower.push follower._id
            me.save (err)->
              throw err if err
              res.send "add"
    delete: (req, res)->
      id = req.session.userid
      deleteId = req.body.deleteId
      User.find({id: {$in: [id, deleteId]}}).populate('follower').exec (err, users)->
        throw err if err
        if user
          me = _.filter users, (u)=>
            return u.id is id
          target = _.filter users, (u)=>
            return u.id is deleteId
          me.follower.remove target._id
          me.save (err)->
            throw err if err
            res.send "delete"

  pending:
    fetch: (req, res)->
      id = req.session.userid
      User.findOne({id: id}).populate('pending').exec (err, user)->
        throw err if err
        if user
          return res.send user.pending
        else
          return res.send []

  request:
    fetch: (req, res)->
      id = req.session.userid
      User.findOne({id: id}).populate('request').exec (err, user)->
        throw err if err
        if user
          return res.send user.request
        else
          return res.send []
    create: (req, res)->
      id = req.session.userid
      targetId = req.body.targetId
      User.find({id: {$in: [id, targetId]}}).exec (err, users)->
        throw err if err
        if users
          me = _.filter users, (u)=>
            return u.id is id
          requester = _.filter users, (u)=>
            return u.id is targetId
          if _.contains me.request, requester
            res.send 'already added'
          else
            me.request.push requester._id
            me.save (err)->
              throw err if err
              res.send "add"
    change: (req, res)->
      nextState = req.body.nextState
      id = req.session.userid
      targetId = req.body.id
      User.find({id: {$in: [id, targetId]}}).exec (err, users)->
        throw err if err
        if user
          me = _.filter users, (u)=>
            return u.id is id
          target = _.filter users, (u)=>
            return u.id is targetId
          if nextState is "toFollowing"
            me.following.push target._id
          me.request.remove target._id
          me.save (err)->
            throw err if err
            res.send 'add following'

  signup: (req, res)->
    id = req.session.userid
    params = req.body
    User.findOne id: id, (err, user)->
      throw err if err
      user.name = params.name
      user.profile.birthday = new Date("#{params.birthday_month}/#{params.birthday_year}/#{params.birthday_day}")
      user.username = params.username
      user.first_name = params.first_name
      user.last_name = params.last_name
      user.isSupporter = false
      user.save (err)->
        if err
          res.redirect "/signup/error"
          throw err
        else
          res.redirect "/"
