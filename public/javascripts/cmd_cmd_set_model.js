/**
 * Created by JetBrains RubyMine.
 * User: liupengtao.pt
 * Date: 11-8-1
 * Time: 上午10:44
 * To change this template use File | Settings | File Templates.
 */
//命令Model
Ext.define('CmdDef', {
    extend:'Ext.data.Model',
    fields:['id','name','alias','arg1','arg2','arg3','arg4','arg5','cmd_group_id'],
    proxy:{
        type:'ajax',
        url:'/admin/cmd_defs',
        reader:'json',
        extraParams: {
            authenticity_token:$('meta[name="csrf-token"]').attr('content')
        }
    }
});

//命令的GridPanel Store
var cmdDefGridStore = Ext.create('Ext.data.Store', {
    model:CmdDef,
    autoLoad:true
});

//命令组Model
Ext.define('CmdGroup', {
    extend:'Ext.data.Model',
    fields:['id','name'],
    proxy:{
        type:'ajax',
        url:'/admin/cmd_groups',
        reader:'json'
    }
});

//编辑命令中的命令组Combo的Store
var editCmdDefCmdGroupComboStore = Ext.create('Ext.data.Store', {
    model:CmdGroup,
    autoLoad:true
});
editCmdDefCmdGroupComboStore.load();
//增加命令时对应的命令组
var addCmdDefCmdGroupComboStore = Ext.create('Ext.data.Store', {
    model:CmdGroup,
    autoLoad:true
});
//编辑命令组中的数据store
var cmdGroupGridStore = Ext.create('Ext.data.Store', {
    model:CmdGroup,
    autoLoad:true
});
//命令中的命令组renderer
function cmdGroupRender(value) {
    var comboRecord = editCmdDefCmdGroupComboStore.getById(value);
    if (comboRecord) {
        return comboRecord.get('name');
    }
    return value;
}

var cmdDefPanelRowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
    clicksToEdit: 1
});
var cmdGroupPanelRowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
    clicksToEdit: 1
});
