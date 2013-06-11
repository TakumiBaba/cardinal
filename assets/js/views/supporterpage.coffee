App = window.App
JST = App.JST

class App.View.SupporterPage extends Backbone.View
  el: "div#main"

  # events:
    # "click button.delete": "removeFollow"
    # "click button.request": "approve"

  constructor: ->
    super
    $(@.el).empty()

    _.bindAll @, "appendFollowings", "appendFollowers"

    @followings = new App.Collection.Followings
      userid: "me"
    @followings.bind 'reset', @.appendFollowings
    if App.User.get('isSupporter') is false
      @followers  = new App.Collection.Followers
        userid: "me"
      @followers.bind 'reset', @.appendFollowers

  render: ->
    if App.User.get('isSupporter') is false
      html = JST['supporter/page']()
    else
      html = JST['supporter/supporter-page']()
    $(@.el).html html

    @followings.fetch()
    if App.User.get('isSupporter') is false
      @followers.fetch()

  appendFollowings: (collection)->
    if collection.models.length > 0
      _.each collection.models, (model)=>
        if model.get('approval') is true
          type = "following"
        else
          type = "request"
        thumbnail = new App.View.SupporterPageLi
          parent: @
          model: model
          type: type
        thumbnail.render()

  appendFollowers: (collection)->
    if collection.models.length > 0
      _.each collection.models, (model)=>
        if model.get('approval') is true
            thumbnail = new App.View.SupporterPageLi
              parent: @
              model: model
              type: "follower"
            thumbnail.render()

  # removeFollow: (e)->
  #   target = $(e.currentTarget)
  #   if !target.hasClass 'deleteFlag'
  #     target.addClass 'deleteFlag'
  #     target.html "本当に削除しますか?"
  #     return false
  #   console.log e.currentTarget
  #   if target.hasClass 'following'
  #     console.log 'delete following'
  #     @removeFollowing(e)
  #   else if target.hasClass 'delete-request'
  #     console.log 'delete not approvaled following'
  #     @removeFollowing(e)
  #   else if target.hasClass 'follower'
  #     console.log 'delete follower'
  #     @removeFollower(e)
  #   $(target).parent().parent().remove()

  # removeFollowing: (e)->
  #   id = $(e.currentTarget).parent().parent().attr 'id'
  #   $.ajax
  #     type: "DELETE"
  #     url: "/api/users/me/following/#{id}"
  #     success:(data)=>
  #       $($(e.currentTarget).parent().parent()).remove()
  #       console.log data
  #       $.ajax
  #         type: "delete"
  #         url: "/debug/sdk/request"
  #         data:
  #           reqId: data.request_id
  #           userId: data.from.facebook_id
  #         success: (d)->
  #           console.log d

  # removeFollower: (e)->
  #   id = $(e.currentTarget).parent().parent().attr 'id'
  #   $.ajax
  #     type: "DELETE"
  #     url: "/api/users/me/followers/#{id}"
  #     success:(data)=>
  #       $($(e.currentTarget).parent().parent()).remove()
  #       console.log data

  # approve: (e)->
  #   id = $(e.currentTarget).parent().parent().attr 'id'
  #   console.log id
  #   console.log
  #   $.ajax
  #     type: "PUT"
  #     url: "/api/users/me/followings/#{id}"
  #     success:(data)->
  #       console.log data
  #       $($(e.currentTarget).parent().parent()).remove()
  #       attributes =
  #         id: data.to.id
  #         source: "/api/users/#{id}/picture"
  #         name: data.to.first_name
  #         optionClass: "following"
  #       li = JST['supporter/li'](attributes)
  #       $("div#following ul").append li
  #       $.ajax
  #         type: "delete"
  #         url: "/debug/sdk/request"
  #         data:
  #           reqId: data.request_id
  #           userId: data.from.facebook_id
  #         success: (d)->
  #           console.log d

class App.View.SupporterPageLi extends Backbone.View
  tagName: "li"

  events:
    "click a.to-user": "toUser"
    "click a.delete": "remove"
    "click a.request": "approve"

  constructor: (attrs)->
    super
    @parent = attrs.parent
    @model = attrs.model
    @type = attrs.type

    _.bindAll @, "destroy"
    @model.bind 'destroy', @destroy

  render: ->
    f =  if @model.get('following') then @model.get('following') else @model.get('follower')
    attributes =
      source: "/api/users/#{f.id}/picture"
      name: f.first_name
    if @type is "following"
      @followingAppend attributes
    else if @type is "follower"
      @followerAppend attributes
    else if @type is "request"
      @requestAppend attributes


  followingAppend: (attributes)->
    $(@.el).html JST['supporter/following/thumbnail'](attributes)
    $(@parent.el).find("div#following ul").append @.el
  followerAppend: (attributes)->
    $(@.el).html JST['supporter/follower/thumbnail'](attributes)
    $(@parent.el).find("div#follower ul").append @.el
  requestAppend: (attributes)->
    $(@.el).html JST['supporter/request/thumbnail'](attributes)
    $(@parent.el).find("div#request ul").append @.el

  approve: (e)->
    console.log "approve"
    e.preventDefault()
    @model.urlRoot = "/api/follow/"
    @model.set 'id', @model.get '_id'
    params =
      approval: true
    _this = @
    @model.save params,
      success: (data)=>
        $(@.el).remove()
        thumbnail = new App.View.SupporterPageLi
          parent: _this.parent
          model: data
          type: "following"
        thumbnail.render()


  remove: (e)->
    e.preventDefault()
    target = $(e.currentTarget)
    if !target.hasClass 'deleteFlag'
      target.addClass 'deleteFlag'
      target.html "本当に削除しますか?"
      return false
    @model.urlRoot = "/api/follow/"
    @model.set 'id', @model.get '_id'
    @model.destroy()

  destroy: (model)=>
    $(@.el).remove()

  toUser: (e)->
    e.preventDefault()
    if @type is "following"
      location.href = "/#/s/#{@model.get('following').id}"
    else if @type is "request"
      location.href = "/#/u/#{@model.get('following').id}"


