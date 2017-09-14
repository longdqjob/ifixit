<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var storeMachine = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../machine/getTree'
        },
        root: {
            text: '<fmt:message key="machine"/>',
            id: '-10',
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
                itemId: 'treeMechanic',
                id: 'treeMechanic',
                layout: 'fit',
                minHeight: 300,
                height: "60%",
                name: 'treeMechanic',
                store: storeMachine,
                rootVisible: false,
                useArrows: true,
                columns: [{
                        xtype: 'treecolumn', //this is so we know which column will show the tree
                        width: 345,
                        text: '<fmt:message key="machine.name"/>',
                        dataIndex: 'name',
                    },{
                        text: '<fmt:message key="machine.code"/>',
                        dataIndex: 'code',
                        flex: 1
                    },{
                        text: '<fmt:message key="machine.fullCode"/>',
                        dataIndex: 'completeCode',
                        flex: 1
                    },{
                        text: '<fmt:message key="machine.description"/>',
                        dataIndex: 'description',
                        flex: 1
                    },{
                        text: '<fmt:message key="machine.type"/>',
                        dataIndex: 'machineTypeName',
                        flex: 1
                    },{
                        text: '<fmt:message key="machine.since"/>',
                        dataIndex: 'since',
                        flex: 1
                    },
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
                console.log("---show mechanicTreeWindow -----");
                maskTarget(Ext.getCmp('mechanicTreeWindow'));
                Ext.getCmp('treeMechanic').getStore().getRootNode().removeAll();
                Ext.getCmp('treeMechanic').getStore().load();
                Ext.getCmp('treeMechanic').getStore().on('load', function (store, records, options) {
                    unMaskTarget();
                });
            }
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    mechanicTreeWindow.hide();
                }
            }]
    });

</script>