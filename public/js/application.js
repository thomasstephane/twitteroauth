var updateServer = function(jid){
  var i = setInterval(function(){
    $.ajax({
      type: 'get',
      url: '/status/' + jid
    }).done(function(data){
      console.log(data);
      clearInterval(i);
      $('#'+jid).find('#status').html(data);
    });
  },100);
};

$(document).ready(function() {

  $('#tweet_form').on('submit', function(e){
    e.preventDefault();

    var $content = $(this).find('[name="text"]');
    var $delay = $(this).find('[name="delay"]');
    var content = $content.val();
    var delay = $delay.val();

    $content.val('');
    $delay.val('');

    $.ajax({
      type: 'post',
      url: '/tweet',
      data: {status: content, delay: delay}
    }).done(function(jid){
      $('#error_messages').html('');
      $('table').append('<tr id="' + jid + '"><td>' + content + '</td><td>' + delay + '" min"</td><td id="status">Processing</td></tr>');
      updateServer(jid);
    }).fail(function(){
      $('#error_messages').html('<p>Twweeted already</p>');
    });
  });
});