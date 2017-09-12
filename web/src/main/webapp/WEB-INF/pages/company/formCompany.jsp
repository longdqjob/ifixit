<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var companyId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "companyId",
        hidden: true,
    });

    var companyParentStore = Ext.create('Ext.data.Store', {
        fields: ['id', 'code', 'name'],
        listeners: {
            load: {
                fn: function (store, records, options) {
                    console.log(records);
                },
                scope: this
            },
        }
    });

    var companyParent = Ext.create('Ext.form.ComboBox', {
        fieldLabel: '<fmt:message key="companyParent"/>',
        store: companyParentStore,
        emptyText: '--Please Select--',
        queryMode: 'local',
        displayField: 'name',
        valueField: 'id',
        margin: '10 10 10 10',
        anchor: '100%',
        editable: true,
        allowBlank: false,
        width: 350,
        autoSelect: true,
        typeAhead: true,
        listConfig: {
            itemTpl: '{code} - {name}'
        },
//        listeners: {
//            'keyup': function () {
//                this.store.filter('name', this.getRawValue(), true, false);
//            },
//            'beforequery': function (queryEvent) {
//                queryEvent.combo.onLoad();
//                // prevent doQuery from firing and clearing out my filter.
//                return false;
//            }
//        }
    });


//    var companyParentStore = Ext.create('Ext.data.Store', {
//        pageSize: 50,
//        fields: ['id', 'code', 'name'],
//        remoteSort: true,
//        proxy: {
//            type: 'ajax',
//            url: '../company/getListCompany',
//            reader: {
//                rootProperty: 'list',
//                type: 'json',
//                totalProperty: 'totalCount'
//            }
//        },
//    });
//
//    var companyParent = Ext.create('Ext.form.ComboBox', {
//        fieldLabel: '<fmt:message key="companyParent"/>',
//        store: companyParentStore,
//        emptyText: '--Please Select--',
//        queryMode: 'remote',
//        displayField: 'name',
//        valueField: 'id',
//        pageSize: 50,
//        margin: '10 10 10 10',
//        anchor: '100%',
//        editable: true,
//        allowBlank: false,
//        width: 350,
//        listConfig: {
//            itemTpl: '{code} - {name}'
//        },
//    });

    var companyName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyName"/>',
        name: 'name',
        id: "companyName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
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
        width: 350,
        maxLength: 50,
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
        width: 350,
        maxLength: 50,
    });

    var companyDescription = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyDescription"/>',
        name: 'description',
        id: "companyDescription",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
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
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
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
                            companyId, companyParent,companyCode,
                            companyName,companyFullCode, companyDescription]
                    }]
            },
        ]
    });


    var companyWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'companyWindow',
        autoEl: 'form',
        width: 400,
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
