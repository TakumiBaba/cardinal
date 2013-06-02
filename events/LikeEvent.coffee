exports.LikeEvent = (app) ->

  Like = app.settings.models.Like
  User = app.settings.models.User
  Candidate = app.settings.models.Candidate
  Status = app.settings.models.Status
  SupporterMessage = app.settings.models.SupporterMessage

  fetch: (req, res)->
    status = if req.query.status? then req.query.status.split(",") else [0,1,2,3]
    id = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
    User.findOne({id: id}).exec (err, user)->
      throw err if err
      Candidate.find({_id: {$in: user.candidates}}).populate("user").exec (err, candidates)=>
        throw err if err
        list = _.filter candidates, (c)=>
          return _.contains status, c.status.toString()
        return res.send list


  status:
    fetch: (req, res)->
      query = if req.query.status? then req.query.status.split(",") else ["0","1","2","3"]
      userId = if req.params.user_id is 'me' then req.session.userid else req.params.user_id
      User.findOne({id: userId}).exec (err, user)->
        throw err if err
        statuses = user.statuses
        Status.find({_id: {$in: statuses}}).populate('one', 'id name profile first_name last_name').populate('two', 'id name profile first_name last_name').exec (err, statuses)=>
          throw err if err
          list = []
          _.each statuses, (status)=>
            if status.one.id is user.id
              json =
                user: status.two
                status: status.two_status
                myStatus: status.one_status
                isSystemMatching: status.two_isSystemMatching
                isRemoved: status.isRemoved
            else
              json =
                user: status.one
                status: status.one_status
                myStatus: status.two_status
                isSystemMatching: status.one_isSystemMatching
                isRemoved: status.isRemoved
            if status.isRemoved is false
              if _.contains query, "0"
                if (json.status is false) and (json.myStatus is false)
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
      console.log oneId, twoId, nextStatus
      User.find({id: {$in:[oneId, twoId]}}).exec (err, users)->
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
          console.log status
          unless status
            status = new Status()
            status.one = one._id
            status.two = two._id
            status.ids = [one.id, two.id]
            status.one_status = false
            status.two_status = false
            status.one_isSystemMatching = true
            status.two_isSystemMatching = true
            one.statuses.push status
            two.statuses.push status
          if status.one.toString() is one._id.toString()
            console.log "one"
            if nextStatus is "up"
              status.one_status = true
            else if nextStatus is "down"
              status.one_status = false
              status.isRemoved = true
            else if nextStatus is "promotion"
              console.log 'promotion!!!!!!!!!!!!'
              status.two_isSystemMatching = false
          else
            console.log "two"
            if nextStatus is "up"
              status.two_status = true
            else if nextStatus is "down"
              status.two_status = false
              status.isRemoved = true
            else if nextStatus is "promotion"
              console.log 'promotion!!!!!!!!!!!!'
              status.one_isSystemMatching = false
          console.log status
          one.save()
          two.save()
          status.save (err)->
            throw err if err
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

  test:
    update: (req, res)->
      playerId = req.params.user_id
      candidateId = req.body.user.id
      params = req.body
      Status.find({ids: {$all: [playerId, candidateId]}}).populate("one", "id").populate("two", "id").exec (err, statuses)=>
        throw err if err
        if statuses.length > 0
          _.each statuses, (status, i)->
            if i > 0
              status.remove()
        status = statuses[0]
        if status.one.id is playerId
          oneStatus = params.myStatus
          twoStatus = params.status
        else
          oneStatus = params.status
          twoStatus = params.myStatus
        status.one_status = oneStatus
        status.two_status = twoStatus
        status.isRemoved = params.isRemoved
        status.save (err)->
          throw err if err
          console.log status
          return res.send status


  # recommend: (req, res)->
  #   oneId = req.params.user_id
  #   twoId = req.params.candidate_id
  #   User.findOne({id: oneId}).populate('candidate').exec (err, one)->
  #     throw err if err
  #     two = _.find one.candidates, (c)=>
  #       return c.id is twoId
  #     if !two
  #       User.find({id: twoId}).exec (err, two)=>
  #         candidate = new Candidate
  #           user: two._id
  #           isSystemMatching: false
  #           status: 0
  #         candidate.save()
  #         one.candidates.push candidate
  #         one.save()
  #         return res.send candidate
  #     else
  #       two.isSystemMatching = false
  #       two.save()
  #       console.log two
  #       return res.send two