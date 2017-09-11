<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var workTypeId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "workTypeId",
        hidden: true,
    });

    var workTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyName"/>',
        name: 'name',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
    });

    var workTypeCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyCode"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
    });
    var workTypeFullCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyFullCode"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
    });

    var workTypeParentId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "workTypeParentId",
        hidden: true,
    });

    var workTypeParentName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyParent"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
    });

    var workTypeParent = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [workTypeParentId, workTypeParentName, {
                xtype: 'button',
                text: 'Choose',
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    companyTreeWindow.show();
                }
            }]
    });

    var workTypeForm = Ext.create('Ext.form.Panel', {
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
                            workTypeId, workTypeName, workTypeCode,
                            workTypeFullCode, workTypeParent]
                    }]
            },
        ]
    });


    var workTypeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'workTypeWindow',
        autoEl: 'form',
        width: 400,
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [workTypeForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveWorkType();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    workTypeWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveWorkType();
                    }
                });
            },
        }
    });


</script>
