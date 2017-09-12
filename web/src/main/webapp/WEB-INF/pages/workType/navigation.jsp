<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var storeWorkType = Ext.create('Ext.data.TreeStore', {
        fields: [
            {name: 'id', type: 'int'},
            {name: 'parentId', type: 'int'},
            {name: 'code', type: 'string'},
            {name: 'name', type: 'string'},
        ],
        proxy: {
            type: 'ajax',
            url: '../workType/getTree'
        },
        root: {
            text: '<fmt:message key="workType"/>',
            id: '-11',
            expanded: true
        },
        folderSort: true,
        sorters: [{
                property: 'name',
                direction: 'ASC'
            }],
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
        useArrows: true,
        rootVisible: false,
        lines: true,
        multiSelect: true,
        border: true,
        store: storeWorkType,
        minHeight: 500,
        columns: [{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                width: 500,
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
                console.log("---afterrender:---");
//                loadWorkOrder("-10");
            },
            itemclick: function (view, node) {
                console.log(node);
                if (node.isLeaf()) {
                    // some functionality to open the leaf(document) in a tabpanel
                    alert(node.get("text"));
                } else if (node.isExpanded()) {
                    node.collapse();
                } else {
                    node.expand();
                }
            },
            itemcontextmenu: function (tree, record, item, index, e, eOpts) {
                // Optimize : create menu once
                var menu_grid = new Ext.menu.Menu({items: [{
                            text: '<fmt:message key="loadData"/>',
                            handler: function () {
                                selectedSystem = record.get("id");
                                loadWorkOrder(selectedSystem);
                            }}, {
                            text: '<fmt:message key="workType.add"/>',
                            handler: function () {
                                addWorkType(record);
                            }}, {
                            text: '<fmt:message key="workType.edit"/>',
                            handler: function () {
                                editWorkType(record);
                            }}, {
                            text: '<fmt:message key="moreDetail"/>',
                            handler: function () {
                                console.log("Moreils: " + record.get("id") + " - " + record.get("name"));
                            }}, {
                            text: '<fmt:message key="delete"/>',
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