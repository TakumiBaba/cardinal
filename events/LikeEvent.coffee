exports.LikeEvent = (app) ->

  Like = app.settings.models.Like
  User = app.settings.models.User
  Candidate = app.settings.models.Candidate

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



