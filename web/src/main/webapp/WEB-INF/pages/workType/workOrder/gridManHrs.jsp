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
        fields: ['id', 'engineerGrp', 'mh', 'cost'],
        pageSize: 20,
    });
    var gridManHrs = Ext.create('Ext.grid.Panel', {
        id: 'gridManHrs',
        store: storeManHrs,
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
            {text: '<fmt:message key="work.manHour.enginnerGrp"/>', dataIndex: 'engineerGrp', flex: 1, },
            {text: '<fmt:message key="work.manHour.manHrs"/>', dataIndex: 'mh', flex: 1, },
            {text: '<fmt:message key="work.manHour.cost"/>', dataIndex: 'cost', flex: 1, },
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

    var gridManHrsPanel = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [gridManHrs]
    });


</script>