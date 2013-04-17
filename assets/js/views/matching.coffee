App = window.App
JST = App.JST

class App.View.MatchingPage extends Backbone.View
  el: "div#main"

  constructor: ->
    super
    @collection = new App.Collection.PreCandidates
      userid: "me"
      status: "0"

  render: ->
    $(@.el).empty()
    html = JST['matching/page']()
    $(@.el).html html

    systemMatchingView = new App.View.MatchingListView
      collection: @collection
      el: "div.system_matching"
    supporterMatchingView = new App.View.MatchingListView
      collection: @collection
      el: "div.supporter_matching"

    @collection.fetch()

class App.View.MatchingListView extends Backbone.View
  events:
    "click li.user-thumbnail": "changeModel"

  constructor: (attrs)->
    super
    console.log attrs
    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind "add", @appendItem
    @.collection.bind "reset", @appendAllItem

  appendItem: (model)->
    user = model.get('user')
    console.log user
    attributes =
      id: user.id
      source: user.profile.image_url
    li = JST['matching/thumbnail'](attributes)
    console.log $(@.el).find('ul.matching_side')
    $(@.el).find('ul.matching_side').append li

  appendAllItem: (collection)->
    console.log collection
    console.log $(@.el).hasClass 'system_matching'
    flag = if $(@.el).hasClass 'system_matching' then true else false
    list = _.filter collection.models, (model)=>
      return model.get('isSystemMatching') is flag
    console.log list
    _.each list, @appendItem

  changeModel: (e)->
    $(@.el).find('li').each ()->
      if $(@).hasClass 'active'
        $(@).removeClass 'active'
    $(e.currentTarget).addClass 'active'
    model = @.collection.where({id: $(e.currentTarget).attr('id')})[0]
    @.setDetail(model)
  setDetail: (model)->

