<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var cmStoreTreeItemType = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../itemType/getTree'
        },
        root: {
            text: '<fmt:message key="itemType"/>',
            id: 0,
            expanded: true
        },
        autoload: false
    });

    var cmItemTypeTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: false,
        title: '<fmt:message key="itemType"/>',
        id: 'cmItemTypeTreeWindow',
        autoEl: 'form',
        width: "70%",
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
                itemId: 'cmTreeItemType',
                id: 'cmTreeItemType',
                layout: 'fit',
                minHeight: 300,
                height: "60%",
                name: 'cmTreeItemType',
                store: cmStoreTreeItemType,
                rootVisible: false,
                useArrows: false,
                columns: [{
                        xtype: 'treecolumn', //this is so we know which column will show the tree
                        width: 345,
                        text: '<fmt:message key="itemType.name"/>',
                        dataIndex: 'name',
                    }, {
                        text: '<fmt:message key="itemType.code"/>',
                        dataIndex: 'code',
                        flex: 1
                    }, {
                        text: '<fmt:message key="itemType.completeCode"/>',
                        dataIndex: 'completeCode',
                        flex: 1
                    }
                ],
                listeners: {
                    itemdblclick: function (tree, record, index) {
                        chooseTreeCmItemType(record);
                        cmItemTypeTreeWindow.hide();
                    }
                }
            }
        ],
        listeners: {
            show: function (window) {
                maskTarget(Ext.getCmp('cmItemTypeTreeWindow'));
                Ext.getCmp('cmTreeItemType').getStore().getRootNode().removeAll();
                Ext.getCmp('cmTreeItemType').getStore().load();
                Ext.getCmp('cmTreeItemType').getStore().on('load', function (store, records, options) {
                    unMaskTarget();
                });
            }
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    cmItemTypeTreeWindow.hide();
                }
            }]
    });

</script>