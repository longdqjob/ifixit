<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var grpEngineerId = ${grpEngineerId};
    var storeEngineer = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../grpEngineer/getTree'
        },
        root: {
            text: '<fmt:message key="grpEngineer"/>',
            id: grpEngineerId,
            expanded: true
        },
        folderSort: true,
        sorters: [{property: 'name', direction: 'ASC'}],
        autoload: false
    });

    var grpEngineerTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: false,
        title: '<fmt:message key="grpEngineer"/>',
        id: 'grpEngineerTreeWindow',
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
                itemId: 'treeGrpEngineer',
                id: 'treeGrpEngineer',
                layout: 'fit',
                height: 300,
                name: 'treeGrpEngineer',
                store: storeEngineer,
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