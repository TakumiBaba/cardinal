App = window.App

class App.Model.User extends Backbone.Model
  urlRoot: '/api/users'

  constructor: (attrs)->
    super
    @.set('age', Math.floor(Math.random()*60)+22)

  # defaults:
  #   name: "baba"
  #   firstName: "Takumi"
  #   lastName: "Baba"
  #   facebookId: "100001088919966"
  #   id: "b08b809483972111e976e85e77ac7527add62ad3"
  #   created_at: new Date()
  #   profile:
  #     image_url: "//graph.facebook.com/100001088919966/picture"
  #     age: 22
  #     gender: "male"
  #     birthday: new Date()
  #     martialHistory: 1
  #     hasChild: 1
  #     wantMarriage: 1
  #     wantChild: 1
  #     address: 1
  #     hometown: 1
  #     education: 1
  #     job: 1
  #     income: 0
  #     height: 0
  #     bloodType: 1
  #     shape: 1
  #     drinking: 1
  #     smoking: 1
  #     hoby: ["hoge", "fuga"]
  #     like: ["アニメ", "ハンドボール"]
  #     message: "hogefuga!"
  #   candidates: ['10101010101010'] #candidate id
  #   followings: ['10101010101011'] #followings id
  #   followers:  ['10101010101012'] #followers id
  #   talks: ['20101010101010'] #talks id
  #   messages: ['30101010101010'] #messages id
  #   supporterMessages: ['40101010101010'] #supporters id


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