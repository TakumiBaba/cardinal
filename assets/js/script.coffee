window.App = {
  JST: {}
  View: {}
  Model: {}
  Collection: {}
  AccessToken: ""
}

requirejs.config
  baseUrl: "/"
  # urlArgs: "bust=#{(new Date()).getTime()}"
  paths:
    text: "/lib/text"

class Router extends Backbone.Router

  constructor: ->
    super

  routes:
    "": "mypageAction"
    ":action": "mypageAction"
    "u/:id": "userpageAction"
    "s/:id": "supporterpageAction"

  mypageAction: (action)->
    if @now
      @now.undelegateEvents()
    if action is undefined
      action = 'matching'
    switch action
      # when 'index'
      when 'matching'
        @now = new App.View.MatchingPage()
        @now.render()
      when 'message'
        @now = new App.View.MessagePage()
        @now.render()
      when 'like'
        @now = new App.View.LikePage()
        @now.render()
      when 'talk'
        @now = new App.View.TalkPage()
        @now.render()
      when 'profile'
        @now = new App.View.ProfilePage()
        # @now.render()
      when 'me'
        @now = new App.View.MePage()
        @now.render()
      when 'supporter'
        @now = new App.View.SupporterPage()
        @now.render()
      when "invite"
        FB.ui
          method: "apprequests"
          message: "私の婚活応援に参加してください！"
          data: App.User.get('id')
        , (res)->
          if res is null
            return location.href = "/#/"
          request_id = res.request
          _.each res.to, (fbid)=>
            FB.api "/#{fbid}", (res)=>
              console.log res
              json =
                name: res.name
                first_name: res.first_name
                last_name: res.last_name
                gender: res.gender
                request_id: request_id
              $.ajax
                type: "POST"
                url: "/api/users/me/fbrequest/#{fbid}"
                data: json
                success: (data)->
                  console.log data
                  return location.href = "/#/"
      when "signup"
        @now = new App.View.SignupPage()
        @now.render()

  supporterpageAction: (id)->
    $("div#main").empty()
    if @now
      @now.undelegateEvents()
    @now = new App.View.UserPage
      id: id
    @now.model.fetch()

  userpageAction: (id)->
    $("div#main").empty()
    if @now
      @now.undelegateEvents()
    @now = new App.View.CandidatePage
      id: id
  newsReload: ()->


window.fbAsyncInit = ->
  FB.init
    appId: 381551511881912
    channelUrl: '//takumibaba.com'
    status: true
    cookie: true
    xfbml: true

  id = $("div#wrapper").attr 'class'
  $("div#wrapper").removeClass id

  App.User = new App.Model.User
    id: id

  sidebar = new App.View.Sidebar
    model: App.User

  @start = =>
    Backbone.history.start()
    $.ajax
      type: "GET"
      url: "/api/users/me/news"
      success: (data)->
        talks = _.filter data, (d)->
          return d.type is "talk"
        messages = _.filter data, (d)->
          return d.type is "message"
        $("li.talk a.talk-badge").html "応援トーク（ #{talks.length} ）"
        $("li.message a.message-badge").html("メッセージ（ #{messages.length} ）")
    setInterval ()->
      $.ajax
        type: "GET"
        url: "/api/users/me/news"
        success: (data)->
          talks = _.filter data, (d)->
            return d.type is "talk"
          messages = _.filter data, (d)->
            return d.type is "message"
          $("li.talk a.talk-badge").html "応援トーク（ #{talks.length} ）"
          $("li.message a.message-badge").html("メッセージ（ #{messages.length} ）")
    , 1000*60
  _.bindAll @, "start"
  App.User.bind 'change', @start

  @router = new Router()
  App.User.fetch()


  # FB.getLoginStatus (response)->
  #   if response.status is "connected"
  #     App.AccessToken = response.authResponse.accessToken
  #     FB.api 'me', (res)->
  #       $.ajax
  #         type: "POST"
  #         url: "/api/login"
  #         data: res
  #         success: (data)->
  #           id = data.id
  #           if data.isFirst is true
  #             window.alert("応援者か婚活者か聞く")
  #           App.User = new App.Model.User
  #             id: id
  #           sidebar = new App.View.Sidebar
  #             model: App.User
  #           @start = =>
  #             Backbone.history.start()
  #             $.ajax
  #               type: "GET"
  #               url: "/api/users/me/news"
  #               success: (data)->
  #                 talks = _.filter data, (d)->
  #                   return d.type is "talk"
  #                 messages = _.filter data, (d)->
  #                   return d.type is "message"
  #                 $("li.talk a.talk-badge").html "応援トーク（ #{talks.length} ）"
  #                 $("li.message a.message-badge").html("メッセージ（ #{messages.length} ）")
  #             setInterval ()->
  #               $.ajax
  #                 type: "GET"
  #                 url: "/api/users/me/news"
  #                 success: (data)->
  #                   talks = _.filter data, (d)->
  #                     return d.type is "talk"
  #                   messages = _.filter data, (d)->
  #                     return d.type is "message"
  #                   $("li.talk a.talk-badge").html "応援トーク（ #{talks.length} ）"
  #                   $("li.message a.message-badge").html("メッセージ（ #{messages.length} ）")
  #             , 1000*60
  #           _.bindAll @, "start"
  #           App.User.bind 'change', @start

  #           @router = new Router()
  #           App.User.fetch()
  #   else
  #     FB.login()