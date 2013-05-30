App = window.App
JST = App.JST

class App.View.Sidebar extends Backbone.View
  el: "div#sidebar"

  events:
    "click a.usage": "modalUsage"
    "click li.use-policy": "modalUsePolicy"

  constructor: ->
    super

    _.bindAll @, "render"
    @.model.bind 'change', @render
    @followers = new App.Collection.Followers
      userid: "me"
    @followers.bind 'reset', @setFollower

  render: (model)=>
    isSupporter = model.get('isSupporter')
    if isSupporter is false
      attributes =
        name: model.get('first_name')
        source: model.get('profile').image_url
      html = JST['sidebar/main'](attributes)
    else
      attributes =
        name: model.get('first_name')
        source: model.get('profile').image_url
      html = JST['sidebar/supporter'](attributes)
      location.href = "/#/supporter"
    $(@.el).html html
    @followers.fetch()

  setFollower: (collection)->
    _.each collection.models, (model)=>
      console.log model.get('follower').firstname
      attributes =
        id: model.get('follower').id
      li = JST['sidebar/follower'](attributes)
      $('ul.sidebar-follower-list').append li

  modalUsage: ->
    if $("div.usage").length < 1
      $("body").append JST['usage/page']()
    $("div.usage").modal
      keyboard: true
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
      hoby: $("#hoby").val()
      like: likelist
      message: $("#message").val()
      ageRangeMin: parseInt $("#age_range_min").val()
      ageRangeMax: parseInt $("#age_range_max").val()
      idealPartner: $("#ideal_partner").val()
    @.model.save detail

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



class App.View.FollowDropDownMenu extends Backbone.View
  el:"div.recommend"

  events:
    "click li": "recommend"

  constructor: (attrs, options)->
    super

    @.collection = new App.Collection.Followings
      userid: "me"

    @targetId = attrs.targetId

    _.bindAll @, "appendItem", "appendAllItem"
    @collection.bind 'add', @.appendItem
    @collection.bind 'reset', @.appendAllItem

  render:->
    @collection.fetch()

  appendItem: (model)->
    if model.get('approval')
      f = model.get('following')
      attributes =
        id: f.id
        source: "/api/users/#{f.id}/picture"
        name: f.firstName
      html = JST['recommend/li'](attributes)
      $(@.el).find('ul.recommend-following').append html

  appendAllItem: (collection)->
    $(@.el).find('ul.recommend-following').empty()
    if collection.models.length > 0
      _.each collection.models, @.appendItem
    else
      $(@.el).find('button').addClass 'disabled'

  setTargetId: (id)->
    @targetId = id

  recommend: (e)->
    id = $(e.currentTarget).attr 'id'
    $.ajax
      type: "POST"
      url: "/api/users/#{id}/candidates/#{@targetId}"
      data:
        nextStatus: "promotion"
      success: (data)->
        console.log data

class App.View.MePage extends Backbone.View
  el: "div#main"

  constructor : ->
    super

    @model = App.User
    @followers = new App.Collection.Followers
      userid: "me"
    _.bindAll @, "setSupporterMessages"
    # @followers.fetch()


  render: (model)->
    requirejs ["text!/views/profile/index?time=#{Date.now()}"], (view)=>
      $(@.el).html view

  setSupporterMessages: (collection)->
    _.each collection.models, (model)->
      s = model.get 'supporter'
      attributes =
        source: s.profile.image_url
        name: s.first_name
        message: model.get('message')
      li = JST['supporter-message/li'](attributes)
      $("div.supporter-message-list ul").append li

