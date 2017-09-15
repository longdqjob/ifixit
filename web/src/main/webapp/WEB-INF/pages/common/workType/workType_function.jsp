<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var cmWorkTypeParentCode = "";

    function generateCmWorkTypeFullCode() {
        if (cmWorkTypeParentCode != "") {
            cmWorkTypeFullCode.setValue(cmWorkTypeParentCode + "." + cmWorkTypeCode.getValue());
        } else {
            cmWorkTypeFullCode.setValue(cmWorkTypeCode.getValue());
        }
    }
    function addCmWorkType(data) {
        cmWorkTypeParentCode = "";
        cmWorkTypeForm.reset();
        if (data) {
            cmWorkTypeParentCode = data.get("code");
            cmWorkTypeParentId.setValue(data.get("id"));
        }
        cmWorkTypeWindow.setTitle('<fmt:message key="workType.add"/>');
        cmWorkTypeWindow.show();
    }

    function editCmWorkType(data) {
        cmWorkTypeParentCode = data.get("parentCode");
        cmWorkTypeForm.reset();
        cmWorkTypeParentId.setValue(data.get("parentId"));
        cmWorkTypeId.setValue(data.get("id"));
        cmWorkTypeName.setValue(data.get("name"));
        cmWorkTypeCode.setValue(data.get("code"));
        cmWorkTypeFullCode.setValue(data.get("completeCode"));
        cmWorkTypeWindow.setTitle('<fmt:message key="workType.add"/>');
        cmWorkTypeWindow.show();
    }

    function deleteWorkType(arrayList) {
        var showMask = new Ext.LoadMask({
            msg: '<fmt:message key="loading"/>',
            target: Ext.getCmp('gridId')
        });
        showMask.show();
        Ext.Ajax.request({
            url: '../workType/delete?' + arrayList,
            method: "POST",
            timeout: 10000,
            success: function (result, request) {
                showMask.hide();
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
            },
            failure: function (response, opts) {
                showMask.hide();
                alertSystemError();
            }
        });
    }

    function saveCmWorkType() {
        var valid = cmWorkTypeForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        maskTarget(cmWorkTypeWindow);
        Ext.Ajax.request({
            url: "../workType/save",
            method: "POST",
            params: {
                id: cmWorkTypeId.getValue(),
                parent: cmWorkTypeParentId.getValue(),
                code: cmWorkTypeCode.getValue(),
                completeCode: cmWorkTypeFullCode.getValue(),
                name: cmWorkTypeName.getValue(),
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    cmWorkTypeCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    cmWorkTypeWindow.hide();
                    alertSuccess(res.message);
//                    if (storeTreeWorkTypeSelected) {
//                        storeTreeWorkTypeSelected.removeAll();
//                    }
                    storeTreeWorkType.load({
                        node: cmWorkTypeParentId.getValue(),
//                        callback: function () {
//                            storeTreeWorkType.sync();
//                            Ext.getCmp("treeWorkType").getView().refresh();
//                        }
                    });
                } else {
                    if (res.message) {
                        alertError(res.message);
                    } else {
                        alertSystemError();
                    }
                }
            },
            failure: function (response, opts) {
                alertSystemError();
                unMaskTarget();
            },
        });
    }
</script>