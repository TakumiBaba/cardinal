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
        # @now.render()
      when 'me'
        @now = new App.View.MePage()
      when 'supporter'
        @now = new App.View.SupporterPage()
        @now.render()
      when "invite"
        FB.ui
          method: "apprequests"
          message: "応援に参加してください！"
          data: App.User.get('id')
        , (res)->
          _.each res.to, (fbid)->
            $.ajax
              type: "POST"
              url: +"/api/users/#{fbid}/follow/#{App.User.get('facebook_id')}"
              success: (data)->
                console.log data
          # console.log res
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

window.fbAsyncInit = ->
  FB.init
    appId: 381551511881912
    channelUrl: '//takumibaba.com'
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

            @start = ()->
              Backbone.history.start()
            _.bindAll @, "start"
            App.User.bind 'change', @start

            router = new Router()
            App.User.fetch()

    else
      FB.login()