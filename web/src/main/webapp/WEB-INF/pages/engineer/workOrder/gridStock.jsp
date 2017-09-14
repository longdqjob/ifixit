<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
//-----------------------------------------Grid---------------------------------------------------------------
    var storeStock = Ext.create('Ext.data.Store', {
        storeId: 'storeStock',
        fields: ['id', 'workOrderId', 'quantity', 'materialId', 'materialCode', 'materialName', 'materialDesc', 'materialUnit'],
        pageSize: 20,
    });

    var materialTotalCost = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        id: "materialTotalCost",
        fieldLabel: '<fmt:message key="work.material.totalCost"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 180,
        readOnly: true,
        labelWidth: 70,
    });

    var gridStock = Ext.create('Ext.grid.Panel', {
        id: 'gridStock',
        store: storeStock,
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
                                    deleteStock(param);
                                }
                            });
                        }
                    },
                    {
                        icon: '../images/edit.png',
                        tooltip: '<fmt:message key="editItem"/>',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex);
                            showStockForm(rec);
                        }
                    },
                ],
            },
            ////RowNumberer
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
            {text: '<fmt:message key="work.material.code"/>', dataIndex: 'materialCode', flex: 1, },
            {text: '<fmt:message key="work.material.name"/>', dataIndex: 'materialName', flex: 1, },
            {text: '<fmt:message key="work.material.description"/>', dataIndex: 'materialDesc', flex: 1, },
            {text: '<fmt:message key="work.material.qty"/>', dataIndex: 'quantity', flex: 1, },
            {text: '<fmt:message key="work.material.unit"/>', dataIndex: 'materialUnit', flex: 1, },
            {text: '<fmt:message key="work.material.cost"/>', dataIndex: 'materialUnit', flex: 1, },
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
                        xtype: 'button',
                        text: '<fmt:message key="add"/>',
                        listeners: {
                            click: function (el) {
                                showStockForm(null);
                            }
                        }//end of listeners
                    }, materialTotalCost
                ]
            }],
        listeners: {
            afterrender: function (usergrid, eOpts) {
                //console.log(usergrid);
            }
        }
    });

    var gridStockPanel = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [gridStock]
    });


</script>