<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var materialImportFile = {
        xtype: 'filefield',
        id: "materialImportFile",
        tabIndex: 3,
        name: 'file',
        fieldLabel: '<fmt:message key="material.import.file"/>',
        allowBlank: true,
        margin: '10 10 10 10',
        anchor: '99%',
        buttonText: '<fmt:message key="browse"/>',
        listeners: {
            change: function (fld, value) {
                var newValue = value.replace(/C:\\fakepath\\/g, '');
                fld.setRawValue(newValue);
                validateImport();
            }
        }
    };

    var materialImportForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        items: [materialImportFile]
    });

    //--------------------------------GRID--------------------------------------
    var storeDataImport = Ext.create('Ext.data.Store', {
        storeId: 'storeDataImport',
        pageSize: 20,
    });

    var storeDataPaging = Ext.create('Ext.data.Store', {
        autoLoad: false,
        pageSize: 5,
        proxy: {
            type: 'pagingmemory'
        }
    });

    var gridDataImport = Ext.create('Ext.grid.Panel', {
        id: 'gridDataImport',
        store: storeDataImport,
        autoWidth: true,
        border: true,
        layout: 'fit',
        columns: [
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
            {text: '<fmt:message key="material.code"/>', dataIndex: 'code', flex: 2, },
            {text: '<fmt:message key="material.completeCode"/>', dataIndex: 'completeCode', flex: 2, },
            {text: '<fmt:message key="material.name"/>', dataIndex: 'name', flex: 2, },
            {text: '<fmt:message key="material.unit"/>', dataIndex: 'unit', flex: 2, },
            {text: '<fmt:message key="material.qty"/>', dataIndex: 'quantity', flex: 2, },
            {text: '<fmt:message key="material.unitCost"/>', dataIndex: 'cost', flex: 2, },
            {text: '<fmt:message key="material.location"/>', dataIndex: 'location', flex: 2, },
            {text: '<fmt:message key="material.import.status"/>', dataIndex: 'imgPath', flex: 2, },
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
                store: storeDataImport,
                displayInfo: true
            }],
        listeners: {
            afterrender: function (usergrid, eOpts) {
                //console.log(usergrid);
            },
        }
    });

    var panelDataImport = Ext.create('Ext.panel.Panel', {
        autoScroll: true,
        layout: 'fit',
        items: [gridDataImport]
    });

    var materialImportWindow = Ext.create('Ext.window.Window', {
        title: '<fmt:message key="material.import.title"/>',
        closeAction: 'hide',
        autoEl: 'form',
        width: '60%',
        height: "80%",
        autoScroll: true,
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [materialImportForm, panelDataImport],
        buttons: [{
                text: '<fmt:message key="button.import"/>',
                type: 'submit',
                id: "btnExeImport",
                hidden: true,
                handler: function () {
                    executeImport();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    materialImportWindow.hide();
                }
            }],
        listeners: {
            show: function (window) {
                gridDataImport.setHeight(materialImportWindow.getHeight() - materialImportForm.getHeight() - 90);
            },
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        executeImport();
                    }
                });
            },
        }
    });


</script>
