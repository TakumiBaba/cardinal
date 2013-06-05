JST = window.App.JST

JST['supporter/following/thumbnail'] = _.template(
  """
    <div class='thumbnail'>
      <a href='/#/s/' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %>さん</h5>
      </a>
      <a class='delete'>削除する</a>
    </div>
  """
  )
JST['supporter/follower/thumbnail'] = _.template(
  """
    <div class='thumbnail'>
      <a class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %>さん</h5>
      </a>
      <a class='delete'>削除する</a>
    </div>
  """
  )

JST['supporter/request/thumbnail'] = _.template(
  """
    <div class='thumbnail'>
      <a href='/#/s/' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %>さん</h5>
      </a>
      <a href="/#/request" class='request'>応援する</a>
      <a href="/#/delete" class='delete'>削除する</a>
    </div>
  """
  )