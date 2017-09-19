<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
    var materialId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });
    var materialFatherId = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var materialFatherName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="material.parent"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: true,
        margin: '10 10 10 10',
        width: 250,
        readOnly: true,
        listeners: {
            'render': function (cmp) {
                this.getEl().on('click', function () {
                    cmItemTypeTreeWindow.show();
                });
            }
        }
    });

    var materialFather = Ext.create('Ext.form.FieldContainer', {
        xtype: 'fieldcontainer',
        // columnWidth: 1,
        layout: 'column',
        items: [materialFatherId, materialFatherName, {
                xtype: 'button',
                text: '<fmt:message key="choose"/>',
                tabIndex: 8,
                margin: '10 0 6 10',
                width: 80,
                handler: function () {
                    cmItemTypeTreeWindow.show();
                }
            }]
    });

    var materialFatherCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="material.parentCode"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        maxLength: 50,
        readOnly: true,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                genMaterialCode(oldValue, newValue);
            }
        }
    });

    var materialCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 1,
        fieldLabel: '<fmt:message key="material.code"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '10 10 10 10',
        width: 250,
        maxLength: 20,
        listeners: {
            'change': function (textfield, newValue, oldValue) {
                genMaterialCode(oldValue, newValue);
            }
        }
    });
    var materialCompleteCode = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: -1,
        fieldLabel: '<fmt:message key="material.completeCode"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '20 10 10 10',
        width: 250,
        maxLength: 20,
        readOnly: true,
    });

   
    var materialName = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 2,
        fieldLabel: '<fmt:message key="material.name"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '20 10 10 10',
        width: 350,
        maxLength: 255,
    });
    
     var materialLocation = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        grow: true,
        tabIndex: 4,
        fieldLabel: '<fmt:message key="material.location"/>',
        labelAlign: 'left',
        anchor: '100%',
        margin: '20 10 10 10',
        width: 250,
        maxLength: 200,
        readOnly: false,
    });


    var unitStore = Ext.create('Ext.data.Store', {
        fields: ['abbr', 'name'],
        data: [
            {"abbr": "UN", "name": "<fmt:message key="material.unit.un"/>"},
            {"abbr": "KG", "name": "<fmt:message key="material.unit.kg"/>"},
            {"abbr": "M", "name": "<fmt:message key="material.unit.m"/>"},
            {"abbr": "M2", "name": "<fmt:message key="material.unit.m2"/>"},
            {"abbr": "M3", "name": "<fmt:message key="material.unit.m3"/>"},
        ]
    });


    var materialUnit = Ext.create('Ext.form.ComboBox', {
        fieldLabel: '<fmt:message key="material.unit"/>',
        labelWidth: 100,
        tabIndex: 6,
        store: unitStore,
        queryMode: 'local',
        displayField: 'name',
        valueField: 'abbr',
        margin: '23 10 10 10',
        anchor: '100%',
        allowBlank: false,
        editable: false,
    });

    var materialCost = Ext.create('Ext.form.field.Number', {
        xtype: 'numberfield',
        grow: true,
        tabIndex: 4,
        fieldLabel: '<fmt:message key="material.unitCost"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '20 10 10 10',
        width: 350,
        allowDecimals: true,
        allowNegative: false,
        decimalSeparator: ".",
        decimalPrecision: 3,
        minValue: 0,
    });
    var materialQty = Ext.create('Ext.form.field.Number', {
        xtype: 'numberfield',
        grow: true,
        tabIndex: 5,
        fieldLabel: '<fmt:message key="material.qty"/>',
        labelAlign: 'left',
        anchor: '100%',
        allowBlank: false,
        margin: '20 10 10 10',
        width: 350,
        allowDecimals: false,
        allowNegative: false,
        minValue: 0,
    });


    var materialImage = {
        xtype: 'filefield',
        id: "materialImage",
        tabIndex: 3,
        name: 'file',
        fieldLabel: '<fmt:message key="material.img"/>',
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

    var materialImgUrl = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var materialImgPath = Ext.create('Ext.form.field.Text', {
        xtype: 'textfield',
        hidden: true,
    });

    var materialImgPreview = new Ext.Component({
        margin: '10 10 10 10',
        autoEl: {
            tag: 'img', src: '../images/no-preview-available.png', id: 'materialImgPreview'
        }
    });

    var imgForm = Ext.create('Ext.form.Panel', {
        xtype: 'form',
        layout: 'anchor',
        bodyStyle: 'background-color: transparent;',
        items: [materialImgUrl, materialImgPath, materialImage]
    });

    //--------------------------------------------------------------------------
    var tabSpec = Ext.create('Ext.tab.Panel', {
        tabBarPosition: 'top',
        autoHeight: true,
        activeTab: 0,
        items: [{
                title: '<fmt:message key="material.info"/>',
                tabIndex: 13,
                id: "tabInfo",
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
                                items: [imgForm, materialCost, materialQty, materialUnit]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.5,
                                layout: 'anchor',
                                items: [materialImgPreview]
                            },
                        ]
                    }
                ],
            }, {
                title: '<fmt:message key="material.specification"/>',
                tabIndex: 7,
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
                                    materialGenSpecLabel("01"),
                                    materialGenSpecLabel("02"),
                                    materialGenSpecLabel("03"),
                                    materialGenSpecLabel("04"),
                                    materialGenSpecLabel("05")
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.25,
                                layout: 'anchor',
                                items: [
                                    materialGenSpec("01"),
                                    materialGenSpec("02"),
                                    materialGenSpec("03"),
                                    materialGenSpec("04"),
                                    materialGenSpec("05")
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.25,
                                layout: 'anchor',
                                items: [
                                    materialGenSpecLabel("06"),
                                    materialGenSpecLabel("07"),
                                    materialGenSpecLabel("08"),
                                    materialGenSpecLabel("09"),
                                    materialGenSpecLabel("10"),
                                ]
                            }, {
                                xtype: 'container',
                                columnWidth: 0.25,
                                layout: 'anchor',
                                items: [
                                    materialGenSpec("06"),
                                    materialGenSpec("07"),
                                    materialGenSpec("08"),
                                    materialGenSpec("09"),
                                    materialGenSpec("10")
                                ]
                            }, ]
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

    var materialForm = Ext.create('Ext.form.Panel', {
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
                        items: [materialId, materialFather, materialCode, materialName, ]
                    }, {
                        xtype: 'container',
                        columnWidth: 0.5,
                        layout: 'anchor',
                        items: [materialFatherCode, materialCompleteCode,materialLocation]
                    },
                    {
                        xtype: 'container',
                        columnWidth: 1,
                        id: "containerTab",
                        layout: 'anchor',
                        items: [tabSpec]
                    }
                ]
            }
        ]
    });

    var materialWindow = Ext.create('Ext.window.Window', {
        closeAction: 'hide',
        autoEl: 'form',
        width: '60%',
        autoScroll: true,
        constrainHeader: true,
        layout: 'anchor',
        modal: true,
        defaults: {
            anchor: '100%'
        },
        items: [materialForm],
        buttons: [{
                text: '<fmt:message key="button.save"/>',
                type: 'submit',
                handler: function () {
                    saveFormMaterial();
                }
            }, {
                text: '<fmt:message key="button.cancel"/>',
                handler: function () {
                    materialWindow.hide();
                }
            }],
        listeners: {
            show: function (window) {
                tabSpec.setActiveTab(Ext.getCmp("tabInfo"));
            },
            afterRender: function (thisForm, options) {
                this.keyNav = Ext.create('Ext.util.KeyNav', this.el, {
                    enter: function () {
                        saveFormMaterial();
                    }
                });
            },
        }
    });


</script>
