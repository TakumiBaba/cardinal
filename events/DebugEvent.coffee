exports.DebugEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Message = app.settings.models.Message
  Talk = app.settings.models.Talk
  Comment = app.settings.models.Comment
  MessageEvent = app.settings.events.MessageEvent app
  TalkEvent = app.settings.events.TalkEvent app

  user:
    fetchAll: (req, res)->
      User.find({}).exec (err, users)->
        throw err if err
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
        _.each u.candidates, (mm, i)=>
          Candidate.findOne({_id: mm}).populate('user', "id").exec (err, candidate)=>
            throw err if err
            _.each [0..20], (i)=>
              if i%2 is 0
                from = candidate.user.id
                to = u.id
              else
                to = candidate.user.id
                from = u.id
              req.params =
                from: from
                to:   to
              req.body =
                text: "hoge#{_.random(0, 100)}fuga"
              MessageEvent.create req, res
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
      id = req.session.userid
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