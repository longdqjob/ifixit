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
        ],
        proxy: {
            type: 'ajax',
            url: '../company/getTreeCompany'
        },
        root: {
            text: '<fmt:message key="company"/>',
            id: '0',
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
        header: false,
        collapsible: true,
        useArrows: true,
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
                                loadMachine();
                                console.log("Load data " + record.get("id") + " - " + record.get("name"));
                            }}, {
                            text: '<fmt:message key="addCompany"/>',
                            handler: function () {
                                console.log("addCompany: " + record.get("id") + " - " + record.get("name"));
                                addCompany(record);
                            }}, {
                            text: '<fmt:message key="editCompany"/>',
                            handler: function () {
                                console.log("editCompany: " + record.get("id") + " - " + record.get("name"));
                                editCompany(record);
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