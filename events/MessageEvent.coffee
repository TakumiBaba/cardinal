exports.MessageEvent = (app) ->

  Message = app.settings.models.Message
  User = app.settings.models.User

  fetch: (req, res)->
    id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
    User.findOne({id: id}).populate('messages').exec (err, user)->
      throw err if err
      Message.find({_id: {$in: user.messages}}).populate('from', "profile name").exec (err, messages)->
        throw err if err
        res.send messages

  create: (req, res)->
    from = req.params.from
    to = req.params.to
    text = req.body.text
    if from? || to?
      return false
    User.find id: {$in: [from, to]}, (err, users)->
      throw err if err
      id = if users[0].facebook_id > users[1].facebook_id then "#{users[0].facebook_id}_#{users[1].facebook_id}" else "#{users[1].facebook_id}_#{users[0].facebook_id}"
      from = _.find users, (user)->
        return user.id is from
      message = new Message()
      message.id = id
      message.from = from
      message.text = text
      message.save()
      _.each users, (u)=>
        u.messages.push message
        u.save()
      return res.send message