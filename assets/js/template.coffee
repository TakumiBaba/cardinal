JST = window.App.JST

JST['matching/page'] = _.template(
  """
  <div id='matching_page' class='profile_and_following_view'>
    <h3 class='title_box'>お相手リスト<small>"ビビッと来たら『いいね』をプッシュ！"</small></h2>
    <div class='system_matching box'>
      <div class='sm_side'>
        <ul class='sm_user_list matching_side'>
        </ul>
      </div>
      <div class='sm_main main_box'>
        <div class='matchinguser_menu box_menu'>
          <img class='profile_image pull-left' src='' />
          <h4 class='name'></h4>
          <h5 class='simple_profile'></h5>
          <div class='btn-group'>
            <button class='like btn pink'>いいね！</button>
            <button class='sendMessage btn btn-success'>メッセージを送る</button>
            <button class='recommend btn btn-primary'>友達に勧める</button>
          </div>
        </div>
        <div class='detail_profile'>
          <div class='follower_column'>
            <div class='follower_column_header'>
              <h5>応援団一覧</5>
            </div>
            <div class='follower-column-body'>
              <ul class='follower-list'>
              </ul>
            </div>
          </div>
          <div class='profile-column'>
            <div class='profile-column-header'>
              <h5>プロフィール詳細</5>
            </div>
            <div class='profile-column-body'>
              <table class='table'>
                <tbody>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
    <h3 class='title_box'>応援団おすすめリスト<small>"お相手にもあなたが紹介されています。"</small></h3>
    <div class='supporter_matching box'>
      <div class='sp_side'>
        <ul class='sp_user_list matching_side'>

        </ul>
      </div>
      <div class='sp_main main_box'>
        <div class='matchinguser_menu box_menu'>
          <img class='profile_image pull-left' src='' />
          <h4 class='name'></h4>
          <h5 class='simple_profile'></h5>
          <div class='btn-group'>
            <button class='like btn btn-primary'>いいね！</button>
            <button class='sendMessage btn btn-success'>メッセージを送る</button>
            <button class='recommend btn btn-inverse'>友達に勧める</button>
          </div>
        </div>
        <div class='detail_profile'>
          <div class='profile-column'>
            <div class='profile-column-header'>
              <h5>プロフィール詳細</5>
            </div>
            <div class='profile-column-body'>
              <table class='table'>
                <tbody>
                </tbody>
              </table>
            </div>
          </div>
          <div class='follower_column'>
            <div class='follower_column_header'>
              <h5>応援団一覧</5>
            </div>
            <div class='follower-column-body'>
              <ul class='follower-list'>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """
)

JST['matching/thumbnail'] = _.template(
  """
  <li id=<%= id %> class='user-thumbnail'>
    <img  src=<%= source %> class='img-rounded' />
  </li>
  """)

JST['profile/page'] = _.template(
  """
  <div id="profile_page">
    <h3 class='title_box'>自分のプロフィール</h3>
    <div class='profile box-inner container'>
      <form class="form-horizontal">
        <div class="control-group">
          <label for="profile-image" class="control-label">プロフィール画像</label>
          <div class="controls">
            <img id="profile-image" style="width:100px; height:100px" src="/user/b08b809483972111e976e85e77ac7527add62ad3/picture">
            <ul class="profile-image-list">
            </ul>
          </div>
        </div>
        <div class="control-group">
          <label for="marital" class="control-label">婚姻歴</label>
          <div class="controls">
            <select name="havingMarried" id="havingMarried">
            <% options = ["---","なし","あり"] %>
            <% _.each(options, function(item, i){
                if(martialHistory == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="hasChild" class="control-label">子どもの有無</label>
          <div class="controls">
            <select name="hasChild" id="hasChild">
            <% options = ["---","いない","いる(別居)","いる(同居)"] %>
            <% _.each(options, function(item, i){
                if(hasChild == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="preferredTime" class="control-label">結婚希望時期</label>
          <div class="controls">
            <select name="wantMarriage" id="wantMarriage">
            <% options = ["---","すぐにでも","2〜3年のうちに","お相手に合わせる","特に決めてない"] %>
            <% _.each(options, function(item, i){
                if(wantMarriage == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="preferredChild" class="control-label">子どもの希望</label>
          <div class="controls">
            <select name="wantChild" id="wantChild">
            <% options = ["---","結婚したら欲しい","お相手と相談したい","いなくても構わない","欲しくない","特に決めてない"] %>
            <% _.each(options, function(item, i){
                if(wantChild == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="address" class="control-label">居住地</label>
          <div class="controls">
            <select name="address" id="address">
            <% options = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
            <% _.each(options, function(item, i){
                if(address == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="birthPlace" class="control-label">出身地</label>
          <div class="controls">
            <select name="hometown" id="hometown">
            <% options = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
            <% _.each(options, function(item, i){
                if(hometown == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="job" class="control-label">ご職業</label>
          <div class="controls">
            <select name="job" id="job">
            <% options = ["---","会社員（営業）","会社員（技術）","会社員（企画）","会社員（サービス）","会社員（販売）","会社員（クリエイティブ）","会社員（事務）","会社員（IT）","会社員（その他）","会社役員","会社経営","国家公務員","地方公務員","自営業","専門職","団体職員","派遣社員","アルバイト","家事手伝い","学生","その他"] %>
            <% _.each(options, function(item, i){
                if(job == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="income" class="control-label">年収</label>
          <div class="controls">
            <input type="text" name="income" id="income" value="0"><span class="help-inline">万円</span>
          </div>
        </div>
        <div class="control-group">
          <label for="education" class="control-label">学歴</label>
          <div class="controls">
            <select name="education" id="education">
            <% options = ["---","中学卒","高校卒","短大卒","大卒","大学院卒","その他","指定しない"] %>
            <% _.each(options, function(item, i){
                if(education == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="bloodType" class="control-label">血液型</label>
          <div class="controls">
            <select name="bloodType" id="bloodType">
            <% options = ["---","A","B","O",'AB'] %>
            <% _.each(options, function(item, i){
                if(bloodType == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="height" class="control-label">身長</label>
          <div class="controls">
            <input type="text" id="height" name="height" value="0">
            <span class="help-inline">cm</span>
          </div>
        </div>
        <div class="control-group">
          <label for="shape" class="control-label">体型</label>
          <div class="controls">
            <select name="shape" id="shape">
            <% options = ["---","スリム","細め","ふつう","ぽっちゃり","グラマー","ガッチリ","太め"] %>
            <% _.each(options, function(item, i){
                if(shape == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="drinking" class="control-label">飲酒習慣</label>
          <div class="controls">
            <select name="drinking" id="drinking">
            <% options = ["---","毎日飲む","週3～4日飲む","週1～2日程度","たまに飲む","全く飲まない"] %>
            <% _.each(options, function(item, i){
                if(drinking == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="smoking" class="control-label">喫煙習慣</label>
          <div class="controls">
            <select name="smoking" id="smoking">
            <% options = ["---","よく吸う","たまに吸う","まったく吸わない"] %>
            <% _.each(options, function(item, i){
                if(smoking == i){
                  var option = "<option selected value="+i+">"+item+"</option>"
                }else{
                  var option = "<option value="+i+">"+item+"</option>"
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class="control-group">
          <label for="hoby" class="control-label">趣味</label>
          <div class="controls">
            <textarea rows="3" id="hoby" name="hoby" class="span4">
            </textarea>
          </div>
        </div>
        <div class="control-group">
          <label for="like" class="control-label">好きなもの</label>
          <div class="controls">
            <input type="text" id="like" name="like" value="hoge" class="span2">
          </div>
        </div>
        <div class="control-group">
          <label for="message" class="control-label">お相手へのメッセージ</label>
          <div class="controls">
            <textarea rows="3" id="message" name="message" class="span5">hello</textarea>
          </div>
        </div>
        <div class='form-actions'>
          <button type='button' class='btn btn-primary save'>保存する</button>
          <button type='button' class='btn cancel'>もとに戻す</button>
        </div>
      </form>
    </div>
  </div>
  """)


JST['sidebar/following'] = _.template(
  """
  <li>
    <a href="/#/user/<%= id %>" class='sidebar_following'>
      <img src=<%= source %> />
      <div><p><%= name %>さん</p></div>
    </a>
  </li>
  """
  )

JST['like/page'] = _.template(
  """
  <div id='like_page'>
    <h3 class='title_box'>両思い中<small>"どんどんメッセージを送って会う約束をしよう！"</small></h3>
    <div class='each-like info box-inner container likebox'>
      <ul class='like-thumbnail'></ul>
    </div>
    <h3 class='title_box'>お相手が片思い<small>"ピピっと来たら、『いいね』をプッシュ！"</small></h3>
    <div class='your-like info box-inner container likebox'>
      <ul class='like-thumbnail'></ul>
    </div>
    <h3 class='title_box'>自分が片思い</h3>
    <div class='my-like info box-inner  container likebox'>
      <ul class='like-thumbnail'></ul>
    </div>
  </div>
  """
  )

JST['like/thumbnail'] = _.template(
  """
  <li id="<%= id %>" >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href="/#/user/<%= id %>" class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <button class='like-action btn-block btn btn-primary l_d_<%= state %>'><%= text %></button>
      <a class='to-talk'><span>応援トークをする</span></a></div>
  </li>
  """
  )

JST['talk/page'] = _.template(
  """
  <div id='talk_page'>
    <h4>応援トーク<span>"お気に入りの人について応援団と大いに語ろう！"</span></h4>
    <ul class='talk_list'>
    </ul>
  </div>
  """)

JST['talk/unit'] = _.template(
  """
  <div class='com_box'>
    <div>
      <img src="<%= source %>" class='com_img'/>
    </div>
    <div class='com_line'>
      <p><%= name %>さんから<%= candidate_name %>さんについて相談があります。</p>
      <p><%= last_update %>★</p>
    </div>
  </div>
  <div class='part_box'>
    <div class='part_img'>
      <img src="<%= candidate_source %>" class="part_img" />
    </div>
    <div class='part_line'>
      <% addressArray = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
      <p><%= candidate_name %>さん <%= candidate_age %>歳 / <%= addressArray[address] %>在住</p>
      <% bloodTypeArray = ["---","A","B","O",'AB'] %>
      <p><%= height %>cm <%= bloodTypeArray[blood] %>型</p>
      <p><label>メッセージ:</label><%= profile_message %></p>
      <a href="/#/u/<%= candidate_id %>">詳細を見る</a>
    </div>
  </div>
  <div class='like_box'>
    <span>
      <a href='#'>いいね！(<%= like_count %>)</a>
    </span>
  </div>
  <div class='comments_box'>
  </div>

  <div class='com_box'>
    <div>
      <img src='<%= source %>' class='com_img' />
    </div>
    <div class='reply_box'>
      <textarea class='comment_area' />
      <button class='btn btn-primary send_comment'>コメントする</button>
    </div>
  </div>
  """
  )

JST['talk/comment'] = _.template(
  """
  <li>
    <div class='com_box'>
      <div>
        <img src="<%= source %>" class='com_img' />
      </div>
      <div class='com_line'>
        <p><%= message %></p>
        <span><%= created_at %></span>
      </div>

    </div>
  </li>
  """)