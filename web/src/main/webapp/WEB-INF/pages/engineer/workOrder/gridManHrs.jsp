<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
//-----------------------------------------Grid---------------------------------------------------------------
    var storeManHrs = Ext.create('Ext.data.Store', {
        storeId: 'storeManHrs',
        fields: ['id', 'engineerId', 'engineerGrp', 'mh', 'engineerCost', 'workOrderId'],
        pageSize: 20,
    });

    var storeManHrsPaging = Ext.create('Ext.data.Store', {
        fields: ['id', 'engineerGrp', 'mh', 'engineerCost'],
        autoLoad: false,
        pageSize: 5,
        proxy: {
            type: 'pagingmemory'
        }
    });

    var manHrsTotalMh = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        id: "manHrsTotalMh",
        fieldLabel: '<fmt:message key="work.manHour.totalHrs"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 150,
        readOnly: true,
        labelWidth: 70,
    });
    var manHrsTotalCost = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        id: "manHrsTotalCost",
        fieldLabel: '<fmt:message key="work.manHour.totalCost"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 150,
        readOnly: true,
        labelWidth: 70,
    });

    var gridManHrs = Ext.create('Ext.grid.Panel', {
        id: 'gridManHrs',
        store: storeManHrs,
        autoWidth: true,
        border: true,
        layout: 'fit',
        columns: [
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
                                    deleteManHrs(param);
                                }
                            });
                        }
                    },
                    {
                        icon: '../images/edit.png',
                        tooltip: '<fmt:message key="editItem"/>',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex);
                            showManHrs(rec);
                        }
                    },
                ],
            },
            ///RowNumberer
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
            ////////////////ITEM
            {text: '<fmt:message key="work.manHour.enginnerGrp"/>', dataIndex: 'engineerGrp', flex: 1, },
            {text: '<fmt:message key="work.manHour.manHrs"/>', dataIndex: 'mh', flex: 1, },
            {text: '<fmt:message key="work.manHour.cost"/>', dataIndex: 'engineerCost', flex: 1, },
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
                store: storeManHrsPaging,
                displayInfo: true
            }, {
                xtype: 'toolbar',
                dock: 'top',
                items: [{
                        xtype: 'button',
                        text: '<fmt:message key="add"/>',
                        listeners: {
                            click: function (el) {
                                showManHrs(null);
                            }
                        }//end of listeners
                    }, manHrsTotalMh, manHrsTotalCost
                ]
            }],
        listeners: {
            afterrender: function (usergrid, eOpts) {
                //console.log(usergrid);
            }
        }
    });

    var gridManHrsPanel = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [gridManHrs]
    });


</script>