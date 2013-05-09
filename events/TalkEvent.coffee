exports.TalkEvent = (app) ->

  Talk = app.settings.models.Talk
  User = app.settings.models.User
  Comment = app.settings.models.Comment

  fetch: (req, res)->
    id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
    User.findOne({id: id}).populate("news").exec (err, user)->
      throw err if err
      console.log user.talks
      Talk.find({_id: {$in: user.talks}}).populate('candidate').populate('user').exec (err, talks)=>
        news = _.filter user.news, (n)->
          console.log n
          return !n.isRead && n.type is "talk"
        _.each news, (n)=>
          n.isRead = true
          n.save()
        return res.send talks

  create: (req, res)->
    one = if req.body.one is 'me' then req.session.userid else req.body.one
    two = if req.body.two is 'me' then req.session.userid else req.body.two
    User.find id: {$in: [one, two]}, (err, users)=>
      throw err if err
      console.log users
      o = ""
      t = ""
      _.each users, (user)=>
        o = user if user.id is one
        t = user if user.id is two
      Talk.findOne({}).where("candidate").in([o._id, t._id]).where("user").in([o._id, t._id]).exec (err, talk)=>
        throw err if err
        unless talk
          talk = new Talk()
          talk.user = o._id
          talk.candidate = t._id
          talk.save()
          o.talks.push talk
          o.save()
          console.log 'new'
        console.log 'old'
        list = talk
        list.name = t.last_name
        console.log list
        return res.send list

    # Talk.findOne id: {$in: [one, two]}, (err, talk)->
    #   throw err if err
    #   unless talk
    #     talk = new Talk()
    #     talk.save()
    #     return res.send talk
    #   return res.send talk

  comment:
    create: (req, res)->
      console.log req.params
      id = if req.body.user_id is 'me' then req.session.userid else req.body.user_id
      text = req.body.text
      Talk.findOne({_id: req.params.talk_id}).exec (err, talk)->
        throw err if err
        unless talk
          return res.send 'talk is not existed'
        comment = new Comment()
        comment.user = id
        comment.text = text
        comment.save (err)->
          throw err if err
          talk.comments.push comment._id
          talk.save (err)->
            throw err if err
            return res.send comment
    fetch: (req, res)->
      console.log req.params.talk_id
      Talk.findOne({_id: req.params.talk_id}).populate('comments').exec (err, talk)->
        throw err if err
        console.log talk.comments
        res.send talk.comments