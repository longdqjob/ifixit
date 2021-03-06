<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var mechanicId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "mechanicId",
        hidden: true,
    });

    var mechanicTypeId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "mechanicTypeId",
        name: "machine_type_id",
        hidden: true,
    });

    var mechanicTypeName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 1,
        fieldLabel: '<fmt:message key="machine.type"/>',
        name: 'parentName',
        id: "mechanicTypeName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    mechanicTypeWindow.show();
                });
            }
        }
    });

    var mechanicType = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [mechanicTypeId, mechanicTypeName, {
                xtype: 'button',
                text: 'Choose',
                tabIndex: 2,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    mechanicTypeWindow.show();
                }
            }]
    });

    var mechanicTypeCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="machine.machineType.code"/>',
        id: "mechanicTypeCode",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        maxLength: 20,
        readOnly: true,
    });


    var mechanicCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 4,
        fieldLabel: '<fmt:message key="machine.code"/>',
        name: 'code',
        id: "mechanicCode",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        maxLength: 20,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                changeCode(oldValue, newValue);
            }
        }
    });
    var mechanicCompleteCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="machine.fullCode"/>',
        id: "mechanicCompleteCode",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        maxLength: 20,
        readOnly: true,
    });

    var mechanicCodeCtn = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        //columnWidth: 1,
        layout: 'column',
        items: [mechanicCode,
//            {
//                xtype: 'label',
//                id: 'mechanicFullCode',
//                margin: '15 10 10 10',
//            }
        ]
    });

    var mechanicName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 5,
        fieldLabel: '<fmt:message key="machine.name"/>',
        name: 'name',
        id: "mechanicName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '20 10 10 10',
        width: 350,
        maxLength: 255,
    });

    var fatherId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "fatherId",
        hidden: true,
    });

    var fatherName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 10,
        fieldLabel: '<fmt:message key="machine.father"/>',
        id: "fatherName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    mechanicTreeWindow.show();
                });
            }
        }
    });

    var father = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        // columnWidth: 1,
        layout: 'column',
        items: [fatherId, fatherName, {
                xtype: 'button',
                text: 'Choose',
                tabIndex: 12,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    mechanicTreeWindow.show();
                }
            }]
    });

    var systemId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        id: "systemId",
        hidden: true,
    });

    var systemName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 14,
        fieldLabel: '<fmt:message key="machine.system"/>',
        id: "systemName",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    companyTreeWindow.show();
                });
            }
        }
    });

    var systemContainer = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        columnWidth: 1,
        layout: 'column',
        items: [systemId, systemName, {
                xtype: 'button',
                text: 'Choose',
                margin: '10 0 6 10',
                width: 80,
                tabIndex: 16,
                handler: function () {
                    companyTreeWindow.show();
                }
            }]
    });

    var sinceField = {
        xtype: 'datefield',
        tabIndex: 18,
        fieldLabel: '<fmt:message key="machine.since"/>',
        id: "sinceField",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        format: 'd/m/Y',
//        altFormats: 'm,d,Y|m.d.Y',
    };

    var machineNote = Ext.create('Ext.form.field.TextArea', {
        xtype: 'textfield',
        grow: true,
        fieldLabel: '<fmt:message key="machine.note"/>',
        id: "machineNote",
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '20 10 10 10',
        width: "98%",
        maxLength: 512,
        tabIndex: 57,
    });

    //--------------------------------------------------------------------------
    var mechanicImage = {
        xtype: 'filefield',
        id: "mechanicImage",
        name: 'file',
        tabIndex: 8,
        fieldLabel: '<fmt:message key="machine.image"/>',
        allowBlank: true,
        margin: '10 10 10 10',
        anchor: '99%',
        buttonText: '<fmt:message key="browse"/>',
        listeners: {
            change: function (fld, value) {
                var newValue = value.replace(/C:\\fakepath\\/g, '');
                fld.setRawValue(newValue);
                uploadImg();
            }
        }
    };

    var mechanicImgUrl = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var mechanicImgPath = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var mechanicImgPreview = new Ext.Component({
        margin: '10 10 10 10',
        autoEl: {
            tag: 'img', src: '../images/no-preview-available.png', id: 'materialImgPreview'
        }
    });

    var imgForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        items: [mechanicImgUrl, mechanicImgPath, mechanicImage]
    });

    var indentifyForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        items: [{
                xtype: 'container',
                anchor: '100%',
                columnWidth: 1,
                layout: 'column',
                height: '100%',
                margin: '20 0 0 0',
                items: [{
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [imgForm, father, systemContainer, sinceField]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [mechanicImgPreview]
                    },
                ]
            }
        ],
    });

    //--------------------------------------------------------------------------
    var tabSpec = Ext.create('Ext.tab.Panel', {
        id: "tabSpecification",
        tabBarPosition: 'top',
        autoHeight: true,
        activeTab: 0,
        items: [{
                title: '01-20',
                id: "specification1",
                tabIndex: 13,
                items: [{
                        xtype: 'container',
                        anchor: '100%',
                        columnWidth: 1,
                        layout: 'column',
                        tabDirection: 'left-right',
                        height: '100%',
                        items: [{
                                xtype: 'container',
                                columnWidth: 0.25,
                                layout: 'anchor',
                                items: [
                                    generateSpecificLabel("01"),
                                    generateSpecificLabel("03"),
                                    generateSpecificLabel("05"),
                                    generateSpecificLabel("07"),
                                    generateSpecificLabel("09"),
                                    generateSpecificLabel("11"),
                                    generateSpecificLabel("13"),
                                    generateSpecificLabel("15"),
                                    generateSpecificLabel("17"),
                                    generateSpecificLabel("19"),
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.25,
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
                                columnWidth: 0.25,
                                layout: 'anchor',
                                items: [
                                    generateSpecificLabel("02"),
                                    generateSpecificLabel("04"),
                                    generateSpecificLabel("06"),
                                    generateSpecificLabel("08"),
                                    generateSpecificLabel("10"),
                                    generateSpecificLabel("12"),
                                    generateSpecificLabel("14"),
                                    generateSpecificLabel("16"),
                                    generateSpecificLabel("18"),
                                    generateSpecificLabel("20"),
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.25,
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
                            }, ]
                    }
                ]},
            {
                title: '21-40',
                id: "specification2",
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
                                items: [
                                    generateSpecificLabel("21"),
                                    generateSpecificLabel("23"),
                                    generateSpecificLabel("25"),
                                    generateSpecificLabel("27"),
                                    generateSpecificLabel("29"),
                                    generateSpecificLabel("31"),
                                    generateSpecificLabel("33"),
                                    generateSpecificLabel("35"),
                                    generateSpecificLabel("37"),
                                    generateSpecificLabel("39"),
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.25,
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
                                columnWidth: 0.25,
                                layout: 'anchor',
                                items: [
                                    generateSpecificLabel("22"),
                                    generateSpecificLabel("24"),
                                    generateSpecificLabel("26"),
                                    generateSpecificLabel("28"),
                                    generateSpecificLabel("30"),
                                    generateSpecificLabel("32"),
                                    generateSpecificLabel("34"),
                                    generateSpecificLabel("36"),
                                    generateSpecificLabel("38"),
                                    generateSpecificLabel("40"),
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.25,
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

    //--------------------------------------------------------------------------
    var tabMechanic = Ext.create('Ext.tab.Panel', {
        id: "tabMechanic",
        tabBarPosition: 'top',
        autoHeight: true,
        activeTab: 0,
        items: [{
                title: '<fmt:message key="machine.indentify"/>',
                id: "indentify",
                tabIndex: 6,
                items: [indentifyForm]
            }, {
                title: '<fmt:message key="machine.specification"/>',
                id: "specification",
                tabIndex: 12,
                items: [tabSpec]
            }, {
                title: '<fmt:message key="machine.maintainHistory"/>',
                id: "maintainHistory",
                tabIndex: 55,
                items: [gridHisPanel]
            }, {
                title: '<fmt:message key="machine.job"/>',
                id: "machineJob",
                tabIndex: 56,
                items: [gridJobPanel]
            }, {
                title: '<fmt:message key="machine.note"/>',
                tabIndex: 57,
                id: "machineNotes",
                items: [machineNote]
            }]
    });


    var mechanicForm = Ext.create('Ext.form.Panel', {
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
                        items: [mechanicId, mechanicType, mechanicCode]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [mechanicTypeCode, mechanicName]
                    }, {
                        xtype: 'container',
                        columnWidth: 1,
                        layout: 'anchor',
                        items: [mechanicCompleteCode]
                    },
                    {
                        xtype: 'container',
                        columnWidth: 1,
                        id: "containerTab",
                        layout: 'anchor',
                        items: [tabMechanic]
                    }
                ]
            }
        ]
    });

    var mechanicWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        id: 'mechanicWindow',
        autoEl: 'form',
        width: '60%',
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [mechanicForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveMechanic();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    mechanicWindow.hide();
                }
            }],
        listeners: {
            show: function (window) {
                Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("indentify"));
                setTimeout(function () {
                    console.log(mechanicForm.getHeight() - mechanicType.getHeight() - mechanicCode.getHeight() - 50);
                    gridHis.setHeight(mechanicForm.getHeight() - mechanicType.getHeight() - mechanicCode.getHeight() - 50);
                    gridJob.setHeight(mechanicForm.getHeight() - mechanicType.getHeight() - mechanicCode.getHeight() - 50);
                }, 1);
            },
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveMechanic();
                    }
                });
            },
        }
    });


</script>
