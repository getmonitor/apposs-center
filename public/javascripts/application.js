//顶部显示瞬时消息
function alert(msg) {
  if(!document.getElementById('msg-div')){
    $(document.body).append('<div id="msg-div" style="display:none"></div>');
  }
  $('#msg-div').html('<div class="msg">' + msg + '</div>');
  $('#msg-div').slideDown(500);
  setTimeout(function(){ $('#msg-div').slideUp(500); }, 3500);
}

