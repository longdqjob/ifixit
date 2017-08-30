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

    //---------------------------Display tab panel--------------------------------------------------------------------
    var tab = Ext.create('Ext.tab.Panel', {
        renderTo: "rightPanel",
        id: "tabid",
        tabBarPosition: 'top',
        autoHeight: true,
        items: [
            {title: 'Tab 1', html: " <div id='searchPanel'></div> <div id='userGrid'></div>"},
            {title: 'Tab 2', html: "longdq"},
            {title: 'Tab 3', html: "VNPT"},
        ],
        listeners: {
            render: function (tab, eOpts) {
                this.items.each(function (i) {
                    i.tab.on('click', function () {
                        console.log(i.title);
                    });
                });
            }
        }
    });

//-----------------------------------------Grid---------------------------------------------------------------
    Ext.define('User', {
        extend: 'Ext.data.Model',
        fields: ['UserName', 'Email', 'PhoneNumber']
    });
    var myStore = Ext.create('Ext.data.Store', {
        model: 'User',
        storeId: 'userstore',
        pageSize: 20,
        autoLoad: true,
        proxy: {
            type: 'ajax',
            url: 'GetAllUser',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });
    var mygrid = Ext.create('Ext.grid.Panel', {
        title: 'Users',
        id: 'gridId',
        renderTo: 'userGrid',
        store: myStore,
        autoWidth: true,
        border: true,
        columns: [
            Ext.create('Ext.grid.RowNumberer', {
                text: 'No.',
                width: 50,
                align: 'center',
                sortable: false,
                renderer: function (v, p, record, rowIndex) {
                    if (this.rowspan) {
                        p.cellAttr = 'rowspan="' + this.rowspan + '"';
                    }
                    return rowIndex + 1;
                }
            }),
            {text: 'Name', dataIndex: 'UserName', flex: 1, },
            {text: 'Email', dataIndex: 'Email', flex: 1, },
            {text: 'Phone', dataIndex: 'PhoneNumber', flex: 1, editor: {
                    completeOnEnter: false,
                    field: {
                        xtype: 'textfield',
                        allowBlank: false
                    }
                }}
        ],
        selModel: 'cellmodel',
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
            },
            {
                xtype: 'toolbar',
                dock: 'top',
                items: [
                    {
                        iconCls: 'add-cls',
                        xtype: 'button',
                        text: 'Add',
                        listeners: {
                            click: function (el) {
                                alert('click el');
                                console.log(el);
                            }
                        }//end of listeners
                    },
                    {
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
    

</script>