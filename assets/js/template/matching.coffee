JST = window.App.JST

JST['matching/userlist/li'] = _.template(
  """
  <li class='user-thumbnail'>
    <img src=<%= source %> class='img-rounded' />
  </li>
  """
  )

JST['matching/profile'] = _.template(
  """
  <h4 class='title_box'><%= name %>さんのプロフィール<h4>
  <table class="sub">
    <tbody>
      <tr>
        <td class="key hoby"> 趣味</td>
        <td class="value"><%= profile.hoby %></td>
      </tr>
      <tr>
        <td class="key like"> 好きなもの</td>
        <td class="value"><%= profile.like %></td>
      </tr>
      <tr>
        <td class="key ideal-message">理想のパートナー像</td>
        <td class="value"><%= profile.idealPartner %></td>
      </tr>
      <tr>
        <td class="key ideal-age">お相手の希望年齢</td>
        <td class="value"><%= profile.ageRangeMin %> ~ <%= profile.ageRangeMax%>歳</td>
      </tr>
    </tbody>
  </table>
  <table class="main">
    <tbody>
      <% martialHistoryArray = ['---','なし','あり'] %>
      <% childrenArray = ['---','いない','いる(別居)','いる(同居)'] %>
      <tr>
        <td class='left-key'>結婚歴</td><td class='left-value'><%= martialHistoryArray[profile.martialHistory] %></td>
        <td class='right-key'>子供の有無</td><td class='right-value'><%= childrenArray[profile.hasChild] %></td>
      </tr>
      <% wantMarriageArray = ['---','すぐにでも','2〜3年のうちに','お相手に合わせる','特に決めてない'] %>
      <% wantChildArray = ['---','結婚したら欲しい','お相手と相談したい','いなくても構わない','欲しくない','特に決めてない'] %>
      <tr>
        <td class='left-key'>結婚希望時期</td><td class='left-value'><%= wantMarriageArray[profile.wantMarriage] %></td>
        <td class='right-key'>子どもの希望</td><td class='right-value'><%= wantChildArray[profile.wantChild] %></td>
      </tr>
      <% addressArray = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
      <% hometownArray = ['---','北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県',,'滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'] %>
      <tr>
        <td class='left-key'>居住地</td><td class='left-value'><%= addressArray[profile.address] %></td>
        <td class='right-key'>出身地</td><td class='right-value'><%= hometownArray[profile.hometown] %></td>
      </tr>
      <% jobArray = ['会社員（営業）','会社員（技術）','会社員（企画）','会社員（サービス）','会社員（販売）','会社員（クリエイティブ）','会社員（事務）','会社員（IT）','会社員（その他）','会社役員','会社経営','国家公務員','地方公務員','自営業','専門職','団体職員','派遣社員','アルバイト','家事手伝い','学生','その他'] %>
      <tr>
        <td class='left-key'>ご職業</td><td class='left-value'><%= jobArray[profile.job] %></td>
        <td class='right-key'>年収</td><td class='right-value'><%= profile.income %>万円</td>
      </tr>
      <% educationArray = ['---','中学卒','高校卒','短大卒','大卒','大学院卒','その他'] %>
      <% bloodTypeArray = ['---','A','B','O','AB'] %>
      <tr>
        <td class='left-key'>学歴</td><td class='left-value'><%= educationArray[profile.education] %></td>
        <td class='right-key'>血液型</td><td class='right-value'><%= bloodTypeArray[profile.bloodType] %></td>
      </tr>
      <% shapeArray = ['---','スリム','ふつう','ぽっちゃり','グラマー','ガッチリ','太め'] %>
      <tr>
        <td class='left-key'>身長</td><td class='left-value'><%= profile.height %>cm</td>
        <td class='right-key'>体型</td><td class='right-value'><%= shapeArray[profile.shape] %></td>
      </tr>

      <% drinkingArray = ['---','毎日飲む','週3～4日飲む','週1～2日程度','たまに飲む','全く飲まない'] %>
      <% smokingArray = ['---','よく吸う','たまに吸う','まったく吸わない'] %>
      <tr>
        <td class='left-key'>飲酒習慣</td><td class='left-value'><%= drinkingArray[profile.drinking] %></td>
        <td class='right-key'>喫煙習慣</td><td class='right-value'><%= smokingArray[profile.smoking] %></td>
      </tr>
    </tbody>
  </table>
  """
  )
JST['matching/supportermessages'] = _.template(
  """
  <h4 class='title_box'><%= name %>さんの応援団おすすめ情報<h4>
  <%  _.each(messages, function(message){ %>
    <%= JST['matching/supportermessages/li'](message) %>
  <%  }); %>
  """
  )
JST['matching/supportermessages/li'] = _.template(
  """
  <li>
    <div class="s-message-left">
      <img src="/api/users/<%= message.supporter.id %>/picture">
    </div>
    <div class="s-mesage-right">
      <div class="s-message-header"> <% message.supporter.first_name %> さん </div>
      <div class="s-message-body"> <% message.message %> </div>
    </div>
  </li>
  """
  )
JST['matching/supporters'] = _.template(
  """
  <h4 class='title_box'><%= name %>さんの応援団<h4>
  <%  _.each(followers, function(follower){ %>
    <%= JST['matching/supporter/li'](follower) %>
  <%  }); %>
  """
  )
JST['matching/supporters/li'] = _.template(
  """
  <li>
    <div class="thumbnail">
      <a class="to-user" href="http://facebook.com/<%= follower.from.facebook_id %>">
        <img src="/api/users/<% follower.from.id %>/picture" />
        <h5><% follower.from.first_name %> さん </h5>
      </a>
    </div>
  </li>
  """
  )