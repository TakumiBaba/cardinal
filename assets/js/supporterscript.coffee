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
      action = 'supporter'
    switch action
      when 'supporter'
        @now = new App.View.SupporterPage()
        @now.render()
      when "signup"
        @now = new App.View.SignupPage()
        @now.render()
      when "usage"
        @now = new App.View.Usage()
        @now.render()

  supporterpageAction: (id)->
    $("div#main").empty()
    if @now
      @now.undelegateEvents()
    @now = new App.View.Supporting.Page
      id: id
    @now.render()

  userpageAction: (id)->
    $("div#main").empty()
    if @now
      @now.undelegateEvents()
    @now = new App.View.CandidatePage
      id: id


window.fbAsyncInit = ->
  FB.init
    appId: 381551511881912
    channelUrl: '//apps.facebook.com/ding_dong'
    frictionlessRequests : true
    status: true
    cookie: true
    xfbml: true

  id = $("div#wrapper").attr 'class'
  $("div#wrapper").removeClass id

  App.User = new App.Model.User
    id: id
  sidebar = new App.View.Sidebar
    model: App.User
  @router = new Router()

  App.User.fetch
    success: ()=>
      console.log 'start'
      Backbone.history.start()


  # FB.getLoginStatus (response)->
  #   console.log response
  #   if response.status is "connected"
  #     FB.api 'me', (res)->
  #       $.ajax
  #         type: "POST"
  #         url: "/api/login"
  #         data: res
  #         success: (data)->
  #           id = data.id
  #           console.log data
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
  #                 $("li.talk a").html("応援トーク（#{talks.length}）")
  #                 $("li.message a").html("メッセージ（#{messages.length}）")
  #             setInterval ()->
  #               console.log 'interval'
  #               $.ajax
  #                 type: "GET"
  #                 url: "/api/users/me/news"
  #                 success: (data)->
  #                   talks = _.filter data, (d)->
  #                     return d.type is "talk"
  #                   messages = _.filter data, (d)->
  #                     return d.type is "message"
  #                   $("li.talk a").html("応援トーク（#{talks.length}）")
  #                   $("li.message a").html("メッセージ（#{messages.length}）")
  #             , 1000*60
  #           _.bindAll @, "start"
  #           App.User.bind 'change', @start

  #           @router = new Router()
  #           App.User.fetch()

  #   else
  #     FB.login()