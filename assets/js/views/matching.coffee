App = window.App
JST = App.JST
App.View.Matching = {}

class App.View.MatchingPage extends Backbone.View
  el: "div#main"

  events:
    "click ul#matching_type_list li": "change"

  constructor: ->
    super
    @collection = new App.Collection.PreCandidates
      userid: "me"
      status: "0"

  render: ->
    $(@.el).empty()
    requirejs ['text!/views/matching'], (view)=>
      $(@.el).html view

      @profileView = new App.View.Matching.Profile()

      @systemList = new App.View.Matching.UserList
        collection: @collection
        el: "ul.user_list.system"
        profileView: @profileView
      @supporterList = new App.View.Matching.UserList
        collection: @collection
        el: "ul.user_list.supporter"
        profileView: @profileView
      @supporterList.hide()

      @collection.fetch()
  change: (e)->
    $(@.el).find('ul#matching_type_list li').each ()->
      if $(@).hasClass 'active'
        $(@).removeClass 'active'
    t = $(e.currentTarget)
    t.addClass 'active'
    if t.hasClass 'system'
      @supporterList.hide()
      @systemList.show()
    else if t.hasClass 'supporter'
      @supporterList.show()
      @systemList.hide()

class App.View.Matching.UserList extends Backbone.View
  el: "ul.user_list"
  events:
    "keydown body": "changeModelForKey"
  constructor: (attrs)->
    super
    @el = attrs.el
    @target = 0
    @model = ""
    @profileView = attrs.profileView
    @type = attrs.isSystemMatching
    _.bindAll @, "setCollection"
    @collection.bind 'reset', @setCollection

  changeModel: (clickedLi)->
    @setProfile clickedLi.model
    _.each $(@.el).children(), (child)->
      if $(child).hasClass 'active'
        $(child).removeClass 'active'
    $(clickedLi.el).addClass 'active'

  changeModelForKey: (e)->
    console.log e.keyCode

  setCollection: (collection)->
    @users = if $(@.el).hasClass "system" then collection.getBySystems() else collection.getBySupporters()
    @model = @users[0]
    if @users.length > 0
      for i in [0..@users.length-1]
        li = new App.View.Matching.UserListThumbnail
          parent: @
          model: @users[i]
        li.render()
        $(li.el).addClass 'active' if i is @target
      @setProfile @model
    else
      if $(@.el).hasClass 'system'
        $("ul#matching_type_list li.system").hide()
      else
        $("ul#matching_type_list li.supporter").hide()

  nextModel: (e)->
    @target += 1 if @target > 1
    console.log 'next'
  prevModel: (e)->
    @target -= 1 if @target < @collection.model.length-1
    console.log 'prev'

  show: ->
    $(@.el).show()
    $(@.el).children().eq(0).find('img').click()
  hide: ->
    $(@.el).hide()

  setProfile: (user)->
    u = user.get('user')
    @profileView.model = user
    @profileView.render()

class App.View.Matching.UserListThumbnail extends Backbone.View
  tagName: "li"
  className: "user-thumbnail"

  events:
    "click img": "changeModel"

  constructor: (attrs)->
    super
    @parent = attrs.parent
    @model = attrs.model
  render: ->
    $(@.el).html "<img class='img-rounded' src='#{@model.get('user').profile.image_url}' />"
    $(@parent.el).append @.el

  changeModel: (e)->
    @parent.changeModel @

class App.View.Matching.Profile extends Backbone.View
  el: "div.profile"

  events:
    "click img.like": "like"
    "click img.message": "message"
    "click img.talk": "talk"

  constructor: (attrs)->
    super

  render: ->
    u = @model.get 'user'
    $("div.p_h_left img").attr 'src', u.profile.image_url
    $("div.p_h_right h4.title_box").html "#{u.first_name} さんからのメッセージ"
    $("div.p_h_right p.message").html u.profile.message
    $("div.profile_supporter_messages h4.title_box").html "#{u.first_name} さんの応援団おすすめ情報"

    $("div.profile_supporters h4.title_box").html "#{u.first_name} さんの応援団"
    profileAttribtues =
      name: u.first_name
      profile: u.profile
    profileView = JST['matching/profile'](profileAttribtues)
    $("div.profile_body").html profileView
    messages = new App.Collection.SupporterMessages
      id: u.id
    messages.bind "reset", (collection)=>
      messagesView = JST['matching/supportermessages']
        name: u.first_name
        messages: collection.models
      if collection.models.length > 0
        $("div.profile_supporter_messages").show()
        $("div.profile_supporter_messages").html messagesView
      else
        $("div.profile_supporter_messages").hide()
    messages.fetch()
    supporters = new App.Collection.Followers
      userid: u.id
    supporters.bind 'reset', (collection)->
      supportersView = JST['matching/supporters']
        name: u.first_name
        followers: collection.models
      if collection.models.length > 0
        $("div.profile_supporters").show()
        $("div.profile_supporters").html supportersView
      else
        $("div.profile_supporters").hide()
    supporters.fetch()

  like: (e)->
    console.log @model
    @model.set "myStatus", true
    @model.urlRoot = "/api/users/#{App.User.get('id')}/candidates"
    @model.save
      success: (data)=>
        console.log data
    e.preventDefault()
  message: (e)->
    console.log e
  talk: (e)->
    console.log e

# class App.View.MatchingListView extends Backbone.View
#   events:
#     "click li.user-thumbnail": "changeModel"
#     "click img.like": "doLike"
#     "click img.sendMessage": "sendMessage"
#     "click img.talk": "talk"

#   constructor: (attrs)->
#     super
#     _.bindAll @, "appendItem", "appendAllItem", "setFollower", "setSupporterMessages"
#     @.collection.bind "add", @appendItem
#     @.collection.bind "reset", @appendAllItem

#     @supporterMessages = new App.Collection.SupporterMessages
#       id: ""
#     @supporterMessages.bind 'reset', @setSupporterMessages

#   appendItem: (model)->
#     user = model.get('user')
#     console.log user
#     attributes =
#       id: user.id
#       source: user.profile.image_url
#     li = JST['matching/thumbnail'](attributes)
#     $(@.el).find('ul.matching_side').append li

#   appendAllItem: (collection)->
#     console.log collection
#     flag = if $(@.el).hasClass 'system_matching' then true else false
#     list = _.filter collection.models, (model)=>
#       return model.get('isSystemMatching') is flag
#     if flag is false
#       $(@.el).parent().find("li.supporter a").html "応援団おすすめリスト(#{list.length})"
#     if list.length > 0
#       _.each list, @appendItem
#       @recommendButton = new App.View.FollowDropDownMenu
#         targetId: list[0].get('user').id
#       @recommendButton.render()
#       $(@.el).find('ul.matching_side li:first').click()
#     else
#       $(@.el).find('div.box').html "<p>応援団からのオススメはありません。</p>" if !flag

#   changeModel: (e)->
#     id = $(e.currentTarget).attr('id')
#     $(@.el).find('li').each ()->
#       if $(@).hasClass 'active'
#         $(@).removeClass 'active'
#     $(e.currentTarget).addClass 'active'
#     _.each @collection.models, (model)=>
#       if model.get('user').id is id
#         @targetModel = model
#         @setDetail model

#         # @supporterMessages.reset()
#         @supporterMessages.setId id
#         @supporterMessages.fetch()

#   setDetail: (model)->
#     user = model.get('user')
#     gender = if user.profile.gender is 'male' then "男性" else "女性"
#     birthday = new Date(user.profile.birthday)
#     age = moment().diff(moment(birthday), "year")
#     $(@.el).find('img.profile_image').attr('src', user.profile.image_url)
#     $(@.el).find('table.sub').html("""
#       <tbody>
#         <tr><td class='key hoby'>趣味</td><td>#{user.profile.hoby}</td></tr>
#         <tr><td class='key like'>好きなもの</td><td>#{user.profile.like}</td></tr>
#         <tr><td class='key ideal-message'>理想のパートナー像</td><td>#{user.profile.idealPartner}</td></tr>
#         <tr><td class='key ideal-age'>お相手の希望年齢</td><td>#{user.profile.ageRangeMin} ~ #{user.profile.ageRangeMax}歳</td></tr>
#       </tbody>
#       """)
#     $(@.el).find('a.to-detail-profile').attr 'href', "/#/u/#{user.id}"
#     $(@.el).find('h5.follower-title').html("#{user.first_name}さんの応援団")
#     console.log user
#     $(@.el).find('h4.name').html "#{user.first_name}さん　（#{age}歳）"
#     $(@.el).find('div.supporter-message-list h4').html "#{user.first_name}さんの応援団おすすめ情報"
#     $(@.el).find('div.profile-column-header h4').html "#{user.first_name}さんのプロフィール"
#     $(@.el).find('h5.message').html user.profile.message
#     @.followers = new App.Collection.Followers
#       userid: user.id
#     @.followers.bind 'reset', @.setFollower
#     @.followers.fetch()
#     @.setProfile user.profile

#   setProfile: (profile)->
#     html = JST['userpage/detailProfile'](profile)
#     $(@.el).find('table.main').html(html)

#   setFollower: (collection)->
#     $(@.el).find('ul.follower-list').empty()
#     _.each collection.models, (f)=>

#       follower = f.get('follower')
#       console.log follower
#       options =
#         facebook_url: "https://facebook.com/#{follower.facebook_id}"
#         source: "/api/users/#{follower.id}/picture"
#         name: "#{follower.first_name}"
#       html = JST['matching/follower'](options)
#       $(@.el).find('ul.follower-list').append html

#   setSupporterMessages: (collection)->
#     _.each collection.models, (model)=>
#       console.log model
#       s = model.get 'supporter'
#       attributes =
#         source: s.profile.image_url
#         name: "#{s.first_name}"
#         message: model.get 'message'
#         message_id: false
#       li = JST['supporter-message/li'](attributes)
#       $(@.el).find('div.supporter-message-list ul').append li

#   show: ()->
#     $(@.el).show()
#   hide: ()->
#     $(@.el).hide()

#   doLike: (e)=>
#     console.log @targetModel.get('user').id
#     $.ajax
#       type: "POST"
#       url: "/api/users/me/candidates/#{@targetModel.get('user').id}"
#       data:
#         nextStatus: "up"
#       success: (data)->
#         location.href = "/#/like"
#         console.log data

#   sendMessage: (e)->
#     console.log e
#     console.log @targetModel.get('user').id
#     $.ajax
#       type: "POST"
#       url: "/api/users/me/#{@targetModel.get('user').id}/message"
#       success:(data)->
#         if data
#           location.href = "/#/message"

#   talk: (e)->
#     $.ajax
#       type: "POST"
#       url: "/api/talks.json"
#       data:
#         one: "me"
#         two: @targetModel.get('user').id
#       success: (data)->
#         if data
#           location.href = "/#/talk"