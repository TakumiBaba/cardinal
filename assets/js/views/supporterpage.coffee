App = window.App
JST = App.JST

class App.View.SupporterPage extends Backbone.View
  el: "div#main"

  constructor: ->
    super
    $(@.el).empty()

    @followings = new App.Collection.Followings
      userid: "me"
    @followers  = new App.Collection.Followers
      userid: "me"
    @pending    = new App.Collection.Pending
      userid: "me"
    @request    = new App.Collection.Request
      userid: "me"

    _.bindAll @, "appendFollowings", "appendFollowers", "appendPending", "appendRequest"
    @followings.bind 'reset', @.appendFollowings
    @followers.bind 'reset', @.appendFollowers
    @pending.bind 'reset', @.appendPending
    @request.bind 'reset', @.appendReuqest

  render: ->
    html = JST['supporter/page']()
    $(@.el).html html

    @followings.fetch()
    @followers.fetch()
    @pending.fetch()
    @request.fetch()

  appendFollowings: (collection)->
    if collection.models.length > 0
      _.each collection.models, (model)=>
        attributes =
          id: model.get('id')
          source: model.get('profile').image_url
          name: model.get('name')
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