<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var storeCompany = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../company/getTreeCompany'
        },
        root: {
            text: '<fmt:message key="company"/>',
            id: '-10',
            expanded: true
        },
        folderSort: true,
        sorters: [{property: 'name', direction: 'ASC'}],
        autoload: false
    });

//    var storeCompany = Ext.create('Ext.data.TreeStore', {
//        fields: [
//            {name: 'id', type: 'int'},
//            {name: 'parentId', type: 'int'},
//            {name: 'code', type: 'string'},
//            {name: 'name', type: 'string'},
//            {name: 'state', type: 'int'},
//            {name: 'description', type: 'string'},
//        ],
//        proxy: {
//            type: 'ajax',
//            url: '../company/getTreeCompany'
//        },
//        root: {
//            text: '<fmt:message key="company"/>',
//            id: '0',
//            expanded: true
//        },
//        folderSort: true,
//        sorters: [{
//                property: 'name',
//                direction: 'ASC'
//            }],
//    });


    var companyTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: false,
        title: '<fmt:message key="company"/>',
        id: 'companyTreeWindow',
        autoEl: 'form',
        width: 500,
        minHeigh:400,
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [
            {
                columnWidth: 1,
                xtype: 'treepanel',
                itemId: 'treeCompany',
                id: 'treeCompany',
                layout: 'fit',
                //height: 300,
                name: 'treeCompany',
                store: storeCompany,
                rootVisible: true,
                useArrows: false,
                lines: true,
                columns: [{
                        xtype: 'treecolumn', //this is so we know which column will show the tree
                        width: 350,
                        sortable: true,
                        dataIndex: 'name',
                    }
                ],
                listeners: {
                    itemdblclick: function (tree, record, index) {
                        chooseCompany(record);
                        companyTreeWindow.hide();
                    }
                }
            }
        ],
        listeners: {
            show: function (window) {
                maskTarget(Ext.getCmp('companyTreeWindow'));
                Ext.getCmp('treeCompany').getStore().getRootNode().removeAll();
                Ext.getCmp('treeCompany').getStore().load();
                Ext.getCmp('treeCompany').getStore().on('load', function (store, records, options) {
                    unMaskTarget();
                });
            }
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    companyTreeWindow.hide();
                }
            }]
    });

</script>