App = window.App
JST = App.JST

class App.View.LikePage extends Backbone.View
  el: "div#main"

  events:
    "click button.l_d_1": "cancelLike"
    "click button.l_d_2": "doLike"
    "click button.l_d_3": "sendMessage"

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
    status = model.get 'status'
    text = ""
    if status is 1
      ul = $(@.el).find('div.my-like ul')
      text = "いいね取り消し"
    else if status is 2
      ul = $(@.el).find('div.your-like ul')
      text = "いいね！"
    else if status is 3
      ul = $(@.el).find('div.each-like ul')
      text = "メッセージ送信"
    attributes =
      id: user.id
      source: user.profile.image_url
      name: user.name
      status: status
      text: text
    li = JST['like/thumbnail'](attributes)
    ul.append li
    console.log model

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

  cancelLike: (e)->
    console.log 'cancel'
    target = $($(e.currentTarget).parents()[1]).attr 'id'
    console.log @.collection.where({"user.id": target})
    model = _.find @.collection.models, (model)->
      return model.get('user').id is target
    model.urlRoot = "/api/users/me/candidates/#{model.get('user').id}.json"
    model.set("status", 0)
    model.save()
  doLike: (e)->
    target = $($(e.currentTarget).parents()[1]).attr 'id'
    model = _.find @.collection.models, (model)->
      return model.get('user').id is target
    model.urlRoot = "/api/users/me/candidates/#{model.get('user').id}.json"
    model.set("status", 3)
    model.save()
  sendMessage: (e)->
    console.log 'send message'
    target = $($(e.currentTarget).parents()[1]).attr 'id'
    model = _.find @.collection.models, (model)->
      return model.get('user').id is target
    console.log model