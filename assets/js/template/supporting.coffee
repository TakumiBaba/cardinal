JST = window.App.JST

JST['supporting/supportermessage/li'] = _.template(
  """
  <div class='s-message-left'>
    <img src="<%= source %>" />
  </div>
  <div class='s-message-right'>
    <% if(isMyMessage != false){ %>
      <div class='s-message-header'><%= name %>さん
        <a href='/#/s/' class='delete-supporter-message'>この情報を削除する</a>
        <a class='modify-supporter-message'>編集する</a>
      </div>
    <% }else{ %>
      <div class='s-message-header'><%= name %>さん </div>
    <% }%>
    <div class='s-message-body'>
      <small><%= message %></small>
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
    <a class='like' href="/#/"><img src="/image/iine_button.gif" /></a>
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
