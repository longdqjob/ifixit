<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    function fnSearchMechanicType() {
        gridMechanicType.getStore().getProxy().extraParams = {
            code: searchMechanicCode.getValue(),
            name: searchMechanicName.getValue(),
        };
        gridMechanicType.getStore().loadPage(1);
    }

    var searchMechanicCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="machineType.code"/>',
        id: "searchMechanicCode",
        anchor: '100%',
        margin: '10 10 10 10',
    });
    var searchMechanicName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="machineType.name"/>',
        id: "searchMechanicName",
        anchor: '100%',
        margin: '10 10 10 10',
    });

    var searchMechanicType = new Ext.form.Panel({
        id: "searchMechanicType",
        xtype: 'form',
        title: '<fmt:message key="button.search"/>' + " " + '<fmt:message key="machineType"/>',
        items: [{
                xtype: 'container',
                anchor: '100%',
                columnWidth: 1,
                layout: 'column',
                items: [
                    {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [searchMechanicCode]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [searchMechanicName]
                    }
                ]
            }
        ],
        buttons: [{
                text: '<fmt:message key="button.search"/>',
                handler: function () {
                    fnSearchMechanicType();
                }
            }, {
                text: '<fmt:message key="button.reset"/>',
                handler: function () {
                    searchMechanicType.getForm().reset();
                    fnSearchMechanicType();
                }
            }
        ],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        fnSearchMechanicType();
                    }
                });
            }
        } //end of listeners
    });

    var storeMechanicType = Ext.create('Ext.data.Store', {
        storeId: 'storeGrid',
        fields: ['id', 'code', 'name', 'description', 'specification', 'note'],
        pageSize: 20,
        autoLoad: true,
        proxy: {
            type: 'ajax',
            url: '../machineType/loadData',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });

    var gridMechanicType = Ext.create('Ext.grid.Panel', {
        title: '<fmt:message key="machineType.list"/>',
        id: 'gridMechanicType',
        store: storeMechanicType,
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
                    var options = store.lastOptions;
                    return (options.start) ? (options.start + rowIndex + 1) : (rowIndex + 1);
                }
            }),
            ////////////////ITEM   
            {text: 'ID', dataIndex: 'id', flex: 1, hidden: true},
            {text: '<fmt:message key="machineType.code"/>', dataIndex: 'code', flex: 0.5, },
            {text: '<fmt:message key="machineType.name"/>', dataIndex: 'name', flex: 1.5, },
            {text: '<fmt:message key="machineType.description"/>', dataIndex: 'description', flex: 1},
            {text: '<fmt:message key="machineType.note"/>', dataIndex: 'note', flex: 1},
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
        dockedItems: [{
                xtype: 'pagingtoolbar',
                dock: 'bottom',
                displayInfo: true
            }],
        listeners: {
            afterrender: function (usergrid, eOpts) {
                //console.log(usergrid);
            },
            itemdblclick: function (dv, record, item, index, e) {
                mechanicTypeWindow.hide();
                chooseMechanicType(record);
            }
        }
    });

    var mechanicTypeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'show',
        autoEl: 'form',
        width: 1000,
        height: 600,
        constrainHeader: true,
        title: 'Choose Device(s)',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [{
                xtype: 'container',
                columnWidth: 1,
                layout: 'anchor',
                anchor: '100%',
                items: [searchMechanicType]
            }, {
                xtype: 'container',
                columnWidth: 1,
                layout: 'anchor',
                anchor: '100%',
                items: [gridMechanicType]
            },
        ],
        listeners: {
            resize: function (width, height, oldWidth, oldHeight, eOpts) {
                setTimeout(function () {
                    gridMechanicType.setHeight(mechanicTypeWindow.getHeight() - searchMechanicType.getHeight() - 78);
                }, 1);
            },
        },
        buttons: [
            {
                text: 'Cancel',
                id: 'cancelEditDeviceId',
                handler: function () {
                    mechanicTypeWindow.hide();
                }
            }
        ]
    });


</script>