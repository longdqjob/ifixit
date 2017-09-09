<%-- 
    Document   : layout
    Created on : Aug 26, 2017, 5:57:28 PM
    Author     : thuyetlv
--%>

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
                Ext.getStore('userstore').reload({start: 0, limit: pagesize});
                Ext.apply(Ext.getStore('userstore'), {pageSize: pagesize});
            },
            afterrender: function (field, opts) {
                field.setValue(pagesize);
            }
        }
    });


//-----------------------------------------Grid---------------------------------------------------------------
    var storeGrid = Ext.create('Ext.data.Store', {
        storeId: 'storeGrid',
        fields: ['id', 'code', 'name', 'description', 'itemTypeId'],
        pageSize: 20,
        proxy: {
            type: 'ajax',
            url: '../itemType/loadData',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });
    var mygrid = Ext.create('Ext.grid.Panel', {
        margin: '0 10 0 10',
        title: 'Users',
        id: 'gridId',
        store: storeGrid,
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
            //////////////ACTION
            {
                xtype: 'actioncolumn',
                text: 'Action',
                align: 'center',
                width: 100,
                items: [
                    {
                        icon: '../images/delete.png',
                        tooltip: 'Delete this Pool',
                        handler: function (grid, rowIndex, colIndex) {
                            var msg = '<fmt:message key="msgDelete.confirm.item"/>';
                            Ext.MessageBox.confirm('Confirm', msg, function (btn) {
                                if (btn == 'yes') {
                                    var recGrid = grid.getStore().getAt(rowIndex);
                                }
                            });
                        }
                    },
                    {
                        icon: '../images/edit.png',
                        tooltip: 'Edit this Pool',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex);
                        }
                    },
                ],
            },
            ////////////////ITEM   
            {text: 'ID', dataIndex: 'id', flex: 1, hidden: true},
            {text: 'Code', dataIndex: 'code', flex: 1, },
            {text: 'Name', dataIndex: 'name', flex: 1, },
            {text: 'Description', dataIndex: 'description', flex: 1, editor: {
                    completeOnEnter: false,
                    field: {
                        xtype: 'textfield',
                        allowBlank: false
                    }
                }},
            {text: 'itemTypeId', dataIndex: 'itemTypeId', flex: 1, },
        ],
        selModel: 'cellmodel',
        viewConfig: {
            autoFit: true,
            forceFit: true,
            preserveScrollOnRefresh: true,
            deferEmptyText: false,
            onStoreLoad: Ext.emptyFn,
            enableTextSelection: true,
            emptyText: '<div class="grid-data-empty"><div data-icon="/" class="empty-grid-icon"></div><div class="empty-grid-byline" style="text-align: center;">There are no records of Pools</div></div>',
        },
        plugins: {
            ptype: 'cellediting',
            clicksToEdit: 1
        },
        dockedItems: [{
                xtype: 'pagingtoolbar',
                id: 'userpagingid',
                dock: 'bottom',
                //store: myStore,
                displayInfo: true
            }, {
                xtype: 'toolbar',
                dock: 'top',
                items: [{
                        iconCls: 'add-cls',
                        xtype: 'button',
                        text: 'Add',
                        listeners: {
                            click: function (el) {
                                alert('click el');
                                console.log(el);
                            }
                        }//end of listeners
                    }, {
                        iconCls: 'delete-cls',
                        xtype: 'button',
                        text: 'Delete',
                        listeners: {
                            click: function (el) {
                                alert('Delete');
                                console.log(el);
                            }
                        }//end of listeners
                    },
                    'Per Page: ',
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
        margin: '0 10 0 0',
        autoScroll: true,
        layout: 'fit',
        items: [mygrid]
    });
</script>