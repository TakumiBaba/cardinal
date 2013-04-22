App = window.App
JST = App.JST

class App.View.Sidebar extends Backbone.View
  el: "div#sidebar"
  constructor: ->
    super

    _.bindAll @, "render", "appendFollowings", "appendAllFollowings"
    @.model.bind 'change', @render

    @.followings = new App.Collection.Followings
      userid: "me"
    @.followings.bind 'add', @.appendFollowings
    @.followings.bind 'reset', @.appendAllFollowings

  render: (model)=>
    isSupporter = model.get('isSupporter')
    if isSupporter is false
      attributes =
        name: model.get('firstName')
        source: model.get('profile').image_url
      html = JST['sidebar/main'](attributes)
    else
      attributes =
        name: model.get('firstName')
        source: model.get('profile').image_url
      html = JST['sidebar/supporter'](attributes)
    $(@.el).html html
    @.followings.fetch()

  appendFollowings: (model)->
    attributes =
      id: model.get('id')
      source: "/api/users/#{model.get('id')}/picture"
      name: model.get('name')
    li = App.JST['sidebar/following'](attributes)
    $(@.el).find('ul.following').append li

  appendAllFollowings: (collection)->
    _.each collection.models, @.appendFollowings

class App.View.ProfilePage extends Backbone.View
  el: "#main"
  events:
    "keydown input#like": "addLikeList"
    "click button.cancel": "cancel"
    "click button.save": "update"

  constructor: (attrs, options)->
    super
    $(@.el).empty()

    @.model = new App.Model.Profile()

    _.bindAll @, "render"
    @.model.bind 'change', @.render

    @.model.fetch()

    # ここでProfileModelを...

  render: (model)->
    console.log model
    attributes = @.model.attributes
    html = App.JST['profile/page'](attributes)
    $(@.el).html html

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

  update: (e)->
    e.preventDefault()
    detail =
      profile_image: $("#profile-image").attr 'src'
      martialHistory: parseInt($("#havingMarried").val())
      hasChild: parseInt($("#hasChild").val())
      wantMarriage: parseInt($("#wantMarriage").val())
      wantChild: parseInt($("#wantChild").val())
      address: parseInt($("#address").val())
      hometown: parseInt($("#hometown").val())
      job: parseInt($("#job").val())
      income: $("#income").val()
      bloodType: parseInt($("#bloodType").val())
      education: parseInt($("#education").val())
      shape: parseInt($("#shape").val())
      height: $("#height").val()
      drinking: parseInt($("#drinking").val())
      smoking: parseInt($("#smoking").val())
      hoby: $("#hoby").val()
      like: $("#like").val()
      message: $("#message").val()
    @.model.save detail

  cancel: (e)->
    @.render()


