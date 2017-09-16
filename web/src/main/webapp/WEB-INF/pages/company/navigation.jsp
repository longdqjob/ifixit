<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var store = Ext.create('Ext.data.TreeStore', {
        fields: [
            {name: 'id', type: 'int'},
            {name: 'parentId', type: 'int'},
            {name: 'code', type: 'string'},
            {name: 'name', type: 'string'},
            {name: 'state', type: 'int'},
            {name: 'description', type: 'string'},
            {name: 'namedisplay', type: 'string'},
            {name: 'completeParentCode', type: 'string'},
            {name: 'parentName', type: 'string'},
        ],
        proxy: {
            type: 'ajax',
            url: '../company/getTreeCompany'
        },
        root: {
            text: '<fmt:message key="company"/>',
            id: '-11',
            expanded: true
        },
        folderSort: true,
        sorters: [{
                property: 'name',
                direction: 'ASC'
            }],
//        listeners: {
//            // Each demo.UserModel instance will be automatically   
//            // decorated with methods/properties of Ext.data.NodeInterface   
//            // (i.e., a "node"). Whenever a UserModel node is appended  
//            // to the tree, this TreeStore will fire an "append" event.  
//            append: function (thisNode, newChildNode, index, eOpts) {
//
//                // If the node that's being appended isn't a root node, then we can   
//                // assume it's one of our UserModel instances that's been "dressed   
//                // up" as a node  
//                if (!newChildNode.isRoot()) {
//
//                    // The node is a UserModel instance with NodeInterface  
//                    // properties and methods added. We want to customize those   
//                    // node properties  to control how it appears in the TreePanel.  
//
//                    // A user "item" shouldn't be expandable in the tree  
//                    newChildNode.set('leaf', true);
//
//                    // Use the model's "name" value as the text for each tree item  
//                    newChildNode.set('text', newChildNode.get('text'));
//
////                    // Use the model's profile url as the icon for each tree item  
////                    newChildNode.set('icon', newChildNode.get('iconCls'));
////                    newChildNode.set('cls', 'iconCls');
////                    newChildNode.set('iconCls', 'iconCls');
//                }
//            }
//        }
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
        id: 'sidelefttree',
        resizable: false,
        header: false,
        collapsible: true,
        useArrows: false,
        rootVisible: false,
        lines: true,
        multiSelect: true,
        border: true,
        store: store,
        minHeight: 500,
        columns: [{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                width: 345,
                sortable: true,
                dataIndex: 'namedisplay',
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
                loadMachine("-10");
            },
            itemclick: function (view, node) {
                //console.log(node);
//                if (node.isLeaf()) {
//                    // some functionality to open the leaf(document) in a tabpanel
//                    alert(node.get("text"));
//                } else if (node.isExpanded()) {
//                    node.collapse();
//                } else {
//                    node.expand();
//                }
            },
            itemdblclick: function (tree, record, item, index, e, eOpts) {
                //console.log(record);
                //console.log(record.get("id"));
                loadMachine(record.get("id"));
                console.log("dbClick Load data " + record.get("id") + " - " + record.get("name"));
            },
            itemcontextmenu: function (tree, record, item, index, e, eOpts) {
                selectedSystem = record;
                // Optimize : create menu once
                var menu_grid = new Ext.menu.Menu({
                    border: true,
                    items: [{
                            text: '<fmt:message key="loadData"/>',
                            iconCls: "refresh",
                            handler: function () {
                                selectedSystem = record;
                                loadMachine(selectedSystem.get("id"));
                                console.log("Load data " + record.get("id") + " - " + record.get("name"));
                            }}, {
                            text: '<fmt:message key="addCompany"/>',
                            iconCls: "add-cls",
                            handler: function () {
                                addCompany(record);
                                console.log(record);
                            }}, {
                            text: '<fmt:message key="editCompany"/>',
                            iconCls: "edit-cls",
                            handler: function () {
                                editCompany(record);
                            }}, {
                            text: '<fmt:message key="delete"/>',
                            iconCls: "delete-cls",
                            handler: function () {
                                var msg = '<fmt:message key="msgDelete.confirm.item"/>';
                                Ext.MessageBox.confirm('Confirm', msg, function (btn) {
                                    if (btn == 'yes') {
                                        var param = '&ids=' + record.get('id');
                                        deleteCompany(param);
                                    }
                                });
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