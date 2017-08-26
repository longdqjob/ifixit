<%@ include file="/common/taglibs.jsp" %>

<head>
    <title><fmt:message key="userList.title"/></title>
    <meta name="menu" content="AdminMenu"/>


   

</head>
<!--<div >
    <div id="tree" class="col-sm-4">
    </div>
    <div class="col-sm-8">
        <div id="searchPanel">    </div>
        <div id="userGrid">    </div>
    </div>
</div>-->
<script>
    var search = new Ext.create('Ext.form.Panel', {
        xtype: 'form-hboxlayout',
        // title: 'Search',
        id: 'searchform',
        fullscreen: true,
        padding: '5 5 5 5',
        fieldDefaults: {
            labelAlign: 'top',
            msgTarget: 'side'
        },
        defaults: {
            border: false,
            xtype: 'panel',
            flex: 1,
            layout: 'anchor'
        },
        layout: 'hbox',
        items: [{
                items: [{
                        xtype: 'textfield',
                        fieldLabel: 'First Name',
                        anchor: '-5',
                        name: 'first'
                    }, {
                        xtype: 'textfield',
                        fieldLabel: 'Company',
                        anchor: '-5',
                        name: 'company'
                    }]
            }, {
                items: [{
                        xtype: 'textfield',
                        fieldLabel: 'Last Name',
                        anchor: '100%',
                        name: 'last'
                    }, {
                        xtype: 'textfield',
                        fieldLabel: 'Email',
                        anchor: '100%',
                        name: 'email',
                        vtype: 'email'
                    }]
            }],
        buttons: ['->', {
                text: 'Search'
            }, {
                text: 'Cancel'
            }],
        listeners: {
            'afterrender': function () {
                //TODO function fo afterender
            },            
        }
    });
    Ext.onReady(function () {


        Ext.create('Ext.container.Viewport', {
            layout: 'border',
            renderTo: Ext.getBody(),
            items: [{
                    region: 'north',
                    html: '  ',
                    border: false,
                    padding: '55 0 0 0'
                }, {
                    region: 'west',
                    collapsible: true,
                    title: 'Navigation',
                    width: 350,
                    html: ' <div id="tree"></div>  ',
                    listeners: {
                        collapse: function () {
                            Ext.getCmp("tabid").updateLayout();
                            Ext.getCmp("gridId").updateLayout();
                            Ext.getCmp("searchform").updateLayout();
                        },
                        expand: function () {
                            Ext.getCmp("tabid").updateLayout();
                            Ext.getCmp("gridId").updateLayout();
                            Ext.getCmp("searchform").updateLayout();
                        }
                    }
                }, {
                    region: 'center',
                    html: '<div id="rightPanel"></div>' //rightPanel
                }],
            listeners: {
                resize: function (width, height, oldWidth, oldHeight, eOpts) {
                    setTimeout(function () {
//                        console.log("Resize viewport");
//                        console.log($(window).height());
//                        console.log($(window).width());

                        Ext.getCmp('tabid').setHeight($(window).height());
                        Ext.getCmp('gridId').setHeight($(window).height() - 142 - search.getHeight());
                        Ext.getCmp('sidelefttree').setHeight($(window).height() - 142);

                        Ext.getCmp("tabid").updateLayout();
                        Ext.getCmp("gridId").updateLayout();
                        Ext.getCmp("searchform").updateLayout();

                    }, 1);
                },
            },
        });
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
        Ext.define('User', {
            extend: 'Ext.data.Model',
            fields: ['UserName', 'Email', 'PhoneNumber']
        });
        var myStore = Ext.create('Ext.data.Store', {
            model: 'User',
            storeId: 'customerNameStore',
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
                    dock: 'bottom',
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
                        }
                    ]
                }],
            listeners: {
                afterrender: function (usergrid, eOpts) {
                    //console.log(usergrid);
                }
            }

        });
        search.render('searchPanel');

    });//end of OnReady furnciotn

</script>



<jsp:include page="../common/treeDemo.jsp" />
