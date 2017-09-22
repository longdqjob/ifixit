<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var userId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "userId",
        hidden: true,
    });

    var userUserName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="user.username"/>',
        name: 'name',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
    });

    var userName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="user.name"/>',
        name: 'name',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 255,
    });
    var userEmail = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="user.email"/>',
        name: 'name',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 255,
    });


    var userSystemId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "userSystemId",
        hidden: true,
    });


    var userSystemName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="user.system"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
    });

    var userSystemCtn = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [userSystemId, userSystemName, {
                xtype: 'button',
                id: "btnUserSystem",
                text: '<fmt:message key="choose"/>',
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    companyTreeWindow.show();
                }
            }]
    });

    var userEngneerId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "userEngneerId",
        hidden: true,
    });
    var userEngneerName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="user.grpEng"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
    });

    var userEngneerCtn = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [userEngneerId, userEngneerName, {
                xtype: 'button',
                id: "btnEngneer",
                text: '<fmt:message key="choose"/>',
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    grpEngineerTreeWindow.show();
                }
            }]
    });

    var userForm = Ext.create('Ext.form.Panel', {
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
                            userId, userUserName, userName, userEmail, userSystemCtn, userEngneerCtn]
                    }]
            },
        ]
    });


    var userWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'userWindow',
        autoEl: 'form',
        width: 400,
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [userForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveUser();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    userWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveUser();
                    }
                });
            },
        }
    });


</script>
