exports.UserEvent = (app) ->

  User = app.settings.models.User
  Follow = app.settings.models.Follow
  SupporterMessage = app.settings.models.SupporterMessage

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
      console.log params
      User.findOne id: id, (err, user)->
        throw err if err
        if user
          _.map params, (v, k)=>
            user.profile[k] = v
          user.save()
          return res.send user.profile
        else
          return res.send 'no data'

  follow:
    following:
      fetch: (req, res)->
        id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
        User.findOne({id: id}).exec (err, user)->
          throw err if err
          console.log user.following
          Follow.find({_id: {$in: user.following} }).populate('to', 'id first_name profile').exec (err, follows)->
            throw err if err
            list = []
            _.each follows, (follow)=>
              list.push
                following: follow.to
                approval: follow.approval
            return res.send list
      update: (req, res)->
        fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
        toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
        User.findOne({id: fromId}).populate('following').exec (err, from)=>
          throw err if err
          follow = _.find from.following, (following)=>
            return _.contains following.ids, toId
          if follow
            Follow.findOne({_id: follow._id}).exec (err, follow)->
              throw err if err
              if follow
                follow.approval = true
                follow.save()
                return res.send follow
              else
                return res.send []
          else
            return res.send []

      delete: (req, res)->
        fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
        toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
        User.find({id: {$in : [fromId, toId]}}).populate('following').exec (err, users)=>
          throw err if err
          from = _.find users, (user)=>
            return user.id is fromId
          to = _.find users, (user)=>
            return user.id is toId
          follow = _.find from.following, (follow)=>
            return (_.contains(follow.ids, fromId) && _.contains(follow.ids, toId))
          follow.remove()
          return res.send follow

      create: (req, res)->
        fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
        toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
        User.find({id: {$in : [fromId, toId]}}).populate('following').exec (err, users)=>
          throw err if err
          from = _.find users, (user)=>
            return user.id is fromId
          to = _.find users, (user)=>
            return user.id is toId
          follow = _.find from.following, (follow)=>
            return (_.contains(follow.ids, fromId) && _.contains(follow.ids, toId))
          unless follow
            follow = new Follow
              from: from._id
              to: to._id
              ids: [from.id, to.id]
              approval: false
            follow.save()
            from.following.push follow
            to.follower.push follow
            from.save()
            to.save()
          return res.send follow || []

    follower:
      fetch: (req, res)->
        id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
        User.findOne({id: id}).exec (err, user)->
          throw err if err
          Follow.find({_id: {$in:user.follower}}).populate('from', "id name first_name facebook_id profile").exec (err, follows)->
            throw err if err
            list = []
            console.log follows
            _.each follows, (follow)=>
              list.push
                follower: follow.from
                approval: follow.approval
            return res.send list
      delete: (req, res)->
        fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
        toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
        User.find({id: {$in : [fromId, toId]}}).populate('follower').exec (err, users)=>
          throw err if err
          from = _.find users, (user)=>
            return user.id is fromId
          to = _.find users, (user)=>
            return user.id is toId
          follow = _.find from.follower, (follow)=>
            return (_.contains(follow.ids, fromId) && _.contains(follow.ids, toId))
          follow.remove()
          return res.send follow

    request:(req, res)->
      # from is me , to is you
      fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
      toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
      User.find({id: {$in: [fromId, toId]}}).exec (err, users)->
        from = _.find users, (user)=>
            return user.id is fromId
        to = _.find users, (user)=>
          return user.id is toId
        follow = _.find from.following, (follow)=>
          return (_.contains(follow.ids, fromId) && _.contains(follow.ids, toId))
        unless follow
          follow = new Follow
            from: to._id
            to: from._id
            ids: [to.id, from.id]
            approval: false
          follow.save()
          from.follower.push follow
          to.following.push follow
          from.save()
          to.save()
        return res.send follow

    update: (req, res)->
      oneId = if req.params.oneId is "me" then req.session.userid else req.params.oneId
      twoId = if req.params.twoId is "me" then req.session.userid else req.params.twoId
      console.log oneId, twoId
      Follow.findOne({ids: {$all: [oneId, twoId]}}).exec (err, follow)->
        throw err if err
        console.log follow
        follow.approval = true
        follow.save (err)->
          throw err if err
          return res.send follow

    create: (req, res)->
      followingId = req.params.following
      followerId = req.params.follower
      console.log followingId, followerId
      User.find({facebook_id: {$in: [followingId, followerId]}}).exec (err, users)->
        throw err if err
        following = _.find users, (u)=>
          return u.facebook_id is followingId
        follower = _.find users, (u)=>
          return u.facebook_id is followerId
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
        unless follower
          follower = new User()
          sha1_hash = Crypto.createHash 'sha1'
          sha1_hash.update followerId
          follower.id = sha1_hash.digest 'hex'
          follower.facebook_id = followerId
          follower.name = ""
          follower.first_name = ""
          follower.last_name = ""
          follower.profile.gender = ""
          follower.isSuppoter = true
          follower.isFirstLogin = true
          follower.profile.image_url = "https://graph.facebook.com/#{followingId}/picture?type=large"
        Follow.findOne({ids: {$all: [following.id, follower.id]}}).exec (err, follow)=>
          throw err if err
          unless follow
            follow = new Follow()
          follow.following = follower._id
          follow.follower = following._id
          follow.ids = [following.id, follower.id]
          follow.save()
          following.following.push follow
          follower.follower.push follow
          following.save()
          follower.save()
          return res.json
            follow:follow
            following:following
            follower:follower

  followings:
    fetch: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne({id: id}).populate('following').exec (err, user)->
        throw err if err
        console.log user
        if user
          following = []
          _.each user.following, (f)=>
            console.log f
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
          f = _.find me.following, (f)=>
            return f.id is following.id
          following.save (err)=>
            throw err if err
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
      id = req.session.userid
      deleteId = req.params.deleteId
      Follow.findOne({ids: {$all: [id, deleteId]}}).exec (err, follow)->
        throw err if err
        console.log follow
        follow.remove()
        res.send "delete"
      # User.findOne({id: id}).populate("following").exec (err, user)->
      #   throw err if err
      #   _.each user.following, (f, i)=>
      #     if f.id.toString() is deleteId
      #       user.following[i].remove()
      #   res.send user.following

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
      deleteId = req.params.deleteId
      console.log 'delete', id, deleteId
      Follow.findOne({ids: {$all: [id, deleteId]}}).exec (err, follow)->
        throw err if err
        console.log follow
        follow.remove()
        res.send "delete"
      # User.find({id: {$in: [id, deleteId]}}).exec (err, users)->
      #   throw err if err
      #   if users
      #     me = _.find users, (u)=>
      #       return u.id is id
      #     target = _.find users, (u)=>
      #       return u.id is deleteId
      #     _.each me.follower, (f, i)=>
      #       if f.toString() is target._id.toString()
      #         me.follower[i].remove()
      #     _.each target.follower, (f, i)=>
      #       if f.toString() is me._id.toString()
      #         target.following[i].remove()
      #     # me.follower.remove target._id
      #     # target.following.remove me._id
      #     me.save()
      #     target.save()
      #     res.send 'delete'
          # me.save (err)->
          #   throw err if err
          #   res.send "delete"

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

  supporterMessage:
    fetch: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne({id: id}).populate("supporter_message").exec (err, user)->
        throw err if err
        console.log 'hogefuga'
        console.log user.supporter_message
        list = _.pluck user.supporter_message, "_id"
        SupporterMessage.find({_id: {$in: list}}).populate('supporter').exec (err, message)->
          throw err if err
          return res.send message

    createOrUpdate: (req, res)->
      userId = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      supporterId   = if req.params.supporter_id is "me" then req.session.userid else req.params.supporter_id
      messageText = req.body.message || req.params.message
      User.find({id: {$in: [userId, supporterId]}}).populate('supporter_message').exec (err, users)=>
        throw err if err
        user = _.find users, (u)=>
          return u.id is userId
        supporter = _.find users, (u)=>
          return u.id is supporterId
        supporterMessage = _.find user.supporter_message, (message)->
          return message.supporterId is supporter.id
        unless supporterMessage
          console.log 'unless'
          supporterMessage = new SupporterMessage()
          supporterMessage.supporterId = supporter.id
          supporterMessage.supporter = supporter._id
          user.supporter_message.push supporterMessage
        supporterMessage.message = messageText
        supporterMessage.save()
        user.save()
        return res.send supporterMessage

    delete: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      SupporterMessage.find({}).exec (err, ms)->
        throw err if err
        _.each ms, (m)->
          m.remove()
        return res.send ms