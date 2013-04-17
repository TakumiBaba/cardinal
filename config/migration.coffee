module.exports = (app, done) ->

  done or= -> return null

  mongoose = require 'mongoose'
  debug = require '../helper/debug'
  Crypto = require "crypto"
  Models = app.settings.models
  User = Models.User
  News = Models.News
  Message = Models.Message

  if app.settings.config.migration
    console.log 'migration'

    User.find {}, (err, users)->
      _.each users, (user)->
        user.remove()
      Message.find {}, (err, messages)->
        _.each messages, (message)->
          message.remove()

      _.each [0..100], (i)=>
        fbid = i+10000
        User.findOne facebook_id: fbid, (err, user)->
          console.log err if err
          unless user
            user = new User()
            sha1_hash = Crypto.createHash 'sha1'
            sha1_hash.update "#{i+10000}"
            user.name = "馬場#{i}"
            user.facebook_id = fbid
            user.id = sha1_hash.digest 'hex'
            if i%2 is 0
              user.profile.gender = 'male'
            else
              user.profile.gender = 'female'
            age = parseInt (20+(Math.floor(Math.random()*40)))
            user.profile.age = age
            user.isMarried = false
            user.profile.image_url = "/image/friends/#{if i%24 is 0 then 25 else i%24}.jpg"
            user.profile.message = "こんばんわ！#{i}です！"
            user.isSupporter = false
            p = user.profile
            p.birthday = Date.now()
            p.martialHistory = i%4
            p.hasChild = i%5
            p.wantMarriage = i%6
            p.wantChild = i%6
            p.address = i%48
            p.hometown = i%48
            p.job = i%23
            p.income = i*100
            p.height = 160+(i*30)
            p.education = i%7
            p.bloodType = i%5
            p.shape = i%9
            p.drinking = i%7
            p.smoking = i%5
            news = new News()
            news.text = "#{i}さんがDing Dongを始めました！"
            user.news.push news
            user.save()
      done()

  else
    done()