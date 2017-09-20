<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var materialCode = "";
    var materialDesc = "";
    var materialUnit = "";
    var materialCost = "";
    var stockItemId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "stockItemId",
        hidden: true,
    });

    //--------------------------------------------------------------------------
    var stockMateId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var stockMateName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="work.material.name"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 550,
        readOnly: true,
        labelWidth: 50,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    materialWindow.show();
                });
            }
        }
    });

    var stockMate = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [stockMateId, stockMateName, {
                xtype: 'button',
                text: '<fmt:message key="choose"/>',
                tabIndex: 2,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    materialWindow.show();
                }
            }]
    });

    var stockQty = Ext.create('Ext.form.field.Number', {
        xtype: 'numberfield',
        grow: true,
        tabIndex: 5,
        fieldLabel: '<fmt:message key="work.material.qty"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        labelWidth: 50,
        allowDecimals: false,
        allowNegative: false,
        minValue: 1,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                calcQty();
            }
        }
    });

    var stockUnit = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="work.material.unit"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 50,
    });
    var stockUnitCost = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="material.unitCost"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 80,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                calcQty();
            }
        }
    });

    var stockTotalCost = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="material.totalCode"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        labelWidth: 80
    });

    var stockItemCtn = Ext.create('Ext.form.FieldContainer', {
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
                        columnWidth: 0.25,
                        layout: 'anchor',
                        items: [stockQty]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.25,
                        layout: 'anchor',
                        items: [stockUnit]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.25,
                        layout: 'anchor',
                        items: [stockUnitCost]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.25,
                        layout: 'anchor',
                        items: [stockTotalCost]
                    }
                ]
            }
        ]
    });
    var stockForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        minHeight: 100,
        items: [stockItemId, stockMate, stockItemCtn]
    });

    var stockWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'stockWindow',
        autoEl: 'form',
        width: '50%',
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [stockForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveStock();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    stockWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveStock();
                    }
                });
            },
        }
    });


</script>
