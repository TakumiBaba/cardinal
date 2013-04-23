exports.LikeEvent = (app) ->

  Like = app.settings.models.Like
  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Status = app.settings.models.Status

  fetch: (req, res)->
    status = if req.query.status? then req.query.status.split(",") else [0,1,2,3]
    id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
    User.findOne({id: id}).exec (err, user)->
      throw err if err
      Candidate.find({_id: {$in: user.candidates}}).populate("user").exec (err, candidates)->
        throw err if err
        list = _.filter candidates, (c)=>
          return _.contains status, c.status.toString()
        return res.send list

  # create: (req, res)->
  #   oneId = req.params.oneId
  #   twoId = req.params.twoId
  #   User.find({id: {$in:[oneId, twoId]}}).populate('candidate').exec (err, users)->
  #     throw err if err
  #     one = {}
  #     two = {}
  #     _.each users, (u)=>
  #       if u.id is oneId
  #         one = u
  #       else
  #         two = u

  #     Candidate.find().where('one').in([one._id, two._id]).where('two').in([one._id, two._id]).exec (err, candidate)->
  #       # 共通のCandidateカラムを作っておいて、そこでStatusを変更させていく。
  #     _.each one.candidates, (c)=>
  #       if c.user is two._id

  status:
    fetch: (req, res)->
      query = if req.query.status? then req.query.status.split(",") else ["0","1","2","3"]
      userId = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
      User.findOne({id: userId}).exec (err, user)->
        throw err if err
        statuses = user.statuses
        Status.find({_id: {$in: statuses}}).populate('one', 'id name profile').populate('two', 'id name profile').exec (err, statuses)=>
          throw err if err
          list = []
          _.each statuses, (status)=>
            if status.one.id is user.id
              json =
                user: status.two
                status: status.two_status
                myStatus: status.one_status
                isSystemMatching: status.two_isSystemMatching
            else
              json =
                user: status.one
                status: status.one_status
                myStatus: status.two_status
                isSystemMatching: status.one_isSystemMatching
            if _.contains query, "0"
              if json.status is false && json.myStatus is false
                list.push json
            if _.contains query, "1"
              if json.status is false && json.myStatus is true
                list.push json
            if _.contains query, "2"
              if json.status is true && json.myStatus is false
                list.push json
            if _.contains query, "3"
              if json.status is true && json.myStatus is true
                list.push json
          return res.send list

    update: (req, res)->
      oneId = if req.params.oneId is 'me' then req.session.userid else req.params.oneId
      twoId = if req.params.twoId is 'me' then req.session.userid else req.params.twoId
      nextStatus = req.body.nextStatus || req.params.status
      console.log 'update!!'
      console.log oneId, twoId
      User.find({id: {$in:[oneId, twoId]}}).exec (err, users)->
        throw err if err
        one = {}
        two = {}
        _.each users, (u)=>
          if u.id is oneId
            one = u
          else
            two = u
        Status.findOne({ids: {$all:[one.id, two.id]}}).populate('one', "id name profile").populate("two", "id name profile").exec (err, status)=>
          throw err if err
          console.log status
          if status.one.id is one.id
            if nextStatus is "up"
              status.one_status = true
            else if nextStatus is "down"
              status.one_status = false
            else if nextStatus is "promotion"
              status.one_isSystemMatching = false
          else
            if nextStatus is "up"
              status.two_status = true
            else if nextStatus is "down"
              status.two_status = false
            else if nextStatus is "promotion"
              status.two_isSystemMatching = false
          status.save()
          return res.send status

  create: (req, res)->
    oneId = if req.params.oneId is 'me' then req.session.userid else req.params.oneId
    twoId = if req.params.twoId is 'me' then req.session.userid else req.params.twoId
    User.find({id: {$in:[oneId, twoId]}}).exec (err, users)->
      throw err if err
      one = {}
      two = {}
      _.each users, (u)=>
        if u.id is oneId
          one = u
        else
          two = u
      Status.findOne({ids: {$all:[one.id, two.id]}}).exec (err, status)->
        throw err if err
        unless status
          status = new Status
            one: one._id
            two: two._id
            ids: [one.id, two.id]
            one_status: false
            two_status: false
          status.save()
          one.statuses.push status
          one.save()
          two.statuses.push status
          two.save()
          console.log 'create new status'
        console.log 'already status exist'
        return res.send status

  recommend: (req, res)->
    oneId = if req.params.oneId is 'me' then req.session.userid else req.params.oneId
    twoId = if req.params.twoId is 'me' then req.session.userid else req.params.twoId
    User.find({id: {$in:[oneId, twoId]}}).populate('candidate').exec (err, users)->
      throw err if err
      one = {}
      two = {}
      _.each users, (u)=>
        if u.id is oneId
          one = u
        else
          two = u
      Status.findOne({ids: {$all:[one.id, two.id]}}).exec (err, status)=>
        throw err if err
        unless status
          status = new Status
            one: one._id
            two: two._id
            ids: [one.id, two.id]
            one_status: false
            two_status: false
          one.statuses.push status
          one.save()
          two.statuses.push status
          two.save()
          console.log 'create new status'
        status.one_isSystemMatching = false
        status.save()
        return res.send status

  update: (req, res)->
    newStatus = req.body.status
    candidateId = req.params.candidate_id
    id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
    promotion = req.body.promotion
    console.log promotion
    User.findOne({id: id}).exec (err, user)=>
      throw err if err
      Candidate.find({_id: {$in: user.candidates}}).populate("user").exec (err, candidates)=>
        throw err if err
        candidate = _.find candidates, (c)->
          return c.user.id is candidateId
        if newStatus is 'up'
          console.log 'up!'
          if candidate.status is 1
            candidate.status = 3
          else
            candidate.status = 1
        else
          candidate.status = newStatus
        if promotion is "true"
          candidate.isSystemMatching = false
        candidate.save()
        return res.send candidate

  recommend: (req, res)->
    oneId = req.params.user_id
    twoId = req.params.candidate_id
    User.findOne({id: oneId}).populate('candidate').exec (err, one)->
      throw err if err
      two = _.find one.candidates, (c)=>
        return c.id is twoId
      if !two
        User.find({id: twoId}).exec (err, two)=>
          candidate = new Candidate
            user: two._id
            isSystemMatching: false
            status: 0
          candidate.save()
          one.candidates.push candidate
          one.save()
          return res.send candidate
      else
        two.isSystemMatching = false
        two.save()
        console.log two
        return res.send two