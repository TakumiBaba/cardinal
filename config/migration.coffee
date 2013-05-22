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

  lastNames = ["佐藤","鈴木","高橋","田中","伊藤","山本","渡辺","中村","小林","加藤","吉田","山田","佐々木","山口","松本","井上","木村","斎藤","林","清水","山崎","阿部","森","池田","橋本","山下","石川","中島","前田","藤田","小川","後藤","岡田","長谷川","村上","石井","近藤","坂本","遠藤","藤井","青木","西村","福田","斉藤","太田","藤原","三浦","岡本","松田","中川","中野","小野","原田","田村","竹内","金子","和田","中山","石田","上田","森田","柴田","酒井","原","横山","宮崎","工藤","宮本","内田","高木","谷口","安藤","大野","丸山","今井","高田","藤本","河野","小島","村田","武田","上野","杉山","増田","平野","菅原","小山","久保","大塚","千葉","松井","岩崎","木下","松尾","野口","野村","佐野","菊地","渡部"]
  firstNames_men = ["蓮","颯太","大翔","大和","翔太","湊","悠人","大輝","蒼空","龍生","陽","陽斗","陸","陸斗","颯真","瑛太","悠真","颯汰","樹","蒼大","悠斗","陽太","一颯","結人","虎太郎","太陽","隼人","遥斗","陽向","颯","海翔","優心","陽翔","龍之介","翔","輝","結斗","春輝","晴","蒼","蒼介","智也","直輝","優希","悠翔","陽大","翼","琉生","颯介","絢斗"]
  firstNames_women = ["結衣","陽菜","結菜","結愛","ひなた","心春","心愛","凜","美桜","芽依","優奈","美結","心咲","葵","花音","心菜","愛莉","心音","優愛","陽葵","さく","芽生","優花","優月","柚希","綾音","杏奈","一花","真央","美羽","優衣","凛","莉子","莉緒","愛菜","杏","琴音","結","咲希","七海","心結","楓","優菜","蘭","莉愛","莉央","結月","咲良","志歩","雫","朱里","朱莉","心","心晴"]

  if app.settings.config.migration
    console.log 'migration'

    User.find {}, (err, users)->
      _.each users, (user)->
        user.remove()
      Message.find {}, (err, messages)->
        _.each messages, (message)->
          message.remove()
      Follow.find {}, (err, follows)->
        _.each follows, (follow)->
          follow.remove()
      Talk.find {}, (err, talks)->
        _.each talks, (talk)->
          talk.remove()
      Status.find {}, (err, statuses)->
        _.each statuses, (status)->
          status.remove()

      _.each [0..100], (i)=>
        fbid = i+10000
        User.findOne facebook_id: fbid, (err, user)=>
          console.log err if err
          unless user
            user = new User()
            sha1_hash = Crypto.createHash 'sha1'
            sha1_hash.update "#{i+10000}"
            lastName = lastNames[i]
            k = Math.floor i/2
            console.log k
            firstName = if i%2 is 0 then firstNames_men[k] else firstNames_women[k]
            user.name = "#{lastName}#{firstName}"
            user.first_name = firstName
            user.last_name = lastName
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
            console.log user.name
            user.save()
      done()

  else
    done()
