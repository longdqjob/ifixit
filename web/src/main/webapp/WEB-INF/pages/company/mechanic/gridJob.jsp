<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
//-----------------------------------------Grid---------------------------------------------------------------
    var storeJob = Ext.create('Ext.data.Store', {
        storeId: 'storeJob',
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
    var gridJob = Ext.create('Ext.grid.Panel', {
        id: 'gridJob',
        store: storeJob,
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
            {text: '<fmt:message key="machine.job.status"/>', dataIndex: 'status', flex: 1,
                renderer: function (value) {
                    switch (value) {
                        case 0 :
                            return '<fmt:message key="work.status.complete"/>';
                        case 1 :
                            return '<fmt:message key="work.status.open"/>';
                        case 2 :
                            return '<fmt:message key="work.status.inProgress"/>';
                        case 3 :
                            return '<fmt:message key="work.status.over"/>';
                    }
                }
            },
            {text: '<fmt:message key="machine.job.wo"/>', dataIndex: 'name', flex: 1, },
            {text: '<fmt:message key="machine.job.code"/>', dataIndex: 'code', flex: 1, },
            {text: '<fmt:message key="machine.job.start"/>', type: 'date', dataIndex: 'startTime', flex: 1,
                renderer: function (value) {
                    if (value) {
                        value = value.replace(".0", "");
                        return Ext.Date.format(Ext.Date.parse(value, 'Y-m-d H:i:s'), 'm/d/Y');
                    }
                    return "";
                }},
            {text: '<fmt:message key="machine.job.end"/>', type: 'date', dataIndex: 'endTime', flex: 1,
                renderer: function (value) {
                    if (value) {
                        value = value.replace(".0", "");
                        return Ext.Date.format(Ext.Date.parse(value, 'Y-m-d H:i:s'), 'm/d/Y');
                    }
                    return "";
                }},
            {text: '<fmt:message key="machine.job.cost"/>', xtype: 'numbercolumn', align: "right", dataIndex: 'mhTotalCost', flex: 1, },
            {text: '<fmt:message key="machine.job.note"/>', dataIndex: 'note', flex: 1, },
        ],
        viewConfig: {
            autoFit: true,
            forceFit: true,
            preserveScrollOnRefresh: true,
            deferEmptyText: false,
            onStoreLoad: Ext.emptyFn,
            enableTextSelection: true,
            emptyText: '<div class="grid-data-empty"><div data-icon="/" class="empty-grid-icon"></div><div class="empty-grid-byline" style="text-align: center;"><fmt:message key="noRecord"/></div></div>',
            getRowClass: function (record, rowIndex, rowParams, store) {
                if (record.get('status') == '2'
                        || record.get('status') == 2) {
                    return 'overdue';
                }
                return "";
            },
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

    var gridJobPanel = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [gridJob]
    });


</script>