var nsRoles = {};
nsRoles.PAGE_SIZE = 50;

Ext.define('Role', {
    extend:'Ext.data.Model',
    fields:['id', 'name'],
    proxy:{
        type:'ajax',
        url:'/admin/roles',
        reader:{
            type:'json',
            totalProperty:'totalCount',
            root:'roles'
        },
        extraParams: {
            authenticity_token:$('meta[name="csrf-token"]').attr('content')
        }
    }
});

//角色的GridPanel Store
var roleGridStore = Ext.create('Ext.data.Store', {
    pageSize:nsRoles.PAGE_SIZE,
    model:Role
});

roleGridStore.loadPage(1)

var rolePanelRowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
    clicksToEdit: 1
});