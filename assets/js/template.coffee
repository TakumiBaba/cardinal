JST = window.App.JST

JST['matching/page'] = _.template(
  """
  <div id='matching_page' class='profile_and_following_view'>
    <ul class='nav nav-tabs matching-type-list'>
      <li class='system active'><a>お相手リスト</a></li>
      <li class='supporter'><a>応援団おすすめリスト</a></li>
    </ul>
    <div class='system_matching'>
      <div class='box'>
        <div class='sm_side matching_side_div'>
          <ul class='sm_user_list matching_side'>
          </ul>
        </div>
        <div class='sm_main main_box'>
          <div class='matchinguser_menu box_menu'>
            <img class='profile_image pull-left' src='' />
            <h4 class='name'></h4>
            <h5 class='simple_profile'></h5>
            <button class='like btn pink'>いいね！</button>
            <button class='sendMessage btn green'>メッセージを送る</button>
            <button class='talk btn yellow'>応援団に相談</button>
            <!--
            <div class='btn-group recommend'>
              <button class='btn dropdown-toggle btn-primary' data-toggle='dropdown' href='#'>友達に勧める<span class='caret'></span></button>
              <ul class='dropdown-menu recommend-following' role='menu' aria-labelledby='dLabel'>
                <li class='divider'></li>
              </ul>
            </div>
            -->
          </div>
          <div class='detail_profile'>
            <div class='profile-column'>
              <div class='profile-column-header'>
                <h5>プロフィール <a class="to-detail-profile" href="">詳細をみる</a></5>
              </div>
              <div class='ideal-profile'></div>
              <div class='profile-column-body'>
                <table class='table'>
                  <tbody>
                  </tbody>
                </table>
              </div>
            </div>
            <div class='follower_column'>
              <div class='follower_column_header'>
                <h5 class='follower-title'></5>
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
    <div class='supporter_matching'>
      <div class='box'>
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
              <!-- <button class='recommend btn btn-inverse'>友達に勧める</button> -->
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
                <h5 class='follower-title'></5>
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
    <h3 class='title_box'>プロフィールを編集する</h3>
    <div class='profile box-inner container'>
      <form class='form-horizontal'>
        <div class='control-group'>
          <label for='profile-image' class='control-label'>プロフィール画像</label>
          <div class='controls'>
            <img id='profile-image' style='width:100px; height:100px' src='<%= image_url %>'>
            <ul class='profile-image-list'>
            </ul>
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
          <label for='hometown' class='control-label'>出身地</label>
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
            <input type='text' name='income' id='income' value='<%= income %>'><span class='help-inline'>万円</span>
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
          <label for='martialHistory' class='control-label'>婚姻歴</label>
          <div class='controls'>
            <select name='martialHistory' id='martialHistory'>
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
          <label for='wantChild' class='control-label'>子どもの希望</label>
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
          <label for='wantMarriage' class='control-label'>結婚希望時期</label>
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
            <input type='text' id='height' name='height' value='<%= height %>'>
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
            <textarea rows='3' id='hoby' name='hoby' class='span4' value="<%= hoby %>"><%= hoby %></textarea>
          </div>
        </div>
        <div class='control-group'>
          <label for='like' class='control-label'>好きなもの</label>
          <div class='controls'>
            <div class='likelist'><% _.each(like, function(item){var label="<span class='label label-info'>"+item+"</span>"%><%= label %><%})%></div>
            <input type='text' id='like' name='like' value='' class='span2'>
          </div>
        </div>
        <div class='control-group'>
          <label for='message' class='control-label'>お相手へのメッセージ</label>
          <div class='controls'>
            <textarea rows='3' id='message' name='message' class='span5' value="<%= message %>"><%= message %></textarea>
          </div>
        </div>
        <div class='control-group'>
          <label for='age_range_min' class='control-label'>希望の年齢</label>
          <div class='controls'>
            <input type='text' id='age_range_min' name='age_range_min' value='<%= ageRangeMin %>' class='span2' />歳から
            <input type='text' id='age_range_max' name='age_range_max' value='<%= ageRangeMax %>' class='span2' />歳まで
          </div>
        </div>
        <div class='control-group'>
          <label for='ideal_partner' class='control-label'>理想のパートナー像</label>
          <div class='controls'>
            <textarea rows='3' id='ideal_partner' name='ideal_partner' class='span5'><%= idealPartner %></textarea>
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
    <div class='each-like info box-inner container likebox'>
      <h3 class='title_box'>両思い中<small>'どんどんメッセージを送って会う約束をしよう！'</small></h3>
      <ul class='like-thumbnail'></ul>
    </div>
    <div class='your-like info box-inner container likebox'>
      <h3 class='title_box'>お相手が片思い<small>'ピピっと来たら、『いいね』をプッシュ！'</small></h3>
      <ul class='like-thumbnail'></ul>
    </div>
    <div class='my-like info box-inner  container likebox'>
      <h3 class='title_box'>あなたが片思い</h3>
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
    <h3 class='title_box'>プロフィールページ</h2>
    <div class='box'>
      <div class='user_profiles main_box'>
        <div class='box_menu'>
          <img class='profile_image pull-left' src='<%= image_source %>' />
          <h4 class='name'><%= name %>さん</h4>
          <h5 class='simple_profile'><%= gender_birthday %></h5>
          <!--
          <div class='btn-group'>
            <button class='recommend btn btn-primary disabled'>友達に勧める</button>
          </div>
          -->
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
              <div class='tab-pane active' id='detailprofile'>
                <div class='supporter-message-list'>
                  <ul></ul>
                </div>
                <div class='supporter-message-post-view'>
                  <textarea></textarea>
                  <button class='btn'>応援メッセージを投稿する</button>
                </div>
              </div>

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
    <h3 class='title_box'>プロフィールページ</h2>
    <div class='box'>
      <div class='user_profiles main_box'>
        <div class='box_menu'>
          <img class='profile_image pull-left' src='<%= image_source %>' />
          <h4 class='name'><%= first_name || name %>さん</h4>
          <h5 class='simple_profile'><%= gender_birthday %></h5>
          <button class='like btn btn-primary'>いいね！</button>
          <button class='sendMessage btn btn-success'>メッセージを送る</button>
            <!--
          <div class='btn-group recommend'>
            <button class='btn dropdown-toggle' data-toggle='dropdown' href='#'>友達に勧める<span class='caret'></span></button>
            <ul class='dropdown-menu recommend-following' role='menu' aria-labelledby='dLabel'>
              <li class='divider'></li>
            </ul>
          </div>
          -->
          <!-- <button class='recommend btn btn-primary'>友達に勧める</button> -->
        </div>
        <div class='detail_profile pull-left'>
          <div id='detailprofile'>
            <div class='profile_column pull-left'>
              <h5>プロフィール詳細</h5>
              <div class='ideal-profile'>
                <p><%= first_name %>さんはこんな人を探しています</p>
                <h4>年齢 <%= profile.ageRangeMin %> ~ <%= profile.ageRangeMax %></h4>
                <p>理想のパートナー像</p>
                <h5><%= profile.idealPartner %></h5>
              </div>
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
      <div class='supporter-message-list'>
        <ul></ul>
      </div>
    </div>
  </div>
  """
  )

JST['supporter/page'] = _.template(
  """
  <div id='supporter_list_page'>
    <div id='follower' class='thumbnail_box clearfix'>
      <h3>応援してくれている仲間</h3>
      <ul class='user_list'>
      </ul>
    </div>
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
      <button class='btn btn-block delete <%= optionClass %>'>削除する</button>
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
  <div class='sidebar-inner'>
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
    <a class='pull-right usage' data-toggle="modal" data-target="#usage"><small>使い方</small></a>
    <div id='navigation' class='clearfix'>
      <ul class='nav nav-list'>
        <li class='nav-header'>メニュー</li>
        <li class='like'><a href='/#/like'> いいねリスト</a></li>
        <li class='talk'><a class='talk-badge' href='/#/talk'> 応援トーク<span class='badge badge-important talk-badge'></span></a></li>
        <li class='message'><a  class='message-badge' href='/#/message'> メッセージ<span class='badge badge-important message-badge'></span></a></li>
        <li class='divider'></li>
        <li class='test'><a href='/#/invite'> 応援団を増やす</a></li>
        <li class='supporter'><a href='/#/supporter'> あなたの婚活仲間</a></li>
      </ul>
      <ul class='nav nav-list sidebar-bottom'>
        <li class='use-policy'><a data-toggle="modal" data-target="#usepolicy">利用規約</a></li>
        <li><a href="/#/privacypolicy">プライバシーポリシー</a></li>
        <li><a href="/#/team">運営チーム</a></li>
      </ul>
    </div>
  </div>
  """
  )
JST['sidebar/supporter'] = _.template(
  """
  <a href='/#/supporter'>
    <img class='logo' src='/image/logo.png' />
  </a>
  <div id='welcome_box' class='clearfix'>
    <a class='pull-left'>
      <img class='user_profile_image' src='<%= source %>' />
    </a>
    <div>
      <a class='user_name'><%= name %>さん</a>
    </div>
  </div>
  <a class='pull-right usage' href='/#/usage'><small>使い方</small></a>
  <div id='navigation' class='clearfix'>
    <ul class='nav nav-list'>
      <li class='nav-header'>メニュー</li>
      <li class='supporter'><a href='/#/supporter'>あなたの婚活仲間</a></li>
      <li class='signup'><a href='/#/signup'>婚活を始める</a></li>
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

# JST['me/page'] = _.template(
#   """
#   <div id='profile_page'>
#     <h3 class='title_box'>あなたのプロフィール</h3>
#     <div class='profile box-inner container'>
#       <form class='form-horizontal'>
#         <div class='control-group'>
#           <label for='profile-image' class='control-label'>プロフィール画像</label>
#           <div class='controls'>
#             <img id='profile-image' style='width:100px; height:100px' src='<%= image_url %>'>
#             <ul class='profile-image-list'>
#             </ul>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='address' class='control-label'>居住地</label>
#           <div class='controls'>
#             <% options = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
#             <%= options[address] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='hometown' class='control-label'>出身地</label>
#           <div class='controls'>
#             <% options = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
#             <%= options[hometown] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='job' class='control-label'>ご職業</label>
#           <div class='controls'>
#             <% options = ['---','会社員（営業）','会社員（技術）','会社員（企画）','会社員（サービス）','会社員（販売）','会社員（クリエイティブ）','会社員（事務）','会社員（IT）','会社員（その他）','会社役員','会社経営','国家公務員','地方公務員','自営業','専門職','団体職員','派遣社員','アルバイト','家事手伝い','学生','その他'] %>
#             <%= options[job] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='income' class='control-label'>年収</label>
#           <div class='controls'>
#             <%= income %>万円
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='education' class='control-label'>学歴</label>
#           <div class='controls'>
#             <% options = ['---','中学卒','高校卒','短大卒','大卒','大学院卒','その他','指定しない'] %>
#             <%= options[education] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='martialHistory' class='control-label'>婚姻歴</label>
#           <div class='controls'>
#             <% options = ['---','なし','あり'] %>
#             <%= options[martialHistory] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='wantChild' class='control-label'>子どもの希望</label>
#           <div class='controls'>
#             <% options = ['---','結婚したら欲しい','お相手と相談したい','いなくても構わない','欲しくない','特に決めてない'] %>
#             <%= options[wantChild] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='wantMarriage' class='control-label'>結婚希望時期</label>
#           <div class='controls'>
#             <% options = ['---','すぐにでも','2〜3年のうちに','お相手に合わせる','特に決めてない'] %>
#             <%= options[wantMarriage] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='hasChild' class='control-label'>子どもの有無</label>
#           <div class='controls'>
#             <% options = ['---','いない','いる(別居)','いる(同居)'] %>
#             <%= options[hasChild] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='bloodType' class='control-label'>血液型</label>
#           <div class='controls'>
#             <% options = ['---','A','B','O','AB'] %>
#             <%= options[bloodType] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='height' class='control-label'>身長</label>
#           <div class='controls'>
#             <%= height %>cm
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='shape' class='control-label'>体型</label>
#           <div class='controls'>
#             <% options = ['---','スリム','ふつう','ぽっちゃり','グラマー','ガッチリ','太め'] %>
#             <%= options[shape] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='drinking' class='control-label'>飲酒習慣</label>
#           <div class='controls'>
#             <% options = ['---','毎日飲む','週3～4日飲む','週1～2日程度','たまに飲む','全く飲まない'] %>
#             <%= options[drinking] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='smoking' class='control-label'>喫煙習慣</label>
#           <div class='controls'>
#             <% options = ['---','よく吸う','たまに吸う','まったく吸わない'] %>
#             <%= options[smoking] %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='hoby' class='control-label'>趣味</label>
#           <div class='controls'>
#             <%= hoby %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='like' class='control-label'>好きなもの</label>
#           <div class='controls'>
#             <div class='likelist'><% _.each(like, function(item){var label="<span class='label label-info'>"+item+"</span>"%><%= label %><%})%></div>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='message' class='control-label'>お相手へのメッセージ</label>
#           <div class='controls'>
#             <%= message %>
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='age_range_min' class='control-label'>希望の年齢</label>
#           <div class='controls'>
#             <%= ageRangeMin %>歳から
#             <%= ageRangeMax %>歳まで
#           </div>
#         </div>
#         <div class='control-group'>
#           <label for='ideal_partner' class='control-label'>理想のパートナー像</label>
#           <div class='controls'>
#             <%= idealPartner %>
#           </div>
#         </div>
#       </form>
#     </div>
#   </div>
#   """
#   )

JST['supporter-message/li'] = _.template(
  """
  <li>
    <div class='s-message-left'>
      <img src="<%= source %>" />
    </div>
    <div class='s-message-right'>
      <div class='s-messge-header'><%= name %>さん</div>
      <div class='s-message-body'><%= message %></div>
    </div>
  </li>
  """
  )

JST['usage/page'] = _.template(
  """
  <div class="usage modal hide fade">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3>Ding-Dongの使い方</h3>
    </div>
    <div class="modal-body">
      <h3 class='title_box'>1. 登録</h3>
      <p>Ding-Dongは、結婚を真剣に考えている方のためのアプリです。Ding-Dongで婚活者として登録できるのは22～60歳までの独身の方です。性別と生年月日は、登録が完了しますと以後修正ができませんので、慎重に入力してください。</p>
      <h3 class='title_box'>2. あなたのプロフィール入力</h3>
      <p>あなたのプロフィールを入力してください。全項目を入力しなくても活動はできますが、入力項目が多いほどお相手の方にとっては判断材料が増えます。</p>
      <h3 class='title_box'>3. 応援団依頼、登録</h3>
      <p>「婚活の応援団を依頼する」をクリックすると、Facebookの友達一覧が表示されます。あなたの婚活について相談したい、あるいは相談できると思う親しいお友達を、応援団として登録しましょう。選択後、お友達に「○○さんから婚活の応援依頼が届いています」というメッセージが配信され、お友達が承認すると応援団登録が完了します。活動中も「応援団を増やす」をクリックして、応援団を増やすこともできます。</p>
      <h3 class='title_box'>4．お相手を探す</h3>
      <p>1～3が完了すると、いよいよ婚活開始です。「マッチング情報」にあなたにマッチングされた方のリストが表示されます。気になる方がいたら積極的に「いいね！」をクリックしましょう。「いいね！」はお相手にも通知されます。</p>
      <h3 class='title_box'>5．迷ったら応援団に相談する</h3>
      <p>気になるお相手が見つかったけど「いいね！」をクリックするか悩む、「いいね！」をクリックしたけどお相手から返事が来ないなど婚活に悩んだり迷ったりした時は、「応援団に相談する」をクリックして応援トークページで応援団と相談しましょう。</p>
      <h3 class='title_box'>6．メッセージを送る</h3>
      <p>「いいね！」だけでは先に進みません。気になるお相手にメッセージを送って、何度かお話ししてみましょう。お相手に直接メッセージを送る勇気が出ない時は、お相手の「応援団おすすめ情報」内にいる応援団にメッセージを送ることもできます。</p>
      <h3 class='title_box'>7. お会いしてみる</h3>
      <p>十分お相手のことを知ることができたら、会う約束をしてみましょう。最初は応援団のお友達と一緒に会ってみるのもいいかもしれませんね。初対面の場所や時間の設定は、お相手の都合をよく聞いて慎重にご検討ください。</p>
    </div>
    <div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal" aria-hidden="true">戻る</a>
    </div>
  </div>
  """
  )

JST['usepolicy/page'] = _.template(
  """
  <div class="usepolicy modal hide fade">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h3>利用規約</h3>
    </div>
    <div class="modal-body">

      <p>この度は、Ding-Dongへお越し頂きまことにありがとうございます。</p>
      <p>Ding-Dong（http://www.×××、以下「当サービス」といいます）のご利用にあたっては、以下の利用規約をお読み頂き、同意される場合にのみご利用下さい。</p>
      <p>なお、本規約につきましては予告なく変更することがありますので、あらかじめ御了承下さい。</p>
      <p>当サービスは、真剣に交際相手を探している独身の方が、お友達に応援してもらいながら将来のパートナーと知り合うチャンスを提供するサービスですが、不特定多数の方がご利用になっているために場合によってはサービスを悪用されたり、あるいは適切なコミュニケーションがとれない方が利用されたりする可能性もあります。</p>
      <p>そういった可能性を十分ご認識のうえ、当サービスのご利用に際して他人に対してどのような個人情報を開示するか、どのようなやりとりをするかについては、常に慎重にお考えください。</p>
      <h3 class='title_box'>第1条【サービス】</h3>
      <p>1. 当サービスでは結婚について真剣に考えている22歳～60歳の独身の方（以下「婚活者」といいます）が、親しいお友達（以下「応援団」といいます）と情報を共有し応援してもらいながらパートナーを探すことができる婚活支援サービスです。</p>
      <p>2. 当サービスの利用に際しては、利用者は自らの費用と責任に必要な機器・ソフトウェア・通信手段等を用意し適切に接続・操作することとします。
      <p>3. 当サービスは、Facebook会員向けのサービスです。婚活者および応援団は、あらかじめFacebookに加入およびログインし、プライバシー設定を行なった上でご利用ください。</p>
      <p>4. 将来、無料・有料を問わず様々なサービスを追加したり、または変更・削除することがあります。</p>
      <p>5. 運営者は、当サービスが提供及び付随するサービスに対する保証行為を一切しておりません。また、運営者は、当サービスの提供するサービスの不確実性・サービス停止等に起因する利用者への損害について、一切責任を負わないものとします。詳細については、「免責事項」をご覧下さい。</p>
      <h3 class='title_box'>第2条【利用資格】</h3>
      <p>当サービスを利用できる方は、婚活者と応援団です。婚活者は、Facebookに登録されている22歳~60歳の独身女性及び独身男性でなければ登録できません。応援団は、Facebookで婚活者の友人に登録されている方で22歳以上であれば、既婚の方・結婚を考えていない方でも利用可能です。</p>
      <h3 class='title_box'>第3条【個人情報の取り扱い】</h3>
      <p>当サービスとの利用に際して利用者から取得した氏名などの個人情報は、Facebookが定める「プライバシーポリシー」に則り取り扱われます。</p>
      <h3 class='title_box'>第4条【著作権等知的財産権】</h3>
      <p>1．当サービス内のプログラム、ロゴ、画像、その他の知的財産権は運営者に帰属します。運営者に無断で使用（複製、送信、譲渡、二次利用等を含む）することは禁じます。</p>
      <p>2．Ding-Dongの商標は、運営者に帰属しますので無断で使用することはできません。</p>
      <h3 class='title_box'>第5条【禁止事項】</h3>
      <p>1．運営者は、利用者が以下の行為を行うことを禁じます。</p>
      <p>1）22歳未満で、独身でない方が婚活者として当サービスを利用すること</p>
      <p>2）運営者または第三者に損害を与える行為、または損害を与える恐れのある行為</p>
      <p>3）運営者または第三者の財産、名誉、プライバシー等を侵害する行為、または侵害する恐れのある行為</p>
      <p>4）公序良俗に反する行為、またはその恐れのある行為</p>
      <p>5）他人や他の存在になりすますこと</p>
      <p>6）虚偽の申告、届出を行う行為</p>
      <p>7）コンピュータウィルス等有害なプログラムを使用または提供する行為</p>
      <p>8）迷惑メールやメールマガジン等を一方的に送付する行為</p>
      <p>9）Facebookの利用規約に反する行為</p>
      <p>10）法令に違反する行為、またはその恐れがある行為</p>
      <p>11）その他運営者が不適切と判断する行為</p>
      <p>2．上記に違反した場合、運営者は利用者に対し損害賠償請求をすることができることに利用者は同意します。</p>
      <h3 class='title_box'>第6条【免責事項】</h3>
      <p>1．運営者は、当サービスに掲載されている全ての情報を慎重に取り扱いますが、その正確性および完全性などに関して、いかなる保証もするものではありません。 </p>
      <p>2．運営者は、予告なしに当サービスの運営を停止または中止し、また当サービスに掲載されている情報の全部または一部を変更する場合があります。 </p>
      <p>3．利用者が当サービスを利用したこと、または何らかの原因により、これをご利用できなかったことにより生じる一切の損害および第三者によるデータの書き込み、不正なアクセス、発言、メールの送信等に関して生じる一切の損害について、運営者は何ら責任を負うものではありません。</p>
      <h3 class='title_box'>第7条【会員間の紛争】</h3>
      <p>当サービスの他の会員との交流について、単独で責任を負うものとします。運営者は、会員間で起きた紛争を監視する義務はありません。</p>
      <h3 class='title_box'>第8条【Facebookとの連携】</h3>
      <p>運営者は、会員がFacebookのガイドラインに従わなかった結果、Facebook及び当サービスを利用できなくなっても責任を負いません。さらに運営者は、いかなる理由でもFacebookのアカウントを中断、遮断、閉鎖、または終了されたために、当サービスを利用できなくなっても責任を負いません。なお、当サービスの会員サービスの中断または終了は、Facebookのアカウントの状態には影響しません。</p>
      <h3 class='title_box'>第9条【会員データおよびコンテンツの取扱い】</h3>
      <p>1．会員が投稿などをしたコンテンツについては、会員または当該コンテンツの著作権者に著作権が帰属しますが、会員は運営者に対して、日本の国内外で無償かつ非独占的に利用（複製、上映、公衆送信、展示、頒布、譲渡、貸与、翻訳、翻案、出版を含みます）する権利を期限の定めなく許諾（サブライセンス権を含みます）したものとみなします。その場合、会員は著作者人格権を行使しないものとします。</p>
      <p>2．運営者は、会員が当社の管理するサーバーに保存しているデータを、婚活研究、サービス向上や保守、新たなサービス展開などに、必要な範囲で複製や利用等することができるものとします。リサーチ情報を公開する場合には、データは全て統計的に処理し、個人が特定されない措置を取ります。</p>
      <p>3．会員が会員自身のメッセージボックスに、6か月間アクセスされなかった場合にメッセージを削除する場合があります。</p>
      <h3 class='title_box'>第10条【契約解除】</h3>
      <p>1．運営者は、利用者が本規約に反する行為をした場合、即時にサービスを停止することができます。</p>
      <p>2．前項の事由が発生したとき、運営者は利用者に損害賠償をすることができます。</p>
      <h3 class='title_box'>第11条【損害賠償】</h3>
      <p>本規約に違反した場合、運営者に発生した損害を賠償していただきます。</p>
      <h3 class='title_box'>第12条【準拠法および管轄裁判所】</h3>
      <p>当サービスおよび本規約の解釈・適用については、日本国法に準拠します。万が一裁判所での争いとなったときは、訴額に応じて東京簡易裁判所または東京地方裁判所を第一審の専属管轄裁判所とします。</p>
      <h3 class='title_box'>第13条【特例】</h3>
      <p>1．本規約に基づき、特別の規定が別途定められている場合があります。</p>
      <p>2．運営者の各サービスの説明のページに当規約と相反する規定があった場合は、各サービスの説明ページに記載してある規定を適用します。</p>
      <p>（附則）</p>
      <p>本規約は、2013年4月20日より施行致します。</p>
      <p>2013年4月20日制定</p>
      <p>　　年　　月　　日改訂</p>
      <p>　　年　　月　　日改訂</p>
    </div>
    <div class="modal-footer">
      <a href="#" class="btn" data-dismiss="modal" aria-hidden="true">戻る</a>
    </div>
  </div>
  """
  )

JST['me/page'] = _.template(
  """
  <div id='user_page' class='profile_and_following_view'>
    <h3 class='title_box'>プロフィールページ</h2>
    <div class='box'>
      <div class='user_profiles main_box'>
        <div class='box_menu'>
          <img class='profile_image pull-left' src='<%= profile.image_url %>' />
          <h4 class='name'><%= first_name || name %>さん</h4>
          <h5 class='simple_profile'><%= profile.birthday %></h5>
          <button class='like btn btn-primary'>いいね！</button>
          <button class='sendMessage btn btn-success'>メッセージを送る</button>
          <div class='btn-group recommend'>
            <!--
            <button class='btn dropdown-toggle' data-toggle='dropdown' href='#'>友達に勧める<span class='caret'></span></button>
            <ul class='dropdown-menu recommend-following' role='menu' aria-labelledby='dLabel'>
              <li class='divider'></li>
            </ul>
            -->
          </div>
          <!-- <button class='recommend btn btn-primary'>友達に勧める</button> -->
        </div>
        <div class='detail_profile pull-left'>
          <div id='detailprofile'>
            <div class='profile_column pull-left'>
              <h5>プロフィール詳細</h5>
              <div class='ideal-profile'>
                <p><%= first_name %>さんはこんな人を探しています</p>
                <h4>年齢 <%= profile.ageRangeMin %> ~ <%= profile.ageRangeMax %></h4>
                <p>理想のパートナー像</p>
                <h5><%= profile.idealPartner %>歳</h5>
              </div>
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
      <div class='supporter-message-list'>
        <ul></ul>
      </div>
    </div>
  </div>
  """
  )