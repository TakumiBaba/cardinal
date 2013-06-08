App = window.App
JST = App.JST
App.View.Matching = {}

class App.View.MatchingPage extends Backbone.View
  el: "div#main"

  events:
    "click ul#matching_type_list li": "change"
    "mousedown a.next": "next"
    "mouseup a.next": "replaceImage"
    "mousedown a.prev": "prev"
    "mouseup a.prev": "replaceImage"

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

      @userList = new App.View.Matching.UserList
        collection: @collection
        profileView: @profileView
      @selectedList = @userList

      @collection.fetch()

  change: (e)->
    $(@.el).find('ul#matching_type_list li').each ()->
      $(@).removeClass 'active' if $(@).hasClass 'active'
    t = $(e.currentTarget)
    t.addClass 'active'
    if t.hasClass 'system'
      # @userList.change()
      @userList.setSystems()
      if @userList.collection.getBySystems().length > 0 then $(@profileView.el).show() else $(@profileView.el).hide()
    else if t.hasClass 'supporter'
      # @supporterList.show()
      # @systemList.hide()
      @userList.setSupporters()
      if @userList.collection.getBySupporters().length > 0 then $(@profileView.el).show() else $(@profileView.el).hide()

  next: (e)->
    @selectedList.nextModel(e)
    $(e.currentTarget).find('img').attr 'src', "/image/scroll_top2.gif"
  replaceImage: (e)->
    if $(e.currentTarget).hasClass 'prev'
      $(e.currentTarget).find('img').attr 'src', "/image/scroll_bottom.gif"
    else
      $(e.currentTarget).find('img').attr 'src', "/image/scroll_top.gif"
  prev: (e)->
    @selectedList.prevModel(e)
    $(e.currentTarget).find('img').attr 'src', "/image/scroll_bottom2.gif"


class App.View.Matching.UserList extends Backbone.View
  el: "ul.user_list"
  events:
    "keydown body": "changeModelForKey"

  constructor: (attrs)->
    super
    @target = 0
    @at = 0
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
    console.log clickedLi

  changeModelForKey: (e)->
    console.log e.keyCode

  setCollection: (collection)->
    @systems = collection.getBySystems()
    @supporters = collection.getBySupporters()
    @users = @systems
    for i in [0..@systems.length-1]
      li = new App.View.Matching.UserListThumbnail
        parent: @
        model: @systems[i]
      li.render()
      $(li.el).addClass 'active' if i is @target
    @setProfile @systems[0]

  setSystems: ->
    $(@.el).empty()
    @target = 0
    if @systems.lengt < 1
      return
    for i in [0..@systems.length-1]
      li = new App.View.Matching.UserListThumbnail
        parent: @
        model: @systems[i]
      li.render()
      $(li.el).addClass 'active' if i is @target
    @setProfile @systems[@target]
    $(@.el).css
      'transform': "translate(0px, #{-@target*65}px)"
    @users = @systems

  setSupporters: ->
    $(@.el).empty()
    @target = 0
    if @supporters.length < 1
      return
    for i in [0..@supporters.length-1]
      li = new App.View.Matching.UserListThumbnail
        parent: @
        model: @supporters[i]
      li.render()
      $(li.el).addClass 'active' if i is @target
    @setProfile @supporters[@target]
    $(@.el).css
      'transform': "translate(0px, #{-@target*65}px)"
    @users = @supporters

  nextModel: (e)->
    e.preventDefault()
    @target += 1 if @target < @collection.models.length-7
    $(@.el).css
      'transform': "translate(0px, #{-@target*65}px)"
    # @changeModel @users[@target]
  prevModel: (e)->
    e.preventDefault()
    @target -= 1 if @target > 0
    $(@.el).css
      'transform': "translate(0px, #{-@target*65}px)"
    # @changeModel @users[@target]

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
    if @model.get('myStatus') is true then $('div.btns img.like').hide() else $('div.btns img.like').show()
    $("div.p_h_right small.message").html u.profile.message
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
    detail =
      myStatus: true
    @model.urlRoot = "/api/users/#{App.User.get('id')}/candidates"
    @model.save detail,
      success: (data)=>
        # フィードバックをどう表現するのか？
        # いいねした人のいいねボタンを消しつつ、他の人のを消さない仕組み
        $(@.el).find("img.like").hide()
    e.preventDefault()
  message: (e)->
    $.ajax
      type: "POST"
      url: "/api/users/me/#{@model.get('user').id}/message"
      success:(data)->
        if data
          location.href = "/#/message"
  talk: (e)->
    talk = new Backbone.Model()
    talk.urlRoot = "/api/talks.json"
    talk.set
      one: App.User.get('id')
      two: @model.get("user").id
    talk.save()
    e.preventDefault()
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