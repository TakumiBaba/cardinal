module.exports = (app, done) ->

  done or= -> return null

  mongoose = require 'mongoose'
  debug = require '../helper/debug'
  Crypto = require "crypto"
  Models = app.settings.models
  User = Models.User
  News = Models.News
  Message = Models.Message
  Follow = Models.Follow
  Talk = Models.Talk
  Status = Models.Status



  if app.settings.config.migration
    console.log 'migration'
    done()

  else
    done()
