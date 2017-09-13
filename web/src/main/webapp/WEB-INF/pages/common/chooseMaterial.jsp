<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    function fnSearchMaterial() {
        gridMaterial.getStore().getProxy().extraParams = {
            code: searchMaterialCode.getValue(),
            name: searchMaterialName.getValue(),
        };
        gridMaterial.getStore().loadPage(1);
    }

    var searchMaterialCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="material.code"/>',
        anchor: '100%',
        margin: '10 10 10 10',
    });
    var searchMaterialName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="material.name"/>',
        anchor: '100%',
        margin: '10 10 10 10',
    });

    var searchMaterial = new Ext.form.Panel({
        xtype: 'form',
        title: '<fmt:message key="button.search"/>' + " " + '<fmt:message key="material"/>',
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
                        items: [searchMaterialCode]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [searchMaterialName]
                    }
                ]
            }
        ],
        buttons: [{
                text: '<fmt:message key="button.search"/>',
                handler: function () {
                    fnSearchMaterial();
                }
            }, {
                text: '<fmt:message key="button.reset"/>',
                handler: function () {
                    searchMaterial.getForm().reset();
                    fnSearchMaterial();
                }
            }
        ],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        fnSearchMaterial();
                    }
                });
            }
        } //end of listeners
    });

    var storeMaterial = Ext.create('Ext.data.Store', {
        storeId: 'storeMaterial',
        fields: ['id', 'code', 'name', 'description', 'unit', 'cost'],
        pageSize: 20,
        autoLoad: false,
        proxy: {
            type: 'ajax',
            url: '../material/loadData',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });

    var gridMaterial = Ext.create('Ext.grid.Panel', {
        title: '<fmt:message key="material.list"/>',
        store: storeMaterial,
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
            {text: '<fmt:message key="material.code"/>', dataIndex: 'code', flex: 0.5, },
            {text: '<fmt:message key="material.name"/>', dataIndex: 'name', flex: 1.5, },
            {text: '<fmt:message key="material.description"/>', dataIndex: 'description', flex: 1},
            {text: '<fmt:message key="work.material.unit"/>', dataIndex: 'unit', flex: 1},
            {text: '<fmt:message key="work.material.cost"/>', dataIndex: 'cost', flex: 1},
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
                materialWindow.hide();
                chooseMaterial(record);
            }
        }
    });

    var materialWindow = Ext.create('Ext.window.Window', {
        closeAction: 'show',
        autoEl: 'form',
        width: 1000,
        height: 600,
        constrainHeader: true,
        title: '<fmt:message key="material"/>',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [{
                xtype: 'container',
                columnWidth: 1,
                layout: 'anchor',
                anchor: '100%',
                items: [searchMaterial]
            }, {
                xtype: 'container',
                columnWidth: 1,
                layout: 'anchor',
                anchor: '100%',
                items: [gridMaterial]
            },
        ],
        listeners: {
            show: function (window) {
                fnSearchMaterial();
            },
            resize: function (width, height, oldWidth, oldHeight, eOpts) {
                setTimeout(function () {
                    gridMaterial.setHeight(materialWindow.getHeight() - searchMaterial.getHeight() - 78);
                }, 1);
            },
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    materialWindow.hide();
                }
            }
        ]
    });


</script>