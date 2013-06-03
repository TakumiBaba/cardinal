JST = window.App.JST

JST['supporter/following/thumbnail'] = _.template(
  """
    <div class='thumbnail'>
      <a href='/#/s/' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %>さん</h5>
      </a>
      <button class='btn btn-block delete'>削除する</button>
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
      <button class='btn btn-block delete '>削除する</button>
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
      <button class='btn btn-block request'>応援する</button>
      <button class='btn btn-danger btn-block delete delete-request'>削除する</button>
    </div>
  """
  )