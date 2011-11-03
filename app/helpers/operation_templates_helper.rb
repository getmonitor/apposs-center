# coding: utf-8
module OperationTemplatesHelper
  def draggable_item d_template,checked
    raw %Q{
      #{image_tag 'delete.png', :onclick=>'$(this).parent().remove();'}
      #{d_template.alias || d_template.name}<br />
      #{d_template.owner.email if d_template.owner_id}
      <input type="hidden"
        name="operation_template[source_ids][]" 
        value="#{d_template.id}|#{checked}" />
      <input type="checkbox" name="#" #{checked ? 'checked="checked"' : ''}
        title="如选中，表示本指令即使失败，后续指令也可继续执行" 
        onchange="
            var template_id = $(this).prev().attr('value').split('|')[0];
            $(this).prev().attr('value',template_id+'|'+this.checked);
        " />
    }
  end
end
