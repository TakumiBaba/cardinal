App = window.App
JST = App.JST

class App.View.TalkPage extends Backbone.View
  el: "div#main"
  constructor: ->
    super

    _.bindAll @, "appendItem", "appendAllItem"

    @collection = new App.Collection.Talks
      userid: 'me'

    @collection.bind 'add', @.appendItem
    @collection.bind 'reset', @.appendAllItem

  render: ->
    $(@.el).empty()
    html = JST['talk/page']()
    $(@.el).html html

    @collection.fetch()

  appendItem: (model)->
    talk = new App.View.TalkUnit
      model: model
    talk.render()
    $(@.el).find('ul.talk_list').append talk.el


  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

class App.View.TalkUnit extends Backbone.View
  tagName: "li"
  className: "talk clearfix"

  events:
    "click button.send_comment": "postComment"

  constructor: ->
    super

    @.talkId = @.model.get('_id')

  render: ->
    c = @model.get('candidate')
    u = @model.get('user')
    attributes =
      another_source: u.profile.image_url
      source: App.User.get('profile').image_url
      name: u.name
      candidate_name: c.name
      last_update: @model.get('updatedAt')
      candidate_source: c.profile.image_url
      candidate_age: c.profile.age
      address: c.profile.address
      blood: c.profile.bloodType
      candidate_id: c.id
      height: c.profile.height
      profile_message: c.profile.message
      like_count: 0
    html = JST['talk/unit'](attributes)
    $(@.el).append html

    @.comments = new App.View.Comments
      id: @.talkId
    $(@.el).find('div.comments_box').html @.comments.el

  postComment: (e)->
    text = $(@.el).find('textarea.comment_area').val()
    $.ajax
      type: "POST"
      url: "/api/talks/#{@.talkId}/comment"
      data:
        user_id: "me"
        text: text
        talk_id: @.talkId
      success:(model)=>
        console.log model
        @.comments.collection.add model
        $(@.el).find('textarea.comment_area').val("")

    # @.comments.collection.add model
    # model.sync()

class App.View.Comments extends Backbone.View
  tagName: "ul"
  className: "comments"

  constructor: (attrs, options)->
    super
    @.collection = new App.Collection.Comments
      talkid: attrs.id

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'reset', @.appendAllItem
    @.collection.bind 'add', @.appendItem

    @.collection.fetch()

  appendItem: (model)->
    console.log model
    d = new Date(model.get('created_at'))
    hours = if d.getHours() < 10 then "0#{d.getHours()}" else d.getHours()
    minutes = if d.getMinutes() < 10 then "0#{d.getMinutes()}" else d.getHours()
    created_at = "#{d.getMonth()+1}月#{d.getDate()}日 #{hours}:#{minutes}"
    attributes =
      source: "/api/users/#{model.get('user').id}/picture"
      message: model.get('text')
      created_at: created_at
    html = JST['talk/comment'](attributes)
    $(@.el).append html

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

  addComment: (model)->
    console.log model
    @.collection.add model

