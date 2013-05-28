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
    $(@.el).find('ul.talk_list').prepend talk.el


  appendAllItem: (collection)->
    if collection.models.length > 0
      _.each collection.models, @.appendItem
    else
      $(@.el).find('ul.talk_list').append "<p>まだ応援トークはできていません。</p><p>気になる人がいたら、積極的にトークしてみましょう。</p>"

class App.View.TalkUnit extends Backbone.View
  tagName: "li"
  className: "talk clearfix"

  events:
    # "click button.send_comment": "postComment"
    "keypress input.comment_area": "postComment"

  constructor: ->
    super

    @.talkId = @.model.get('_id')

  render: ->
    c = @model.get('candidate')
    u = @model.get('user')
    date = new Date(@model.get('updatedAt'))
    c_age = moment().diff(moment(c.profile.birthday), "year")
    attributes =
      another_source: u.profile.image_url
      source: App.User.get('profile').image_url
      name: u.first_name
      candidate_name: c.first_name
      last_update: "#{date.getMonth()+1}月#{date.getDate()}日"
      candidate_source: c.profile.image_url
      candidate_age: c_age
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
    if e.keyCode is 13
      text = $(@.el).find('input.comment_area').val()
      $.ajax
        type: "POST"
        url: "/api/talks/#{@.talkId}/comment"
        data:
          user_id: "me"
          text: text
          talk_id: @.talkId
        success:(model)=>
          @.comments.collection.add model
          $(@.el).find('input.comment_area').val("")
          $.ajax
            type: "POST"
            url: "/api/users/me/notification/talk"
            success: (data)->
              console.log data

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
    $(@.el).prepend html

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

  addComment: (model)->
    console.log model
    @.collection.add model

