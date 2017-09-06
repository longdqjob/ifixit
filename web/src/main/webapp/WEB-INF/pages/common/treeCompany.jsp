<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var storeCompany = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '/company/getTreeCompany'
        },
        root: {
            text: '<fmt:message key="company"/>',
            id: '0',
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
//            url: '/company/getTreeCompany'
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
        title: 'Company',
        id: 'companyTreeWindow',
        autoEl: 'form',
        width: 500,
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
                height: 300,
                name: 'treeCompany',
                store: storeCompany,
                rootVisible: false,
                useArrows: true,
                columns: [{
                        xtype: 'treecolumn', //this is so we know which column will show the tree
                        width: 345,
                        sortable: true,
                        dataIndex: 'name',
                    }
                ],
                listeners: {
                    itemdblclick: function (tree, record, index) {
                        Ext.getCmp('companyParentName').setValue(record.get('name'));
                        Ext.getCmp('companyParentId').setValue(record.get('id'));
                        companyTreeWindow.hide();
                    }
                }
            }
        ],
        listeners: {
            show: function (window) {
                var popUpMask = new Ext.LoadMask({
                    msg: "Please wait...",
                    target: Ext.getCmp('companyTreeWindow')
                });
                popUpMask.show();
                Ext.getCmp('treeCompany').getStore().getRootNode().removeAll();
                Ext.getCmp('treeCompany').getStore().load();
                Ext.getCmp('treeCompany').getStore().on('load', function (store, records, options) {
                    popUpMask.hide();
                });
            }
        },
        buttons: [{
                text: 'Cancel',
                handler: function () {
                    companyTreeWindow.hide();
                }
            }]
    });

</script>