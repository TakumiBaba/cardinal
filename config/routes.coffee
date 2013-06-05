module.exports = (app) ->

  SiteEvent = app.settings.events.SiteEvent app
  View = app.settings.events.ViewEvent app
  User = app.settings.events.UserEvent app
  Talk = app.settings.events.TalkEvent app
  Message = app.settings.events.MessageEvent app
  Like = app.settings.events.LikeEvent app
  Follow = app.settings.events.FollowEvent app
  Debug = app.settings.events.DebugEvent app

  # {ensure}
  log = app.settings.helper.logger no

  app.get    '/',  log,  SiteEvent.index
  app.post   '/',  log,  SiteEvent.postindex
  app.post '/hogefuga', Debug.hogefuga
  app.get '/login', SiteEvent.Login.normal
  app.get '/firstlogin', SiteEvent.Login.first
  app.get '/signup', SiteEvent.Login.signup
  # app.post '/api/login', SiteEvent.login
  app.post '/api/signup', User.signup
  app.get '/api/appaccesstoken', SiteEvent.appAccessToken.fetch

  # UserEvent
  app.get '/api/users/:user_id', User.fetch
  app.get '/api/users/:user_id/picture', User.profile.picture
  app.put '/api/users/me', User.update
  app.get '/api/users/me/profile', User.profile.fetch
  app.post '/api/users/me/profile', User.profile.update
  app.get '/api/users/:user_id/news', User.news.fetch
  app.get '/api/users/me/news/delete', User.news.delete
  app.get '/api/users/facebook/:facebook_id', User.facebook.fetch

  # ViewEvent
  app.get '/render/test', Debug.rendertest
  app.get '/views/profile/index', SiteEvent.profile.index
  app.get '/views/candidate/:id', SiteEvent.candidate
  app.get '/views/sidebar', View.sidebar
  app.get '/views/matching', View.matching
  app.get '/views/like', View.like
  app.get '/views/message', View.message
  app.get '/views/supporting/:userid', View.supportUser
  app.get '/views/usage', View.usage

  # FollowEvent
  app.get '/api/users/:user_id/followings', Follow.following.fetch
  app.get '/api/users/:user_id/followers', Follow.follower.fetch
  app.get '/api/users/:from_id/request/:to_id', Follow.request.normal # get → post
  app.post '/api/users/:from_id/fbrequest/:to_facebook_id', Follow.request.facebook
  app.put '/api/users/:from_id/followings/:to_id', Follow.following.update # get → put
  app.post '/api/users/:from_id/followings/:to_id', Follow.following.update # get → put
  # app.delete '/api/users/:from_id/following/:to_id', Follow.following.delete
  app.delete '/api/follow/:follow_id', Follow.following.delete
  app.delete '/api/users/:from_id/followers/:to_id', Follow.follower.delete
  app.put '/api/follow/:follow_id', Follow.following.bUpdate

  # TalkEvent
  app.get '/api/users/:user_id/talks.json', Talk.fetch
  app.post '/api/talks.json', Talk.create
  app.post '/api/talks/:talk_id/comment', Talk.comment.create
  app.post '/api/talks/:talk_id/like/:user_id/increment', Talk.like.increment
  app.post '/api/talks/:talk_id/like/:user_id/decrement', Talk.like.decrement
  app.get '/api/talks/:talk_id/comments.json', Talk.comment.fetch

  # MessageEvent
  app.get '/api/users/:user_id/messages.json', Message.List.fetch
  app.post '/api/users/:user_id/:candidate_id/message', Message.List.create
  app.post '/api/users/:user_id/messages/:candidate_id', Message.List.create
  app.get '/api/messagelist/:list_id/messages', Message.Comment.fetch
  app.post '/api/messagelist/:list_id/message', Message.Comment.create

  # SupporterMessageEvent
  app.get '/api/users/:user_id/supportermessages', User.supporterMessage.fetch
  app.post '/api/users/:user_id/supportermessages/:supporter_id', User.supporterMessage.createOrUpdate
  app.get '/api/users/:user_id/supportermessages/:supporter_id/:message', User.supporterMessage.createOrUpdate
  app.post '/api/users/:user_id/supportermessage', User.supporterMessage.test.createOrUpdate
  app.delete '/api/supportermessages/:id', User.supporterMessage.delete

  # LikeEvent
  app.get '/api/users/:user_id/candidates.json', Like.status.fetch
  app.get '/api/users/:oneId/candidates/:twoId', Like.create
  app.post '/api/users/:oneId/candidates/:twoId', Like.status.update
  app.get '/api/users/:oneId/candidates/:twoId/:status', Like.status.update
  # Like test
  app.post '/api/users/:user_id/candidates', Like.test.update

  # NotificationEvent
  app.post '/api/users/:from/notification/:to/message', User.news.message
  app.post '/api/users/:user_id/notification/talk', User.news.talk

  # DebugEvent
  app.get '/debug/api/users', Debug.user.fetchAll
  app.get '/debug/api/users/delete', Debug.user.deleteAll
  app.get '/debug/api/setup', Debug.setup
  app.get '/debug/api/talk/:user_id/create', Debug.talk.create
  app.get '/debug/api/talk/reset', Debug.talk.reset
  app.get '/debug/api/message/create', Debug.message.create
  app.get '/debug/api/message/reset', Debug.message.reset
  app.get '/debug/api/users/me/following/:followingId', Debug.followings.create
  app.get '/debug/sdk/', Debug.facebooksdk.test
  app.get '/debug/sdk/notification', Debug.facebooksdk.sendNotification
  app.delete '/debug/sdk/request', Debug.facebooksdk.deleteRequest
  app.get '/debug/api/reset/statuses/:id', Debug.reset.statuses
  app.get '/debug/api/users/:user_id/status/removecancel', Debug.removeCancel
  app.get '/debug/api/dammy/user/create', Debug.Dammy.User.create
  app.get '/debug/api/dammy/:userid/supporter/create', Debug.Dammy.Supporter.create
  # app.get '/debug/api/users/me/sm/delete', User.supporterMessage.delete

  return SiteEvent.failure