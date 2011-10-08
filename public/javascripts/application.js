//顶部显示瞬时消息
function alert(msg) {
  if(!document.getElementById('msg-div')){
    $(document.body).append('<div id="msg-div" style="display:none"></div>');
  }
  $('#msg-div').html('<div class="msg">' + msg + '</div>');
  $('#msg-div').slideDown(500);
  setTimeout(function(){ $('#msg-div').slideUp(500); }, 3500);
}

$(function() {
  var application;
  $.application = application = {
    load_toggle: function(node,url){
      if(node.html()==""){
        node.html("正在装载...");
        $.ajax({
          url: url,
          success: function(data,status,xhrs){
            node.html(data);
          }
        });
      }else{
        node.empty();
      }
    },
    refresh: function(node,url){
      $.ajax({
        url: url,
        success: function(data,status,xhrs){
          node.html(data);
          alert('已刷新');
        }
      });
    },
    link: function(node){
      if(node.data('box-href')==null){
        node.data("box-href",node.attr('box-href'));
      }
      return node.data('box-href');
    },
    stopEverything: function(e) {
      $(e.target).trigger('ujs:everythingStopped');
      e.stopImmediatePropagation();
      return false;
    }
  };

  $('div[box-href],li[box-href]').live('load_toggle.application', function(e) {
    var base_node = $(e.currentTarget);
    application.load_toggle(
      base_node,
      application.link(base_node)
    );
    return application.stopEverything(e);
  });
  $('div[box-href],li[box-href]').live('refresh.application', function(e) {
    var base_node = $(e.currentTarget);
    application.refresh(
      base_node,
      application.link(base_node)
    );
    return application.stopEverything(e);
  });
  $('a[handle]').live('ajax:success', function(e, data, status, xhr) {
    var node = $(e.currentTarget).parent();
    while(node.length > 0){
      if(node.is('div[box-href],li[box-href]')){
        return node.trigger("refresh.application");
      }
      node = node.parent();
    }
  });
});

