<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var storeMachine = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../machine/getTree'
        },
        root: {
            text: '<fmt:message key="machine"/>',
            id: '0',
            expanded: true
        },
        folderSort: true,
        sorters: [{property: 'name', direction: 'ASC'}],
        autoload: false
    });

    var mechanicTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: false,
        title: '<fmt:message key="machine"/>',
        id: 'mechanicTreeWindow',
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
                itemId: 'treeMechanic',
                id: 'treeMechanic',
                layout: 'fit',
                height: 300,
                name: 'treeMechanic',
                store: storeMachine,
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
                        chooseMechanic(record);
                        mechanicTreeWindow.hide();
                    }
                }
            }
        ],
        listeners: {
            show: function (window) {
                var popUpMask = new Ext.LoadMask({
                    msg: "Please wait...",
                    target: Ext.getCmp('mechanicTreeWindow')
                });
                popUpMask.show();
                Ext.getCmp('treeMechanic').getStore().getRootNode().removeAll();
                Ext.getCmp('treeMechanic').getStore().load();
                Ext.getCmp('treeMechanic').getStore().on('load', function (store, records, options) {
                    popUpMask.hide();
                });
            }
        },
        buttons: [{
                text: 'Cancel',
                handler: function () {
                    mechanicTreeWindow.hide();
                }
            }]
    });

</script>