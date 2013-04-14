module.exports = (app) ->

  SiteEvent = app.settings.events.SiteEvent app

  # {ensure}
  log = app.settings.helper.logger no

  app.get    '/',  log,  SiteEvent.success

  return SiteEvent.failure