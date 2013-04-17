App = window.App
JST = App.JST

class App.View.MessagePage extends Backbone.View
  el: "div#main"
  # あとでやる。MessagesListコレクションを作って、そこに格納。
  constructor: ->
    super

    _.bindAll @, "appendAllItem", "appendItem"

    @collection = new App.Collection.Messages
      userid: "me"
    @collection.bind 'add', @.appendItem
    @collection.bind 'reset', @.appendAllItem

    @collection.fetch()

  appendItem: (model)->
    console.log model

  appendAllItem: (collection)->
    console.log collection.models.length
    group = _.groupBy(collection.models, "id")
    _.each group, @.appendItem

class App.View.Messages extends Backbone.View
  el: "div#message-list-view"

  events:
    "click button.send_message": "postMessage"

  constructor: ->
    @.collection = new App.Collection.Messages()
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
      source: "/user/#{model.get('from')}/picture"
      name: model.get('name')
      text: model.get('text')
      created_at: "#{d.getMonth()+1}月#{d.getDay()}日 #{hours}:#{minutes}"
    li = window.JST['message/body'](attributes)
    ul.append li
    $(@.el).find('div.message-header h5').html("#{model.get('name')}さんとのやりとり")
    # ここで、ul.message-listにliをぶち込む。

  appendAllItem: (collection)->
    console.log 'messages set'
    $(@.el).find('div.message-body ul').empty()
    _.each collection.models, (model)=>
      @.appendItem model

  setModel: (one, two)->
    @.targetId = two
    @.collection.url = "/user/#{one}/#{two}/messages"
    @.collection.fetch()

  postMessage: (e)->
    text = $('textarea.message').val()
    $.ajax
      type: "POST"
      url: "/user/#{App.User.get('id')}/#{@.targetId}/message"
      data:
        text: text
      success: (data)=>
        $('textarea.message').val("")
        @.collection.add data
    console.log text