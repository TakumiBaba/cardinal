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
    if action is undefined
      action = 'matching'
    switch action
      # when 'index'
      when 'matching'
        console.log action
        matching = new App.View.MatchingPage()
        matching.render()

      when 'message'
        console.log action
        message = new App.View.MessagePage()
        message.render()
      when 'like'
        console.log action
        like = new App.View.LikePage()
        like.render()
      when 'talk'
        console.log action
        talk = new App.View.TalkPage()
        talk.render()
      when 'profile'
        profile = new App.View.ProfilePage()
        profile.render()
      # when 'me'
      when 'supporter'
        supporter = new App.View.SupporterPage()
        supporter.render()
      when "invite"
        FB.ui
          method: "apprequests"
          message: "応援に参加してください！"
          data: App.User.get('id')



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