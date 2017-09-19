<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var engneerId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "engneerId",
        hidden: true,
    });

    var engneerName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="grpEngineer.name"/>',
        name: 'name',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 255,
    });

    var engneerDes = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="grpEngineer.description"/>',
        name: 'name',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 255,
    });

    var engneerCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="grpEngineer.code"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 20,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                generateFullCode();
            }
        }
    });
    var engneerFullCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="grpEngineer.completeCode"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 20,
        readOnly: true,
    });

    var engneerCost = Ext.create('Ext.form.field.Number', {
        xtype: 'numberfield',
        grow: true,
        fieldLabel: '<fmt:message key="grpEngineer.cost"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        allowDecimals: true,
        allowNegative: false,
        decimalSeparator: ".",
        decimalPrecision: 3,
    });

    var engneerParentId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "engneerParentId",
        hidden: true,
    });

    var engneerParentCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                generateFullCode();
            }
        }
    });

    var engneerParentName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="grpEngineer.parent"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
    });

    var engneerParent = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [engneerParentId, engneerParentCode, engneerParentName, {
                xtype: 'button',
                id: "btnEngneerParent",
                text: '<fmt:message key="choose"/>',
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    grpEngineerTreeWindow.show();
                }
            }]
    });

    var engneerForm = Ext.create('Ext.form.Panel', {
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
                        anchor: '100%',
                        columnWidth: 1,
                        height: '100%',
                        items: [
                            engneerId, engneerParent, engneerName, engneerDes, engneerCode,
                            engneerFullCode, engneerCost]
                    }]
            },
        ]
    });


    var engneerWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'engneerWindow',
        autoEl: 'form',
        width: 400,
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [engneerForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveEngineer();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    engneerWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveEngineer();
                    }
                });
            },
        }
    });


</script>
