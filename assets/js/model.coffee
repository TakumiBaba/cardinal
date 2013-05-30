App = window.App

class App.Model.User extends Backbone.Model
  urlRoot: '/api/users'

  constructor: (attrs)->
    super

class App.Model.Profile extends Backbone.Model

  constructor: (attrs, options)->
    super
    @.urlRoot = "/api/users/me/profile"

class App.Model.Candidates extends Backbone.Model

  constructor: (attrs, options)->
    super
    @.urlRoot = "/api/users/#{attrs.userid}/candidates"

class App.Model.Message extends Backbone.Model

  constructor: (attrs, options)->
    super
    @.urlRoot = "/api/users/#{attrs.userid}/messages"

class App.Model.Talk extends Backbone.Model

  constructor: (attrs, options)->
    super
    @.urlRoot = "/api/users/#{attrs.userid}/talk"

class App.Model.Comment extends Backbone.Model

  constructor: (attrs, options)->
    super
    @.urlRoot = "/api/talks/#{attrs.talk_id}/comment"

class App.Model.SupporterMessage extends Backbone.Model

  constructor: (attrs, options)->
    super
    @.urlRoot = "/api/talks/#{attrs.talk_id}/supportermessage"