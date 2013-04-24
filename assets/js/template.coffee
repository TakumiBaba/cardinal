JST = window.App.JST

JST['matching/page'] = _.template(
  """
  <div id='matching_page' class='profile_and_following_view'>
    <h3 class='title_box'>お相手リスト<small>ビビッと来たら『いいね』をプッシュ！</small></h2>
    <div class='system_matching box'>
      <div class='sm_side matching_side_div'>
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
            <div class='btn-group recommend'>
              <button class='btn dropdown-toggle' data-toggle='dropdown' href='#'>友達に勧める<span class='caret'></span></button>
              <ul class='dropdown-menu recommend-following' role='menu' aria-labelledby='dLabel'>
                <li class='divider'></li>
              </ul>
            </div>
          </div>
        </div>
        <div class='detail_profile'>
          <div class='profile-column'>
            <div class='profile-column-header'>

              <h5>プロフィール <a href="">詳細をみる</a></5>
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
    <h3 class='title_box'>応援団おすすめリスト<small>お相手にもあなたが紹介されています。</small></h3>
    <div class='supporter_matching box'>
      <div class='sp_side matching_side_div'>
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
  <div id='profile_page'>
    <h3 class='title_box'>自分のプロフィール</h3>
    <div class='profile box-inner container'>
      <form class='form-horizontal'>
        <div class='control-group'>
          <label for='profile-image' class='control-label'>プロフィール画像</label>
          <div class='controls'>
            <img id='profile-image' style='width:100px; height:100px' src=''>
            <ul class='profile-image-list'>
            </ul>
          </div>
        </div>
        <div class='control-group'>
          <label for='marital' class='control-label'>婚姻歴</label>
          <div class='controls'>
            <select name='havingMarried' id='havingMarried'>
            <% options = ['---','なし','あり'] %>
            <% _.each(options, function(item, i){
                if(martialHistory == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='hasChild' class='control-label'>子どもの有無</label>
          <div class='controls'>
            <select name='hasChild' id='hasChild'>
            <% options = ['---','いない','いる(別居)','いる(同居)'] %>
            <% _.each(options, function(item, i){
                if(hasChild == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='preferredTime' class='control-label'>結婚希望時期</label>
          <div class='controls'>
            <select name='wantMarriage' id='wantMarriage'>
            <% options = ['---','すぐにでも','2〜3年のうちに','お相手に合わせる','特に決めてない'] %>
            <% _.each(options, function(item, i){
                if(wantMarriage == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='preferredChild' class='control-label'>子どもの希望</label>
          <div class='controls'>
            <select name='wantChild' id='wantChild'>
            <% options = ['---','結婚したら欲しい','お相手と相談したい','いなくても構わない','欲しくない','特に決めてない'] %>
            <% _.each(options, function(item, i){
                if(wantChild == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='address' class='control-label'>居住地</label>
          <div class='controls'>
            <select name='address' id='address'>
            <% options = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
            <% _.each(options, function(item, i){
                if(address == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='birthPlace' class='control-label'>出身地</label>
          <div class='controls'>
            <select name='hometown' id='hometown'>
            <% options = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
            <% _.each(options, function(item, i){
                if(hometown == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='job' class='control-label'>ご職業</label>
          <div class='controls'>
            <select name='job' id='job'>
            <% options = ['---','会社員（営業）','会社員（技術）','会社員（企画）','会社員（サービス）','会社員（販売）','会社員（クリエイティブ）','会社員（事務）','会社員（IT）','会社員（その他）','会社役員','会社経営','国家公務員','地方公務員','自営業','専門職','団体職員','派遣社員','アルバイト','家事手伝い','学生','その他'] %>
            <% _.each(options, function(item, i){
                if(job == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='income' class='control-label'>年収</label>
          <div class='controls'>
            <input type='text' name='income' id='income' value='0'><span class='help-inline'>万円</span>
          </div>
        </div>
        <div class='control-group'>
          <label for='education' class='control-label'>学歴</label>
          <div class='controls'>
            <select name='education' id='education'>
            <% options = ['---','中学卒','高校卒','短大卒','大卒','大学院卒','その他','指定しない'] %>
            <% _.each(options, function(item, i){
                if(education == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='bloodType' class='control-label'>血液型</label>
          <div class='controls'>
            <select name='bloodType' id='bloodType'>
            <% options = ['---','A','B','O','AB'] %>
            <% _.each(options, function(item, i){
                if(bloodType == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='height' class='control-label'>身長</label>
          <div class='controls'>
            <input type='text' id='height' name='height' value='0'>
            <span class='help-inline'>cm</span>
          </div>
        </div>
        <div class='control-group'>
          <label for='shape' class='control-label'>体型</label>
          <div class='controls'>
            <select name='shape' id='shape'>
            <% options = ['---','スリム','ふつう','ぽっちゃり','グラマー','ガッチリ','太め'] %>
            <% _.each(options, function(item, i){
                if(shape == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='drinking' class='control-label'>飲酒習慣</label>
          <div class='controls'>
            <select name='drinking' id='drinking'>
            <% options = ['---','毎日飲む','週3～4日飲む','週1～2日程度','たまに飲む','全く飲まない'] %>
            <% _.each(options, function(item, i){
                if(drinking == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='smoking' class='control-label'>喫煙習慣</label>
          <div class='controls'>
            <select name='smoking' id='smoking'>
            <% options = ['---','よく吸う','たまに吸う','まったく吸わない'] %>
            <% _.each(options, function(item, i){
                if(smoking == i){
                  var option = '<option selected value='+i+'>'+item+'</option>'
                }else{
                  var option = '<option value='+i+'>'+item+'</option>'
                }%>
                <%= option %>
            <%}); %>
            </select>
          </div>
        </div>
        <div class='control-group'>
          <label for='hoby' class='control-label'>趣味</label>
          <div class='controls'>
            <textarea rows='3' id='hoby' name='hoby' class='span4'>
            </textarea>
          </div>
        </div>
        <div class='control-group'>
          <label for='like' class='control-label'>好きなもの</label>
          <div class='controls'>
            <input type='text' id='like' name='like' value='hoge' class='span2'>
          </div>
        </div>
        <div class='control-group'>
          <label for='message' class='control-label'>お相手へのメッセージ</label>
          <div class='controls'>
            <textarea rows='3' id='message' name='message' class='span5'>hello</textarea>
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
    <a href='/#/s/<%= id %>' class='sidebar_following'>
      <img src=<%= source %> />
      <div><p><%= name %>さん</p></div>
    </a>
  </li>
  """
  )

JST['like/page'] = _.template(
  """
  <div id='like_page'>
    <h3 class='title_box'>両思い中<small>'どんどんメッセージを送って会う約束をしよう！'</small></h3>
    <div class='each-like info box-inner container likebox'>
      <ul class='like-thumbnail'></ul>
    </div>
    <h3 class='title_box'>お相手が片思い<small>'ピピっと来たら、『いいね』をプッシュ！'</small></h3>
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
  <li id='<%= id %>' >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href='/#/u/<%= id %>' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <button class='like-action btn-block btn btn-primary l_d_<%= status %>'><%= text %></button>
      <a class='to-talk'><span>応援トークをする</span></a></div>
  </li>
  """
  )

JST['talk/page'] = _.template(
  """
  <div id='talk_page'>
    <h3 class='title_box'>応援トーク<small class=''>お気に入りの人について応援団と大いに語ろう！</small></h3>
    <ul class='talk_list'>
    </ul>
  </div>
  """)

JST['talk/unit'] = _.template(
  """
  <div class='com_box'>
    <div>
      <img src='<%= another_source %>' class='com_img'/>
    </div>
    <div class='com_line'>
      <p><%= name %>さんから<%= candidate_name %>さんについて相談があります。</p>
      <p><%= last_update %>★</p>
    </div>
  </div>
  <div class='part_box'>
    <div class='part_img'>
      <img src='<%= candidate_source %>' class='part_img' />
    </div>
    <div class='part_line'>
      <% addressArray = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
      <p><%= candidate_name %>さん <%= candidate_age %>歳 / <%= addressArray[address] %>在住</p>
      <% bloodTypeArray = ['---','A','B','O','AB'] %>
      <p><%= height %>cm <%= bloodTypeArray[blood] %>型</p>
      <p><label>メッセージ:</label><%= profile_message %></p>
      <a href='/#/u/<%= candidate_id %>'>詳細を見る</a>
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
        <img src='<%= source %>' class='com_img' />
      </div>
      <div class='com_line'>
        <p><%= message %></p>
        <span><%= created_at %></span>
      </div>

    </div>
  </li>
  """)

JST['message/page'] = _.template(
  """
  <div id='message_page'>
    <h4>お相手からのメッセージ<small>'このページは応援団は閲覧できません'</small></h4>
    <div class='user-list-column'>
      <ul class='message-user-thumbnail'>
      </ul>
    </div>
    <div id='message-list-view'>
      <div class='message-header'>
        <h5></h5>
      </div>
      <div class='message-body'>
        <ul></ul>
      </div>
      <div class='message-footer'>
        <img src='<%= source %>' class='com_img' />
        <div class='reply_box'>
          <textarea class='message' />
          <button class='btn btn-primary send_message'>メッセージを送る</button>
        </div>
        <!-- メッセージポストView -->
    </div>
  </div>
  """
  )

JST['message/user-thumbnail'] = _.template(
  """
  <li id='<%= id %>' class='m_thumbnail_li'>
    <img src='<%= source %>' class='img-rounded m_thumbnail' />
  </li>
  """
  )

JST['message/body'] = _.template(
  """
  <li>
    <div class='message_clm'>
      <div class='message_left'><img src='<%= source %>' class='message_img' /></div>
      <div class='message_line'>
        <p><a href='' class='b'><%= name %>さん</a></p>
        <p><%= text %></p>

        <small><%= created_at %></small>
      </div>
    </div>
  </li>
  """
)

JST['userpage/detailProfile'] = _.template(
  """
  <tr>
    <td class='span2 key'>メッセージ</td><td colspan='3'><%= message %></td>
  </tr>
  <% martialHistoryArray = ['---','なし','あり'] %>
  <% childrenArray = ['---','いない','いる(別居)','いる(同居)'] %>
  <tr>
    <td class='key'>結婚歴</td><td><%= martialHistoryArray[martialHistory] %></td>
    <td class='key'>子供の有無</td><td><%= childrenArray[hasChild] %></td>
  </tr>
  <% wantMarriageArray = ['---','すぐにでも','2〜3年のうちに','お相手に合わせる','特に決めてない'] %>
  <% wantChildArray = ['---','結婚したら欲しい','お相手と相談したい','いなくても構わない','欲しくない','特に決めてない'] %>
  <tr>
    <td class='key'>結婚希望時期</td><td><%= wantMarriageArray[wantMarriage] %></td>
    <td class='key'>子どもの希望</td><td><%= wantChildArray[wantChild] %></td>
  </tr>
  <% addressArray = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
  <% hometownArray = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
  <tr>
    <td class='key'>居住地</td><td><%= addressArray[address] %></td>
    <td class='key'>出身地</td><td><%= hometownArray[hometown] %></td>
  </tr>
  <% jobArray = ['会社員（営業）','会社員（技術）','会社員（企画）','会社員（サービス）','会社員（販売）','会社員（クリエイティブ）','会社員（事務）','会社員（IT）','会社員（その他）','会社役員','会社経営','国家公務員','地方公務員','自営業','専門職','団体職員','派遣社員','アルバイト','家事手伝い','学生','その他'] %>
  <tr>
    <td class='key'>ご職業</td><td><%= jobArray[job] %></td>
    <td class='key'>年収</td><td><%= income %>万円</td>
  </tr>
  <% educationArray = ['---','中学卒','高校卒','短大卒','大卒','大学院卒','その他'] %>
  <% bloodTypeArray = ['---','A','B','O','AB'] %>
  <tr>
    <td class='key'>学歴</td><td><%= educationArray[education] %></td>
    <td class='key'>血液型</td><td><%= bloodTypeArray[bloodType] %></td>
  </tr>
  <% shapeArray = ['---','スリム','ふつう','ぽっちゃり','グラマー','ガッチリ','太め'] %>
  <tr>
    <td class='key'>身長</td><td><%= height %>cm</td>
    <td class='key'>体型</td><td><%= shapeArray[shape] %></td>
  </tr>

  <% drinkingArray = ['---','毎日飲む','週3～4日飲む','週1～2日程度','たまに飲む','全く飲まない'] %>
  <% smokingArray = ['---','よく吸う','たまに吸う','まったく吸わない'] %>
  <tr>
    <td class='key'>飲酒習慣</td><td><%= drinkingArray[drinking] %></td>
    <td class='key'>喫煙習慣</td><td><%= smokingArray[smoking] %></td>
  </tr>
  """
  )

JST['matching/follower'] = _.template(
  """
  <li>
    <div class='media'>
      <a href=<%= facebook_url %> >
        <img src=<%= source %> class='pull-left' />
        <div class='media-body'>
          <h5><%= name %></h5>
        </div>
      </a>
    </div>
  </li>
  """
  );

JST['supporting/userpage/page'] = _.template(
  """
  <div id='user_page' class='profile_and_following_view'>
    <h3 class='title_box'>ユーザーページ</h2>
    <div class='box'>
      <div class='user_profiles main_box'>
        <div class='box_menu'>
          <img class='profile_image pull-left' src='<%= image_source %>' />
          <h4 class='name'><%= name %>さん</h4>
          <h5 class='simple_profile'><%= gender_birthday %></h5>
          <div class='btn-group'>
            <button class='recommend btn btn-primary disabled'>友達に勧める</button>
          </div>
        </div>
        <div class='detail_profile pull-left'>
          <div class='tabbable'>
            <ul class='nav nav-tabs supporter-menu'>
              <li class='active'><a href='#detailprofile' data-toggle='tab'>プロフィール詳細</a></li>
              <li><a href='#matchinglist' data-toggle='tab'>マッチングリスト</a></li>
              <li><a href='#likelist' data-toggle='tab'>いいねリスト</a></li>
              <li><a href='#supportertalk' data-toggle='tab'>応援団トーク</a></li>
            </ul>
            <div class='tab-content'>
              <!-- プロフィール -->
              <div class='tab-pane active' id='detailprofile'></div>
              <!-- マッチングリスト -->
              <div class='tab-pane' id='matchinglist'>
                <h3 class='title_box'>マッチング情報</h3>
                <div class='system info box-inner container likebox'>
                  <ul class='userpage-like-thumbnail'>
                  </ul>
                </div>
                <h3 class='title_box'>応援団おすすめ情報</h3>
                <div class='supporter info box-inner container likebox'>
                  <ul class='userpage-like-thumbnail'></ul>
                </div>
              </div>
              <!-- いいねリスト -->
              <div class='tab-pane' id='likelist'>
                <h3 class='title_box'>両思い中<small>'どんどんメッセージを送って会う約束をしよう！'</small></h3>
                <div class='each-like info box-inner container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
                <h3 class='title_box'>お相手が片思い<small>'ピピっと来たら、『いいね』をプッシュ！'</small></h3>
                <div class='your-like info box-inner container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
                <h3 class='title_box'><%= name %>さんが片思い</h3>
                <div class='my-like info box-inner  container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
              </div>
              <!-- 応援団トーク -->
              <div class='tab-pane' id='supportertalk'>
                <ul class='talk_list'>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """
  )

JST['userpage/profile'] = _.template(
  """
  <div class='profile_column pull-left'>
    <h5>プロフィール詳細</h5>
    <table class='table'>
      <tbody>
      <% html = App.JST['userpage/detailProfile'](profile) %>
      <%= html %>
      </tbody>
    </table>
  </div>
  <div class='follower_column'>
    <h5>応援団一覧</h5>
    <ul class='follower-list pull-left'>
    </ul>
  </div>
  <!-- ここに応援団のメッセージ一覧&投稿画面が出てくる -->
  """
)

JST['userpage/matching-thumbnail'] = _.template(
  """
  <li id=<%= id %> class='userpage-matching-thumbnail'>
    <a href='/#/u/<%= id %>'>
      <img  src=<%= source %> class='img-rounded' />
    </a>
  </li>
  """
)

JST['userpage/sys_matching/thumbnail'] = _.template(
  """
  <li id='<%= id %>' >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href='/#/user/<%= id %>' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <button class='like-action btn-block btn btn-primary l_d_<%= status %>'><%= text %></button>
      <a class='to-talk'><span>応援トークをする</span></a></div>
  </li>
  """
  )
JST['userpage/sup_matching/thumbnail'] = _.template(
  """
  <li id='<%= id %>' >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href='/#/user/<%= id %>' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <a class='to-talk'><span>応援トークをする</span></a></div>
  </li>
  """
  )
JST['userpage/like/thumbnail'] = _.template(
  """
  <li id='<%= id %>' >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href='/#/user/<%= id %>' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <a class='to-talk'><span>応援トークをする</span></a></div>
  </li>
  """
  )

JST['candidate/page'] = _.template(
  """
  <div id='user_page' class='profile_and_following_view'>
    <h3 class='title_box'>ユーザーページ</h2>
    <div class='box'>
      <div class='user_profiles main_box'>
        <div class='box_menu'>
          <img class='profile_image pull-left' src='<%= image_source %>' />
          <h4 class='name'><%= name %>さん</h4>
          <h5 class='simple_profile'><%= gender_birthday %></h5>
          <button class='like btn btn-primary'>いいね！</button>
          <button class='send-message btn btn-success'>メッセージを送る</button>
          <div class='btn-group recommend'>
            <button class='btn dropdown-toggle' data-toggle='dropdown' href='#'>友達に勧める<span class='caret'></span></button>
            <ul class='dropdown-menu recommend-following' role='menu' aria-labelledby='dLabel'>
              <li class='divider'></li>
            </ul>
          </div>
          <!-- <button class='recommend btn btn-primary'>友達に勧める</button> -->
        </div>
        <div class='detail_profile pull-left'>
          <div id='detailprofile'>
            <div class='profile_column pull-left'>
              <h5>プロフィール詳細</h5>
              <table class='table'>
                <tbody>
                <% html = App.JST['userpage/detailProfile'](profile) %>
                <%= html %>
                </tbody>
              </table>
            </div>
            <div class='follower_column'>
              <h5>応援団一覧</h5>
              <ul class='follower-list pull-left'>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """
  )

JST['supporter/page'] = _.template(
  """
  <div id='supporter_list_page'>
    <div id='following' class='thumbnail_box clearfix'>
      <h3>応援中の仲間</h3>
      <ul class='user_list'>
      </ul>
    </div>
    <div id='follower' class='thumbnail_box clearfix'>
      <h3>応援してくれている仲間</h3>
      <ul class='user_list'>
      </ul>
    </div>
    <div id='request' class='thumbnail_box clearfix'>
      <h3>応援申請</h3>
      <ul class='user_list'>
      </ul>
    </div>
    <!--<div id='pending' class='thumbnail_box clearfix'>
      <h3>応援申請待ち</h3>
      <ul class='user_list'>
      </ul>
    </div> -->
  </div>
  """
)
JST['supporter/supporter-page'] = _.template(
  """
  <div id='supporter_list_page'>
    <div id='following' class='thumbnail_box clearfix'>
      <h3>応援中の仲間</h3>
      <ul class='user_list'>
      </ul>
    </div>
    <div id='request' class='thumbnail_box clearfix'>
      <h3>応援申請</h3>
      <ul class='user_list'>
      </ul>
    </div>
  </div>
  """
)
JST['supporter/li'] = _.template(
  """
  <li id='<%= id %>' >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href='/#/s/<%= id %>' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <button class='btn btn-block following'>削除する</button>
    </div>
  </li>
  """
  )

JST['supporter/request-li'] = _.template(
  """
  <li id='<%= id %>' >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href='/#/s/<%= id %>' class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <button class='btn btn-block request'>応援する</button>
      <button class='btn btn-danger btn-block delete'>削除する</button>
    </div>
  </li>
  """
  )

JST['signup/page'] = _.template(
  """
  <div class='signup_page'>
    <h3 class='title_box'>婚活者登録</h3>
    <div class='info box-inner container'>
      <form action='/api/signup' method='POST' class='form-horizontal'>
        <div class='control-group'>
          <label for='name' class='control-label'>名前
          </label>
          <div class='controls'>
            <input type='text' name='name' id='name' required value='<%= fullName %>'/>
            <div class='control-group'>
            </div>
          </div>
          <label for='gender' class='control-label'>性別
          </label>
          <div class='controls'>
            <label class='radio inline'>
              <input type='radio' name='gender' id='gender_male' value='male' <% if(gender == 'male'){%><%= 'checked'%><%} %>/>男
            </label>
            <label class='radio inline'>
              <input type='radio' name='gender' id='gender_female' value='female' <% if(gender == 'female'){%><%= 'checked'%><%} %> />女
            </label>
          </div>
        </div>
        <div class='control-group'>
          <label for='birthday' class='control-label'>生年月日
          </label>
          <div class='controls'>
            <select name='birthday_year' id='birthday_year' class='span2'>
              <option>1954</option>
              <option>1955</option>
              <option>1956</option>
              <option>1957</option>
              <option>1958</option>
              <option>1959</option>
              <option>1960</option>
              <option>1961</option>
              <option>1962</option>
              <option>1963</option>
              <option>1964</option>
              <option>1965</option>
              <option>1966</option>
              <option>1967</option>
              <option>1968</option>
              <option>1969</option>
              <option>1970</option>
              <option>1971</option>
              <option>1972</option>
              <option>1973</option>
              <option>1974</option>
              <option>1975</option>
              <option>1976</option>
              <option>1977</option>
              <option>1978</option>
              <option>1979</option>
              <option>1980</option>
              <option>1981</option>
              <option>1982</option>
              <option>1983</option>
              <option>1984</option>
              <option>1985</option>
              <option>1986</option>
              <option>1987</option>
              <option>1988</option>
              <option>1989</option>
              <option selected>1990</option>
              <option>1991</option>
              <option>1992</option>
            </select>年
            <select name='birthday_month' id='birthday_month' class='span1'>
              <option selected>1</option>
              <option>2</option>
              <option>3</option>
              <option>4</option>
              <option>5</option>
              <option>6</option>
              <option>7</option>
              <option>8</option>
              <option>9</option>
              <option>10</option>
              <option>11</option>
              <option>12</option>
            </select>月
            <select name='birthday_day' id='birthday_day' class='span1'>
              <option selected>1</option>
              <option>2</option>
              <option>3</option>
              <option>4</option>
              <option>5</option>
              <option>6</option>
              <option>7</option>
              <option>8</option>
              <option>9</option>
              <option>10</option>
              <option>11</option>
              <option>12</option>
              <option>13</option>
              <option>14</option>
              <option>15</option>
              <option>16</option>
              <option>17</option>
              <option>18</option>
              <option>19</option>
              <option>20</option>
              <option>21</option>
              <option>22</option>
              <option>23</option>
              <option>24</option>
              <option>25</option>
              <option>26</option>
              <option>27</option>
              <option>28</option>
              <option>29</option>
              <option>30</option>
              <option>31</option>
            </select>日
          </div>
        </div>
        <div class='control-group'>
          <div class='controls'>
            <label class='checkbox'>
              <input type='checkbox' class='required_checkbox' required>22歳以上ですか?
            </label>
            <label class='checkbox'>
              <input type='checkbox' class='required_checkbox' required>あなたは独身ですか?
            </label>
          </div>
        </div>
        <input type='hidden' name='id' id='id' value='<%= facebook_id %>' />
        <input type='hidden' name='username' id='username' value='<%= username %>' />
        <input type='hidden' name='first_name' id='first_name' value='<%= firstName %>' />
        <input type='hidden' name='last_name' id='last_name' value='<%= lastName %>' />
        <div class='control-group'>
          <div class='controls'>
            <button type='submit' class='btn btn-primary register'>登録する
            </button>
            <button type='button' class='btn cancel'>キャンセル
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>
  <div id='myModal' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true' class='modal hide fade'>
    <div class='modal-header'>
      <h3 id='myModalLabel'>規約に同意してください
      </h3>
    </div>
    <div class='modal-body'>
      <div class='control-group'>
        <label class='checkbox'>
          <input type='checkbox' value='' id='is-married'/>
          <p>結婚していません
          </p>
        </label>
      </div>
      <div class='control-group'>
        <label class='checkbox'>
          <input type='checkbox' value='' id='use-policy'/>
          <p>利用規約に同意する
          </p>
        </label>
      </div>
      <div class='control-group'>
        <label class='checkbox'>
          <input type='checkbox' value='' id='over-age'/>
          <p>22歳以上です
          </p>
        </label>
      </div>
    </div>
    <div class='modal-footer'>
      <button id='agreement' class='btn btn-primary'>同意する
      </button>
      <button id='disagreement' class='btn'>同意しない
      </button>
    </div>
  </div>
  """
  )

JST['sidebar/main'] = _.template(
  """
  <a href='/#/'>
    <img class='logo' src='/image/logo.png' />
  </a>
  <div id='welcome_box' class='clearfix'>
    <a class='pull-left'>
      <img class='user_profile_image' src='<%= source %>' />
    </a>
    <div>
      <a class='user_name' href='/#/me'><%= name %>さん</a>
      <a href='/#/profile'>プロフィールを編集する</a>
    </div>
  </div>
  <a class='pull-right usage' href='/#/usage'><small>使い方</small></a>
  <div id='navigation' class='clearfix'>
    <ul class='nav nav-list'>
      <li class='nav-header'>メニュー</li>
      <li class='like'><a href='/#/like'> いいねリスト</a></li>
      <li class='talk'><a href='/#/talk'> 応援トーク</a></li>
      <li class='message'><a href='/#/message'> メッセージ</a></li>
      <li class='test'><a href='/#/invite'> 応援団を増やす</a></li>
      <li class='supporter'><a href='/#/supporter'> あなたの婚活仲間</a></li>
      <li class='nav-header'>あなたが応援している人</li>
      <li>
        <ul class='nav nav-list following'></ul>
      </li>
    </ul>
  </div>
  <div id='sidebar-bottom' class='pull-left'>
    <ul class='breadcrumb'>
      <li><a>利用規約</a></li>
      <li class='divider'>/</li>
      <li><a>プライバシーポリシー</a></li>
      <li class='divider'>/</li>
      <li><a>運営チーム</a></li>
    </ul>
  </div>
  """
  )
JST['sidebar/supporter'] = _.template(
  """
  <a href='/#/'>
    <img class='logo' src='/image/logo.png' />
  </a>
  <div id='welcome_box' class='clearfix'>
    <a class='pull-left'>
      <img class='user_profile_image' src='<%= source %>' />
    </a>
    <div>
      <a class='user_name' href='/#/me'><%= name %>さん</a>
      <a href='/#/profile'>プロフィールを編集する</a>
    </div>
  </div>
  <a class='pull-right usage' href='/#/usage'><small>使い方</small></a>
  <div id='navigation' class='clearfix'>
    <ul class='nav nav-list'>
      <li class='nav-header'>メニュー</li>
      <li class='supporter'><a href='/#/supporter'>あなたの婚活仲間</a></li>
        <li class='signup'><a href='/#/signup'>婚活を始める</a></li>
      <li class='nav-header'>あなたが応援している人</li>
      <li>
        <ul class='nav nav-list following'></ul>
      </li>
    </ul>
  </div>
  <div id='sidebar-bottom' class='pull-left'>
    <ul class='breadcrumb'>
      <li><a>利用規約</a></li>
      <li class='divider'>/</li>
      <li><a>プライバシーポリシー</a></li>
      <li class='divider'>/</li>
      <li><a>運営チーム</a></li>
    </ul>
  </div>
  """
  )

JST['recommend/li'] = _.template(
  """
  <li id=<%= id %>>
    <a class='recommend_following'>
      <img src=<%= source %> />
      <div><p><%= name %>さん</p></div>
    </a>
  </li>
  """)