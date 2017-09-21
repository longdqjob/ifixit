<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="workType/workType_form.jsp" />
<jsp:include page="workType/workType_function.jsp" />
<script>
    function fnCmSearchWorkType() {
        gridCmWorkType.getStore().getProxy().extraParams = {
            code: searchCmWorkTypeCode.getValue(),
            name: searchCmWorkTypeName.getValue(),
        };
        gridCmWorkType.getStore().loadPage(1, {
            callback: function (records, operation, success) {
                storeRedirectIfNotAuthen(operation);
            }
        });
    }

    var searchCmWorkTypeCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="workType.code"/>',
        anchor: '100%',
        margin: '10 10 10 10',
    });
    var searchCmWorkTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="workType.name"/>',
        anchor: '100%',
        margin: '10 10 10 10',
    });

    var searchCmWorkType = new Ext.form.Panel({
        xtype: 'form',
        collapsible: true,
        collapsed: true,
        title: '<fmt:message key="button.search"/>' + " " + '<fmt:message key="workType"/>',
        items: [searchCmWorkTypeCode, searchCmWorkTypeName],
        buttons: [{
                text: '<fmt:message key="button.search"/>',
                handler: function () {
                    fnCmSearchWorkType();
                }
            }, {
                text: '<fmt:message key="button.reset"/>',
                handler: function () {
                    searchCmWorkType.getForm().reset();
                    fnCmSearchWorkType();
                }
            }
        ],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        fnCmSearchWorkType();
                    }
                });
            }
        } //end of listeners
    });

    var storeCmWorkType = Ext.create('Ext.data.Store', {
        storeId: 'storeCmWorkType',
        pageSize: 20,
        autoLoad: false,
        proxy: {
            type: 'ajax',
            url: '../workType/loadData',
            reader: {
                rootProperty: 'list',
                type: 'json',
                totalProperty: 'totalCount'
            }
        },
    });

    var gridCmWorkType = Ext.create('Ext.grid.Panel', {
        title: '<fmt:message key="workType.list"/>',
        id: "gridCmWorkType",
        store: storeCmWorkType,
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
            {text: '<fmt:message key="workType.code"/>', dataIndex: 'code', flex: 0.5, },
            {text: '<fmt:message key="workType.name"/>', dataIndex: 'name', flex: 1.5, },
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
                cmWorkTypeWindow.hide();
                chooseWorkType(record);
            }
        }
    });

    var cmWorkTypeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'show',
        autoEl: 'form',
        width: 1000,
        height: 600,
        constrainHeader: true,
        title: '<fmt:message key="workType"/>',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [{
                xtype: 'container',
                columnWidth: 1,
                layout: 'anchor',
                anchor: '100%',
                items: [searchCmWorkType]
            }, {
                xtype: 'container',
                columnWidth: 1,
                layout: 'anchor',
                anchor: '100%',
                items: [gridCmWorkType]
            },
        ],
        listeners: {
            show: function (window) {
                fnCmSearchWorkType();
            },
            resize: function (width, height, oldWidth, oldHeight, eOpts) {
                setTimeout(function () {
                    gridCmWorkType.setHeight(cmWorkTypeWindow.getHeight() - searchCmWorkType.getHeight() - 78);
                }, 1);
            },
        },
        buttons: [{
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    cmWorkTypeWindow.hide();
                }
            }
        ]
    });


</script>