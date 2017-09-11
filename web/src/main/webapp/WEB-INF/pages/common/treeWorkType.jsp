<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var storeTreeWorkType = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../workType/getTree'
        },
        root: {
            text: '<fmt:message key="workType"/>',
            id: '-10',
            expanded: true
        },
        folderSort: true,
        sorters: [{property: 'name', direction: 'ASC'}],
        autoload: false
    });

    var workTypeTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: false,
        title: '<fmt:message key="workType"/>',
        id: 'workTypeTreeWindow',
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
                layout: 'fit',
                height: 300,
                name: 'treeWorkType',
                id: 'treeWorkType',
                store: storeTreeWorkType,
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
                        chooseWorkType(record);
                        workTypeTreeWindow.hide();
                    }
                }
            }
        ],
        listeners: {
            show: function (window) {
                maskTarget(Ext.getCmp('workTypeTreeWindow'));
                Ext.getCmp('treeWorkType').getStore().getRootNode().removeAll();
                Ext.getCmp('treeWorkType').getStore().load();
                Ext.getCmp('treeWorkType').getStore().on('load', function (store, records, options) {
                    unMaskTarget();
                });
            }
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    workTypeTreeWindow.hide();
                }
            }]
    });

</script>