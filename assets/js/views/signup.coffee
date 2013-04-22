App = window.App
JST = App.JST

class App.View.SignupPage extends Backbone.View
  el: "div#main"

  events:
    "click button.cancel": "cancel"

  constructor: ->
    super
    $(@.el).empty()

  render: ->
    FB.api "me", (res)=>
      FB.api "/me/birthday", (res)->
        console.log res
      console.log res
      attributes =
        fullName: res.name
        firstName: res.first_name
        lastName: res.last_name
        username: res.username
        gender: res.gender
        facebook_id: res.id
      console.log attributes
      html = JST['signup/page'](attributes)
      $(@.el).html html

  cancel: (e)->
    location.href = "/"
    console.log "cancel"