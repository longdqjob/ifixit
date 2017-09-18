<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var selectedItem = null;

    function updateLayOut() {
        if (itemTypeWindow.isVisible()) {
            itemTypeWindow.updateLayout();
        }
        if (materialWindow.isVisible()) {
            materialWindow.updateLayout();
        }
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridId').setWidth(Ext.getCmp("searchform").getWidth());
        Ext.getCmp('gridId').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 110);
        Ext.getCmp("gridId").updateLayout();
        tree.setHeight(Ext.getCmp("viewport").getHeight() - 180);
    }

    function genItemTypeCode() {
        if (itemTypeParentCode.getValue() != "") {
            itemTypeFullCode.setValue(itemTypeParentCode.getValue() + "." + itemTypeCode.getValue());
        } else {
            itemTypeFullCode.setValue(itemTypeCode.getValue());
        }
    }

    function chooseTreeCmItemType(record) {
        if (itemTypeWindow.isVisible()) {
            itemTypeParentId.setValue(record.get("id"));
            itemTypeParentName.setValue(record.get("name"));
            itemTypeParentCode.setValue(record.get("completeCode"));
            genItemTypeCode();
        }
        if (materialWindow.isVisible()) {
            materialFatherId.setValue(record.get("id"));
            materialFatherName.setValue(record.get("name"));
            materialFatherCode.setValue(record.get("completeCode"));
            materialFillSpec(record.get("specification"));
        }
    }
    function loadMaterial(id) {
        var itemId = 0;
        if (id == 0) {
            if (selectedItem != null) {
                itemId = selectedItem.get("id");
            }
        } else {
            itemId = id;
        }
        mygrid.getStore().getProxy().extraParams = {
            itemId: itemId,
            code: searchCode.getValue(),
            name: searchName.getValue(),
        };
        mygrid.getStore().loadPage(1, {
            callback: function (records, operation, success) {
                storeRedirectIfNotAuthen(operation);
            }
        });
    }

    function addItemType(data) {
        itemTypeResetSpec();
        itemTypeForm.reset();
        if (data != null) {
            itemTypeParentId.setValue(data.get("id"));
            itemTypeParentName.setValue(data.get("name"));
            itemTypeParentCode.setValue(data.get("completeCode"));
        }
        itemTypeWindow.setTitle('<fmt:message key="itemType.add"/>');
        itemTypeWindow.setIconCls("add-cls");
        enableCode();
        itemTypeWindow.show();
        itemTypeCode.focus();
    }

    function editItemType(data) {
        itemTypeForm.reset();
        itemTypeId.setValue(data.get("id"));
        itemTypeParentId.setValue(data.get("parentId"));
        itemTypeParentName.setValue(data.get("parentName"));
        itemTypeParentCode.setValue(data.get("parentCode"));
        itemTypeName.setValue(data.get("name"));
        itemTypeCode.setValue(data.get("code"));
        itemTypeFullCode.setValue(data.get("completeCode"));
        itemTypeFillSpec(data.get("specification"));
        disableCode();
        itemTypeWindow.setTitle('<fmt:message key="itemType.edit"/>');
        itemTypeWindow.setIconCls("edit-cls");
        itemTypeWindow.show();
        itemTypeCode.focus();
    }
    function enableCode() {
        itemTypeCode.setReadOnly(false);
    }
    function disableCode() {
        itemTypeCode.setReadOnly(true);
    }

    function deleteItemType(arrayList) {
        maskTarget(Ext.getCmp('tree'));
        Ext.Ajax.request({
            url: '../itemType/delete?' + arrayList,
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
    function saveFormItemType() {
        var valid = itemTypeForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        maskTarget(itemTypeWindow);
        Ext.Ajax.request({
            url: "../itemType/save",
            method: "POST",
            params: {
                id: itemTypeId.getValue(),
                parent: itemTypeParentId.getValue(),
                code: itemTypeCode.getValue(),
                completeCode: itemTypeFullCode.getValue(),
                name: itemTypeName.getValue(),
                specification: Ext.encode(itemTypeCreateSpec())
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    itemTypeCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    alertSuccess(res.message);
                    itemTypeWindow.hide();
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

    function itemTypeGenSpecLabel(idx) {
        return Ext.create('Ext.form.field.Text', {
            xtype: 'textfield',
            grow: true,
            fieldLabel: idx,
            labelWidth: 20,
            id: "it_spec_" + idx,
            labelAlign: 'left',
            anchor: '100%',
            allowBlank: true,
            margin: '10 10 10 10',
            width: 350,
            maxLength: 50,
        });
    }
    function itemTypeResetSpec() {
        var tmp;
        for (var i = 1; i <= numSpecification; i++) {
            if (i < 10) {
                tmp = "0" + i;
            } else {
                tmp = "" + i;
            }
            Ext.getCmp("it_spec_" + tmp).reset();
        }
    }

    function itemTypeFillSpec(input) {
        itemTypeResetSpec();
        if (input != null && input != "") {
            var obj = Ext.decode(input);
            for (var key in obj) {
                if (key) {
                    try {
                        Ext.getCmp("it_spec_" + key).setValue(obj[key]);
                    } catch (c) {
                        console.log("----key: " + key);
                    }
                }
            }
        }
    }
    function itemTypeCreateSpec() {
        var tmp;
        var rtn = {};
        for (var i = 1; i <= numSpecification; i++) {
            if (i < 10) {
                tmp = "0" + i;
            } else {
                tmp = "" + i;
            }
            if (Ext.getCmp("it_spec_" + tmp).getValue() != "") {
                rtn["" + tmp] = Ext.getCmp("it_spec_" + tmp).getValue();
            }
        }
        console.log(rtn);
        return rtn;
    }
</script>