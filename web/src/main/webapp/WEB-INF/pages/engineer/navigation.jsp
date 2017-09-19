<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var grpEngineerIdSs = ${grpEngineerId};
//    var grpEngineerNameSs = '${grpEngineerName}';
//    var userGrpEngineerObj = {
//        "id": grpEngineerIdSs,
//        "name": grpEngineerNameSs,
//        "code": "",
//        "completeCode": "",
//        "description": "",
//        "namedisplay": "",
//        "cost": "",
//    };
//    var grpEngineerNameObjSs = '${userGrpEngineerObj}';
//    console.log(grpEngineerNameObjSs);
//    var decoded = $('<div/>').html(grpEngineerNameObjSs).text();
//    console.log(decoded);
//    if(decoded){
//        var tmpObj = Ext.decode(decoded);
//        userGrpEngineerObj["id"] = tmpObj.myHashMap.id;
//        userGrpEngineerObj["name"] = tmpObj.myHashMap.name;
//        userGrpEngineerObj["code"] = tmpObj.myHashMap.code;
//        userGrpEngineerObj["completeCode"] = tmpObj.myHashMap.completeCode;
//        userGrpEngineerObj["description"] = tmpObj.myHashMap.description;
//        userGrpEngineerObj["namedisplay"] = tmpObj.myHashMap.namedisplay;
//        userGrpEngineerObj["cost"] = tmpObj.myHashMap.cost;
//    }
//    console.log(Ext.decode(decoded));
    var storeEngineer = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../grpEngineer/getTree'
        },
        root: {
            id: 0,
            name: '<fmt:message key="grpEngineer"/>',
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
        useArrows: false,
        rootVisible: true,
        lines: true,
        multiSelect: true,
        border: true,
        constrainHeader: false,
        store: storeEngineer,
        hideHeaders: true,
        minHeight: 400,
         viewConfig: {
            toggleOnDblClick: false
        },
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
                var menu_grid = null;
                if (record.get("id") > 0) {
                    engParentNode = record.parentNode.get("id");
                    // Optimize : create menu once
                    menu_grid = new Ext.menu.Menu({items: [{
                                text: '<fmt:message key="loadData"/>',
                                iconCls: "refresh",
                                handler: function () {
                                    selectedSystem = record;
                                    console.log(selectedSystem);
                                    loadWorkOrder(selectedSystem.get("id"));
                                }}, {
                                text: '<fmt:message key="button.add"/>',
                                iconCls: "add-cls",
                                handler: function () {
                                    addEngineer(record);
                                }}, {
                                text: '<fmt:message key="button.edit"/>',
                                iconCls: "edit-cls",
                                handler: function () {
                                    editEngineer(record);
                                }}, {
                                text: '<fmt:message key="moreDetail"/>',
                                handler: function () {
                                    console.log("Moreils: " + record.get("id") + " - " + record.get("name"));
                                }}, {
                                text: '<fmt:message key="button.delete"/>',
                                iconCls: "delete-cls",
                                handler: function () {
                                    var msg = '<fmt:message key="msgDelete.confirm.item"/>';
                                    Ext.MessageBox.confirm('Confirm', msg, function (btn) {
                                        if (btn == 'yes') {
                                            //var param = record.get('id');
                                            deleteEngineer("ids=" + record.get('id'));
                                        }
                                    });
                                }}]
                    });
                } else {
                    engParentNode = 0;
                    menu_grid = new Ext.menu.Menu({items: [{
                                text: '<fmt:message key="loadData"/>',
                                iconCls: "refresh",
                                handler: function () {
                                    selectedSystem = record;
                                    console.log(selectedSystem);
                                    loadWorkOrder(selectedSystem.get("id"));
                                }
                            }, {
                                text: '<fmt:message key="button.add"/>',
                                iconCls: "add-cls",
                                handler: function () {
                                    addEngineer(record);
                                }
                            }, ]
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