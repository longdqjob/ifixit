<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var store = Ext.create('Ext.data.TreeStore', {
        fields: [
            {name: 'id', type: 'int'},
            {name: 'text', type: 'string'}
        ],
        proxy: {
            type: 'ajax',
            url: '../itemType/getListItem'
        },
        root: {
            text: '<fmt:message key="itemType"/>',
            id: '0',
            expanded: true
        },
        folderSort: true,
        sorters: [{
                property: 'text',
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

    var singleClickTask = new Ext.util.DelayedTask(singleClickAction), // our delayed task for single click
            singleClickDelay = 200; // delay in milliseconds
    function onClick(view, node) {
        singleClickTask.delay(singleClickDelay);
    }

    function onDblClick(id) {
        // double click detected - trigger double click action
        doubleClickAction(id);
        // and don't forget to cancel single click task!
        singleClickTask.cancel();
    }

    function singleClickAction() {
        alert("singleClickAction");
    }

    function doubleClickAction(id) {
        loadMachine(id);
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
        columns: [{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                width: 345,
                sortable: true,
                dataIndex: 'text',
            }
        ],
        listeners: {
            itemclick: function (view, node) {
                onClick();
//                console.log(node);
//                console.log("isLeaf: " + node.isLeaf());
//                console.log("children " + node.data.childNodes);
//                if (node.isLeaf()) {
//                    // some functionality to open the leaf(document) in a tabpanel
//                    alert(node.get("text"));
//                } else if (node.isExpanded()) {
//                    node.collapse();
//                } else {
//                    node.expand();
//                }
            },
            itemdblclick: function (tree, record, index) {
                onDblClick(record.get("id"));
//                console.log("dblclicked");
//                event.preventDefault();
            },
            itemcontextmenu: function (tree, record, item, index, e, eOpts) {
                // Optimize : create menu once
                var menu_grid = new Ext.menu.Menu({items: [{
                            text: '<fmt:message key="loadData"/>',
                            handler: function () {
                                loadMachine(record.get("id"));
                                console.log("Load data " + record.get("id") + " - " + record.get("text"));
                            }}, {
                            text: '<fmt:message key="moreDetail"/>',
                            handler: function () {
                                console.log("Moreils: " + record.get("id") + " - " + record.get("text"));
                            }}, {
                            text: '<fmt:message key="delete"/>',
                            handler: function () {
                                console.log("Delete " + record.get("id") + " - " + record.get("text"));
                            }}]
                });
                // HERE IS THE MAIN CHANGE
                var position = [e.getX() - 10, e.getY() - 10];
                e.stopEvent();
                menu_grid.showAt(position);
            }
        }
    });


    function loadMachine(id) {
        mygrid.getStore().getProxy().extraParams = {
            id: id,
        };
        mygrid.getStore().loadPage(1);
        
//        Ext.Ajax.request({
//            url: '../itemType/loadData',
//            method: "POST",
//            params: {
//                id: id,
//                start: 0,
//                limit: 10
//            },
//            success: function (response) {
//                var res = JSON.parse(response.responseText);
//                console.log(res);
//            },
//            failure: function (response, opts) {
//                alert("System Error!");
//            },
//        });
    }
</script>