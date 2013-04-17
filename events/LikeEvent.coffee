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
      # candidatesId = _.pluck user.candidates, "user"
      # list = _.filter user.candidates, (c)=>
      #   return _.contains status, c.status.toString()
      # console.log list
      # return res.send list

  update: (req, res)->
    newStatus = req.body.status
    candidateId = req.params.candidate_id
    id = req.session.userid
    User.findOne({id: id}).exec (err, user)->
      throw err if err
      Candidate.find({_id: {$in: user.candidates}}).populate("user").exec (err, candidates)->
        throw err if err
        candidate = _.find candidates, (c)->
          return c.user.id is candidateId
        candidate.status = newStatus
        candidate.save()
        return res.send candidate
      # _.each user.candidates, (c, i)=>
      #   if c.user.id is candidateId
      #     user.candidates[i].status = newStatus
      #     user.updatedAt = Date.now()
      #     user.save (err)->
      #       throw err if err
      #       console.log @
      #     return res.send user.candidates[i]



