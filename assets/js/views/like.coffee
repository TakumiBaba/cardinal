App = window.App
JST = App.JST

class App.View.LikePage extends Backbone.View
  el: "div#main"

  events:
    "click img.l_d_1": "cancelLike"
    "click img.l_d_2": "doLike"
    "click img.l_d_3": "sendMessage"
    "click a.to-talk": "talk"

  constructor: ->
    super
    @collection = new App.Collection.PreCandidates
      userid: "me"
      status: "1,2,3"

    _.bindAll @, "appendItem", "appendAllItem"
    @collection.bind 'add', @appendItem
    @collection.bind 'reset', @appendAllItem

  render: ->
    $(@.el).empty()
    html = JST['like/page']()
    $(@.el).html html

    @collection.fetch()

  appendItem: (model)->
    user = model.get 'user'
    yourStatus = model.get 'status'
    myStatus = model.get 'myStatus'
    text = ""
    status = ""
    button_source = ""
    href = ""
    if myStatus && !yourStatus
      ul = $(@.el).find('div.my-like ul')
      button_source = "/image/o_button_mini.gif"
      text = "いいね取り消し"
      href = "/#/like"
      status = 1
    else if !myStatus && yourStatus
      ul = $(@.el).find('div.your-like ul')
      button_source = "/image/iine_button_mini.gif"
      text = "いいね！"
      href = "/#/like"
      status = 2
    else if myStatus && yourStatus
      ul = $(@.el).find('div.each-like ul')
      button_source = "/image/m_button_mini.gif"
      text = "メッセージ送信"
      href = "/#/message"
      status = 3
    attributes =
      id: user.id
      source: user.profile.image_url
      button_source: button_source
      name: user.first_name
      status: status
      text: text
      href: href
    li = JST['like/thumbnail'](attributes)
    ul.append li
    console.log model

  appendAllItem: (collection)->
    console.log collection
    _.each collection.models, @.appendItem

  cancelLike: (e)->
    console.log 'cancel'
    target = $($(e.currentTarget).parents().parents()[1]).attr 'id'
    console.log @.collection.where({"user.id": target})
    model = _.find @.collection.models, (model)->
      return model.get('user').id is target
    model.urlRoot = "/api/users/me/candidates/#{model.get('user').id}"
    model.set("nextStatus", "down")
    model.save()
    $($(e.currentTarget).parent().parent()).remove()
  doLike: (e)->
    target = $($(e.currentTarget).parents().parents()[1]).attr 'id'
    model = _.find @.collection.models, (model)->
      return model.get('user').id is target
    console.log model
    model.urlRoot = "/api/users/me/candidates/#{model.get('user').id}"
    model.set("nextStatus", "up")
    model.save()
    li = $($(e.currentTarget).parent().parent()).clone()
    @appendItem model
    # $("div.each-like ul").append li
    $($(e.currentTarget).parent().parent()).remove()
  sendMessage: (e)->
    console.log 'send message'
    target = $($(e.currentTarget).parents().parents()[1]).attr 'id'
    console.log target
    model = _.find @.collection.models, (model)->
      return model.get('user').id is target
    console.log model
    $.ajax
      type: "POST"
      url: "/api/users/me/#{target}/message"
      success: (data)->
        if data
          location.href = "/#/message"


  talk: (e)->
    id = $($(e.currentTarget).parent().parent()).attr 'id'
    console.log id
    $.ajax
      type: "POST"
      url: "/api/talks.json"
      data:
        one: "me"
        two: id
      success:(data)->
        if data
          location.href = "/#/talk"