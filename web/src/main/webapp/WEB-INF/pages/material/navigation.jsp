<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var treeItemTypeStore = Ext.create('Ext.data.TreeStore', {
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

    function resetHeight(cmp) {
        setTimeout(function () {
            var innerElement = cmp.getEl().down('table.x-grid-table');
            if (innerElement) {
                var height = innerElement.getHeight();
                cmp.setHeight(height);
            }
        }, 200);
    }

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
    var tree = Ext.create('Ext.tree.Panel', {
        resizable: false,
        id: "treeItemType",
        header: false,
        collapsible: true,
        useArrows: false,
        rootVisible: true,
        lines: true,
        multiSelect: true,
        border: true,
        store: treeItemTypeStore,
        minHeight: 500,
        columns: [{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                width: 345,
                sortable: true,
                dataIndex: 'text',
            }
        ],
        listeners: {
            load: function () {
                resetHeight(this);
            },
            afterrender: function () {
                this.getEl().setStyle('height', 'auto');
                this.body.setStyle('height', 'auto');
                this.getView().getEl().setStyle('height', 'auto');
                if (treeItemTypeStore.data.length == 1) {
                    selectedItem = treeItemTypeStore.data.items[0];
                    loadMaterial(treeItemTypeStore.data.items[0].data.id);
                } else {
                    loadMaterial(0);
                }
            },
            itemclick: function (view, node) {
            },
            itemdblclick: function (tree, record, item, index, e, eOpts) {
                selectedItem = record;
                loadMaterial(selectedItem.get("id"));
                console.log("dbClick Load data " + record.get("id") + " - " + record.get("name"));
            },
            itemcontextmenu: function (tree, record, item, index, e, eOpts) {
                var menu_grid = null;
                if (record.get("id") > 0) {
                    itemTypeParentNode = record.parentNode.get("id");
                    menu_grid = new Ext.menu.Menu({items: [{
                                text: '<fmt:message key="loadData"/>',
                                iconCls: "refresh",
                                handler: function () {
                                    selectedItem = record;
                                    console.log(selectedItem);
                                    loadMaterial(selectedItem.get("id"));
                                }}, {
                                text: '<fmt:message key="button.add"/>',
                                iconCls: "add-cls",
                                handler: function () {
                                    addItemType(record);
                                }}, {
                                text: '<fmt:message key="button.add"/>' + " " + '<fmt:message key="material"/>',
                                iconCls: "add-cls",
                                handler: function () {
                                    addMaterial(record);
                                }}, {
                                text: '<fmt:message key="button.edit"/>',
                                iconCls: "edit-cls",
                                handler: function () {
                                    editItemType(record);
                                }}, {
                                text: '<fmt:message key="button.delete"/>',
                                iconCls: "delete-cls",
                                handler: function () {
                                    var msg = '<fmt:message key="msgDelete.confirm.item"/>';
                                    Ext.MessageBox.confirm('Confirm', msg, function (btn) {
                                        if (btn == 'yes') {
                                            var param = '&ids=' + record.get('id');
                                            deleteItemType(param);
                                        }
                                    });
                                }}]
                    });
                } else {
                    itemTypeParentNode = 0;
                    menu_grid = new Ext.menu.Menu({items: [{
                                text: '<fmt:message key="loadData"/>',
                                iconCls: "refresh",
                                handler: function () {
                                    selectedItem = record;
                                    console.log(selectedItem);
                                    loadMaterial(selectedItem.get("id"));
                                }
                            }, {
                                text: '<fmt:message key="button.add"/>',
                                iconCls: "add-cls",
                                handler: function () {
                                    addItemType(record);
                                }
                            }]
                    });
                }
                // HERE IS THE MAIN CHANGE
                var position = [e.getX() - 10, e.getY() - 10];
                e.stopEvent();
                menu_grid.showAt(position);
            }
        }
    });



</script>