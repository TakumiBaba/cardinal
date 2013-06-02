exports.MessageEvent = (app) ->

  Message = app.settings.models.Message
  MessageList = app.settings.models.MessageList
  User = app.settings.models.User

  List:
    fetch: (req, res)->
      id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
      User.findOne({id: id}).populate('news').exec (err, user)->
        throw err if err
        MessageList.find({_id: {$in: user.messageLists}}).populate("messages").populate("one").populate("two").exec (err, lists)->
          throw err if err
          news = _.filter user.news, (n)=>
            return !n.isRead && n.type is "message"
          _.each news, (n)->
            n.isRead = true
            n.save()
          sortedLists = _.sortBy lists, (list)->
            return list.lastUpdated
          res.send sortedLists
    create: (req, res)->
      userid = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
      candidateid = req.params.candidate_id
      text = req.body.text
      console.log userid, candidateid
      User.find {id: {$in: [userid, candidateid]}}, (err, users)=>
        throw err if err
        f = _.find users, (u)->
          return u.id is userid
        t = _.find users, (u)->
          return u.id is candidateid
        MessageList.findOne().where('one').in([f._id, t._id]).where('two').in([f._id, t._id]).exec (err, list)=>
          throw err if err
          console.log list
          if !list
            messageList = new MessageList()
            messageList.one = f._id
            messageList.two = t._id
            f.messageLists.push messageList
            t.messageLists.push messageList
            messageList.save ()=>
              f.save()
              t.save()
              return res.send messageList
          else
            message = new Message()
            message.text = text
            message.from = f._id
            message.from_id = f.id
            message.from_name = f.first_name
            message.parent = list._id
            message.save()
            list.messages.push message
            list.save()
            return res.send message
  Comment:
    fetch: (req, res)->
      list_id = req.params.list_id
      MessageList.findOne({_id: list_id}).exec (err, list)=>
        throw err if err
        Message.find({_id: {$in: list.messages}}).populate('from', "id first_name").exec (err, messages)->
          throw err if err
          console.log messages
          return res.send messages
    create: (req, res)->
      params = req.body
      MessageList.findOne({_id: req.params.list_id}).exec (err, list)->
        throw err if err
        unless list
          console.log 'list is not exist'
          return res.send 'list is not exist'
        message = new Message
          text: params.text
          from: params.from
          parent: params.parent
        message.save()
        list.messages.push message
        list.save (err)->
          throw err if err
          console.log list
          return res.send message

  test:
    create:(req, res)->
      userid = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
      candidateid = req.params.candidate_id
      text = req.body.text
      console.log userid, candidateid
      User.find {id: {$in: [userid, candidateid]}}, (err, users)=>
        throw err if err
        f = _.find users, (u)->
          return u.id is userid
        t = _.find users, (u)->
          return u.id is candidateid
        MessageList.findOne().where('one').in([f._id, t._id]).where('two').in([f._id, t._id]).exec (err, list)=>
          throw err if err
          console.log list

  comment:
    fetch: (req, res)->
      id = req.params.message_id
      Message.find {id: id}, (err, message)->
        throw err if err

