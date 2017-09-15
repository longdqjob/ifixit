<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var grpEngineerId = ${grpEngineerId};
    var storeTreeEngineer = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../grpEngineer/getTree'
        },
        root: {
            text: '<fmt:message key="grpEngineer"/>',
            id: grpEngineerId,
            expanded: true
        },
        autoload: false
    });

    var grpEngineerTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: true,
        title: '<fmt:message key="grpEngineer"/>',
        id: 'grpEngineerTreeWindow',
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
                itemId: 'treeGrpEngineer',
                id: 'treeGrpEngineer',
                layout: 'fit',
                minHeight: 300,
                height: "60%",
                name: 'treeGrpEngineer',
                store: storeTreeEngineer,
                rootVisible: false,
                useArrows: false,
                columns: [{
                        xtype: 'treecolumn', //this is so we know which column will show the tree
                        width: 345,
                        text: '<fmt:message key="grpEngineer.name"/>',
                        dataIndex: 'name',
                    }, {
                        text: '<fmt:message key="grpEngineer.code"/>',
                        dataIndex: 'code',
                        flex: 1
                    }, {
                        text: '<fmt:message key="grpEngineer.completeCode"/>',
                        dataIndex: 'completeCode',
                        flex: 1
                    }, {
                        text: '<fmt:message key="grpEngineer.description"/>',
                        dataIndex: 'description',
                        flex: 1
                    }, {
                        text: '<fmt:message key="grpEngineer.cost"/>',
                        dataIndex: 'cost',
                        flex: 1
                    }
                ],
                listeners: {
                    itemdblclick: function (tree, record, index) {
                        choosegrpEngineer(record);
                        grpEngineerTreeWindow.hide();
                    }
                }
            }
        ],
        listeners: {
            show: function (window) {
                maskTarget(Ext.getCmp('grpEngineerTreeWindow'));
                Ext.getCmp('treeGrpEngineer').getStore().getRootNode().removeAll();
                Ext.getCmp('treeGrpEngineer').getStore().load();
                Ext.getCmp('treeGrpEngineer').getStore().on('load', function (store, records, options) {
                    unMaskTarget();
                });
            }
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    grpEngineerTreeWindow.hide();
                }
            }]
    });

</script>