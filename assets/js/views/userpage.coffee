App = window.App
JST = App.JST

class App.View.UserPage extends Backbone.View
  el: "div#main"

  events:
    "click ul.supporter-menu li": "changeTab"

  constructor: (attrs, options)->
    super
    $(@.el).empty()
    id = attrs.id
    @model = new App.Model.User
      id: id

    _.bindAll @, "render"
    @model.bind 'change', @render

  render: (model)->
    console.log model
    user = model
    gender = if user.get('profile').gender is 'male' then "男性" else "女性"
    b = new Date(user.get('profile').birthday)
    options =
      image_source: user.get('profile').image_url
      name: user.get('name')
      gender_birthday: "#{gender} #{user.get('profile').age}歳　#{b.getFullYear()}年#{b.getMonth()-1}月#{b.getDay()}日生まれ"
      follower: user.get('follower')
      profile: user.get('profile')
    html = JST['supporting/userpage/page'](options)
    $(@.el).empty()
    $(@.el).html html

    profileView = new App.View.UserPageProfile
      id: @model.id

  changeTab: (e)=>
    tab = $(e.currentTarget).find('a').attr 'href'
    console.log tab
    if tab is "#detailprofile"
      if @profileView
        @profileView.undelegateEvents()
        # $("div#detailprofile").empty()
      $("div.profile_column").remove()
      $("div.follower_column").remove()
      $("div.supporter-message-list ul").empty()

      @profileView = new App.View.UserPageProfile
        id: @model.id
    else if tab is "#matchinglist"
      if @matchinglistView
        @matchinglistView.undelegateEvents()
      $("div#matchinglist").find('ul.userpage-like-thumbnail').each ()->
        $(@).empty()
      @matchinglistView = new App.View.UserPageMatchingList
        id: @model.id
    else if tab is "#likelist"
      if @likelistView
        @likelistView.undelegateEvents()
      $("div#likelist").find('ul.like-thumbnail').each ()->
        $(@).empty()
      @likelistView = new App.View.UserPageLikeList
        id: @model.id
    else if tab is "#supportertalk"
      if @supportertalkView
        @supportertalkView.undelegateEvents()
      $("div#supportertalk").find('ul').empty()
      @supportertalkView = new App.View.UserPageSupporterTalk
        id: @model.id

class App.View.UserPageProfile extends Backbone.View
  el: "div#detailprofile"

  events:
    "click div.supporter-message-post-view button": "postSupporterMessage"

  constructor: (attrs, options)->
    super
    _.bindAll @, "render", "appendFollower"

    @model = new App.Model.User
      id: attrs.id
    @model.bind 'change', @.render

    @supporterMessages = new App.Collection.SupporterMessages
      id: attrs.id
    @supporterMessages.bind 'reset', @appendSupporterMessages

    @model.fetch()

    @.followers = new App.Collection.Followers
      userid: @model.id
    @.followers.bind 'reset', @.appendFollower
    @.followers.fetch()

  render: (model)->
    console.log 'profile render'
    user = model
    gender = if user.get('profile').gender is 'male' then "男性" else "女性"
    b = new Date(user.get('profile').birthday)
    attributes =
      image_source: user.get('profile').image_url
      name: user.get("name")
      gender_birthday: "#{gender} #{user.get('profile').age}歳"
      follower: user.get("follower")
      profile: user.get('profile')
    @.el = JST['userpage/profile'](attributes)
    $('div#detailprofile').prepend @.el
    @supporterMessages.fetch()

  appendFollower: (collection)->
    ul = $("ul.follower-list")
    _.each collection.models, (model)=>
      if model.get('approval')
        attributes =
          facebook_url: "https://facebook.com/#{model.get('follower').facebook_id}"
          source: model.get('follower').profile.image_url
          name: model.get('follower').last_name
        li = JST['matching/follower'](attributes)
        ul.append li

  appendSupporterMessages: (collection)->

    _.each collection.models, (model)=>
      console.log model
      s = model.get('supporter')
      attributes =
        source: s.profile.image_url
        name: s.first_name
        message: model.get('message')
      li = JST['supporter-message/li'](attributes)
      console.log li
      $("div.supporter-message-list ul").append li
      # $find("div.supporter-message-list ul").append li

  postSupporterMessage: (e)->
    text =  $('div.supporter-message-post-view textarea').val()
    console.log text
    console.log @model.get('id')
    $.ajax
      type: "POST"
      url: "/api/users/#{@model.get('id')}/supportermessages/me"
      data:
        message: text
      success:(data)=>
        console.log data
        @model.fetch()

class App.View.UserPageMatchingList extends Backbone.View
  el: "div#matchinglist"

  events:
    "click button.like-action": "recommend"
    "click a.to-talk": "talk"

  constructor: (attrs, option)->
    super
    @targetId = attrs.id
    @.collection = new App.Collection.PreCandidates
      userid: attrs.id
      status: "0"

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

    @.collection.fetch()

  appendItem: (model)->
    console.log model.get('user').name
    console.log model
    if model.get('isSystemMatching')
      ul = $("div.system ul")
      text = "オススメする"
      render = JST['userpage/sys_matching/thumbnail']
    else
      ul = $("div.supporter ul")
      text = ""
      render = JST['userpage/sup_matching/thumbnail']
    attributes =
      id: model.get('user').id
      source: model.get('user').profile.image_url
      text: text
      status: model.get('status')
      name: model.get('user').name
    li = render(attributes)
    ul.append li

  appendAllItem: (collection)->
    console.log collection
    _.each collection.models, @.appendItem

  recommend: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    $.ajax
      type: "POST"
      url: "/api/users/#{@targetId}/candidates/#{id}"
      data:
        nextStatus: "promotion"
      success: (data)->
        console.log data

  talk: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    console.log id
    $.ajax
      type: "POST"
      url: "/api/talks.json"
      data:
        one: @targetId
        two: id
      success:(data)->
        console.log data
        $("a[href='#supportertalk']").click()
        # window.alert("応援団トークのタブをクリックして#{data.candidate.name}さんについて話しましょう")

class App.View.UserPageLikeList extends Backbone.View
  el: "div#likelist"

  events:
    "click a.to-talk": "talk"

  constructor: (attrs, options)->
    super

    @.targetId = attrs.id
    @.collection = new App.Collection.PreCandidates
      userid: attrs.id
      status: "1,2,3"

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

    @.collection.fetch()

  appendItem: (model)->
    status = model.get('status')
    user  = model.get('user')
    text  = ""
    console.log model
    myStatus = model.get("myStatus")
    status = model.get("status")
    if myStatus is true && status is false
      ul = $('div.my-like ul')
    else if myStatus is false && status is true
      ul = $('div.your-like ul')
    else if myStatus is true && status is true
      ul = $('div.each-like ul')
    else
      ul = $("")
    attributes =
      id: user.id
      source: user.profile.image_url
      name: user.name
      status: status
      text: ""
    li = JST['userpage/like/thumbnail'](attributes)
    ul.append li

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

  talk: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    console.log id
    $.ajax
      type: "POST"
      url: "/api/talks.json"
      data:
        one: @targetId
        two: id
      success:(data)=>
        console.log data
        $("a[href='#supportertalk']").click()
        # window.alert("応援団トークのタブをクリックして#{data.candidate.name}さんについて話しましょう")
        location.href = "/#/s/#{@targetId}"


class App.View.UserPageSupporterTalk extends Backbone.View
  el: "div#supportertalk"

  constructor: (attrs, options)->
    super
    @.collection = new App.Collection.Talks
      userid: attrs.id

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

    @.collection.fetch()

  appendItem: (model)->
    console.log model
    talk = new App.View.TalkUnit
      model: model
    talk.render()
    $("div#supportertalk ul.talk_list").append talk.el

  appendAllItem: (collection)->
    $(@.el).find('ul.talk_list').empty()
    _.each collection.models, @.appendItem