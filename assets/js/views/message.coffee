App = window.App
JST = App.JST
App.View.Message = {}

class App.View.MessagePage extends Backbone.View
  el: "div#main"

  events:
    "click li.m_thumbnail_li": "changeModel"
    "keypress input.comment_area": "postMessage"

  constructor: ->
    super
    $(@.el).empty()
    _.bindAll @, "appendAllItem", "appendItem"

    @collection = new App.Collection.MessageList
      userid: "me"

  render: ->
    requirejs ["text!/views/message"], (view)=>
      $(@.el).html view
      @messageView = new App.View.MessageView()
      @userlist = new App.View.Message.UserList
        collection: @collection
        messageView: @messageView
      @collection.fetch()

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
      @messageView.postMessage e

class App.View.Message.UserList extends Backbone.View
  el: "ul.message-user-thumbnail"

  constructor: (attrs)->
    super
    @messageView = attrs.messageView
    _.bindAll @, "setCollection"
    @collection.bind 'reset', @setCollection

  changeModel: (clickedLi)->
    console.log clickedLi.model
    # $(@.el).find('div.message-header h5').html("#{model.get('from').first_name}さんとのやりとり")
    @setMessages clickedLi.model
    _.each $(@.el).children(), (child)->
      if $(child).hasClass 'active'
        $(child).removeClass 'active'
    $(clickedLi.el).addClass 'active'

  setCollection: (collection)->
    console.log collection
    @model = collection.models[0]
    if collection.models.length > 0
      for i in [0..collection.models.length-1]
        li = new App.View.Message.UserThumbnail
          parent: @
          model: collection.models[i]
        li.render()
        if i is collection.models.length - 1
          @changeModel li
      $(li.el).addClass 'active' if i is @target
      # @setProfile @model
  setMessages: (model)->
    console.log @messageView
    @messageView.setList model.get('_id')


class App.View.Message.UserThumbnail extends Backbone.View
  tagName: "li"
  className: "m_thumbnail_li"

  events:
    "click img": "changeModel"

  constructor: (attrs)->
    super
    @parent = attrs.parent
    @model = attrs.model
  render: ->
    console.log @parent
    other = if @model.get('one').id is App.User.get('id') then @model.get('two') else @model.get('one')
    $(@.el).html "<img src='#{other.profile.image_url}' class='img-rounded m_thumbnail' />"
    $(@parent.el).prepend @.el
  changeModel: (e)->
    @parent.changeModel @

  setProfile: (messages)->
    console.log messages

class App.View.MessageView extends Backbone.View
  el: "div#message-list-view"

  constructor: ->
    super
    @messages = new App.Collection.Messages()
    _.bindAll @, "appendAllMessages", "appendMessage"
    @messages.bind 'reset', @appendAllMessages
    @messages.bind 'add', @appendMessage

  setList: (id)->
    @messages.id = id
    @messages.url = "/api/messagelist/#{id}/messages"
    @messages.fetch()

  appendAllMessages: (collection)->
    @ul = $(@.el).find('div.message-body ul')
    moment().local()
    @ul.empty()
    _.each collection.models, @appendMessage

  appendMessage: (model)->
    attributes =
      source: "/api/users/#{model.get('from').id}/picture"
      name: model.get('from').first_name
      text: model.get('text')
      created_at: moment(model.get("created_at")).format("LLL")
    @ul.prepend JST['message/body'](attributes)


  postMessage: (e)->
    text = $('input.comment_area').val()
    message = new App.Model.Message()
    message.set
      text: text
      from: App.User.get('_id')
      parent: @messages.id
    message.urlRoot = "/api/messagelist/#{@messages.id}/message"
    message.save()
    console.log message

    # $.ajax
    #   type: "POST"
    #   url: "/api/users/me/#{@target.id}/message"
    #   data:
    #     text: text
    #   success: (data)=>
    #     $('input.comment_area').val("")
    #     @.collection.add data
    #     $.ajax
    #       type: "POST"
    #       url: "/api/users/me/notification/#{@target.id}/message"
    #       success: (data)->
    #         console.log data

#     d = new Date(model.get('created_at'))
#     ul = $(@.el).find('div.message-body ul')
#     hours = if d.getHours() < 10 then "0#{d.getHours()}" else d.getHours()
#     minutes = if d.getMinutes() < 10 then "0#{d.getMinutes()}" else d.getMinutes()
#     attributes =
#       source: "/api/users/#{model.get('from_id')}/picture"
#       name: model.get('from_name')
#       text: model.get('text')
#       created_at: "#{d.getMonth()+1}月#{d.getDate()}日 #{hours}:#{minutes}"
#     li = JST['message/body'](attributes)
#     $(@.el).find('div.message-header h5').html("#{@target.first_name}さんとのやりとり")
#     ul.prepend li
#     # ここで、ul.message-listにliをぶち込む。

# class App.View.Messages extends Backbone.View
#   el: "div#message-list-view"

#   events:
#     "click button.send_message": "postMessage"

#   constructor: ->
#     @.collection = new App.Collection.Messages
#       userid: "me"
#     _.bindAll @, "appendItem", "appendAllItem"
#     @.collection.bind 'add', @.appendItem
#     @.collection.bind 'reset', @.appendAllItem

#   appendItem: (model)->
#     d = new Date(model.get('created_at'))
#     ul = $(@.el).find('div.message-body ul')
#     hours = if d.getHours() < 10 then "0#{d.getHours()}" else d.getHours()
#     minutes = if d.getMinutes() < 10 then "0#{d.getMinutes()}" else d.getMinutes()
#     attributes =
#       source: "/api/users/#{model.get('from_id')}/picture"
#       name: model.get('from_name')
#       text: model.get('text')
#       created_at: "#{d.getMonth()+1}月#{d.getDate()}日 #{hours}:#{minutes}"
#     li = JST['message/body'](attributes)
#     $(@.el).find('div.message-header h5').html("#{@target.first_name}さんとのやりとり")
#     ul.prepend li
#     # ここで、ul.message-listにliをぶち込む。

#   appendAllItem: (collection)->
#     console.log 'messages set'
#     $(@.el).find('div.message-body ul').empty()
#     if collection.models.length > 0
#       _.each collection.models, (model)=>
#         @.appendItem model
#     else
#       console.log 'hoge-'

#   setModel: (model)->
#     one = model.get('one')
#     two = model.get('two')
#     @target =  if one.id is App.User.get('id') then two else one
#     console.log @target
#     $(@.el).find('div.message-body ul').empty()
#     $(@.el).find('div.message-header h5').html("#{@target.first_name}さんとのやりとり")
#     _.each model.get('messages'), (message)=>
#       @collection.add message

#   postMessage: (e)->
#     text = $('input.comment_area').val()
#     $.ajax
#       type: "POST"
#       url: "/api/users/me/#{@target.id}/message"
#       data:
#         text: text
#       success: (data)=>
#         $('input.comment_area').val("")
#         @.collection.add data
#         $.ajax
#           type: "POST"
#           url: "/api/users/me/notification/#{@target.id}/message"
#           success: (data)->
#             console.log data