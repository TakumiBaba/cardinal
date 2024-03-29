App = window.App
JST = App.JST

class App.View.MessagePage extends Backbone.View
  el: "div#main"

  events:
    "click li.m_thumbnail_li": "changeModel"
    # "click button.send_message": "postMessage"
    "keypress input.comment_area": "postMessage"

  constructor: ->
    super
    $(@.el).empty()
    _.bindAll @, "appendAllItem", "appendItem"

    @collection = new App.Collection.Messages
      userid: "me"
    @collection.bind 'add', @.appendItem
    @collection.bind 'reset', @.appendAllItem

    @collection.fetch()

    @detaiView = new App.View.Messages()

  appendItem: (model)->
    ul = $("ul.message-user-thumbnail")
    one = model.get('one')
    two = model.get('two')
    other = if one.id is App.User.get('id') then two else one
    attributes =
      id: other.id
      source: other.profile.image_url
    li = JST['message/user-thumbnail'](attributes)
    ul.prepend li

  appendAllItem: (collection)->
    attributes =
      source: App.User.get('profile').image_url
    html = JST['message/page'](attributes)
    if collection.models.length > 0
      $(@.el).html html
      _.each collection.models, @.appendItem
      $(@.el).find('ul.message-user-thumbnail li:first').click()
    else
      html = """
      <h4>お相手からのメッセージ<small>'このページは応援団は閲覧できません'</small></h4>
      <p>まだお相手からのメッセージがありません。</p>
      <p>気になる人がいたら、あなたからも積極的にメッセージを送ってみましょう。</p>
      """
      $(@.el).html html

  changeModel: (e)->
    id = $(e.currentTarget).attr 'id'
    $("ul.message-user-thumbnail li").each ()->
      if $(@).hasClass 'active'
        $(@).removeClass 'active'
    $(e.currentTarget).addClass 'active'
    _.each @collection.models, (model)=>
      if model.get('one').id is id or model.get('two').id is id
        @detaiView.setModel model

  postMessage: (e)->
    if e.keyCode is 13
      @detaiView.postMessage e

class App.View.Messages extends Backbone.View
  el: "div#message-list-view"

  events:
    "click button.send_message": "postMessage"

  constructor: ->
    @.collection = new App.Collection.Messages
      userid: "me"
    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

  appendItem: (model)->
    console.log model
    d = new Date(model.get('created_at'))
    ul = $(@.el).find('div.message-body ul')
    hours = if d.getHours() < 10 then "0#{d.getHours()}" else d.getHours()
    minutes = if d.getMinutes() < 10 then "0#{d.getMinutes()}" else d.getMinutes()
    attributes =
      source: "/api/users/#{model.get('from_id')}/picture"
      name: model.get('from_name')
      text: model.get('text')
      created_at: "#{d.getMonth()+1}月#{d.getDate()}日 #{hours}:#{minutes}"
    li = JST['message/body'](attributes)
    $(@.el).find('div.message-header h5').html("#{@target.first_name}さんとのやりとり")
    ul.prepend li
    # ここで、ul.message-listにliをぶち込む。

  appendAllItem: (collection)->
    console.log 'messages set'
    $(@.el).find('div.message-body ul').empty()
    if collection.models.length > 0
      _.each collection.models, (model)=>
        @.appendItem model
    else
      console.log 'hoge-'

  setModel: (model)->
    one = model.get('one')
    two = model.get('two')
    @target =  if one.id is App.User.get('id') then two else one
    console.log @target
    $(@.el).find('div.message-body ul').empty()
    $(@.el).find('div.message-header h5').html("#{@target.first_name}さんとのやりとり")
    _.each model.get('messages'), (message)=>
      @collection.add message

  postMessage: (e)->
    text = $('input.comment_area').val()
    $.ajax
      type: "POST"
      url: "/api/users/me/#{@target.id}/message"
      data:
        text: text
      success: (data)=>
        $('input.comment_area').val("")
        @.collection.add data
        $.ajax
          type: "POST"
          url: "/api/users/me/notification/#{@target.id}/message"
          success: (data)->
            console.log data