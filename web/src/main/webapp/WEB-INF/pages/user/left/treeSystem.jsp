<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var systemIdSs = '${systemId}';
    var systemNameSs = '${systemName}';
    var storeTreeSys = Ext.create('Ext.data.TreeStore', {
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
            namedisplay: systemNameSs,
            id: systemIdSs,
            expanded: true
        },
        folderSort: true,
        sorters: [{
                property: 'namedisplay',
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
    var treeSystem = Ext.create('Ext.tree.Panel', {
        id: 'treeSystem',
        resizable: false,
        header: false,
        collapsible: false,
        useArrows: false,
        rootVisible: true,
        lines: true,
        multiSelect: true,
        border: true,
        store: storeTreeSys,
        minHeight: 400,
        viewConfig: {
            toggleOnDblClick: false
        },
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
                searchUser(systemIdSs);
            },
            itemclick: function (view, record) {
                //tree.expandPath(record.getPath());
            },
            itemdblclick: function (tree, record, item, index, e, eOpts) {
                selectedSystem = record;
                searchUser(record.get("id"));
                console.log("dbClick Load data " + record.get("id") + " - " + record.get("name"));
            },
        }
    });



</script>