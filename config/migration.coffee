module.exports = (app, done) ->

  done or= -> return null

  mongoose = require 'mongoose'
  {Site} = app.settings.models

  if app.settings.config.migration
    text = '適当なテキスト'
    Site.findOne text: text, (err, site) ->
      console.error err if err
      unless site
        site = new Site
          text: '適当なテキスト'
          created: Date.now()
      site.save done

  else
    done()