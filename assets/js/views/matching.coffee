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

  constructor: (attrs)->
    super
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
    console.log collection
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
        console.log id
        @targetModel = model
        @setDetail model
    @recommendButton = new App.View.FollowDropDownMenu
      targetId: id
    @recommendButton.render()

  setDetail: (model)->
    user = model.get('user')
    console.log user
    gender = if user.profile.gender is 'male' then "男性" else "女性"
    birthday = new Date(user.profile.birthday)
    $(@.el).find('img.profile_image').attr('src', user.profile.image_url)
    $(@.el).find('h5.simple_profile').html("""
      <p>#{user.name}さんはこんな人を探しています。</p>
      <p>年齢22 ~ 44歳</p>
      <p>理想パートナー像</p>
      """)
    console.log user
    $(@.el).find('h4.name').html "#{user.first_name}さん　（#{user.profile.age}歳）"
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

  doLike: (e)=>
    console.log @targetModel.get('user').id
    $.ajax
      type: "POST"
      url: "/api/users/me/candidates/#{@targetModel.get('user').id}"
      data:
        nextStatus: "up"
      success: (data)->
        location.href = "/#/like"
        console.log data

  sendMessage: (e)->
    console.log e
    console.log @targetModel.get('user').id
    $.ajax
      type: "POST"
      url: "/api/users/me/#{@targetModel.get('user').id}/message"
      success:(data)->
        if data
          location.href = "/#/message"