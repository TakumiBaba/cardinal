mongoose = require 'mongoose'
Schema = mongoose.Schema
{ObjectId} = Schema.Types
{Mixed} = Schema.Types

# SiteSchema = new Schema
#   text: { type: String }
#   created: { type: Date, default: Date.now() }
#   updated: { type: Date, default: Date.now() }

# SiteSchema.statics.findById = (id, callback) ->
#   @findOne _id: id, {}, {}, (err, site) ->
#     console.error err if err
#     return callback err, site

# SiteSchema.pre 'save', (next) ->
#   @updated = Date.now()
#   return next()

UserSchema = new Schema
  name:
    type: String
  first_name:
    type: String
  last_name:
    type: String
  facebook_id:
    type: String
  id:
    type: String
  created_at:
    type: Date
    default: Date.now
  username:
    type: String
  profile:
    image_url:
      type: String
    age:
      type: Number
      default: 22
    gender:
      type: String
      default: ""
    birthday:
      type: Date
    martialHistory:
      type: Number
      default: 0
    hasChild:
      type: Number
      default: 0
    wantMarriage:
      type: Number
      default: 0
    wantChild:
      type: Number
      default: 0
    address:
      type: Number
      default: 0
    hometown:
      type: Number
      default: 0
    job:
      type: Number
      default: 0
    income:
      type: Number
      default: 0
    height:
      type: Number
      default: 0
    education:
      type: Number
      default: 0
    bloodType:
      type: Number
      default: 0
    shape:
      type: Number
      default: 0
    drinking:
      type: Number
      default: 0
    smoking:
      type: Number
      default: 0
    hoby:
      type: String
      default: ""
    like:
      type: [String]
    message:
      type: String
      default: ""
    ageRangeMin:
      type: Number
      default: 22
    ageRangeMax:
      type: Number
      default: 60
    idealPartner:
      type: String
      default: ""
  candidates:
    type: [{type: ObjectId, ref: "Candidate"}]
    default: []
  following:
    type: [{type: ObjectId, ref: "Follow"}]
  follower:
    type: [{type: ObjectId, ref: "Follow"}]
  pending:
    type: [{type: ObjectId, ref: "Follow"}]
    default: []
  request:
    type: [{type: ObjectId, ref: "Follow"}]
    default: []
  profile_message:
    type: String
  talks:
    type: [{type: ObjectId, ref: "Talk"}]
    default: []
  isSupporter:
    type: Boolean
    default: true
  isFirstLogin:
    type: Boolean
    default: false
  messages:
    type: [{type: ObjectId, ref: "Message"}]
    default: []
  messageLists: [{type: ObjectId, ref: "MessageList"}]
  supporter_message:
    type: [{type: ObjectId, ref: "SupporterMessage"}]
    default: []
  updatedAt:
    type: Date
  news:
    type: [{type: ObjectId, ref: "News"}]
  statuses:
    type: [{type: ObjectId, ref: "Status"}]


StatusSchema = new Schema
  one:
    type: ObjectId
    ref: "User"
  two:
    type: ObjectId
    ref: "User"
  ids:
    type: [String]
  one_status:
    type: Boolean
    default: false
  one_isSystemMatching:
    type: Boolean
    default: true
  two_status:
    type: Boolean
    default: false
  two_isSystemMatching:
    type: Boolean
    default: true
  lastUpdated:
    type: Date

StatusSchema.pre 'save', (next)->
  @lastUpdated = Date.now()
  next()

FollowSchema = new Schema
  # user:
  #   type: ObjectId
  #   ref: "User"
  from:
    type: ObjectId
    ref: "User"
  to:
    type: ObjectId
    ref: "User"
  ids:
    type: [String]
  request_id:
    type: String
  approval:
    type: Boolean
    default: false

CandidateSchema = new Schema
  user:
    type: ObjectId
    ref: "User"
  # user:
  #   type: String
  createdAt:
    type: Date
    default: Date.now
  isSystemMatching:
    type: Boolean
    default: true
  status:
    type: Number
    default: 0

TalkSchema = new Schema
  user:
    type: ObjectId
    ref: "User"
  created_at:
    type: Date
    default: Date.now
  comments:
    type: [type: ObjectId, ref: "Comment"]
    default: []
  candidate:
    type: ObjectId
    ref: "User"
  updatedAt:
    type: Date
    default: Date.now

TalkSchema.post 'save', (next)->
  User = mongoose.model 'User', UserSchema
  News = mongoose.model 'News', NewsSchema
  @updatedAt = Date.now()
  userId = @user
  candidateId = @candidate
  User.findOne({_id: @user}).exec (err, user)->
    throw err if err
    if user
      news = new News
        type: "talk"
        isRead: false
      user.news.push news
      news.save()
      user.save()
    next()
  # User.find({_id: {$in: [@user, @candidate]}}).exec (err, users)=>
  #   throw err if err
  #   if users.length is 2
  #     console.log 'generate news'
  #     user = _.find users, (u)=>
  #       return u._id is userId

  #     news1 = new News
  #       type: "talk"
  #       isRead: false
  #     news2 = new News
  #       type: "talk"
  #       isRead: false
  #     users[0].news.push news1
  #     users[1].news.push news2
  #     news1.save()
  #     news2.save()
  #     users[0].save()
  #     users[1].save()
  #   next()

CommentSchema = new Schema
  user:
    type: String
  text:
    type: String
  count:
    type: Number
    default: 0
  created_at:
    type: Date
    default: Date.now()

SupporterMessageSchema = new Schema
  supporter:
    type: ObjectId
    ref: "User"
  # supporter:
  #   type: String
  supporterId:
    type: String
  message:
    type: String
  count:
    type: Number
    default: 0

NewsSchema = new Schema
  created_at:
    type: Date
    default: new Date()
  type:
    type: String
  isRead:
    type: Boolean
    default: false

MessageSchema = new Schema
  created_at:
    type: Date
    default: Date.now
  text:
    type: String
  from:
    type: ObjectId
    ref: "User"
  from_name:
    type: String
  parent:
    type: ObjectId
    ref: "MessageList"

MessageListSchema = new Schema
  created_at:
    type: Date
    default: Date.now
  one:
    type: ObjectId
    ref: "User"
  two:
    type: ObjectId
    ref: "User"
  messages:
    type: [{type: ObjectId, ref: "Message"}]
    default: []
  lastUpdated:
    type: Date

MessageSchema.post 'save', (next)->
  News = mongoose.model 'News', NewsSchema
  User = mongoose.model 'User', UserSchema
  MessageList = mongoose.model 'MessageList', MessageListSchema
  @lastUpdated = Date.now()
  fromId = @from
  MessageList.findOne({_id: @parent}).populate('one', 'id _id').populate('two', 'id _id').exec (err, ml)=>
    throw err if err
    console.log "messge list"
    console.log ml
    candidateId = if ml.one._id is fromId then ml.one.id else ml.two.id
    User.findOne {id: candidateId}, (err , user)=>
      throw err if err
      console.log user
      if user
        news = new News
          type: "message"
          isRead: false
        user.news.push news
        news.save()
        user.save()
      return false


module.exports =
  User: mongoose.model 'User', UserSchema
  UserSchema: UserSchema
  Candidate: mongoose.model 'Candidate', CandidateSchema
  CandidateSchema: CandidateSchema
  Talk: mongoose.model 'Talk', TalkSchema
  TalkSchema: TalkSchema
  Comment: mongoose.model 'Comment', CommentSchema
  CommentSchema: CommentSchema
  SupporterMessage: mongoose.model 'SupporterMessage', SupporterMessageSchema
  SupporterMessageSchema: SupporterMessageSchema
  News: mongoose.model 'News', NewsSchema
  NewsSchema: NewsSchema
  Message: mongoose.model 'Message', MessageSchema
  MessageSchema: MessageSchema
  MessageList: mongoose.model 'MessageList', MessageListSchema
  MessageListSchema: MessageListSchema
  Follow: mongoose.model 'Follow', FollowSchema
  FollowSchema: FollowSchema
  Status: mongoose.model 'Status', StatusSchema
  StatusSchema: StatusSchema