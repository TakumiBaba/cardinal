App = window.App
JST = App.JST

class App.View.SupporterPage extends Backbone.View
  el: "div#main"

  events:
    "click button.following": "removeFollowing"
    "click button.request": "approve"

  constructor: ->
    super
    $(@.el).empty()

    _.bindAll @, "appendFollowings", "appendFollowers", "appendPending", "appendRequest"

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
        console.log model
        f = model.get('following')
        attributes =
          id: f.id
          source: "/api/users/#{f.id}/picture"
          name: f.name
          approval: model.get('approval')
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
        if model.get('approval')
          li = JST['supporter/li'](attributes)
          $(@.el).find('div#follower ul').append li

  appendPending: (collection)->
    console.log collection
    if collection.models.length > 0
      _.each collection.models, (model)=>
        attributes =
          id: model.get('id')
          source: model.get('profile').image_url
          name: model.get('name')
        li = JST['supporter/li'](attributes)
        $(@.el).find('div#pending ul').append li

  appendRequest: (collection)->
    console.log collection
    if collection.models.length > 0
      _.each collection.models, (model)=>
        attributes =
          id: model.get('id')
          source: model.get('profile').image_url
          name: model.get('name')
        li = JST['supporter/li'](attributes)
        $(@.el).find('div#request ul').append li

  removeFollowing: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    $.ajax
      type: "DELETE"
      url: App.BaseUrl+"/api/users/me/following/#{id}"
      success:(data)=>
        $($(e.currentTarget).parent().parent()).remove()
        console.log data

  approve: (e)->
    id = $(e.currentTarget).parent().parent().attr 'id'
    console.log id
    $.ajax
      type: "PUT"
      url: App.BaseUrl+"/api/users/me/follow/#{id}"
      success:(data)->
        console.log data
