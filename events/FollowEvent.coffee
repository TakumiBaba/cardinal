exports.FollowEvent = (app) ->

  User = app.settings.models.User
  Follow = app.settings.models.Follow
  Crypto = require 'crypto'

  FB = require 'fb'

  following:
    fetch: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne({id: id}).populate("following", "id").exec (err, user)->
        throw err if err
        ids = _.filter user.following, (f)->
          return f isnt null
        Follow.find({_id: {$in: ids} }).populate('to', 'id first_name profile').exec (err, follows)->
          throw err if err
          list = []
          _.each follows, (follow)=>
            list.push
              _id: follow._id
              following: follow.to
              approval: follow.approval
          return res.send list
    update: (req, res)->
      console.log req.body, req.params
      fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
      toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
      User.findOne({id: fromId}).populate('following').exec (err, from)=>
        throw err if err
        nonApprovalFollow = _.find from.following, (following)=>
          return _.contains following.ids, toId
        if nonApprovalFollow
          Follow.findOne({_id: nonApprovalFollow._id}).populate('to').exec (err, follow)->
            throw err if err
            if follow
              follow.approval = true
              follow.save()
              return res.send follow
            else
              return res.send []
        else
          return res.send []
    bUpdate: (req, res)->
      followId = req.params.follow_id
      Follow.findOne({_id: followId}).populate('from', "id").populate("to", "id").exec (err, follow)=>
        throw err if err
        follow.approval = req.body.approval
        follow.save()
        return res.send  follow
    delete: (req, res)->
      followId = req.params.follow_id
      Follow.findOne({_id: followId}).populate('from', "id").populate("to", "id").exec (err, follow)->
        throw err if err
        console.log follow
        follow.remove()
        return res.send 'delete'
        # User.find({id: {$in: [follow.from.id, follow.to.id]}}).populate("following", "_id").populate("follower", "_id").exec (err, users)=>
          # _.each users, (user)=>
          #   console.log "!!LENGTH: following:#{user.following.length} follower:#{user.follower.length}"
          #   _.each user.follower, (follower)=>
          #     console.log follower._id
          #     console.log followId
          #     if follower._id.toString() is followId
          #       follower.remove()
          #   _.each user.following, (following)=>
          #     console.log following._id
          #     console.log followId
          #     if following._id.toString() is followId
          #       following.remove()
          #   console.log "!!LENGTH: following:#{user.following.length} follower:#{user.follower.length}"


    approve: (req, res)->
      params = req.body
      console.log req.body
      return res.send 'hoge'
      # User.findOne({id: req.params.from_id}).exec (err, user)->
      #   throw err if err

      # User.find({id: {$in : [fromId, toId]}}).populate('following').exec (err, users)=>
      #   throw err if err
      #   from = _.find users, (user)=>
      #     return user.id is fromId
      #   to = _.find users, (user)=>
      #     return user.id is toId
      #   follow = _.find from.following, (follow)=>
      #     return (_.contains(follow.ids, fromId) && _.contains(follow.ids, toId))
      #   follow.remove()
      #   return res.send follow

  follower:
    fetch: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne({id: id}).exec (err, user)->
        throw err if err
        Follow.find({_id: {$in:user.follower}, approval: true}).populate('from', "id name first_name facebook_id profile").exec (err, follows)->
          throw err if err
          list = []
          console.log follows
          _.each follows, (follow)=>
            list.push
              _id: follow._id
              follower: follow.from
              approval: follow.approval
          return res.send list

    delete: (req, res)->
      followId = req.params.follow_id
      Follow.findOne({_id: followId}).populate('from', "id").populate("to", "id").exec (err, follow)->
        throw err if err
        follow.remove()
        return res.send 'delete'
        # User.find({id: {$in: [follow.from.id, follow.to.id]}}).populate("following", "_id").populate("follower", "_id").exec (err, users)=>
          # _.each users, (user)=>
          #   console.log "!!LENGTH: following:#{user.following.length} follower:#{user.follower.length}"
          #   _.each user.follower, (follower)=>
          #     console.log follower._id
          #     console.log followId
          #     if follower._id.toString() is followId
          #       follower.remove()
          #   _.each user.following, (following)=>
          #     console.log following._id
          #     console.log followId
          #     if following._id.toString() is followId
          #       following.remove()
          #   console.log "!!LENGTH: following:#{user.following.length} follower:#{user.follower.length}"


      # fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
      # toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
      # User.find({id: {$in : [fromId, toId]}}).populate('follower').exec (err, users)=>
      #   throw err if err
      #   from = _.find users, (user)=>
      #     return user.id is fromId
      #   to = _.find users, (user)=>
      #     return user.id is toId
      #   follow = _.find from.follower, (follow)=>
      #     return (_.contains(follow.ids, fromId) && _.contains(follow.ids, toId))
      #   follow.remove()
      #   return res.send follow

  request:
    normal: (req, res)->
      # from is me , to is you
      fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
      toId = if req.params.to_id is "me" then req.session.userid else req.params.to_id
      User.find({id: {$in: [fromId, toId]}}).exec (err, users)->
        from = _.find users, (user)=>
            return user.id is fromId
        to = _.find users, (user)=>
          return user.id is toId
        follow = _.find from.follower, (follow)=>
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

    facebook: (req, res)->
      fromId = if req.params.from_id is "me" then req.session.userid else req.params.from_id
      toFacebookId = req.params.to_facebook_id
      params = req.body
      FB.api toFacebookId, (response)=>
        return res.send false if !response or response.error
        params = response
        console.log params
        User.findOne id: fromId, (err, from)=>
          throw err if err
          unless fromId
            return res.send []
          User.findOne({facebook_id: toFacebookId}).exec (err, to)=>
            throw err if err
            console.log "if userdata exist then next log is to uesr data"
            console.log to
            unless to
              sha1_hash = Crypto.createHash 'sha1'
              sha1_hash.update params.id
              to = new User
                id: sha1_hash.digest 'hex'
                facebook_id: params.id
                name: params.name
                first_name: params.first_name
                last_name: params.last_name
                isSuppoter: true
                isFirstLogin: true
                profile:
                  image_url: "https://graph.facebook.com/#{toFacebookId}/picture"
                  gender: params.gender
            to.save (err)->
              throw err if err
              follow = _.find from.following, (follow)=>
                return (_.contains(follow.ids, fromId) && _.contains(follow.ids, to.id))
              unless follow
                follow = new Follow
                  from: to._id
                  to: from._id
                  ids: [to.id, from.id]
                  request_id: params.request_id
                  approval: false
                follow.save()
                from.follower.push follow
                to.following.push follow
                from.save()
                to.save()
              console.log follow
              follow.cancel_request_facebook_id = to.facebook_id
              return res.send follow