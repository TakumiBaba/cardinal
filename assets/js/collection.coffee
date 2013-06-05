App = window.App

class App.Collection.Users extends Backbone.Collection
  model: App.Model.User

  constructor: ->
    super
    @.url = "/api/users/"

class App.Collection.PreCandidates extends Backbone.Collection
  model: App.Model.Candidates

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.userid}/candidates.json?status=#{attrs.status}"

  getBySystems: ->
    return _.filter @models, (model)->
      return model.get('isSystemMatching') is true
  getBySupporters: ->
    return _.filter @models, (model)->
      return model.get('isSystemMatching') is false

class App.Collection.Followings extends Backbone.Collection

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.userid}/followings"

class App.Collection.Followers extends Backbone.Collection

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.userid}/followers"

class App.Collection.Pending extends Backbone.Collection
  model: App.Model.User

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.userid}/pending.json"

class App.Collection.Request extends Backbone.Collection
  model: App.Model.User

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.userid}/request.json"

class App.Collection.MessageList extends Backbone.Collection
  # model: App.Model.Message

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.userid}/messages.json"

class App.Collection.Messages extends Backbone.Collection
  model: App.Model.Message

  constructor: (attrs, options)->
    super

class App.Collection.Talks extends Backbone.Collection
  model: App.Model.Talk

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.userid}/talks.json"

class App.Collection.Comments extends Backbone.Collection
  model: App.Model.Comment

  constructor: (attrs, options)->
    super
    @.url = "/api/talks/#{attrs.talkid}/comments.json"

class App.Collection.SupporterMessages extends Backbone.Collection
  model: App.Model.SupporterMessage

  constructor: (attrs, options)->
    super
    @.url = "/api/users/#{attrs.id}/supportermessages"

  setId: (id)->
    @id = id
    @.url = "/api/users/#{id}/supportermessages"