<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
//-----------------------------------------Grid---------------------------------------------------------------
    var storeHis = Ext.create('Ext.data.Store', {
        storeId: 'storeHis',
        pageSize: 20,
        autoLoad: false,
        proxy: {
            type: 'ajax',
            url: '../workOrder/loadWOHis',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });
    var gridHis = Ext.create('Ext.grid.Panel', {
        id: 'gridHis',
        store: storeHis,
        autoWidth: true,
        border: true,
        layout: 'fit',
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
            ////////////////ITEM
            {text: '<fmt:message key="machine.maintainHistory.status"/>', dataIndex: 'status', flex: 1,
                renderer: function (value) {
                    switch (value) {
                        case 0 :
                            return '<fmt:message key="work.status.complete"/>';
                        case 1 :
                            return '<fmt:message key="work.status.open"/>';
                        case 2 :
                            return '<fmt:message key="work.status.over"/>';
                    }
                }
            },            
            {text: '<fmt:message key="machine.maintainHistory.wo"/>', dataIndex: 'name', flex: 1, },
            {text: '<fmt:message key="machine.maintainHistory.code"/>', dataIndex: 'code', flex: 1, },
            {text: '<fmt:message key="machine.maintainHistory.start"/>', type: 'date', dataIndex: 'startTime', flex: 1,
                renderer: function (value) {
                    if (value) {
                        value = value.replace(".0", "");
                        return Ext.Date.format(Ext.Date.parse(value, 'Y-m-d H:i:s'), 'm/d/Y');
                    }
                    return "";
                }},
            {text: '<fmt:message key="machine.maintainHistory.end"/>', type: 'date', dataIndex: 'endTime', flex: 1,
                renderer: function (value) {
                    if (value) {
                        value = value.replace(".0", "");
                        return Ext.Date.format(Ext.Date.parse(value, 'Y-m-d H:i:s'), 'm/d/Y');
                    }
                    return "";
                }},
            {text: '<fmt:message key="machine.maintainHistory.cost"/>', dataIndex: 'mhTotalCost', flex: 1, },
            {text: '<fmt:message key="machine.maintainHistory.note"/>', dataIndex: 'note', flex: 1, },
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
            }],
        listeners: {
            afterrender: function (usergrid, eOpts) {
                //console.log(usergrid);
            }
        }
    });

    var gridHisPanel = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [gridHis]
    });


</script>