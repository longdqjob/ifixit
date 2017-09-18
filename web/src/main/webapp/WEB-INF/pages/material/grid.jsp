<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var pagesize = 20;
    var combo = new Ext.form.ComboBox({
        name: 'perpage',
        width: 60,
        store: new Ext.data.ArrayStore({
            fields: ['id'],
            data: [
                ['20'],
                ['50'],
                ['100']
            ]
        }),
        mode: 'local',
        value: '15',
        listWidth: 40,
        triggerAction: 'all',
        displayField: 'id',
        valueField: 'id',
        editable: false,
        forceSelection: true,
        listeners: {
            select: function (combo, record, eOpts) {
                pagesize = record.id;
                Ext.getStore('storeGrid').reload({start: 0, limit: pagesize});
                Ext.apply(Ext.getStore('storeGrid'), {pageSize: pagesize});
            },
            afterrender: function (field, opts) {
                field.setValue(pagesize);
            }
        }
    });


//-----------------------------------------Grid---------------------------------------------------------------
    var storeGrid = Ext.create('Ext.data.Store', {
        storeId: 'storeGrid',
        pageSize: 20,
        proxy: {
            type: 'ajax',
            url: '../material/loadData',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });
    var mygrid = Ext.create('Ext.grid.Panel', {
        title: '<fmt:message key="material.list"/>',
        id: 'gridId',
        store: storeGrid,
        autoWidth: true,
        border: true,
        layout: 'fit',
        selModel: {
            selType: 'checkboxmodel',
            showHeaderCheckbox: true
        },
        columns: [
            Ext.create('Ext.grid.RowNumberer', {
                text: 'No.',
                width: 50,
                align: 'center',
                sortable: false,
                renderer: function (value, metaData, record, rowIndex, colIdx, store) {
                    if (this.rowspan) {
                        metaData.cellAttr = 'rowspan="' + this.rowspan + '"';
                    }
                    return store.indexOfTotal ? (store.indexOfTotal(record) + 1) : (rowIndex + 1);
                }
            }),
            //////////////ACTION
            {
                xtype: 'actioncolumn',
                text: 'Action',
                align: 'center',
                width: 100,
                items: [
                    {
                        icon: '../images/edit.png',
                        tooltip: '<fmt:message key="editItem"/>',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex);
                            editMaterial(rec);
                        }
                    },
                    {
                        icon: '../images/delete.png',
                        tooltip: '<fmt:message key="deleteItem"/>',
                        handler: function (grid, rowIndex, colIndex) {
                            var msg = '<fmt:message key="msgDelete.confirm.item"/>';
                            Ext.MessageBox.confirm('Confirm', msg, function (btn) {
                                if (btn == 'yes') {
                                    var rec = grid.getStore().getAt(rowIndex);
                                    var param = '&ids=' + rec.get('id');
                                    deleteMaterial(param);
                                }
                            });
                        }
                    },
                ],
            },
            ////////////////ITEM   
            {text: 'ID', dataIndex: 'id', flex: 1, hidden: true},
            {text: '<fmt:message key="material.code"/>', dataIndex: 'code', flex: 1, },
            {text: '<fmt:message key="material.completeCode"/>', dataIndex: 'completeCode', flex: 1, },
            {text: '<fmt:message key="material.name"/>', dataIndex: 'name', flex: 1, },
            {text: '<fmt:message key="material.qty"/>', dataIndex: 'quantity', flex: 1,
                editor: {
                    completeOnEnter: true,
                    field: {
                        xtype: 'numberfield',
                        allowBlank: false,
                        allowDecimals: false,
                        allowNegative: false,
                        minValue: 0,
                    },
                }
            },
            {text: '<fmt:message key="material.unit"/>', dataIndex: 'unit', flex: 1,
                editor: {
                    xtype: 'combobox',
                    queryMode: 'local',
                    displayField: 'name',
                    valueField: 'abbr',
                    store: unitStore,
                },
            },
            {text: '<fmt:message key="material.unitCost"/>', dataIndex: 'cost', flex: 1,
                editor: {
                    completeOnEnter: true,
                    field: {
                        xtype: 'numberfield',
                        allowBlank: false,
                        allowDecimals: true,
                        allowNegative: false,
                        minValue: 0,
                    },
                }
            },
        ],
        viewConfig: {
            autoFit: true,
            forceFit: true,
            preserveScrollOnRefresh: true,
            deferEmptyText: false,
            onStoreLoad: Ext.emptyFn,
            enableTextSelection: true,
            emptyText: '<div class="grid-data-empty"><div data-icon="/" class="empty-grid-icon"></div><div class="empty-grid-byline" style="text-align: center;"><fmt:message key="noRecord"/></div></div>',
        },
        plugins: {
            ptype: 'cellediting',
            clicksToEdit: 1
        },
        dockedItems: [{
                xtype: 'pagingtoolbar',
                dock: 'bottom',
                displayInfo: true
            }, {
                xtype: 'toolbar',
                dock: 'top',
                items: [{
                        iconCls: 'add-cls',
                        xtype: 'button',
                        text: '<fmt:message key="add"/>',
                        listeners: {
                            click: function (el) {
                                addMaterial(selectedItem);
                            }
                        }//end of listeners
                    }, {
                        iconCls: 'delete-cls',
                        xtype: 'button',
                        text: '<fmt:message key="delete"/>',
                        listeners: {
                            click: function (el) {
                                var arrayList = '',
                                        selected = Ext.getCmp('gridId').getView().getSelectionModel().getSelection();
                                var count = 0;
                                Ext.each(selected, function (item) {
                                    arrayList += '&ids=' + (item.get('id'));
                                    count++;
                                });
                                if (count <= 0) {
                                    alertWarning('<fmt:message key="notSelect"/>');
                                } else {
                                    var message = '<fmt:message key="msgDelete.confirm.list"/>';
                                    message = message.replace("{0}", count);
                                    alertConfirm(message, function (e) {
                                        if (e == 'yes') {
                                            deleteMaterial(arrayList);
                                        }
                                    });
                                }
                            }
                        }//end of listeners
                    },
                    '<fmt:message key="perPage"/>',
                    combo
                ]
            }],
        listeners: {
            afterrender: function (usergrid, eOpts) {
                //console.log(usergrid);
            },'rowdblclick': function (grid, record) {
                editMaterial(record);
            },validateedit: function (editor, context, eOpts) {
                if (!editor.editors.items[0].field.wasValid) {
                    context.cancel = true;
                    return false;
                }
                var record = context.record;
                var unit = record.get("unit");
                var cost = record.get("cost");
                var quantity = record.get("quantity");
                if (context.field == "unit") {
                    if (context.value == "") {
                        context.cancel = true;
                        return false;
                    } else if (unit == context.value) {
                        return true;
                    }
                    unit = context.value;
                } else if (context.field == "cost") {
                    if (parseFloat(context.value) < 0) {
                        context.cancel = true;
                        return false;
                    } else if (cost == context.value) {
                        return true;
                    }
                    cost = context.value;
                } else if (context.field == "quantity") {
                    if (parseInt(context.value) < 0) {
                        context.cancel = true;
                        return false;
                    } else if (quantity == context.value) {
                        return true;
                    }
                    quantity = context.value;
                }

                saveChangeMaterial(record.get("id"), quantity, unit, cost,
                        function () {
                            context.record.dirty = true;
                            return true;
                        },
                        function () {
                            context.cancel = true;
                            return false;
                        });
            },
            edit: function (editor, e) {
                var record = e.record;
                record.dirty = true;
            }
        }
    });

    var gridPanel = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [mygrid]
    });
</script>