App = window.App
JST = App.JST

class App.View.SupporterPage extends Backbone.View
  el: "div#main"

  events:
    "click button.delete": "removeFollow"
    "click button.request": "approve"

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
    console.log collection
    if collection.models.length > 0
      _.each collection.models, (model)=>
        console.log model
        f = model.get('following')
        attributes =
          id: f.id
          source: "/api/users/#{f.id}/picture"
          name: f.name
          approval: model.get('approval')
          optionClass: "following"
        if model.get('approval') is false
          ul = $(@.el).find('div#request ul')
          li = JST['supporter/request-li'](attributes)
        else
          ul = $(@.el).find('div#following ul')
          li = JST['supporter/li'](attributes)
        ul.append li


  appendFollowers: (collection)->
    console.log collection
    if collection.models.length > 0
      _.each collection.models, (model)=>
        console.log model
        f = model.get('follower')
        attributes =
          id: f.id
          source: "/api/users/#{f.id}/picture"
          name: f.name
          optionClass: "follower"
        if model.get('approval')
          li = JST['supporter/li'](attributes)
          $(@.el).find('div#follower ul').append li

  removeFollow: (e)->
    target = $(e.currentTarget)
    if !target.hasClass 'deleteFlag'
      target.addClass 'deleteFlag'
      target.html "本当に削除しますか?"
      return false
    if target.hasClass 'following'
      console.log 'delete following'
      @removeFollowing(e)
    else if target.hasClass 'follower'
      console.log 'delete follower'
      @removeFollower(e)

  removeFollowing: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    $.ajax
      type: "DELETE"
      url: "/api/users/me/following/#{id}"
      success:(data)=>
        $($(e.currentTarget).parent().parent()).remove()
        console.log data

  removeFollower: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    $.ajax
      type: "DELETE"
      url: "/api/users/me/followers/#{id}"
      success:(data)=>
        $($(e.currentTarget).parent().parent()).remove()
        console.log data

  approve: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    console.log id
    $.ajax
      type: "PUT"
      url: "/api/users/me/followings/#{id}"
      success:(data)->
        console.log data
        FB.api requestId, "delete", (res)->
          console.log res
