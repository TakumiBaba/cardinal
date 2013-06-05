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
    "click a.like_count": "count"

  constructor: ->
    super

  render: ->
    c = @model.get('candidate')
    u = @model.get('user')
    date = new Date(@model.get('updatedAt'))
    c_age = moment().diff(moment(c.profile.birthday), "year")
    liked = false
    console.log @model.get('count')
    _.each @model.get('count'), (count)=>
      if count.id is App.User.get('id')
        liked = true
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
      like_count: if (@model.get("count") isnt null) then "#{@model.get('count').length}人がいいね！を押しています。" else ""
      like_or_dislike: if liked is true then "いいね！を取り消す" else "いいね！"
    html = JST['talk/unit'](attributes)
    $(@.el).append html

    @.comments = new App.View.Comments
      id: @model.get "_id"
    $(@.el).find('div.comments_box').html @.comments.el



  postComment: (e)->
    if e.keyCode is 13
      input = $(@.el).find('input.comment_area')
      console.log App.User.get('_id')
      console.log @model.get "_id"
      comment = new App.Model.Comment
        talk_id: @model.get "_id"
      comment.set
        user: App.User.get('id')
        text: input.val()
        count: 0
        created_at: Date.now()
      comment.save()
      # あとで、イベント後発行に
      @comments.collection.add comment
      input.val("")

  count: (e)->
    console.log 'count'
    console.log @model
    liked = false
    _.each @model.get('count'), (count)=>
      console.log count.id, App.User.get('id')
      if count.id is App.User.get('id')
        liked = true
    console.log liked
    if liked is true
      $.ajax
        type: "POST"
        url: "/api/talks/#{@model.get('_id')}/like/#{App.User.get('id')}/decrement"
        success: (data)->
          console.log data
    else
      $.ajax
        type: "POST"
        url: "/api/talks/#{@model.get('_id')}/like/#{App.User.get('id')}/increment"
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
      source: "/api/users/#{model.get('user')}/picture"
      message: model.get('text')
      created_at: created_at
    html = JST['talk/comment'](attributes)
    $(@.el).prepend html

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

  addComment: (model)->
    console.log model
    @.collection.add model

