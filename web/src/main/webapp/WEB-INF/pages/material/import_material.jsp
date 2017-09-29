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
                var ext = getExtOfFile(newValue);
                if (ext != "xls" && ext != "xlsx") {
                    fld.setRawValue("");
                    alertError('<fmt:message key="invalidFormatImport"/>');
                    return;
                }
                fld.setRawValue(newValue);
                validateImport();
            }
        }
    };

    var materialImportDownloadTmp = new Ext.create('Ext.Component', {
        margin: '15 10 10 10',
        html: '<fmt:message key="downloadTpl"/>' + ' <a href="../admin/download?file=' + "eec34d804c9ce6c89cff596be555e6a4" + '">' + '<fmt:message key="here"/>' + '</a>.',
        listeners: {
            'click': function () {
                // do stuff
            },
            // name of the component property which refers to the element to add the listener to
            element: 'el',
            // css selector to filter the target element
            delegate: 'a'
        }
    });

    var materialImportForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        items: [{
                xtype: 'container',
                anchor: '100%',
                columnWidth: 1,
                layout: 'column',
                height: '100%',
                items: [{
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [materialImportFile]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [materialImportDownloadTmp]
                    },
                ]
            }
        ],
    });

    //--------------------------------GRID--------------------------------------
    var storeDataImport = Ext.create('Ext.data.Store', {
        storeId: 'storeDataImport',
        listeners: {
            load: function () {
                console.log("---------storeDataImport--------");
                storeDataPaging.getProxy().setData(storeDataImport.getRange());
                storeDataPaging.load();
            }
        }
    });

    var storeDataPaging = Ext.create('Ext.data.Store', {
        proxy: {
            type: 'memory',
            enablePaging: true,
        },
        autoLoad: false,
        pageSize: 5,
    });

    var gridDataImport = Ext.create('Ext.grid.Panel', {
        id: 'gridDataImport',
        store: storeDataPaging,
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
                    if (record.get('errorCode') != '0') {
                        metaData.style = 'background-color: #e88971 !important;';
                    }
                    return ((store.currentPage - 1) * store.pageSize) + (rowIndex + 1);
                }
            }),
            ////////////////ITEM
            {text: '<fmt:message key="material.code"/>', dataIndex: 'code', flex: 0.75, },
            {text: '<fmt:message key="material.completeCode"/>', dataIndex: 'completeCode', flex: 1.25, },
            {text: '<fmt:message key="material.name"/>', dataIndex: 'name', flex: 1.5, },
            {text: '<fmt:message key="material.unit"/>', dataIndex: 'unit', flex: 0.5, },
            {text: '<fmt:message key="material.qty"/>', dataIndex: 'quantity', flex: 1, },
            {text: '<fmt:message key="material.unitCost"/>', dataIndex: 'cost', flex: 1, },
            {text: '<fmt:message key="material.location"/>', dataIndex: 'location', flex: 1.5, },
            {text: '<fmt:message key="material.import.status"/>', dataIndex: 'message', flex: 2, },
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
                if (record.get('errorCode') == '1') {
                    return 'parentNotExits';
                } else if (record.get('errorCode') == '2') {
                    return 'codeExits';
                }
                return "";
            },
        },
        dockedItems: [{
                xtype: 'pagingtoolbar',
                dock: 'bottom',
                store: storeDataPaging,
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
        width: '80%',
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
