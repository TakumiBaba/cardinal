App = window.App
JST = App.JST

class App.View.CandidatePage extends Backbone.View
  el: "div#main"

  events:
    "click button.like": "doLike"
    "click button.sendMessage": "sendMessage"

  constructor: (attrs, options)->
    super
    $(@.el).children().remove()
    @render(attrs)
    @supporterMessages = new App.Collection.SupporterMessages
      id: attrs.id

    _.bindAll @, "appendSupporterMessages"
    @supporterMessages.bind 'reset', @appendSupporterMessages

  render: (attrs)->
    requirejs ["text!/views/candidate/#{attrs.id}?time=#{Date.now()}"], (view)=>
      $(@.el).html view
      @supporterMessages.fetch()

  appendFollowers: (collection)->
    _.each collection.models, (model)=>
      if model.get('approval')
        f = model.get('follower')
        console.log f
        attributes =
          facebook_url: "https://facebook.com/#{f.facebook_id}"
          source: f.profile.image_url
          name: "#{f.first_name}さん"
        li = JST['matching/follower'](attributes)
        $(@.el).find('ul.follower-list').append li

  appendSupporterMessages: (collection)->
    _.each collection.models, (model)=>
      s = model.get('supporter')
      li = new App.View.Supporting.SupporterMessage
        parent: @
        model: model
      li.render()

  doLike: (e)->
    console.log e
    $.ajax
      type: "POST"
      url: "/api/users/me/candidates/#{@model.get('id')}"
      data:
        nextStatus: "up"
      success:(data)->
        location.href = "/#/like"
        console.log data

  sendMessage: (e)->
    console.log @model.get('id')
    $.ajax
      type: "POST"
      url: "/api/users/me/#{@model.get('id')}/message"
      success:(data)->
        if data
          location.href = "/#/message"
