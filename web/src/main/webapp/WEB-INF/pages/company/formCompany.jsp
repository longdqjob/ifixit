<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var companyId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "companyId",
        hidden: true,
    });

    var companyName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyName"/>',
        name: 'name',
        id: "companyName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 450,
        maxLength: 255,
    });

    var companyCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyCode"/>',
        name: 'code',
        id: "companyCode",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 450,
        maxLength: 20,
        listeners: {
            change: function (code, newval, oldval, options) {
                console.log(newval);
                companyFullCode.setValue(companyParentCode.getValue() + "." + newval);

            },
        }
    });
    var companyFullCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyFullCode"/>',
        name: 'fullCode',
        id: "companyFullCode",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 450,
        maxLength: 20,
        readOnly: true,
    });

    var companyDescription = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyDescription"/>',
        name: 'description',
        id: "companyDescription",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 450,
        maxLength: 255,
    });

    var companyParentId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "companyParentId",
        hidden: true,
    });

    var companyParentName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyParent"/>',
        name: 'parentName',
        id: "companyParentName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 350,
        readOnly: true,
    });
    var companyParentCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: 'Higher ' + '<fmt:message key="companyCode"/>',
        name: 'parentCode',
        id: "parentCodeId",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 450,
        readOnly: true,
    });

    var companyParent = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [companyParentId, companyParentName, {
                xtype: 'button',
                name: 'btntreecompany',
                id: 'btntreecompany',
                text: 'Choose',
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    companyTreeWindow.show();
                }
            }]
    });

    var companyForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
//        frame: true,
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
                            companyId, companyParent, companyParentCode, companyCode,
                            companyFullCode, companyName]
                    }]
            },
        ]
    });


    var companyWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'companyWindow',
        autoEl: 'form',
        width: 500,
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [companyForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveForm();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    companyWindow.hide();
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
