App = window.App
JST = App.JST

class App.View.CandidatePage extends Backbone.View
  el: "div#main"

  events:
    "click button.like": "doLike"

  constructor: (attrs, options)->
    super
    $(@.el).children().remove()
    @.model = new App.Model.User
      id: attrs.id

    @.collection = new App.Collection.Followers
      userid: attrs.id

    _.bindAll @, "render", "appendFollowers"
    @.model.bind 'change', @render
    @.collection.bind 'reset', @appendFollowers

    @.model.fetch()
    @.collection.fetch()

  render: (model)->
    user = model
    gender = if user.get('profile').gender is 'male' then "男性" else "女性"
    b = new Date(user.get('profile').birthday)
    attributes =
      image_source: model.get('profile').image_url
      name: model.get('name')
      gender_birthday: "#{gender} #{user.get('profile').age}歳　#{b.getFullYear()}年#{b.getMonth()-1}月#{b.getDay()}日生まれ"
      profile: user.get('profile')
    html = JST['candidate/page'](attributes)
    $(@.el).html html

  appendFollowers: (collection)->
    _.each collection.models, (model)=>
      attributes =
        facebook_url: "https://facebook.com/#{model.facebook_id}"
        source: model.get('profile').image_url
        name: "#{model.get('name')}さん"
      li = JST['matching/follower'](attributes)
      $(@.el).find('ul.follower-list').append li
      console.log model

  doLike: (e)->
    console.log e
    # $.ajax
    #   type: "POST"
    #   url: "/api/users/me/candidates/#{@model.get('id')}.json"
    #   data:
    #     status: "up"
    #   success:(data)->
    #     console.log data