//顶部显示瞬时消息
function alert(msg,millisecond) {
  if(!document.getElementById('msg-div')){
    $(document.body).append('<div id="msg-div" style="display:none"></div>');
  }
  $('#msg-div').html('<div class="msg">' + msg + '</div>');
  $('#msg-div').slideDown(300);
  setTimeout(function(){ $('#msg-div').slideUp(300); }, millisecond || 2500);
}

$(function() {
  var application;
  $.application = application = {

    global_interval_handler: null,

    findParent: function(child, parent_tag) {
      while(child.length > 0){
        if(child.is(parent_tag)){
          return child;
        }
        child = child.parent();
      }
      return null;
    },

    startPoller: function(load_func, millisecond) {
      application.stopPoller();
      load_func();
      application.global_interval_handler = setInterval(load_func,millisecond);
    },

    stopPoller: function() {
      if(application.global_interval_handler){
        clearInterval(application.global_interval_handler);
        application.global_interval_handler = null;
      } 
    },

    load_toggle: function(node,url){
      if(node.html()==""){
        node.html("开始每5秒自动刷新......");
        application.startPoller(function(){
          console.info('load'+new Date());
          $.ajax({
            url: url,
            success: function(data,status,xhrs){
              console.info('loaded'+new Date());
              node.html(data);
              console.info('randered'+new Date());
            }
          });
        },5000);
      }else{
        application.stopPoller();
        node.empty();
      }
    },

    refresh: function(node,url){
      application.stopPoller();
      $.ajax({
        url: url,
        success: function(data,status,xhrs){
          node.html(data);
          alert('数据已更新，同时关闭自动刷新');
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
    var parent = application.findParent(node,'div[box-href],li[box-href]');
    if(parent){
      parent.trigger("refresh.application");
    }
  });
  $('ul a[select]').live('click', function(e) {
    var node = $(e.currentTarget);
    var checked = node.attr('select')=="all";
    var ul_node = application.findParent(node,'ul');
    if(ul_node){
      ul_node.find('li input[type=checkbox]').each(function(index,input_ele){
        input_ele.checked = checked;
      });
    }
  });
});

