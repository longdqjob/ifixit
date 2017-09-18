<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var storeTreeMaterial = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../material/getTree'
        },
        root: {
            text: '<fmt:message key="material"/>',
            id: 0,
            expanded: true
        },
        autoload: false
    });

    var materialTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: true,
        title: '<fmt:message key="material"/>',
        id: 'materialTreeWindow',
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
                itemId: 'treeMaterial',
                id: 'treeMaterial',
                layout: 'fit',
                minHeight: 300,
                height: "60%",
                name: 'treeMaterial',
                store: storeTreeMaterial,
                rootVisible: false,
                useArrows: false,
                columns: [{
                        xtype: 'treecolumn', //this is so we know which column will show the tree
                        width: 345,
                        text: '<fmt:message key="material.name"/>',
                        dataIndex: 'name',
                    }, {
                        text: '<fmt:message key="material.code"/>',
                        dataIndex: 'code',
                        flex: 1
                    }, {
                        text: '<fmt:message key="material.completeCode"/>',
                        dataIndex: 'completeCode',
                        flex: 1
                    }, {
                        text: '<fmt:message key="material.description"/>',
                        dataIndex: 'description',
                        flex: 1
                    }, {
                        text: '<fmt:message key="material.unit"/>',
                        dataIndex: 'unit',
                        flex: 1
                    }, {
                        text: '<fmt:message key="material.unitCost"/>',
                        dataIndex: 'cost',
                        flex: 1
                    },{
                        text: '<fmt:message key="material.qty"/>',
                        dataIndex: 'quantity',
                        flex: 1
                    }
                ],
                listeners: {
                    itemdblclick: function (tree, record, index) {
                        chooseTreeMeterial(record);
                        materialTreeWindow.hide();
                    }
                }
            }
        ],
        listeners: {
            show: function (window) {
                maskTarget(Ext.getCmp('materialTreeWindow'));
                Ext.getCmp('treeMaterial').getStore().getRootNode().removeAll();
                Ext.getCmp('treeMaterial').getStore().load();
                Ext.getCmp('treeMaterial').getStore().on('load', function (store, records, operation, options) {
                    treeRedirectIfNotAuthen(options);
                    unMaskTarget();
                });
            }
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    materialTreeWindow.hide();
                }
            }]
    });

</script>