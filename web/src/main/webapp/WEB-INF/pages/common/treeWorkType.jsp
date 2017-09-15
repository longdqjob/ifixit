<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="workType/workType_function.jsp" />
<jsp:include page="workType/workType_form.jsp" />
<script>
    var storeTreeWorkTypeSelected = null;
    var storeTreeWorkType = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            url: '../workType/getTree'
        },
        root: {
            text: '<fmt:message key="workType"/>',
            id: '-10',
            expanded: true
        },
        autoload: false
    });

    var workTypeTreeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        closable: true,
        title: '<fmt:message key="workType"/>',
        id: 'workTypeTreeWindow',
        autoEl: 'form',
        width: "70%",
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [
            {
                columnWidth: 1,
                xtype: 'treepanel',
                layout: 'fit',
                minHeight: 300,
                height: "60%",
                name: 'treeWorkType',
                id: 'treeWorkType',
                store: storeTreeWorkType,
                rootVisible: false,
                useArrows: true,
                columns: [{
                        xtype: 'treecolumn', //this is so we know which column will show the tree
                        width: 345,
                        text: '<fmt:message key="material.code"/>',
                        dataIndex: 'code',
                    }, {
                        text: '<fmt:message key="material.completeCode"/>',
                        dataIndex: 'completeCode',
                        flex: 1
                    }, {
                        text: '<fmt:message key="material.name"/>',
                        dataIndex: 'name',
                        flex: 1
                    },
                ],
                listeners: {
                    itemdblclick: function (tree, record, index) {
                        chooseWorkType(record);
                        workTypeTreeWindow.hide();
                    },
                    itemcontextmenu: function (tree, record, item, index, e, eOpts) {
                        // Optimize : create menu once
                        var menu_grid = new Ext.menu.Menu({items: [{
                                    text: '<fmt:message key="workType.addRoot"/>',
                                    iconCls: "add-cls",
                                    handler: function () {
                                        addCmWorkType();
                                    }}, {
                                    text: '<fmt:message key="workType.add"/>',
                                    iconCls: "add-cls",
                                    handler: function () {
                                        storeTreeWorkTypeSelected = record;
                                        addCmWorkType(record);
                                    }}, {
                                    text: '<fmt:message key="workType.edit"/>',
                                    iconCls: "edit-cls",
                                    handler: function () {
                                        storeTreeWorkTypeSelected = record;
                                        editCmWorkType(record);
                                    }}, {
                                    text: '<fmt:message key="workType.delete"/>',
                                    iconCls: "delete-cls",
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
            }
        ],
        listeners: {
            show: function (window) {
                maskTarget(Ext.getCmp('workTypeTreeWindow'));
                Ext.getCmp('treeWorkType').getStore().getRootNode().removeAll();
                Ext.getCmp('treeWorkType').getStore().load();
                Ext.getCmp('treeWorkType').getStore().on('load', function (store, records, options) {
                    unMaskTarget();
                });
            },
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    workTypeTreeWindow.hide();
                }
            }]
    });

</script>