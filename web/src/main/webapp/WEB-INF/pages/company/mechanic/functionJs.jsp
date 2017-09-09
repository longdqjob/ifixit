<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function changeCode(oldValue, newValue) {
        if (mechanicTypeCode.getValue() != "") {
            Ext.getCmp("mechanicFullCode").setText('<fmt:message key="machine.fullCode"/>: ' + mechanicTypeCode.getValue() + "-" + newValue);
        } else {
            Ext.getCmp("mechanicFullCode").setText('<fmt:message key="machine.fullCode"/>: ' + newValue);
        }

    }
    //--------------------------------Mechanic----------------------------------
    function addMechanic(data) {
        resetLabelSpec();
        mechanicForm.reset();
        mechanicWindow.setTitle('<fmt:message key="machine.add"/>');
        mechanicWindow.show();
        gridHis.setHeight(mechanicForm.getHeight() - mechanicType.getHeight() - mechanicCode.getHeight() - 50);
        mechanicName.focus();
    }

    function editMechanic(data) {
        resetLabelSpec();
        mechanicForm.reset();
        mechanicId.setValue(data.get("id"));
        mechanicTypeId.setValue(data.get("machineTypeId"));
        mechanicTypeName.setValue(data.get("machineTypeName"));
        mechanicTypeCode.setValue(data.get("machineTypeCode"));
        mechanicCode.setValue(data.get("code"));
        mechanicName.setValue(data.get("name"));
        fatherId.setValue(data.get("parentId"));
        fatherName.setValue(data.get("parentName"));
        systemId.setValue(data.get("companyId"));
        systemName.setValue(data.get("companyName"));
        fillSpecificValue(data.get("specification"));
        mechanicWindow.setTitle('<fmt:message key="machine.edit"/>');
        mechanicWindow.show();
        gridHis.setHeight(mechanicForm.getHeight() - mechanicType.getHeight() - mechanicCode.getHeight() - 50);
        mechanicName.focus();
    }

    function getMechanicType(id) {
        mask();
        Ext.Ajax.request({
            url: "/machineType/getInfo",
            method: "POST",
            params: {
                id: id,
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                console.log(res);
                if ("true" == res.success || true === res.success) {
                    if (res.info && res.info.specification) {
                        fillSpecific(res.info.specification);
                    } else {
                        fillSpecific("");
                    }
                } else {
                    alertError(res.message);
                }
            },
            failure: function (response, opts) {
                alertSystemError();
                unmask();
            },
        });
    }


    function generateSpecificLabel(idx) {
        return Ext.create('Ext.form.field.Text', {
            xtype: 'textfield',
            grow: true,
            fieldLabel: idx,
            labelWidth: 20,
            tabIndex: -1,
            id: "specificationlb_" + idx,
            labelAlign: 'left',
            anchor: '100%',
            allowBlank: true,
            margin: '10 10 10 10',
            width: 350,
            maxLength: 50,
            readOnly: true,
        });
    }

    function generateSpecific(idx) {
        return Ext.create('Ext.form.field.Text', {
            xtype: 'textfield',
            grow: true,
            tabIndex: parseInt(idx) + 13,
            name: 'specification',
            id: "specification_" + idx,
            labelAlign: 'left',
            anchor: '100%',
            allowBlank: true,
            margin: '10 10 10 10',
            width: 350,
            maxLength: 50,
        });
    }


    function resetLabelSpec() {
        var tmp;
        for (var i = 1; i <= maxSpecification; i++) {
            if (i < 10) {
                tmp = "0" + i;
            } else {
                tmp = "" + i;
            }
            Ext.getCmp("specificationlb_" + tmp).reset();
        }
    }
    function fillSpecific(input) {
        resetLabelSpec();
        if (input != null && input != "") {
            var obj = Ext.decode(input);
            for (var key in obj) {
                if (key) {
                    try {
                        Ext.getCmp("specificationlb_" + key).setValue(obj[key]);
                    } catch (c) {
                        console.log("----key: " + key);
                    }
//                    Ext.getCmp("specification_" + key).setFieldLabel(obj[key]);
                }
            }
        }
    }

    function fillSpecificValue(value) {
        if (value != null && value != "") {
            var obj = Ext.decode(value);
            var tmp;
            for (var key in obj) {
                if (key && obj.hasOwnProperty(key)) {
                    tmp = obj[key];
                    if (tmp.hasOwnProperty("value")) {
//                        Ext.getCmp("specification_" + key).setFieldLabel(tmp["label"]);
                        Ext.getCmp("specification_" + key).setValue(tmp["value"]);
                    }
                }
            }
        }
    }


    function createSpecific() {
        var tmp;
        var rtn = {};
        for (var i = 1; i <= maxSpecification; i++) {
            if (i < 10) {
                tmp = "0" + i;
            } else {
                tmp = "" + i;
            }
            if (Ext.getCmp("specification_" + tmp).getValue() != "") {
                rtn[tmp] = {
                    "label": Ext.getCmp("specification_" + tmp).getFieldLabel(),
                    "value": Ext.getCmp("specification_" + tmp).getValue()
                };
            }
        }
        return rtn;
    }
    function chooseMechanicType(record) {
        maskTarget(mechanicWindow);
        Ext.getCmp('mechanicTypeName').setValue(record.get('name'));
        Ext.getCmp('mechanicTypeId').setValue(record.get('id'));
        Ext.getCmp('mechanicTypeCode').setValue(record.get('code'));
        changeCode("", mechanicCode.getValue());
        fillSpecific(record.get('specification'));
        unMaskTarget();
    }

    function chooseMechanic(record) {
        Ext.getCmp('fatherName').setValue(record.get('name'));
        Ext.getCmp('fatherId').setValue(record.get('id'));
    }

    function loadHistory(id) {
        gridHis.getStore().getProxy().extraParams = {
            id: id,
        };
        gridHis.getStore().loadPage(1);
    }


    function saveMechanic() {
        var valid = mechanicForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        if (mechanicTypeId.getValue() == null || mechanicTypeId.getValue() === "") {
            mechanicTypeName.reset();
            mechanicTypeName.setActiveError("This field is required!");
            mechanicTypeWindow.show();
            return false;
        }

        if (systemId.getValue() == null || systemId.getValue() === "") {
            systemName.reset();
            systemName.setActiveError("This field is required!");
            companyTreeWindow.show();
            return false;
        }

        maskTarget(mechanicWindow);
        Ext.Ajax.request({
            url: "/machine/save",
            method: "POST",
            params: {
                id: mechanicId.getValue(),
                code: mechanicCode.getValue(),
                name: mechanicName.getValue(),
                description: "",
                specification: Ext.encode(createSpecific()),
                parentId: fatherId.getValue(),
                companyId: systemId.getValue(),
                machineTypeId: mechanicTypeId.getValue(),
                note: "",
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("true" == res.success || true === res.success) {
                    mechanicWindow.hide();
                    var scrollPosition = mygrid.getEl().down('.x-grid-view').getScroll();
                    alertSuccess(res.message);
                    loadMachine();
                    mygrid.getView().getEl().scrollTo('Top', scrollPosition.top, true);
                } else {
                    alertError(res.message);
                }
            },
            failure: function (response, opts) {
                alertSystemError();
                unMaskTarget();
            },
        });
    }
</script>