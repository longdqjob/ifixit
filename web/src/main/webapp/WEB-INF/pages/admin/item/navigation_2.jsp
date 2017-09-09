<script>
    var store = Ext.create('Ext.data.TreeStore', {
        fields: [
            {name: 'id', type: 'int'},
            {name: 'text', type: 'string'}
        ],
        proxy: {
            type: 'ajax',
            url: '../admin/getListItem'
        },
        root: {
            text: 'Item Type',
            id: '0',
            expanded: true
        },
        reader: {
            type: 'json',
            root: 'list'
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

    var tree = Ext.create('Ext.tree.Panel', {
        store: store,
        height: 300,
        width: 250,
        title: 'Files',
        useArrows: true,
//        rootVisible: true,
    });

//    store.load();

//        //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
//    var tree = Ext.create('Ext.tree.Panel', {
//        id: 'sidelefttree',
//        header: false,
//        collapsible: true,
//        useArrows: true,
//        rootVisible: false,
//        lines: true,
//        multiSelect: true,
//        border: true,
//        store: store,
//        columns: [{
//                xtype: 'treecolumn', //this is so we know which column will show the tree
//                width: 200,
//                sortable: true,
//                dataIndex: 'text',
//            }
//        ],
//        listeners: {
//            itemclick: function (s, r) {
//                console.log(r.id);
//                alert(r.id);
//            },
//            itemdblclick: function (tree, record, index) {
//
//            }
//        }
//    });

</script>