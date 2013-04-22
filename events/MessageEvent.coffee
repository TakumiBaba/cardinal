exports.MessageEvent = (app) ->

  Message = app.settings.models.Message
  MessageList = app.settings.models.MessageList
  User = app.settings.models.User

  fetch: (req, res)->
    id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
    User.findOne({id: id}).exec (err, user)->
      throw err if err
      MessageList.find({_id: {$in: user.messageLists}}).populate("messages").populate("one").populate("two").exec (err, list)->
        throw err if err
        res.send list

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
          message.from_name = f.name
          message.save()
          list.messages.push message
          list.save()
          return res.send message


  comment:
    fetch: (req, res)->
      id = req.params.message_id
      Message.find {id: id}, (err, message)->
        throw err if err
