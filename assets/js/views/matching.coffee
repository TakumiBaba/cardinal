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
    "click button.like": "doLike"
    "click button.sendMessage": "sendMessage"
    "click button.recommend": "recommend"

  constructor: (attrs)->
    super
    console.log attrs
    _.bindAll @, "appendItem", "appendAllItem", "setFollower"
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
    flag = if $(@.el).hasClass 'system_matching' then true else false
    list = _.filter collection.models, (model)=>
      return model.get('isSystemMatching') is flag
    _.each list, @appendItem
    $(@.el).find('ul.matching_side li:first').click()

  changeModel: (e)->
    id = $(e.currentTarget).attr('id')
    $(@.el).find('li').each ()->
      if $(@).hasClass 'active'
        $(@).removeClass 'active'
    $(e.currentTarget).addClass 'active'
    _.each @collection.models, (model)=>
      if model.get('user').id is id
        @targetModel = model
        @setDetail model
  setDetail: (model)->
    user = model.get('user')
    console.log user
    gender = if user.profile.gender is 'male' then "男性" else "女性"
    birthday = new Date(user.profile.birthday)
    $(@.el).find('img.profile_image').attr('src', user.profile.image_url)
    $(@.el).find('h5.simple_profile').html("#{gender}　#{user.profile.age}歳　#{birthday.getFullYear()}年#{birthday.getMonth()+1}月#{birthday.getDay()}日生まれ")
    $(@.el).find('h4.name').html "#{user.name}さん"
    @.followers = new App.Collection.Followers
      userid: user.id
    @.followers.bind 'reset', @.setFollower
    @.followers.fetch()
    @.setProfile user.profile
  setProfile: (profile)->
    html = JST['userpage/detailProfile'](profile)
    $(@.el).find('table.table').html(html)

  setFollower: (collection)->
    $(@.el).find('ul.follower-list').empty()
    console.log collection
    _.each collection.models, (f)=>
      options =
        facebook_url: "https://facebook.com/#{f.facebook_id}"
        source: "/api/users/#{f.id}/picture"
        name: "#{f.get('name')}さん"
      html = JST['matching/follower'](options)
      $(@.el).find('ul.follower-list').append html

  doLike: (e)->
    console.log @targetModel
    @targetModel.urlRoot = "/api/users/me/candidates/#{@targetModel.get('user').id}.json"
    @targetModel.set "status", 1
    @targetModel.save()
  sendMessage: (e)->
    console.log e
  recommend: (e)->
    console.log e