module.exports = (app, done)->

  Crypto = require 'crypto'
  User = app.settings.models.User
  exports.createUser = (params)->
    console.log params