App = window.App
JST = App.JST

class App.View.SupporterPage extends Backbone.View
  el: "div#main"

  events:
    "click button.following": "removeFollowing"

  constructor: ->
    super
    $(@.el).empty()

    _.bindAll @, "appendFollowings", "appendFollowers", "appendPending", "appendRequest"

    @followings = new App.Collection.Followings
      userid: "me"
    @pending    = new App.Collection.Pending
      userid: "me"
    @followings.bind 'reset', @.appendFollowings
    @pending.bind 'reset', @.appendPending
    if App.User.get('isSupporter') is false
      @followers  = new App.Collection.Followers
        userid: "me"
      @request    = new App.Collection.Request
        userid: "me"
      @followers.bind 'reset', @.appendFollowers
      @request.bind 'reset', @.appendReuqest

  render: ->
    console.log App.User.get('isSupporter')
    if App.User.get('isSupporter') is false
      html = JST['supporter/page']()
    else
      html = JST['supporter/supporter-page']()
    $(@.el).html html

    @followings.fetch()
    @pending.fetch()
    if App.User.get('isSupporter') is false
      @followers.fetch()
      @request.fetch()

  appendFollowings: (collection)->
    if collection.models.length > 0
      _.each collection.models, (model)=>
        console.log model
        attributes =
          id: model.get('id')
          source: "/api/users/#{model.get('id')}/picture"
          name: model.get('name')
          approval: model.get('approval')
        li = JST['supporter/li'](attributes)
        $(@.el).find('div#following ul').append li


  appendFollowers: (collection)->
    console.log collection
    if collection.models.length > 0
      _.each collection.models, (model)=>
        attributes =
          id: model.get('id')
          source: model.get('profile').image_url
          name: model.get('name')
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
      url: "/api/users/me/following/#{id}"
      success:(data)=>
        $($(e.currentTarget).parent().parent()).remove()
        console.log data