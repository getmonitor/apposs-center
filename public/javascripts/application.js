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
    find_box: function(base_node){
      switch(base_node.attr('box-type')){
        case 'last':
          return base_node.children().last();
        case 'first': 
          return base_node.children().first();
        case 'before':
          return base_node.prev();
        case 'after':
          return base_node.next();
        default: 
          return base_node;
      }
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
      application.find_box(base_node),
      base_node.attr('box-href')
    );
    return application.stopEverything(e);
  });
  $('div[box-href],li[box-href]').live('refresh.application', function(e) {
    var base_node = $(e.currentTarget);
    application.refresh(
      application.find_box(base_node),
      base_node.attr('box-href')
    );
    return application.stopEverything(e);
  });

});

