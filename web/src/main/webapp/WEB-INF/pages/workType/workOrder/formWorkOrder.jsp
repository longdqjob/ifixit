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

    var workTypeId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var workTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="work.workType"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
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
        items: [workTypeId, workTypeName, {
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
        maxLength: 50,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                changeCode(oldValue, newValue);
            }
        }
    });

    var workOrderCodeCtn = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [workOrderCode, {
                xtype: 'label',
                id: 'workOrderFullCode',
                margin: '15 10 10 10',
            }]
    });

    var workOrderName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 5,
        fieldLabel: '<fmt:message key="machine.name"/>',
        name: 'name',
        id: "mechanicName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
    });


    var startTime = {
        xtype: 'datefield',
        tabIndex: 11,
        fieldLabel: '<fmt:message key="work.start"/>',
        id: "startTime",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        format: 'd/m/Y',
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
//        altFormats: 'm,d,Y|m.d.Y',
    };

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
                items: []
            }, {
                title: '<fmt:message key="work.manHour"/>',
                id: "manHour",
                tabIndex: 12,
                items: []
            }, {
                title: '<fmt:message key="work.material"/>',
                id: "material",
                tabIndex: 55,
                items: [gridManHrsPanel]
            }, {
                title: '<fmt:message key="work.reason"/>',
                tabIndex: 56,
                id: "reason",
                items: []
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
                        items: [workOrderId, mechanic, workType]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [startTime, endTime]
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
        width: '60%',
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
                    saveMechanic();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    workOrderWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveMechanic();
                    }
                });
            },
        }
    });


</script>