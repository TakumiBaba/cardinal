exports.ViewEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate

  candidate: (req, res)->
    id = if req.params.id is 'me' then req.session.userid else req.params.id
    isMe = id is req.params.id
    User.findOne({id: id}).populate("follower", "approval _id").exec (err, user)->
      throw err if err
      unless user
        return res.send false
      follows = _.filter user.follower, (f)->
        return f.approval is true
      followIds = _.pluck follows, "_id"
      console.log followIds
      SupporterMessage.find({_id: {$in: user.supporter_message}}).populate("supporter", "first_name id").exec (err, messages)=>
        throw err if err
        Follow.find({_id: {$in: followIds}}).populate("from", "first_name facebook_id id").exec (err, followers)=>
          throw err if err
          return res.render 'candidate',
            req: req
            image_url: user.profile.image_url
            name: user.first_name
            profile: user.profile
            messages: messages
            followers: followers
          , (err, html)->
            return res.send html

  profile: (req, res)->
    id = req.session.userid
    User.findOne({id: id}).populate("follower", "approval _id").exec (err, user)->
      throw err if err
      unless user
        return res.send false
      follows = _.filter user.follower, (f)->
        return f.approval is true
      followIds = _.pluck follows, "_id"
      SupporterMessage.find({_id: {$in: user.supporter_message}}).populate("supporter", "first_name id").exec (err, messages)=>
        throw err if err
        Follow.find({_id: {$in: followIds}}).populate("from", "first_name facebook_id id").exec (err, followers)=>
          throw err if err
          return res.render 'user/profile',
            req: req
            image_url: user.profile.image_url
            name: user.first_name
            profile: user.profile
            messages: messages
            followers: followers
          , (err, html)->
            return res.send html

  sidebar: (req, res)->
    id = req.session.userid
    User.findOne({id: id}).populate('follower', "profile.image_url id").exec (err, user)->
      throw err if err
      if user.isSupporter is true
        return res.render 'sidebar/supporter',
          req: req
          name: user.first_name
          source: user.profile.image_url
      else
        return res.render 'sidebar/player',
          req: req
          name: user.first_name
          source: user.profile.image_url
          followers: user.follower

  matching: (req, res)->
    id = req.session.userid
    return res.render 'matching/index',
      req: req
    , (err, html)->
      return res.send html

  like: (req, res)->
    return res.render "like",
      req: req
    , (err, html)->
      throw err if err
      return res.send html
  message: (req, res)->
    User.findOne({id: req.session.userid}).exec (err, user)->
      throw err if err
      return res.render 'message',
        req: req
        source: user.profile.image_url
      , (err, html)->
        return res.send html