<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var manHrsId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "manHrsId",
        hidden: true,
    });

    //--------------------------------------------------------------------------
    var mhGrpEngineerId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var mhGrpEngineerName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="mh.enginnerGrp"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 550,
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

    var mhGrpEngineer = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [mhGrpEngineerId, mhGrpEngineerName, {
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

    var mhManHrs = Ext.create('Ext.form.field.Number', {
        xtype: 'numberfield',
        grow: true,
        tabIndex: 5,
        fieldLabel: '<fmt:message key="mh.manHrs"/>',
        id: "mhForm",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        labelWidth: 100,
        allowDecimals: true,
        allowNegative: false,
        decimalSeparator: ".",
        decimalPrecision: 3,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                changeHrs(oldValue, newValue);
            }
        }
    });

    var mhfrmCost = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="mh.cost"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 80,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                changeHrs(oldValue, newValue);
            }
        }
    });
    var mhfrmTotalCost = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="mh.totalCost"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 80,
    });

    var mhfrmCtn = Ext.create('Ext.form.FieldContainer', {
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
                        columnWidth: 0.33,
                        layout: 'anchor',
                        items: [mhManHrs]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.33,
                        layout: 'anchor',
                        items: [mhfrmCost]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.33,
                        layout: 'anchor',
                        items: [mhfrmTotalCost]
                    }
                ]
            }
        ]
    });
    var manHrsForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        minHeight: 100,
        items: [manHrsId, mhGrpEngineer, mhfrmCtn]
    });

    var manHrsWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'manHrsWindow',
        autoEl: 'form',
        width: '50%',
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [manHrsForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveManHrs();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    manHrsWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveManHrs();
                    }
                });
            },
        }
    });


</script>
