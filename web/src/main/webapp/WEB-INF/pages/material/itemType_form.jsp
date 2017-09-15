<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var itemTypeId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var itemTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="itemType.name"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 450,
        maxLength: 50,
    });

    var itemTypeCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="itemType.code"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 450,
        maxLength: 50,
        listeners: {
            change: function (code, newval, oldval, options) {
                genItemTypeCode();
            },
        }
    });
    var itemTypeFullCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="itemType.completeCode"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 450,
        maxLength: 50,
        readOnly: true,
    });

    var itemTypeParentId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var itemTypeParentName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="companyParent"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 350,
        readOnly: true,
    });
    var itemTypeParentCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="itemType.parent"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '10 10 10 10',
        width: 450,
        readOnly: true,
    });

    var itemTypeParent = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [itemTypeParentId, itemTypeParentName, {
                xtype: 'button',
                text: '<fmt:message key="choose"/>',
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    companyTreeWindow.show();
                }
            }]
    });
    
    //--------------------------------------------------------------------------
    var itemTypeSpec = Ext.create('Ext.tab.Panel', {
        tabBarPosition: 'top',
        autoHeight: true,
        activeTab: 0,
        items: [{
                title: '<fmt:message key="itemType.specification"/>',
                tabIndex: 13,
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
                                items: [
                                    itemTypeGenSpecLabel("01"),
                                    itemTypeGenSpecLabel("02"),
                                    itemTypeGenSpecLabel("03"),
                                    itemTypeGenSpecLabel("04"),
                                    itemTypeGenSpecLabel("05")
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.5,
                                layout: 'anchor',
                                items: [
                                    itemTypeGenSpecLabel("06"),
                                    itemTypeGenSpecLabel("07"),
                                    itemTypeGenSpecLabel("08"),
                                    itemTypeGenSpecLabel("09"),
                                    itemTypeGenSpecLabel("10"),
                                ]
                            }]
                    }
                ]}
        ],
        listeners: {
            render: function (tab, eOpts) {
                this.items.each(function (i) {
                    i.tab.on('click', function () {
                    });
                });
            }
        }
    });
    var itemTypeForm = Ext.create('Ext.form.Panel', {
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
                        items: [itemTypeId, itemTypeParent, itemTypeCode, itemTypeName]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [itemTypeParentCode, itemTypeFullCode]
                    },
                    {
                        xtype: 'container',
                        columnWidth: 1,
                        layout: 'anchor',
                        items: [itemTypeSpec]
                    }
                ]
            }
        ]
    });

    var itemTypeWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        autoEl: 'form',
        width: '70%',
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [itemTypeForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveFormItemType();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    itemTypeWindow.hide();
                }
            }],
        listeners: {
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveFormItemType();
                    }
                });
            },
        }
    });
</script>
