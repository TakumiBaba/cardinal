util = require 'util'
moment = require 'moment'

# connect-logger replacement
#   app.use helper.log

exports.logger = (unknown = no) ->
  return (req, res, next) ->
    ini = Date.now()
    end = res.end
    res.end = ->
      res.end = end
      res.emit 'end'
      res.end.apply @, arguments
    res.on 'end', ->
      util.print "\x1b[90m[#{moment().format('YY.MM.DD HH:mm:ss')}] "
      if unknown
        util.print "\x1b[31m[Unknown]\x1b[0m "
      else
        util.print "\x1b[35m#{req.method.toUpperCase()} "
      util.print "\x1b[37m#{req.url} "
      if 500 <= @statusCode
        util.print "\x1b[31m#{@statusCode}\x1b[0m "
      else if 400 <= @statusCode
        util.print "\x1b[33m#{@statusCode}\x1b[0m "
      else if 300 <= @statusCode
        util.print "\x1b[36m#{@statusCode}\x1b[0m "
      else if 200 <= @statusCode
        util.print "\x1b[32m#{@statusCode}\x1b[0m "
      if req.route
        util.print "\x1b[90m(#{req.route.path} - #{Date.now() - ini}ms) "
      else
        util.print "\x1b[90m(#{Date.now() - ini}ms) "
      util.print "\x1b[0m\n"
    next()
