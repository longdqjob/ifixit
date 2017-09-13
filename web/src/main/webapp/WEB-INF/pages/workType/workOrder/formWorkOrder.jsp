<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var workOrderId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "workOrderId",
        hidden: true,
    });

    var mechanicId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var mechanicName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="work.mechanic"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 80,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    mechanicTreeWindow.show();
                });
            }
        }
    });

    var mechanic = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [mechanicId, mechanicName, {
                xtype: 'button',
                text: '<fmt:message key="choose"/>',
                tabIndex: 2,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    mechanicTreeWindow.show();
                }
            }]
    });

    var wWorkTypeId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var wWorkTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        id: "workTypeName",
        fieldLabel: '<fmt:message key="work.workType"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 80,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    workTypeTreeWindow.show();
                });
            }
        }
    });

    var workType = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [wWorkTypeId, wWorkTypeName, {
                xtype: 'button',
                text: '<fmt:message key="choose"/>',
                tabIndex: 2,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    workTypeTreeWindow.show();
                }
            }]
    });


    //--------------------------------------------------------------------------
    var grpEngineerId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var grpEngineerName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="work.enginnerGrp"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 100,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    grpEngineerTreeWindow.show();
                });
            }
        }
    });

    var grpEngineer = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [grpEngineerId, grpEngineerName, {
                xtype: 'button',
                text: '<fmt:message key="choose"/>',
                tabIndex: 2,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    grpEngineerTreeWindow.show();
                }
            }]
    });
    var statusStore = Ext.create('Ext.data.Store', {
        fields: ['abbr', 'name'],
        data: [
            {"abbr": 1, "name": "<fmt:message key="work.status.open"/>"},
            {"abbr": 2, "name": "<fmt:message key="work.status.approval"/>"},
            {"abbr": 3, "name": "<fmt:message key="work.status.inProgress"/>"},
            {"abbr": 4, "name": "<fmt:message key="work.status.pendding"/>"},
            {"abbr": 0, "name": "<fmt:message key="work.status.complete"/>"},
        ]
    });


    var workOrderStatus = Ext.create('Ext.form.ComboBox', {
        fieldLabel: '<fmt:message key="work.status"/>',
        labelWidth: 100,
        store: statusStore,
        queryMode: 'local',
        displayField: 'name',
        valueField: 'abbr',
        margin: '20 10 10 10',
        anchor: '100%',
        allowBlank: false,
        editable: false,
        value: 1,
    });

    //--------------------------------------------------------------------------
    var workOrderCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 4,
        fieldLabel: '<fmt:message key="work.code"/>',
        name: 'code',
        id: "mechanicCode",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 200,
        maxLength: 20,
        labelWidth: 100,
    });

    var workOrderName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 5,
        fieldLabel: '<fmt:message key="machine.name"/>',
        name: 'name',
        id: "mechanicName",
        labelAlign: 'right',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        labelWidth: 100,
    });

    var workOrderInfo = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [{
                xtype: 'container',
                anchor: '100%',
                columnWidth: 1,
                layout: 'column',
                height: '100%',
                items: [{
                        xtype: 'container',
                        columnWidth: 0.4,
                        layout: 'anchor',
                        items: [workOrderCode]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.6,
                        layout: 'anchor',
                        items: [workOrderName]
                    }
                ]
            }
        ]
    });

    var workOrderInterval = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 5,
        fieldLabel: '<fmt:message key="work.interval"/>',
        name: 'interval',
        id: "workOrderInteval",
        labelAlign: 'right',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        labelWidth: 100,
    });
    var workOrderRepeat = Ext.create('Ext.form.field.Checkbox', {
        xtype: 'checkboxfield',
        grow: true,
        tabIndex: 5,
        boxLabel: '<fmt:message key="work.repeat"/>',
        name: 'repeat',
        inputValue: '1',
        id: "workOrderRepeat",
        labelAlign: 'right',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
    });

    var workOrderIntervalCtn = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [{
                xtype: 'container',
                anchor: '100%',
                columnWidth: 1,
                layout: 'column',
                height: '100%',
                items: [{
                        xtype: 'container',
                        columnWidth: 0.1,
                        layout: 'anchor',
                        items: [workOrderRepeat]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.8,
                        layout: 'anchor',
                        items: [workOrderInterval]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.1,
                        layout: 'anchor',
                        items: [{
                                xtype: 'label',
                                labelAlign: 'left',
                                text: '<fmt:message key="work.unit"/>',
                                style: 'font-weight:inherit;',
                                margin: '15 0 0 0'
                            }]
                    }
                ]
            }
        ]
    });
    //--------------------------------------------------------------------------


    var startTime = {
        xtype: 'datefield',
        tabIndex: 11,
        fieldLabel: '<fmt:message key="work.start"/>',
        id: "startTime",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '20 10 10 10',
        width: 250,
        format: 'd/m/Y',
        labelWidth: 100,
//        altFormats: 'm,d,Y|m.d.Y',
    };
    var endTime = {
        xtype: 'datefield',
        tabIndex: 11,
        fieldLabel: '<fmt:message key="work.end"/>',
        id: "endTime",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '20 10 10 10',
        width: 250,
        format: 'd/m/Y',
        labelWidth: 100,
//        altFormats: 'm,d,Y|m.d.Y',
    };

    var workTypeTask = Ext.create('Ext.form.field.TextArea', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="work.task"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '20 10 10 10',
        width: "98%",
        maxLength: 512,
        tabIndex: 7,
    });

    var workTypeReason = Ext.create('Ext.form.field.TextArea', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="work.reason"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '20 10 10 10',
        width: "98%",
        maxLength: 512,
        tabIndex: 15,
    });

    var workTypeNote = Ext.create('Ext.form.field.TextArea', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="work.note"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '20 10 10 10',
        width: "98%",
        maxLength: 512,
        tabIndex: 57,
    });

    //--------------------------------------------------------------------------
    var tabWorkOrder = Ext.create('Ext.tab.Panel', {
        id: "tabWorkOrder",
        tabBarPosition: 'top',
        autoHeight: true,
        activeTab: 0,
        items: [{
                title: '<fmt:message key="work.task"/>',
                id: "tabTask",
                tabIndex: 6,
                items: [workTypeTask]
            }, {
                title: '<fmt:message key="work.manHour"/>',
                id: "manHour",
                tabIndex: 12,
                items: [gridManHrsPanel]
            }, {
                title: '<fmt:message key="work.material"/>',
                id: "material",
                tabIndex: 55,
                items: [gridStockPanel]
            }, {
                title: '<fmt:message key="work.reason"/>',
                tabIndex: 56,
                id: "reason",
                items: [workTypeReason]
            }, {
                title: '<fmt:message key="work.note"/>',
                tabIndex: 56,
                id: "note",
                items: [workTypeNote]
            }]
    });


    var workOrderForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        minHeight: 500,
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
                        items: [workOrderId, mechanic, workType, grpEngineer, workOrderInfo]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [startTime, endTime, workOrderStatus, workOrderIntervalCtn]
                    }, {
                        xtype: 'container',
                        columnWidth: 1,
                        id: "containerTab",
                        layout: 'anchor',
                        items: [tabWorkOrder]
                    }
                ]
            }
        ]
    });

    var workOrderWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'workOrderWindow',
        autoEl: 'form',
        width: '80%',
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [workOrderForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveWorkOrder();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    workOrderWindow.hide();
                }
            }],
        listeners: {
            show: function (window) {
                Ext.getCmp("tabWorkOrder").setActiveTab(Ext.getCmp("tabTask"));
                gridManHrs.setHeight(workOrderForm.getHeight() - 220);
                gridStock.setHeight(workOrderForm.getHeight() - 220);
            },
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveWorkOrder();
                    }
                });
            },
        }
    });


</script>
