<script>
    Ext.define('Car', {
        extend: 'Ext.data.Model',
        fields: [{
                name: 'name',
                type: 'string'
            }]
    });

//    var store = Ext.create('Ext.data.TreeStore', {
//        model: 'Task',
//        proxy: {
//            type: 'ajax',
//            //the store will get the content from the .json file
//            url: 'GetAllTask'
//        },
//        folderSort: true,
//    });
    var store = Ext.create('Ext.data.TreeStore', {
        model: 'Car'
    });

//        //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
    var tree = Ext.create('Ext.tree.Panel', {
        id: 'sidelefttree',
        header: false,
        collapsible: true,
        useArrows: true,
//        rootVisible: false,
        lines: true,
        multiSelect: true,
        border: true,
        columns: [{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                width: 200,
                sortable: true,
                dataIndex: 'name',
            }
        ],
        listeners: {
            itemclick: function (s, r) {
                console.log(r.id);
                alert(r.id);
            },
            itemdblclick: function (tree, record, index) {

            }
        }
    });
    var carRootNode = {
        name: 'Cars',
        text: 'Cars',
        expanded: true,
        leaf: false,
        children: []
    };
    //set root node
    tree.setRootNode(carRootNode);

    //suppose this is your store containing dynamic data (coming from ajax response or populated on screen
    var carStore = Ext.create('Ext.data.Store', {
        model: 'Car',
        data: [{
                name: 'Mercedes-Benz'
            }, {
                name: 'Ferrari'
            }, {
                name: 'Audi'
            }, {
                name: 'Prius'
            }]
    });

    //get the root of the tree
    var root = tree.getRootNode();

    //iterate over your store and append your children one by one
    carStore.each(function (rec) {
        var childAttrModel;
        //Create a new object and set it as a leaf node (leaf: true)  
        childAttrModel = {
            name: rec.data.name,
            text: rec.data.name,
            leaf: true,
        };
        // add/append this object to your root node 
        root.appendChild(childAttrModel);
    });

</script>