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
    

    var workTypeForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        items: [workTypeId,workTypeCode,workTypeName]
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
