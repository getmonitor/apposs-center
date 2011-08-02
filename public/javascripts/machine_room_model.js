/**
 * Created by JetBrains RubyMine.
 * User: liupengtao.pt
 * Date: 11-8-1
 * Time: 上午10:54
 * To change this template use File | Settings | File Templates.
 */
//机器Model
Ext.define('Machine', {
    extend:'Ext.data.Model',
    fields:['id','name','host','room_id','app_id'],
    proxy:{
        type:'ajax',
        url:'/admin/machines',
        reader:'json',
        extraParams: {
            authenticity_token:$('meta[name="csrf-token"]').attr('content')
        }
    }
});

//机器的GridPanel Store
var machineGridStore = Ext.create('Ext.data.Store', {
    model:Machine,
    autoLoad:true
});

//机房Model
Ext.define('Room', {
    extend:'Ext.data.Model',
    fields:['id','name'],
    proxy:{
        type:'ajax',
        url:'/admin/rooms',
        reader:'json'
    }
});
//应用Model
Ext.define('MachineApp', {
    extend:'Ext.data.Model',
    fields:['id','name'],
    proxy:{
        type:'ajax',
        url:'/apps',
        reader:'json'
    }
});

//编辑机器中的机房Combo的Store
var editMachineRoomComboStore = Ext.create('Ext.data.Store', {
    model:Room,
    autoLoad:true
});
editMachineRoomComboStore.load();

//编辑机器中的机房Combo的Store
var editMachineAppComboStore = Ext.create('Ext.data.Store', {
    model:MachineApp,
    autoLoad:true
});
editMachineAppComboStore.load();

//增加机器时对应的机房
var addMachineRoomComboStore = Ext.create('Ext.data.Store', {
    model:Room,
    autoLoad:true
});
//增加机器时对应的应用
var addMachineAppComboStore = Ext.create('Ext.data.Store', {
    model:MachineApp,
    autoLoad:true
});

//编辑机房中的数据store
var roomGridStore = Ext.create('Ext.data.Store', {
    model:Room,
    autoLoad:true
});
//机器中的机房renderer
function roomRender(value) {
    var comboRecord = editMachineRoomComboStore.getById(value);
    if (comboRecord) {
        return comboRecord.get('name');
    }
    return value;
}

//机器中的应用renderer
function appRender(value) {
    var comboRecord = editMachineAppComboStore.getById(value);
    if (comboRecord) {
        return comboRecord.get('name');
    }
    return value;
}

var machinePanelRowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
    clicksToEdit: 1
});
var roomPanelRowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
    clicksToEdit: 1
});
