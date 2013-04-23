window.App = {
  JST: {}
  View: {}
  Model: {}
  Collection: {}
}

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
        @now.render()
      # when 'me'
      when 'supporter'
        @now = new App.View.SupporterPage()
        @now.render()
      when "invite"
        FB.ui
          method: "apprequests"
          message: "応援に参加してください！"
          data: App.User.get('id')
        , (res)->
          console.log res
      when "signup"
        @now = new App.View.SignupPage()
        @now.render()

  supporterpageAction: (id)->
    $("div#main").empty()
    user = new App.View.UserPage
      id: id
    user.model.fetch()

  userpageAction: (id)->
    $("div#main").empty()
    candidate = new App.View.CandidatePage
      id: id

window.fbAsyncInit = ->
  FB.init
    appId: 381551511881912
    channelUrl: '//localhost:3000/'
    status: true
    cookie: true
    xfbml: true

  FB.getLoginStatus (response)->
    console.log response
    if response.status is "connected"
      FB.api 'me', (res)->
        $.ajax
          type: "POST"
          url: "/api/login"
          data: res
          success: (id)->
            console.log id
            App.User = new App.Model.User
              id: id
            sidebar = new App.View.Sidebar
              model: App.User

            App.User.fetch()

            router = new Router()
            Backbone.history.start()
    else
      FB.login()