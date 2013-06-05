App = window.App
JST = App.JST

class App.View.Sidebar extends Backbone.View
  el: "div#sidebar"

  events:
    "click button.request": "invite"

  constructor: ->
    super
    @render()
  render: ->
    requirejs ["text!/views/sidebar?time=#{Date.now()}"], (view)=>
      $(@.el).html view

  invite: ->
    location.href = "/#/invite"

  modalUsePolicy: ->
    console.log 'use policy'
    if $("div.usepolicy").length < 1
      $("body").append JST['usepolicy/page']()
    $("div.usepolicy").modal
      keyboard: true


class App.View.ProfilePage extends Backbone.View
  el: "#main"
  events:
    "keydown input#like": "addLikeList"
    "click button.cancel": "cancel"
    "click button.save": "update"
    "click a.delete-supporter-message": "deleteSupporterMessage"

  constructor: (attrs, options)->
    super
    $(@.el).empty()

    @model = new App.Model.Profile()
    @supporterMessages = new App.Collection.SupporterMessages
      id: "me"


    _.bindAll @, "render", "setSupporterMessages"
    @.model.bind 'change', @.render
    @.model.fetch()

    @supporterMessages.bind 'reset', @setSupporterMessages


  render: (model)->
    attributes = @.model.attributes
    console.log @.model.attributes
    html = App.JST['profile/page'](attributes)
    $(@.el).html html

    @supporterMessages.fetch()

  profileImageTemplate: (url)->
    return "<li><img src=#{url} /></li>"

  changeProfileImage: (e)->
    source =  $(e.currentTarget).find('img').attr 'src'
    $("ul.profile-image-list li").each ()->
      $(@).removeClass 'active'
    $(e.currentTarget).addClass 'active'
    $("#profile-image").attr 'src', source
    @.update(e)

  addLikeList: (e)->
    if e.keyCode is 13
      text = $(e.currentTarget).val()
      label = $("<span>").addClass('label label-info')
      label.html text
      $(@.el).find('div.likelist').append label
      $(e.currentTarget).val("")

  update: (e)->
    e.preventDefault()
    console.log 'update'
    likelist = []
    $('div.likelist').children().each ()->
      likelist.push $(@).html()
    detail =
      profile_image: $("#profile-image").attr 'src'
      martialHistory: parseInt($("#martialHistory").val())
      hasChild: parseInt($("#hasChild").val())
      wantMarriage: parseInt($("#wantMarriage").val())
      wantChild: parseInt($("#wantChild").val())
      address: parseInt($("#address").val())
      hometown: parseInt($("#hometown").val())
      job: parseInt($("#job").val())
      income: parseInt $("#income").val()
      bloodType: parseInt($("#bloodType").val())
      education: parseInt($("#education").val())
      shape: parseInt($("#shape").val())
      height: $("#height").val()
      drinking: parseInt($("#drinking").val())
      smoking: parseInt($("#smoking").val())
      hoby: _.escape $("#hoby").val()
      like: likelist
      message: _.escape $("#message").val()
      ageRangeMin: parseInt $("#age_range_min").val()
      ageRangeMax: parseInt $("#age_range_max").val()
      idealPartner: _.escape $("#ideal_partner").val()
    @.model.save detail,
      success:(data)->
        location.href = "/#/me"

  cancel: (e)->
    @.render()

  setSupporterMessages: (collection)->
    _.each collection.models, (model)=>
      s = model.get 'supporter'
      attributes =
        source: s.profile.image_url
        name: s.first_name
        message: model.get('message')
        message_id: model.get('_id')
      li = JST['supporter-message/li'](attributes)
      $("div.supporter-message-list ul").append li

  deleteSupporterMessage: (e)->
    id = e.currentTarget.id
    $.ajax
      type: "DELETE"
      url: "/api/supportermessages/#{id}"
      success: (data)=>
        if data is true
          $(e.currentTarget).parent().parent().parent().remove()


class App.View.MePage extends Backbone.View
  el: "div#main"

  constructor : ->
    super

    @supporterMessages = new App.Collection.SupporterMessages
      id: "me"
    _.bindAll @, "setSupporterMessages"
    @supporterMessages.bind 'reset', @setSupporterMessages

  render: (model)->
    requirejs ["text!/views/profile/index?time=#{Date.now()}"], (view)=>
      $(@.el).html view

  setSupporterMessages: (collection)->
    _.each collection.models, (model)=>
      li = new App.View.Supporting.SupporterMessage
        parent: @
        model: model
      li.render()
      # s = model.get 'supporter'
      # attributes =
      #   source: s.profile.image_url
      #   name: s.first_name
      #   message: model.get('message')
      # li = JST['supporter-message/li'](attributes)
      # $("div.supporter-message-list ul").append li


class App.View.Usage extends Backbone.View
  el: "div#main"

  constructor: ->
    super

  render: ->
    requirejs ["text!/views/usage"], (view)=>
      $(@.el).html view