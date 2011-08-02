/**
 * Created by JetBrains RubyMine.
 * User: liupengtao.pt
 * Date: 11-8-1
 * Time: 下午1:53
 * To change this template use File | Settings | File Templates.
 */
//创建各种Model
function createModel(modelName, fields, store) {
    var modelConfig = {
        extend:'Ext.data.Model',
        fields:fields
    };
    if (store) {
        modelConfig.store = store;
    }
    return Ext.define(modelName, modelConfig);
}