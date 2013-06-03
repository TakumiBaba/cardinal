JST = window.App.JST

JST['supporting/supportermessage/li'] = _.template(
  """
  <div class='s-message-left'>
    <img src="<%= source %>" />
  </div>
  <div class='s-message-right'>
    <% if(isMyMessage != false){ %>
      <div class='s-message-header'><%= name %>さん <a href='/#/s/' class='delete-supporter-message'>この情報を削除する</a></div>
    <% }else{ %>
      <div class='s-message-header'><%= name %>さん </div>
    <% }%>
    <div class='s-message-body'>
      <%= message %>
    </div>
  </div>

  """
  )

JST['supporting/matching/supporter'] = _.template(
  """
  <div class='thumbnail'>
    <a href='/#/user/<%= id %>' class='to-user'>
      <img src=<%= source %> />
      <h5><%= name %>さん</h5>
    </a>
    <a class='to-talk'><span>応援トークをする</span></a>
  </div>
  """
  )


JST['supporting/matching/system'] = _.template(
  """
  <div class='thumbnail'>
    <a href='/#/u/<%= id %>' class='to-user'>
      <img src=<%= source %> />
      <h5><%= name %>さん</h5>
    </a>
    <button class='like-action'>イイね！</button>
    <a class='to-talk'><span>応援トークをする</span></a>
  </div>
  """
  )

JST['supporting/like/thumbnail'] = _.template(
  """
  <div class='thumbnail'>
    <a href='/#/user/<%= id %>' class='to-user'>
      <img src=<%= source %> />
      <h5><%= name %>さん</h5>
    </a>
    <a class='to-talk'><span>応援トークをする</span></a>
  </div>
  """
  )
