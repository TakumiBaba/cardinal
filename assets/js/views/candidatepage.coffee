App = window.App
JST = App.JST

class App.View.CandidatePage extends Backbone.View
  el: "div#main"

  events:
    "click button.like": "doLike"
    "click button.sendMessage": "sendMessage"
    "click button.recommend": "recommend"

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
    @recommendButton = new App.View.FollowDropDownMenu
      targetId: user.get('id')
    @recommendButton.render()

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
    $.ajax
      type: "POST"
      url: App.BaseUrl+"/api/users/me/candidates/#{@model.get('id')}.json"
      data:
        status: "up"
      success:(data)->
        console.log data

  sendMessage: (e)->
    console.log @model.get('id')
    $.ajax
      type: "POST"
      url: App.BaseUrl+"/api/users/me/#{@model.get('id')}/message"
      success:(data)->
        if data
          location.href = "/#/message"

  recommend: (e)->
    console.log e