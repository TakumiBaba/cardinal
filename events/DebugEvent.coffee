exports.DebugEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Message = app.settings.models.Message
  MessageList = app.settings.models.MessageList
  Talk = app.settings.models.Talk
  Comment = app.settings.models.Comment
  Follow = app.settings.models.Follow
  MessageEvent = app.settings.events.MessageEvent app
  TalkEvent = app.settings.events.TalkEvent app

  user:
    fetchAll: (req, res)->
      User.find({}).exec (err, users)->
        throw err if err
        res.send users
    deleteAll: (req, res)->
      User.find({}).exec (err, users)->
        throw err if err
        _.each users, (u)=>
          u.remove()
        res.send users

  setup: (req, res)->
    User.find {}, (err, users)->
      throw err if err
      _.each users, (u)=>
        shuffled = _.shuffle users
        _.each [0..40], (i)=>
          if u.candidates.length < 30
            status = 0
            if i < 20
              status = _.random(1,3)
            else
              status = 0
            candidate = new Candidate
              user: shuffled[i]._id
              status: status
              isSystemMatching: if i%2 is 0 then true else false
            candidate.save ()=>
              u.save()
            # candidate =
            #   user: shuffled[i]._id
            #   status: status
            #   isSystemMatching: if i%2 is 0 then true else false
            u.candidates.push candidate._id
          else if i < 40
            u.following.push shuffled[i]._id if u.following.length < 10
            u.follower.push shuffled[i]._id if u.follower.length < 10
            u.save()
        # _.each u.candidates, (mm, i)=>
        #   Candidate.findOne({_id: mm}).populate('user', "id").exec (err, candidate)=>
        #     throw err if err
        #     _.each [0..20], (i)=>
        #       if i%2 is 0
        #         from = candidate.user.id
        #         to = u.id
        #       else
        #         to = candidate.user.id
        #         from = u.id
        #       req.params =
        #         from: from
        #         to:   to
        #       req.body =
        #         text: "hoge#{_.random(0, 100)}fuga"
        #       MessageEvent.create req, res
        # _.each u.candidates, (mm, i)=>
        #   User.findOne _id: mm.user, (err, temp)=>
        #     throw err if err
        #     _.each [0..5], (i)=>
        #       if i%2 is 0
        #         req.params =
        #           from: u.id
        #           to:   temp.id
        #         req.body =
        #           text: "hoge#{_.random(0, 100)}fuga"
        #       else
        #         req.params =
        #           from: temp.id
        #           to:   u.id
        #         req.body =
        #           text: "hoge#{_.random(0, 100)}fuga"
        #       MessageEvent.create(req, res)
      return res.send 'setup'

  message: (req, res)->
    id = req.session.userid
    User.findOne({id: id}).exec (err, user)->
      throw err if err
      main = user
      User.find({}).exec (err, users)=>
        throw err if err
        shuffled = users

        _.each [0..10], (k)=>
          d = shuffled[k]
          _.each [0..10], (i)=>
            message = new Message()
            message.id = if main.facebook_id > d.facebook_id then "#{main.facebook_id}_#{d.facebook_id}" else "#{d.facebook_id}_#{main.facebook_id}"
            message.from = if i%2 is 0 then d._id else main._id
            message.text = "hoge#{_.random(0, 100)}fuga"
            # message.save()
            main.messages.push message._id
            console.log 'ok'
        console.log 'hoge'
        main.save()
        return res.send 'ok'

  talk:
    create: (req, res)->
      id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
      User.findOne id: id, (err, user)->
        throw err if err
        main = user
        User.find {}, (err, users)=>
          throw err if err
          shuffled = _.shuffle users
          _.each [0..10], (i)=>
            candidate = shuffled[i]
            talk = new Talk()
            talk.user = main._id
            talk.candidate = candidate._id
            comment = new Comment()
            comment.user = candidate.id
            comment.text = "#{_.random(0, 100)}ですよね。"
            comment.save()
            talk.comments.push comment._id
            talk.save()
            main.talks.push talk._id
          main.save()
          return res.send main.talks
    reset: (req, res)->
      id = req.session.userid
      User.findOne id: id, (err, user)->
        throw err if err
        user.talks = []
        user.save()
      Talk.find {}, (err, talks)->
        _.each talks, (talk)->
          talk.remove()
      return res.send 'ok'

  message:
    create: (req, res)->
      id = req.session.userid
      User.findOne id: id, (err, user)->
        throw err if err
        main = user
        User.find {}, (err, users)=>
          throw err if err
          shuffled = _.shuffle users
          _.each [0..10], (i)=>
            c = shuffled[i]
            messageList = new MessageList()
            messageList.one = main._id
            messageList.two = c._id
            _.each [0..5], (k)=>
              message = new Message()
              message.text = "こんばんわ#{k*2}"
              message.from = if k%2 is 0 then c._id else main._id
              message.from_name = if k%2 is 0 then c.name else main.name
              message.save()
              messageList.messages.push message
            messageList.save()
            main.messageLists.push messageList
          main.save()
          return  res.send main
    reset: (req, res)->
      id = req.session.userid
      User.findOne id: id, (err, user)->
        throw err if err
        user.messageList = []
        MessageList.find {}, (err, list)->
          throw err if err
          _.each list, (l)->
            l.remove()
        Message.find {}, (err, messages)->
          throw err if err
          _.each messages, (m)->
            m.remove()
        res.send 'ok'


  followings:
    fetch: (req, res)->
      id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
      User.findOne({id: id}).populate("following", "id name profile").exec (err, user)->
        throw err if err
        if user
          res.send user.following
        else
          res.send []
    create: (req, res)->
      id = req.session.userid
      followingId = req.params.followingId
      User.find({id: {$in: [id, followingId]}}).exec (err, users)->
        throw err if err
        if users
          me = _.filter users, (u)=>
            return u.id is id
          following = _.filter users, (u)=>
            return u.id is followingId
          if _.contains me.following, following
            res.send 'already added'
          else
            following = new Follow()
            following.approval = false
            following.user = following._id
            console.log following
            console.log me.following
            me.following.push following
            me.save (err)->
              throw err if err
              res.send "add"
    delete: (req, res)->
      console.log 'hoge'
      id = req.session.userid
      deleteId = req.params.deleteId
      console.log id, deleteId
      User.find({id: {$in: [id, deleteId]}}).populate('following').exec (err, users)=>
        throw err if err
        if users
          me = _.find users, (u)=>
            return u.id is id
          target = _.find users, (u)=>
            return u.id is deleteId
          _.each me.following, (follow, i)=>
            if follow.id is target.id
              me.following[i] = null
          console.log me
          me.save (err)->
            throw err if err
            res.send @