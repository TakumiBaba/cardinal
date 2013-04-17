App = window.App
JST = App.JST

class App.View.UserPage extends Backbone.View
  el: "div#main"

  constructor: (attrs, options)->
    super
    $(@.el).empty()
    id = attrs.id
    @model = new App.Model.User
      id: id

    _.bindAll @, "render"
    @model.bind 'change', @render

    profileView = new App.View.UserPageProfile
      model: @model
    matchinglistView = new App.View.UserPageMatchingList
      id: id
    likelistView = new App.View.UserPageLikeList
      id: id
    matchinglistView = new App.View.UserPageMatchingList
      id: id
    supportertalkView = new App.View.UserPageSupporterTalk
      id: id

  render: (model)->
    console.log model
    user = model
    gender = if user.get('profile').gender is 'male' then "男性" else "女性"
    b = new Date(user.get('profile').birthday)
    options =
      image_source: user.get('profile').image_url
      name: user.get('name')
      gender_birthday: "#{gender} #{user.get('profile').age}歳　#{b.getFullYear()}年#{b.getMonth()-1}月#{b.getDay()}日生まれ"
      follower: user.get('follower')
      profile: user.get('profile')
    html = JST['userpage/page'](options)
    $(@.el).empty()
    $(@.el).html html

class App.View.UserPageProfile extends Backbone.View
  el: "div#detailprofile"

  constructor: (attrs, options)->
    super
    _.bindAll @, "render", "appendFollower"
    @.model.bind 'change', @.render

    @.followers = new App.Collection.Followers
      userid: @model.id
    @.followers.bind 'reset', @.appendFollower
    @.followers.fetch()

  render: (model)->
    console.log 'profile render'
    user = model
    gender = if user.get('profile').gender is 'male' then "男性" else "女性"
    b = new Date(user.get('profile').birthday)
    attributes =
      image_source: user.get('profile').image_url
      name: user.get("name")
      gender_birthday: "#{gender} #{user.get('profile').age}歳　#{b.getFullYear()}年#{b.getMonth()-1}月#{b.getDay()}日生まれ"
      follower: user.get("follower")
      profile: user.get('profile')
    @.el = JST['userpage/profile'](attributes)
    $('div#detailprofile').append @.el

  appendFollower: (collection)->
    ul = $("ul.follower-list")
    _.each collection.models, (model)=>
      attributes =
        facebook_url: "https://facebook.com/#{model.get('facebook_id')}"
        source: model.get('profile').image_url
        name: model.get('name')
      li = JST['matching/follower'](attributes)
      ul.append li

class App.View.UserPageMatchingList extends Backbone.View
  el: "div#matchinglist"

  constructor: (attrs, option)->
    super
    @.collection = new App.Collection.PreCandidates
      userid: attrs.id
      status: "0"

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

    @.collection.fetch()

  appendItem: (model)->
    if model.get('isSystemMatching')
      ul = $("div.system ul")
    else
      ul = $("div.supporter ul")
    attributes =
      id: model.get('user').id
      source: model.get('user').profile.image_url
      text: "いいね！"
      status: model.get('status')
      name: model.get('user').name
    li = JST['like/thumbnail'](attributes)
    ul.append li

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

class App.View.UserPageLikeList extends Backbone.View
  el: "div#likelist"

  constructor: (attrs, options)->
    super

    @.collection = new App.Collection.PreCandidates
      userid: attrs.id
      status: "1,2,3"

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

    @.collection.fetch()

  appendItem: (model)->
    status = model.get('status')
    user  = model.get('user')
    text  = ""
    if status is 1
      ul = $('div.my-like ul')
    else if status is 2
      ul = $('div.your-like ul')
    else if status is 3
      ul = $('div.each-like ul')
    else
      ul = ""
    attributes =
      id: user.id
      source: user.profile.image_url
      name: user.name
      status: status
      text: "イイね！"
    li = JST['like/thumbnail'](attributes)
    ul.append li

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

class App.View.UserPageSupporterTalk extends Backbone.View
  el: "div#supportertalk"

  constructor: (attrs, options)->
    super
    @.collection = new App.Collection.Talks
      userid: attrs.id

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

    @.collection.fetch()

  appendItem: (model)->
    console.log model
    talk = new App.View.TalkUnit
      model: model
    talk.render()
    $("div#supportertalk ul.talk_list").append talk.el

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem