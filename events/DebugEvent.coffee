exports.DebugEvent = (app) ->

  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Message = app.settings.models.Message
  MessageList = app.settings.models.MessageList
  Talk = app.settings.models.Talk
  Comment = app.settings.models.Comment
  Follow = app.settings.models.Follow
  Status = app.settings.models.Status
  SupporterMessage = app.settings.models.SupporterMessage

  MessageEvent = app.settings.events.MessageEvent app
  TalkEvent = app.settings.events.TalkEvent app
  LikeEvent = app.settings.events.LikeEvent app

  Config = app.settings.config
  FB = require 'fb'

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
      Status.find({}).exec (err, statuses)->
        throw err if err
        _.each statuses, (s)=>
          s.remove()
      Follow.find({}).exec (err, follows)->
        throw err if err
        _.each follows, (f)=>
          f.remove()
      res.send 'delete'

  setup: (req, res)->
    User.find {}, (err, users)->
      throw err if err
      _.each users, (u)=>
        shuffled = _.shuffle users
        _.each [0..40], (i)=>
          u.following = []
          u.follower = []
          if u.statuses.length < 30 && i < 30
            req.params.oneId = u.id
            req.params.twoId = shuffled[i].id
            LikeEvent.create req, res
            # status = new Status
            #   one: u._id
            #   two: shuffled[i]._id
            #   ids: [u.id, shuffled[i].id]
            #   one_status: if _.random(0,1) is 0 then true else false
            #   two_status: if _.random(0,1) is 0 then true else false
            #   one_isSystemMathing: if _.random(0,3) < 1 then true else false
            #   two_isSystemMathing: if _.random(0,3) < 1 then true else false
            # u.statuses.push status
            # shuffled[i].statuses.push status
            # status.save()
            # u.save()
            # shuffled[i].save()
          else if i < 40
            console.log i
            following = new Follow
              name: shuffled[i].name
              id: shuffled[i].id
              approval: if _.random(0,3) < 3 then true else false
            follower = new Follow
              name: shuffled[i].name
              id: shuffled[i].id
              approval: if _.random(0,3) < 3 then true else false
            u.following.push following if u.following.length < 10
            u.follower.push follower if u.follower.length < 10
            following.save()
            follower.save()
            u.save()
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
              message.from_name = if k%2 is 0 then c.first_name else main.first_name
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

  facebooksdk:
    test: (req, res)->
      FB.api "100001088919966", {}, (response)->
        console.log(response.error) if !response or response.error
        console.log response
        return res.send response
    sendNotification: (req, res)->
      FB.api 'oauth/access_token',
        client_id: Config.appId
        client_secret: Config.appSecret
        grant_type: 'client_credentials'
      , (response)->
        console.log(response.error) if !response or response.error
        console.log response
        FB.setAccessToken response.access_token
        FB.api '100001088919966/notifications', 'post',
          access_token: response.access_token
          href: "https://takumiubaba.com"
          template: "Hi! @[100001088919966] yeah!"
        , (response)->
          console.log(response.error) if !response or response.error
          console.log response
          return res.send response
    deleteRequest: (req, res)->
      request_id = req.body.reqId || ""
      user_id    = req.body.userId || ""
      console.log request_id, user_id
      FB.api 'oauth/access_token',
        client_id: Config.appId
        client_secret: Config.appSecret
        grant_type: 'client_credentials'
      , (response)=>
        console.log "#{request_id}_#{user_id}"
        FB.api "#{request_id}_#{user_id}", "delete",
          access_token: response.access_token
        , (response)->
          throw response.error if !response or response.error
          console.log response
          return res.send response

  rendertest: (req, res)->
    res.render 'matching/index',
      req: req
    , (err, html)=>
      return res.send html

  reset:
    statuses:(req, res)->
      Status.find({}).exec (err, statuses)->
        throw err if err
        _.each statuses, (status)->
          status.remove()
        return res.send "status rset"


  profile:
    index: (req, res)->
      id = req.session.userid
      console.log id
      User.findOne({id: id}).exec (err, user)->
        throw err if err
        console.log user
        ids = user.supporter_message
        Follow.find({_id: {$in: user.follower}}).populate('from', "id first_name").exec (err, follows)=>
          throw err if err
          followers = []
          _.each follows, (follow)->
            followers.push follow.from
          SupporterMessage.find({_id: {$in: ids}}).populate('supporter', "id first_name").exec (err, messages)=>
            throw err if err
            res.render 'user/index',
              first_name: user.first_name
              profile: user.profile
              followers: followers
              messages: messages
            , (err, html)->
              throw err if err
              return res.send html
  hogefuga: (req,res)->
    console.log req.params
    console.log req.body
    console.log req.query
    return "hoge"
  removeCancel: (req, res)->
    id = if req.params.user_id is "me" then req.session.userid else req.params.user_id
    User.findOne({id: id}).populate('statuses').exec (err, user)->
      throw err if err
      console.log user.statuses
      _.each user.statuses, (status)->
        status.isRemoved = false
        # status.save()
      return res.send 'ok'

  Dammy:
    create: (req, res)->
      User.find {}, (err, users)->
      throw err if err
      _.each [0..100], (i)=>
        fbid = i+10000
        User.findOne facebook_id: fbid, (err, user)=>
          console.log err if err
          unless user
            user = new User()
            sha1_hash = Crypto.createHash 'sha1'
            sha1_hash.update "#{i+10000}"
            lastName = lastNames[i]
            k = Math.floor i/2
            console.log k
            firstName = if i%2 is 0 then firstNames_men[k] else firstNames_women[k]
            user.name = "#{lastName}#{firstName}"
            user.first_name = firstName
            user.last_name = lastName
            user.facebook_id = fbid
            user.id = sha1_hash.digest 'hex'
            if i%2 is 0
              user.profile.gender = 'male'
            else
              user.profile.gender = 'female'
            age = parseInt (20+(Math.floor(Math.random()*40)))
            user.profile.age = age
            user.isMarried = false
            user.profile.image_url = "/image/friends/#{if i%24 is 0 then 25 else i%24}.jpg"
            user.profile.message = "こんばんわ！#{user.first_name}です！"
            user.isSupporter = false
            p = user.profile
            y = 1960+Math.floor(Math.random()*30)
            m = 1+Math.floor(Math.random()*13)
            d = 1+Math.floor(Math.random()*30)
            birthday = moment(y+m+d)
            p.birthday = new Date(birthday)
            p.martialHistory = i%4
            p.hasChild = i%5
            p.wantMarriage = i%6
            p.wantChild = i%6
            p.address = i%48
            p.hometown = i%48
            p.job = i%23
            p.income = i*100
            p.height = 160+(i*30)
            p.education = i%7
            p.bloodType = i%5
            p.shape = i%9
            p.drinking = i%7
            p.smoking = i%5
            news = new News()
            news.text = "#{user.first_name}さんがDing Dongを始めました！"
            user.news.push news
            console.log user.name
            user.save()
    return res.send 'dammy create!'