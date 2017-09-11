<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var machineTypeId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "machineTypeId",
        hidden: true,
    });

    var machineTypeCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="machineType.code"/>',
        name: 'code',
        id: "supplierCode",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        tabIndex: 1,
    });

    var machineTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="machineType.name"/>',
        name: 'name',
        id: "supplierName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        tabIndex: 2,
    });

    var machineTypeNote = Ext.create('Ext.form.field.TextArea', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="machineType.note"/>',
        name: 'note',
        id: "supplierPhone",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 350,
        maxLength: 50,
        tabIndex: 4,
    });

    var tab = Ext.create('Ext.tab.Panel', {
        id: "tabSpecification",
        tabBarPosition: 'top',
        autoHeight: true,
        activeTab: 0,
        items: [{
                title: '<fmt:message key="machineType.specification"/> 01-20',
                id: "specification1",
                items: [{
                        xtype: 'container',
                        anchor: '100%',
                        columnWidth: 1,
                        layout: 'column',
                        tabDirection: 'left-right',
                        height: '100%',
                        items: [{
                                xtype: 'container',
                                columnWidth: 0.5,
                                layout: 'anchor',
                                items: [
                                    generateSpecific("01"),
                                    generateSpecific("03"),
                                    generateSpecific("05"),
                                    generateSpecific("07"),
                                    generateSpecific("09"),
                                    generateSpecific("11"),
                                    generateSpecific("13"),
                                    generateSpecific("15"),
                                    generateSpecific("17"),
                                    generateSpecific("19"),
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.5,
                                layout: 'anchor',
                                items: [
                                    generateSpecific("02"),
                                    generateSpecific("04"),
                                    generateSpecific("06"),
                                    generateSpecific("08"),
                                    generateSpecific("10"),
                                    generateSpecific("12"),
                                    generateSpecific("14"),
                                    generateSpecific("16"),
                                    generateSpecific("18"),
                                    generateSpecific("20"),
                                ]
                            }]
                    }
                ]},
            {
                title: '<fmt:message key="machineType.specification"/> 21-40',
                id: "specification2",
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
                                    generateSpecific("21"),
                                    generateSpecific("23"),
                                    generateSpecific("25"),
                                    generateSpecific("27"),
                                    generateSpecific("29"),
                                    generateSpecific("31"),
                                    generateSpecific("33"),
                                    generateSpecific("35"),
                                    generateSpecific("37"),
                                    generateSpecific("39"),
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.5,
                                layout: 'anchor',
                                items: [
                                    generateSpecific("22"),
                                    generateSpecific("24"),
                                    generateSpecific("26"),
                                    generateSpecific("28"),
                                    generateSpecific("30"),
                                    generateSpecific("32"),
                                    generateSpecific("34"),
                                    generateSpecific("36"),
                                    generateSpecific("38"),
                                    generateSpecific("40"),
                                ]
                            }]
                    }
                ]},
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

    var addForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        minHeight: 300,
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
                        items: [machineTypeId, machineTypeCode]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [machineTypeName]
                    }, {
                        xtype: 'container',
                        columnWidth: 1,
                        layout: 'anchor',
                        items: [machineTypeNote]
                    }, {
                        xtype: 'container',
                        columnWidth: 1,
                        layout: 'anchor',
                        items: [tab]
                    }
                ]
            }
        ]
    });

    var addWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        iconCls: 'add-cls',
        id: 'addWindow',
        autoEl: 'form',
        width: '60%',
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [addForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveForm();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    addWindow.hide();
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
