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
        fields: ['id', 'code', 'name', 'startTime', 'endTime', 'status', 'workTypeId', 
            'workTypeName','machineId','machineName','grpEngineerId','grpEngineerName'],
        pageSize: 20,
        proxy: {
            type: 'ajax',
            url: '../workOrder/loadData',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });
    
    
    
    var mygrid = Ext.create('Ext.grid.Panel', {
        title: '<fmt:message key="work.list"/>',
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
                        icon: '../images/delete.png',
                        tooltip: '<fmt:message key="deleteItem"/>',
                        handler: function (grid, rowIndex, colIndex) {
                            var msg = '<fmt:message key="msgDelete.confirm.item"/>';
                            Ext.MessageBox.confirm('Confirm', msg, function (btn) {
                                if (btn == 'yes') {
                                    var rec = grid.getStore().getAt(rowIndex);
                                    var param = '&ids=' + rec.get('id');
                                    deleteWorkOrder(param);
                                }
                            });
                        }
                    },
                    {
                        icon: '../images/edit.png',
                        tooltip: '<fmt:message key="editItem"/>',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex);
                            editWorkOrder(rec);
                        }
                    },
                ],
            },
            ////////////////ITEM   
            {text: 'ID', dataIndex: 'id', flex: 1, hidden: true},
            {text: '<fmt:message key="work.code"/>', dataIndex: 'code', flex: 1, },
            {text: '<fmt:message key="work.name"/>', dataIndex: 'name', flex: 1, },
            {text: '<fmt:message key="work.status"/>', dataIndex: 'status', flex: 1,
                renderer: function (value) {
                    switch (value) {
                        case 0 :
                            return '<fmt:message key="work.status.complete"/>';
                        case 1 :
                            return '<fmt:message key="work.status.open"/>';
                        case 2 :
                            return '<fmt:message key="work.status.approval"/>';
                        case 3 :
                            return '<fmt:message key="work.status.inProgress"/>';
                        case 3 :
                            return '<fmt:message key="work.status.pendding"/>';
                    }
                }
            },
            {text: '<fmt:message key="work.start"/>', dataIndex: 'startTime', flex: 1, },
            {text: '<fmt:message key="work.end"/>', dataIndex: 'endTime', flex: 1, },
            {text: '<fmt:message key="work.workType"/>', dataIndex: 'workTypeName', flex: 1, },
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
                //store: myStore,
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
                                addWorkOrder(null);
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
                                            deleteWorkOrder(arrayList);
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
            }
        }
    });

    var gridPanel = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [mygrid]
    });
</script>