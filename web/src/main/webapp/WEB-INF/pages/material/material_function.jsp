<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function addMaterial(data) {
        materialResetSpec();
        materialForm.reset();
        if (data != null) {
            materialFatherId.setValue(data.get("id"));
            materialFatherName.setValue(data.get("name"));
            materialFatherCode.setValue(data.get("completeCode"));
        }
        materialWindow.setTitle('<fmt:message key="material.add"/>');
        materialWindow.setIconCls("add-cls");
        enableCode();
        resetImgPreView();
        materialWindow.show();
        materialCode.focus();
    }

    function resetImgPreView() {
        materialImgUrl.reset();
        try {
            materialImgPreview.el.dom.src = "../images/no-preview-available.png";
        } catch (c) {
            console.error(c);
        }
    }
    function setImgPreView(url) {
        materialImgUrl.setValue(url);
        try {
            materialImgPreview.el.dom.src = url;
        } catch (c) {
            console.error(c);
        }
    }

    function editMaterial(data) {
        materialResetSpec();
        var itemTypeObj = null;

        materialForm.reset();
        materialId.setValue(data.get("id"));

        if (data.get("itemType")) {
            itemTypeObj = Ext.decode(data.get("itemType"));
            console.log(itemTypeObj);
            materialFatherId.setValue(itemTypeObj.id);
            materialFatherName.setValue(itemTypeObj.name);
            materialFatherCode.setValue(itemTypeObj.completeCode);
        }

        materialCode.setValue(data.get("code"));
        materialCompleteCode.setValue(data.get("completeCode"));
        materialName.setValue(data.get("name"));
        materialCost.setValue(data.get("cost"));
        materialUnit.setValue(data.get("unit"));
        materialQty.setValue(data.get("quantity"));

        if (data.get("imgUrl") && data.get("imgUrl") != "") {
            setImgPreView(data.get("imgUrl"));
        } else {
            resetImgPreView();
        }

        if (data.get("imgPath") && data.get("imgPath") != "") {
            materialImgPath.setValue(data.get("imgPath"));
        }


        disableCode();
        materialFillSpecValue(data.get("specification"));
        materialWindow.setTitle('<fmt:message key="material.edit"/>');
        materialWindow.setIconCls("edit-cls");
        materialWindow.show();
        materialCode.focus();
    }
    function enableCode() {
        materialCode.setReadOnly(false);
    }
    function disableCode() {
        materialCode.setReadOnly(true);
    }
    function genMaterialCode() {
        if (materialFatherCode.getValue() != "") {
            materialCompleteCode.setValue(materialFatherCode.getValue() + "." + materialCode.getValue());
        } else {
            materialCompleteCode.setValue(materialCode.getValue());
        }
    }

    function chooseTreeMeterial(record) {
        materialFatherId.setValue(record.get("id"));
        materialFatherName.setValue(record.get("name"));
        materialFatherCode.setValue(record.get("completeCode"));
    }

    function deleteMaterial(arrayList) {
        maskTarget(Ext.getCmp('treeItemType'));
        Ext.Ajax.request({
            url: '../material/delete?' + arrayList,
            method: "POST",
            timeout: 10000,
            success: function (result, request) {
                unMaskTarget();
                jsonData = Ext.decode(result.responseText);
                if (jsonData.success == true) {
                    alertSuccess(jsonData.message);
                } else {
                    if (jsonData.message) {
                        alertError(jsonData.message);
                    } else {
                        alertSystemError();
                    }
                }
                //TODO reload store
                store.reload();
            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
                unMaskTarget();
                alertSystemError();
            }
        });
    }

    function materialCreateSpec() {
        var tmp;
        var rtn = {};
        for (var i = 1; i <= numSpecification; i++) {
            if (i < 10) {
                tmp = "0" + i;
            } else {
                tmp = "" + i;
            }
            if (Ext.getCmp("mat_spec_" + tmp).getValue() != "") {
                rtn[tmp] = {
                    "label": Ext.getCmp("mat_speclb_" + tmp).getValue(),
                    "value": Ext.getCmp("mat_spec_" + tmp).getValue()
                };
            }
        }
        return rtn;
    }

    function uploadImg() {
        maskTarget(materialWindow);
        imgForm.getForm().submit({
            url: '../material/saveImg',
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
                materialImgPath.setValue(o.result.path);
            },
            failure: function (form, o) {
                unMaskTarget();
                alertError('Error: ' + o.result && o.result.message || '<fmt:message key="uploadFailMsg"/>');
            }
        });
    }

    function saveFormMaterial() {
        var valid = materialForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        maskTarget(materialWindow);
        Ext.Ajax.request({
            url: "../material/save",
            method: "POST",
            params: {
                id: materialId.getValue(),
                itemTypeId: materialFatherId.getValue(),
                code: materialCode.getValue(),
                completeCode: materialCompleteCode.getValue(),
                name: materialName.getValue(),
                cost: materialCost.getValue(),
                unit: materialUnit.getValue(),
                quantity: materialQty.getValue(),
                imgUrl: materialImgUrl.getValue(),
                imgPath: materialImgPath.getValue(),
                specification: Ext.encode(materialCreateSpec())
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    materialCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    materialWindow.hide();
                    alertSuccess(res.message);
                    loadMaterial(0);
                } else {
                    if (res.message || res.message == "true") {
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

    function saveChangeMaterial(id, quantity, unit, cost, callbackSuccess, callbackFail) {
        maskTarget(Ext.getCmp("gridId"));
        Ext.Ajax.request({
            url: "../material/saveChange",
            method: "POST",
            params: {
                id: id,
                quantity: quantity,
                cost: cost,
                unit: unit,
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("true" == res.success || true === res.success) {
                    alertSuccess(res.message);
                    if (isFunction(callbackSuccess)) {
                        callbackSuccess();
                    }
                } else {
                    if (res.message || res.message == "true") {
                        alertError(res.message);
                    } else {
                        alertSystemError();
                    }
                    if (isFunction(callbackFail)) {
                        callbackFail();
                    }
                }
            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
                alertSystemError();
                unMaskTarget();
                if (isFunction(callbackFail)) {
                    callbackFail();
                }
            },
        });
    }
    //
    function materialGenSpecLabel(idx) {
        return Ext.create('Ext.form.field.Text', {
            xtype: 'textfield',
            grow: true,
            fieldLabel: idx,
            labelWidth: 20,
            tabIndex: -1,
            id: "mat_speclb_" + idx,
            labelAlign: 'left',
            anchor: '100%',
            allowBlank: true,
            margin: '10 10 10 10',
            width: 350,
            maxLength: 50,
            readOnly: true,
        });
    }

    function materialGenSpec(idx) {
        return Ext.create('Ext.form.field.Text', {
            xtype: 'textfield',
            grow: true,
            tabIndex: parseInt(idx) + 13,
            id: "mat_spec_" + idx,
            labelAlign: 'left',
            anchor: '100%',
            allowBlank: true,
            margin: '10 10 10 10',
            width: 350,
            maxLength: 50,
        });
    }

    function materialResetSpec() {
        var tmp;
        for (var i = 1; i <= numSpecification; i++) {
            if (i < 10) {
                tmp = "0" + i;
            } else {
                tmp = "" + i;
            }
            Ext.getCmp("mat_speclb_" + tmp).reset();
            Ext.getCmp("mat_spec_" + tmp).reset();
        }
    }
    function materialFillSpec(input) {
        materialResetSpec();
        if (input != null && input != "") {
            var obj = Ext.decode(input);
            for (var key in obj) {
                if (key) {
                    try {
                        Ext.getCmp("mat_speclb_" + key).setValue(obj[key]);
                    } catch (c) {
                        console.log("----key: " + key);
                    }
                }
            }
        }
    }

    function materialFillSpecValue(value) {
        if (value != null && value != "") {
            var obj = Ext.decode(value);
            var tmp;
            for (var key in obj) {
                if (key && obj.hasOwnProperty(key)) {
                    tmp = obj[key];
                    if (tmp.hasOwnProperty("label")) {
                        Ext.getCmp("mat_speclb_" + key).setValue(tmp["label"]);
                    }
                    if (tmp.hasOwnProperty("value")) {
                        Ext.getCmp("mat_spec_" + key).setValue(tmp["value"]);
                    }
                }
            }
        }
    }
</script>