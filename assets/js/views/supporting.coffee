App = window.App
JST = App.JST
App.View.Supporting = {}

class App.View.Supporting.Page extends Backbone.View
  el: "div#main"

  events:
    "click a[href='#supportertalk']": "talk"

  constructor: (attrs)->
    super
    @id = attrs.id

  render: ->
    requirejs ["text!/views/supporting/#{@id}"], (view)=>
      $(@.el).empty
      $(@.el).html view

      @profile = new App.View.Supporting.Profile
        id: @id
      @profile.supporterMessages.fetch()

      @matching = new App.View.Supporting.MatchingList
        id: @id
      @matching.collection.fetch()

      @like = new App.View.Supporting.LikeList
        id: @id
      @like.collection.fetch()

      @talk = new App.View.Supporting.TalkList
        id: @id
      @talk.collection.fetch()

  talk: (e)->
    console.log 'talk'
    @talk.collection.fetch()

class App.View.Supporting.Profile extends Backbone.View
  el: "div#detail_profile"

  events:
    "click button.btn": "createSupporterMessage"

  constructor: (attrs)->
    super
    @id = attrs.id
    @supporterMessages = new App.Collection.SupporterMessages
      id: attrs.id
    _.bindAll @, "append", "allAppend"
    @supporterMessages.bind "add", @append
    @supporterMessages.bind "reset", @allAppend

  append: (model)->
    console.log model
    li = new App.View.Supporting.SupporterMessage
      parent: @
      model: model
    li.render()

  allAppend: (collection)->
    _.each collection.models, @append

  createSupporterMessage: (e)->
    input = $("textarea")
    message = input.val()
    model = new App.Model.SupporterMessage
      userid: @id
    detail =
      supporter: App.User.get('_id')
      supporterId: App.User.get('id')
      message: message
    model.save detail,
      success: (model)=>
        model.urlRoot = "/api/supportermessages/"
        model.set 'id', model.get('_id')
        model.bind 'change', (m)=>
          li = new App.View.Supporting.SupporterMessage
            parent: @
            model: model
          li.render()
        model.fetch()
        $("textarea").val("")

class App.View.Supporting.SupporterMessage extends Backbone.View
  tagName: "li"
  events:
    "click a.delete-supporter-message": "delete"

  constructor: (attrs)->
    super
    @parent = attrs.parent
    @model  = attrs.model
    _.bindAll @, "destroy", "modify"
    @model.bind 'destroy', @destroy


  render: ->
    attributes =
      source: @model.get('supporter').profile.image_url
      name: @model.get('supporter').first_name
      message: @model.get('message')
      isMyMessage: if @model.get('supporter').id is App.User.get('id') then true else false
    $(@.el).html JST['supporting/supportermessage/li'](attributes)
    $(@parent.el).find("div.supporter-message-list ul").append @.el
    if @model.get('supporter').id is App.User.get('id')
      option =
        trigger: $("a.modify-supporter-message")
        action: "click"
      $(@.el).find('div.s-message-body small').editable option, @modify
      $("div.supporter-message-post-view").hide()


  delete: (e)->
    e.preventDefault()
    @model.urlRoot = "/api/supportermessages/"
    @model.set
      isNew: false
      id: @model.get("_id")
    @model.destroy()

  destroy: (model)->
    $(@.el).remove()

  modify: (e)->
    @model.urlRoot = "/api/users/#{@parent.id}/supportermessages/#{@model.get('supporter').id}"
    detail =
      supporter: App.User.get('_id')
      supporterId: App.User.get('id')
      message: e.value
    @model.save detail,
      success: (model)=>
        console.log model

class App.View.Supporting.MatchingList extends Backbone.View
  el: "div#matchinglist"

  constructor: (attrs)->
    super
    @id = attrs.id
    @collection = new App.Collection.PreCandidates
      userid: @id
      status: "0"
    _.bindAll @, "append", "allAppend"
    @collection.bind 'reset', @allAppend
    @collection.bind 'add', @append

  append: (model)->
    thumbnail = new App.View.Supporting.MatchingThumbnail
      parent: @
      model: model
    thumbnail.render()

  allAppend: (collection)->
    $("div.system ul.userpage-like-thumbnail").empty()
    $("div.supporter ul.userpage-like-thumbnail").empty()
    _.each collection.models, @append

class App.View.Supporting.MatchingThumbnail extends Backbone.View
  tagName: "li"

  events:
    "click a.like": "supporterLike"
    "click a.to-talk": "talk"

  constructor: (attrs)->
    super
    @parent = attrs.parent
    @model = attrs.model

  render: ->
    attributes =
      id: @model.get('user').id
      source: @model.get('user').profile.image_url
      name: @model.get('user').first_name
    if @model.get('isSystemMatching')
      ul = $("div.system ul.userpage-like-thumbnail")
      $(@.el).html JST['supporting/matching/system'](attributes)
    else
      ul = $("div.supporter ul.userpage-like-thumbnail")
      $(@.el).html JST['supporting/matching/supporter'](attributes)
    ul.append @.el

  supporterLike: (e)->
    e.preventDefault()
    console.log @model
    @model.urlRoot = "/api/users/#{@model.get("user").id}/candidates"
    # @model.set "isSystemMatching", false
    @model.save {isSystemMatching: false},
      success:(data)=>
        console.log data
        $(@.el).remove()
        @parent.append data


  talk: (e)->
    e.preventDefault()
    console.log 'talk'
    talk = new Backbone.Model()
    talk.urlRoot = "/api/talks.json"
    detail =
      one: @parent.id
      two: @model.get("user").id
    talk.save detail,
      success: (model)=>
        console.log model



class App.View.Supporting.LikeList extends Backbone.View
  el: "div#likelist"

  constructor: (attrs)->
    super
    @id = attrs.id
    @collection = new App.Collection.PreCandidates
      userid: @id
      status: "1,2,3"
    _.bindAll @, "append", "allAppend"
    @collection.bind "reset", @allAppend
    @collection.bind "add", @append

  append: (model)->
    thumbnail = new App.View.Supporting.LikeThumbnail
      parent: @
      model: model
    thumbnail.render()
  allAppend: (collection)->
    $("div.each-like ul").empty()
    $("div.your-like ul").empty()
    $("div.my-like ul").empty()
    _.each collection.models, @append

class App.View.Supporting.LikeThumbnail extends Backbone.View
  tagName: "li"

  events:
    "click a.to-talk": "talk"

  constructor: (attrs)->
    super
    @parent = attrs.parent
    @model = attrs.model

  render: ->
    attributes =
      id: @model.get('id')
      source: @model.get('user').profile.image_url
      name: @model.get('user').first_name
    $(@.el).html JST['supporting/like/thumbnail'](attributes)
    mstatus = @model.get('myStatus')
    ystatus = @model.get('status')
    if (mstatus is true) and (ystatus is true)
      $("div.each-like ul").append @.el
    else if (mstatus is false) and (ystatus is true)
      $("div.your-like ul").append @.el
    else if (mstatus is true) and (ystatus is false)
      $("div.my-like ul").append @.el
    else
      return

  talk: (e)->
    talk = new Backbone.Model()
    talk.urlRoot = "/api/talks.json"
    talk.set
      one: @parent.id
      two: @model.get("user").id
    talk.save()
    e.preventDefault()

class App.View.Supporting.TalkList extends Backbone.View
  el: "div#supportertalk"

  constructor: (attrs)->
    super
    @id = attrs.id
    @collection = new App.Collection.Talks
      userid: @id
    _.bindAll @, "append", "allAppend"
    @collection.bind "add", @append
    @collection.bind "reset", @allAppend

  append: (model)->
    talk = new App.View.TalkUnit
      model: model
    talk.render()
    $(@.el).find("ul.talk_list").prepend talk.el
  allAppend: (collection)->
    $("ul.talk_list").empty()
    _.each collection.models, @append