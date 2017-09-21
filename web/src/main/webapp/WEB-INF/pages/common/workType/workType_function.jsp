<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function addCmWorkType() {
        cmWorkTypeForm.reset();
        cmWorkTypeWindow.setTitle('<fmt:message key="workType.add"/>');
        cmWorkTypeWindow.show();
    }

    function editCmWorkType(data) {
        cmWorkTypeForm.reset();
        cmWorkTypeId.setValue(data.get("id"));
        cmWorkTypeName.setValue(data.get("name"));
        cmWorkTypeCode.setValue(data.get("code"));
        cmWorkTypeWindow.setTitle('<fmt:message key="workType.add"/>');
        cmWorkTypeWindow.show();
    }

    function deleteWorkType(arrayList) {
        maskTarget(cmWorkTypeWindow);
        Ext.Ajax.request({
            url: '../workType/delete?' + arrayList,
            method: "POST",
            timeout: 10000,
            success: function (result, request) {
                unMaskTarget();
                jsonData = Ext.decode(result.responseText);
                if (jsonData.success == true) {
                    alertSuccess(jsonData.message);
                    fnCmSearchWorkType();
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

    function saveCmWorkType() {
        var valid = cmWorkTypeForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }
        
        if (hasUnicode(cmWorkTypeCode.getValue())) {
            cmWorkTypeCode.setActiveError('<fmt:message key="notUnicode"/>');
            alertError('<fmt:message key="notUnicode"/>');
            return false;
        }

        maskTarget(cmWorkTypeWindow);
        Ext.Ajax.request({
            url: "../workType/save",
            method: "POST",
            params: {
                id: cmWorkTypeId.getValue(),
                code: cmWorkTypeCode.getValue(),
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
                    fnCmSearchWorkType();
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
</script>