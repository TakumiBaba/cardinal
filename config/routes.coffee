module.exports = (app) ->

  SiteEvent = app.settings.events.SiteEvent app
  User = app.settings.events.UserEvent app
  Talk = app.settings.events.TalkEvent app
  Message = app.settings.events.MessageEvent app
  Like = app.settings.events.LikeEvent app
  Debug = app.settings.events.DebugEvent app

  # {ensure}
  log = app.settings.helper.logger no

  app.get    '/',  log,  SiteEvent.index
  app.post   '/',  log,  SiteEvent.index
  app.post '/api/login', SiteEvent.login


  # UserEvent
  app.get '/api/users/:user_id', User.fetch
  app.get '/api/users/:user_id/picture', User.profile.picture
  app.put '/api/users/me', User.update
  app.get '/api/users/me/profile', User.profile.fetch
  app.post '/api/users/me/profile', User.profile.update
  app.get '/api/users/:user_id/followings.json', User.followings.fetch
  # app.get '/api/users/:user_id/follower.json', User.fetchFollower

  # TalkEvent
  app.get '/api/users/:user_id/talks.json', Talk.fetch
  app.post '/api/talks.json', Talk.create
  app.post '/api/talks/:talk_id/comment', Talk.comment.create
  app.get '/api/talks/:talk_id/comments.json', Talk.comment.fetch

  # MessageEvent
  app.get '/api/users/:user_id/messages.json', Message.fetch
  app.post '/api/message', Message.create

  # LikeEvent
  app.get '/api/users/:user_id/candidates.json', Like.fetch # Queryによって返す値を変更
  app.post '/api/users/me/candidates/:candidate_id.json', Like.update

  # DebugEvent
  app.get '/debug/api/users', Debug.user.fetchAll
  app.get '/debug/api/setup', Debug.setup
  app.get '/debug/api/message', Debug.message
  app.get '/debug/api/talk/create', Debug.talk.create
  app.get '/debug/api/talk/reset', Debug.talk.reset


  return SiteEvent.failure