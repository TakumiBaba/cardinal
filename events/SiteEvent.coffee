exports.SiteEvent = (app) ->

  {Site} = app.settings.models

  success: (req, res) ->
    Site.find {}, {}, {}, (err, sites) ->
      res.render 'site_success',
        req: req
        sites: sites

  failure: (req, res) ->
    res.statusCode = 404
    res.render 'site_failure', env: arguments
