mongoose = require 'mongoose'
Schema = mongoose.Schema
{ObjectId} = Schema.Types
{Mixed} = Schema.Types

SiteSchema = new Schema
  text: { type: String }
  created: { type: Date, default: Date.now() }
  updated: { type: Date, default: Date.now() }

SiteSchema.statics.findById = (id, callback) ->
  @findOne _id: id, {}, {}, (err, site) ->
    console.error err if err
    return callback err, site

SiteSchema.pre 'save', (next) ->
  @updated = Date.now()
  return next()

module.exports =
  Site: mongoose.model 'sites', SiteSchema
  SiteSchema: SiteSchema