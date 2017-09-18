<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function resetImgPreView() {
        mechanicImgUrl.reset();
        mechanicImgPath.reset();
        try {
            mechanicImgPreview.el.dom.src = "../images/no-preview-available.png";
        } catch (c) {
            console.error(c);
        }
    }
    function setImgPreView(url) {
        mechanicImgUrl.setValue(url);
        try {
            mechanicImgPreview.el.dom.src = url;
        } catch (c) {
            console.error(c);
        }
    }

    function changeCode(oldValue, newValue) {
        if (mechanicTypeCode.getValue() != "") {
            //  Ext.getCmp("mechanicFullCode").setText('<fmt:message key="machine.fullCode"/>: ' + mechanicTypeCode.getValue() + "." + newValue);
            mechanicCompleteCode.setValue(mechanicTypeCode.getValue() + "." + newValue);
        } else {
            // Ext.getCmp("mechanicFullCode").setText('<fmt:message key="machine.fullCode"/>: ' + newValue);
            mechanicCompleteCode.setValue(newValue);
        }
    }

    function enableCode() {
        mechanicCode.setReadOnly(false);
    }
    function disableCode() {
        mechanicCode.setReadOnly(true);
    }
    //--------------------------------Mechanic----------------------------------
    function addMechanic(data) {
        resetLabelSpec();
        resetImgPreView();
        mechanicForm.reset();
        mechanicWindow.setTitle('<fmt:message key="machine.add"/>');
        mechanicWindow.setIconCls('add-cls');
        enableCode();
        mechanicWindow.show();
        gridHis.setHeight(mechanicForm.getHeight() - mechanicType.getHeight() - mechanicCode.getHeight() - 50);
        mechanicCode.focus();
    }

    function editMechanic(data) {
        console.log(data);
        resetLabelSpec();
        mechanicForm.reset();
        mechanicId.setValue(data.get("id"));
        mechanicTypeId.setValue(data.get("machineTypeId"));
        mechanicTypeName.setValue(data.get("machineTypeName"));
        mechanicTypeCode.setValue(data.get("machineTypeCode"));
        fillSpecific(data.get("machineTypeSpec"));
        mechanicCode.setValue(data.get("code").replace(data.get("machineTypeCode") + ".", ""));
        mechanicName.setValue(data.get("name"));
        fatherId.setValue(data.get("parentId"));
        fatherName.setValue(data.get("parentName"));
        systemId.setValue(data.get("companyId"));
        systemName.setValue(data.get("companyName"));

        fillSpecificValue(data.get("specification"));
        machineNote.setValue(data.get("note"));
        if (typeof data.get("since") !== "undefined") {
            Ext.getCmp("sinceField").setValue(Ext.Date.parse(data.get("since").split(".")[0], 'Y-m-d H:i:s'));
        }

        if (data.get("imgUrl") && data.get("imgUrl") != "") {
            setImgPreView(data.get("imgUrl"));
        } else {
            resetImgPreView();
        }
        if (data.get("imgPath") && data.get("imgPath") != "") {
            mechanicImgPath.setValue(data.get("imgPath"));
        }
        mechanicWindow.setTitle('<fmt:message key="machine.edit"/>');
        mechanicWindow.setIconCls('edit-cls');
        disableCode();
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
                redirectIfNotAuthen(response);
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
                    "label": Ext.getCmp("specification_" + tmp).getValue(),
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
        gridHis.getStore().loadPage(1, {
            callback: function (records, operation, success) {
                storeRedirectIfNotAuthen(operation);
            }
        });
    }

    function uploadImg() {
        maskTarget(mechanicWindow);
        imgForm.getForm().submit({
            url: '../machine/saveImg',
            waitMsg: '<fmt:message key="uploadingMsg"/>',
            handleResponse: function (response) {
                var res = JSON.parse(response.responseXML.body.textContent);
                console.log(res);
                return res;
            },
            success: function (fp, o) {
                unMaskTarget();
                alertSuccess('Success: ' + o.result && o.result.message || '<fmt:message key="uploadSuccessMsg"/>');
                setImgPreView(o.result.url);
                mechanicImgPath.setValue(o.result.path);
            },
            failure: function (form, o) {
                unMaskTarget();
                alertError('Error: ' + o.result && o.result.message || '<fmt:message key="uploadFailMsg"/>');
            }
        });
    }

    function saveMechanic() {
        var valid = mechanicForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            if (mechanicTypeId.getValue() == null || mechanicTypeId.getValue() === "") {
                mechanicTypeName.reset();
                mechanicTypeName.setActiveError('<fmt:message key="message.required"/>');
                return false;
            }

            if (systemId.getValue() == null || systemId.getValue() === "") {
                Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("indentify"));
                systemName.reset();
                systemName.setActiveError('<fmt:message key="message.required"/>');
                return false;
            }

            if (!machineNote.isValid()) {
                Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("machineNotes"));
            }
            return false;
        }

        if (mechanicTypeId.getValue() == null || mechanicTypeId.getValue() === "") {
            mechanicTypeName.reset();
            mechanicTypeName.setActiveError('<fmt:message key="message.required"/>');
            mechanicTypeWindow.show();
            return false;
        }

        if (systemId.getValue() == null || systemId.getValue() === "") {
            Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("indentify"));
            systemName.reset();
            systemName.setActiveError('<fmt:message key="message.required"/>');
            companyTreeWindow.show();
            return false;
        }

        maskTarget(mechanicWindow);
        console.log(Ext.getCmp("sinceField").getRawValue());
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
                note: machineNote.getValue(),
                since: Ext.getCmp("sinceField").getRawValue(),
                imgUrl: mechanicImgUrl.getValue(),
                imgPath: mechanicImgPath.getValue(),
                completeCode: mechanicCompleteCode.getValue()
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    mechanicCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    mechanicWindow.hide();
                    var scrollPosition = mygrid.getEl().down('.x-grid-view').getScroll();
                    alertSuccess(res.message);
                    loadMachine();
                    mygrid.getView().getEl().scrollTo('Top', scrollPosition.top, true);
                } else {
                    if (res.message) {
                        alertError(res.message);
                    } else {
                        alertSystemError();
                    }
                }
            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
                alertSystemError();
                unMaskTarget();
            },
        });
    }

    function deleteMachine(arrayList) {
        maskTarget(Ext.getCmp('gridId'));
        Ext.Ajax.request({
            url: '../machine/delete?' + arrayList,
            method: "POST",
            timeout: 10000,
            success: function (result, request) {
                unMaskTarget();
                jsonData = Ext.decode(result.responseText);
                if (jsonData.success == true) {
                    alertSuccess(jsonData.message);
                    loadMachine(selectedSystem.get("id"));
                } else {
                    if (jsonData.message) {
                        alertError(jsonData.message);
                    } else {
                        alertSystemError();
                    }
                }
            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
                unMaskTarget();
                alertSystemError();
            }
        });
    }
</script>