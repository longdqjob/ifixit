<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var workTypeId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "workTypeId",
        hidden: true,
    });

    var workTypeCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="workType.code"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
    });

    var workTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="workType.name"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
    });

    //--------------------------------------------------------------------------
    var grpEngineerId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var grpEngineerName = Ext.create('Ext.form.field.Text', {
        id: "grpEngineerName",
        xtype: 'textfield',
        grow: true,
        tabIndex: 7,
        fieldLabel: '<fmt:message key="work.enginnerGrp"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 300,
        readOnly: true,
        labelWidth: 100,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    if (!grpEngineerName.readOnly) {
                        grpEngineerTreeWindow.show();
                    }
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
                id: "btnChooseGrpEngineer",
                text: '<fmt:message key="choose"/>',
                tabIndex: 8,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    grpEngineerTreeWindow.show();
                }
            }]
    });
    //----------------------------------interval----------------------------------------
    var workTypeInterval = Ext.create('Ext.form.field.Number', {
        xtype: 'numberfield',
        grow: true,
        tabIndex: 13,
        fieldLabel: '<fmt:message key="work.interval"/>',
        name: 'interval',
        id: "workTypeInterval",
        labelAlign: 'right',
        anchor: '100%',
        allowBlank: true,
        margin: '13 10 10 10',
        width: 350,
        maxLength: 50,
        labelWidth: 100,
        allowDecimals: true,
        allowNegative: false,
        decimalSeparator: ".",
        decimalPrecision: 3,
        hidden: true,
    });
    var workTypeRepeat = Ext.create('Ext.form.field.Checkbox', {
        xtype: 'checkboxfield',
        grow: true,
        tabIndex: 12,
        boxLabel: '<fmt:message key="work.repeat"/>',
        name: 'repeat',
        inputValue: '1',
        id: "workTypeRepeat",
        labelAlign: 'right',
        anchor: '100%',
        allowBlank: false,
        margin: '13 10 10 10',
        listeners: {
            change: function (checkbox, newVal, oldVal) {
                if (newVal) {
                    workTypeInterval.allowBlank = false;
                    workTypeInterval.show();
                    Ext.getCmp("lbMonWt").show();
                } else {
                    workTypeInterval.reset();
                    workTypeInterval.allowBlank = true;
                    Ext.getCmp("lbMonWt").hide();
                    workTypeInterval.hide();
                }
            }
        }
    });

    var workTypeIntervalCtn = Ext.create('Ext.form.FieldContainer', {
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
                        items: [workTypeRepeat]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.8,
                        layout: 'anchor',
                        items: [workTypeInterval]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.1,
                        layout: 'anchor',
                        items: [{
                                xtype: 'label',
                                labelAlign: 'left',
                                id: "lbMonWt",
                                hidden: true,
                                text: '<fmt:message key="work.unit"/>',
                                style: 'font-weight:inherit;',
                                margin: '15 0 0 0'
                            }]
                    }
                ]
            }
        ]
    });
    
    //------------------------------------Tab--------------------------------------
    var workTypeTask = Ext.create('Ext.form.field.TextArea', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 14,
        fieldLabel: '<fmt:message key="work.task"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '20 10 10 10',
        width: "98%",
        maxLength: 512,
    });
    
    var tabWorkType = Ext.create('Ext.tab.Panel', {
        id: "tabWorkType",
        tabBarPosition: 'top',
        autoHeight: true,
        activeTab: 0,
        items: [{
                title: '<fmt:message key="work.task"/>',
                id: "tabTask",
                tabIndex: 6,
                items: [workTypeTask]
            }]
    });
    //--------------------------------------------------------------------------


    var workTypeForm = Ext.create('Ext.form.Panel', {
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
                        items: [workTypeId, grpEngineer, workTypeCode]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [workTypeIntervalCtn, workTypeName]
                    }, {
                        xtype: 'container',
                        columnWidth: 1,
                        id: "containerTabWT",
                        layout: 'anchor',
                        items: [tabWorkType]
                    }
                ]
            }
        ]
    });


    var workTypeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'workTypeWindow',
        autoEl: 'form',
        width: '80%',
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [workTypeForm],
        buttons: [{
                text: 'Save',
                type: 'submit',
                handler: function () {
                    saveForm();
                }
            }, {
                text: 'Cancel',
                handler: function () {
                    workTypeWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveForm();
                    }
                });
            },
        }
    });


</script>
