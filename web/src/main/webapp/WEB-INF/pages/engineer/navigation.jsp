<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var grpEngineerIdSs = ${grpEngineerId};
    var storeEngineer = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../grpEngineer/getTree'
        },
        root: {
            text: '<fmt:message key="grpEngineer"/>',
            id: grpEngineerIdSs,
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
        header: false,
        collapsible: true,
        useArrows: false,
        rootVisible: false,
        lines: true,
        multiSelect: true,
        border: true,
        store: storeEngineer,
        minHeight: 500,
        columns: [{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                width: 345,
                sortable: true,
                dataIndex: 'name',
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
                if (storeEngineer.data.length == 1) {
                    loadWorkOrder(storeEngineer.data.items[0].data.id);
                } else {
                    loadWorkOrder(grpEngineerIdSs);
                }
            },
            itemclick: function (view, node) {
            },
            itemdblclick: function (tree, record, item, index, e, eOpts) {
                selectedSystem = record;
                loadWorkOrder(selectedSystem.get("id"));
                console.log("dbClick Load data " + record.get("id") + " - " + record.get("name"));
            },
            itemcontextmenu: function (tree, record, item, index, e, eOpts) {
                // Optimize : create menu once
                var menu_grid = new Ext.menu.Menu({items: [{
                            text: '<fmt:message key="loadData"/>',
                            handler: function () {
                                selectedSystem = record;
                                console.log(selectedSystem);
                                loadWorkOrder(selectedSystem.get("id"));
                            }}, {
                            text: '<fmt:message key="grpEngineer.add"/>',
                            handler: function () {
                                addEngineer(record);
                            }}, {
                            text: '<fmt:message key="grpEngineer.edit"/>',
                            handler: function () {
                                editEngineer(record);
                            }}, {
                            text: '<fmt:message key="moreDetail"/>',
                            handler: function () {
                                console.log("Moreils: " + record.get("id") + " - " + record.get("name"));
                            }}, {
                            text: '<fmt:message key="grpEngineer.delete"/>',
                            handler: function () {
                                console.log("Delete " + record.get("id") + " - " + record.get("name"));
                            }}]
                });
                // HERE IS THE MAIN CHANGE
                var position = [e.getX() - 10, e.getY() - 10];
                e.stopEvent();
                menu_grid.showAt(position);
            }
        }
    });



</script>