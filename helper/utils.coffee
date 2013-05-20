module.exports = (app, done)->

  Crypto = require 'crypto'
  FB = require 'fb'
  User = app.settings.models.User
  Config = app.settings.config

  exports.createUser = (params)->
    console.log params

  sendNotification: (id)->
    FB.api 'oauth/access_token',
      client_id: Config.appId
      client_secret: Config.appSecret
      grant_type: 'client_credentials'
    , (response)->
      throw err if !response or response.error
      FB.setAccessToken response.access_token
      FB.api "#{id}/notifications", "post",
        access_token: response.access_token
        href: "https://takumibaba.com/#/supporter"
        template "@[#{id}]さん、応援しましょう！"
      , (response)->
        throw err if !response or response.error
        return response