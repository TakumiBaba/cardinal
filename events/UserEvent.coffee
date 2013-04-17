exports.UserEvent = (app) ->

  User = app.settings.models.User
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
      User.findOne({id: id}).populate("following", "id name profile").exec (err, user)->
        throw err if err
        if user
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