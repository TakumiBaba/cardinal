# DingDong

## 依存

* node.js
* mongodb


## 初回

    npm install

## 起動

    node web

or

    coffee app


## 設定

`config/application.json`


## 特徴

* 静的ファイルの配信にstを使っているので静的配信も早め
* requireするのに逐一パス書かなくてもよい
* ルーターは1ファイルに見やすくまとめる
* production以外ではjadeをminifyしない
* productionで起動すると全部minifyされる
* CPUのスレッド数に応じてfork、マルチプロセスで起動
  * 落ちたプロセスは自動で再起動する
* 独自のロガーを使用
* Fallbackを組み込み(404)


## サンプル

実装されてるサンプル

* dbをマイグレーション、dbから文書を表示する
* sessionマネージャは組み込んであるが認証機構は組み込んでない
* passportをご利用ください


## フォルダ

* assets
  * css: cssかstylを書く、npm install lessすればlessも書ける
  * js: jsかcoffeeを書く
* config
  * migration: DBにインポートする初期データとかを書く
  * routes: ルートの定義
* events
  * routesから呼ばれるメソッドの実装
  * 文字数が揃えたかっただけ、コントローラと呼んでも構わない
* models
  * mongooseのスキーマ定義
* helper
  * 各所でよく呼ばれるメソッド
* public
  * webルートだよ！
  * assetsはここにビルドされる、二回目以降はstが配信する
  * 変更があるとハッシュが変わるのでちゃんとリロードされます
* views
  * jade置いてください


## eventsの追加

    touch events/SomeEvent.coffee
    vim events/SomeEvent.coffee

      exports.SomeEvent = (app) ->
        hoge: (req, res) ->
          res.end 'Hello, World!!'

    vim config/routes.coffee

      SomeEvent = app.settings.events.SomeEvent app

      app.get '/hoge', SomeEvent.hoge


## modelsの追加

    touch models/SomeModel.coffee
    vim models/SomeModel.coffee

      mongoose = require 'mongoose'
      Schema   = mongoose.Schema
      ObjectId = Schema.Types.ObjectId
      Mixed    = Schema.Types.Mixed

      PostSchema = new Schema
        some:  { type: String }

      module.exports =
        Some: mongoose.model 'somes', SomeSchema
        SomeSchema: SomeSchema


### eventsからmodelsをインポート

    vim events/SomeEvent.coffee

      exports.SomeEvent = (app) ->

        {Some} = app.settings.models

        hoge: (req, res) ->
          Some.find {}, {}, {}, (err, somes) ->
            res.end 'Hello, World!!', somes: somes



## viewからassetsの呼び出し

### js

    !=js('ファイル名')

### css

    !=css('ファイル名')


なんかわかんないことあったらgeta6に聞く

