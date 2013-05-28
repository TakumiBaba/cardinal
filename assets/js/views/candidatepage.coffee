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

    @.supporterMessages = new App.Collection.SupporterMessages
      id: attrs.id

    _.bindAll @, "render", "appendFollowers", "appendSupporterMessages"
    @.model.bind 'change', @render
    @.collection.bind 'reset', @appendFollowers
    @.supporterMessages.bind 'reset', @appendSupporterMessages

    @.model.fetch()
    @.collection.fetch()
    @.supporterMessages.fetch()


  render: (model)->
    user = model
    gender = if user.get('profile').gender is 'male' then "男性" else "女性"
    b = new Date(user.get('profile').birthday)
    age = moment().diff(moment(user.get('profile').birthday), "year")
    console.log age
    attributes =
      image_source: model.get('profile').image_url
      name: model.get('name')
      first_name: model.get('first_name')
      gender_birthday: "#{age}歳"
      profile: user.get('profile')
    html = JST['candidate/page'](attributes)
    $(@.el).html html
    @recommendButton = new App.View.FollowDropDownMenu
      targetId: user.get('id')
    @recommendButton.render()

  appendFollowers: (collection)->
    _.each collection.models, (model)=>
      if model.get('approval')
        f = model.get('follower')
        console.log f
        attributes =
          facebook_url: "https://facebook.com/#{f.facebook_id}"
          source: f.profile.image_url
          name: "#{f.first_name}さん"
        li = JST['matching/follower'](attributes)
        $(@.el).find('ul.follower-list').append li

  appendSupporterMessages: (collection)->
    _.each collection.models, (model)=>
      s = model.get('supporter')
      attributes =
        source: s.profile.image_url
        name: s.first_name
        message: model.get('message')
      li = JST['supporter-message/li'](attributes)
      $(@.el).find("div.supporter-message-list ul").append li

  doLike: (e)->
    console.log e
    $.ajax
      type: "POST"
      url: "/api/users/me/candidates/#{@model.get('id')}"
      data:
        nextStatus: "up"
      success:(data)->
        location.href = "/#/like"
        console.log data

  sendMessage: (e)->
    console.log @model.get('id')
    $.ajax
      type: "POST"
      url: "/api/users/me/#{@model.get('id')}/message"
      success:(data)->
        if data
          location.href = "/#/message"

  recommend: (e)->
    console.log e
