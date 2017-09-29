<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function updateLayOut() {
        Ext.getCmp("searchWorkTypePn").updateLayout();
        Ext.getCmp('gridWorkType').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchWorkTypePn").getHeight() - 120);
        Ext.getCmp("gridWorkType").updateLayout();
    }

    function addWorkType() {
        workTypeForm.reset();
        workTypeWindow.setTitle('<fmt:message key="workType.add"/>');
        workTypeWindow.show();
        workTypeCode.focus();
    }

    function editWorkType(data) {
        workTypeForm.reset();
        workTypeId.setValue(data.get("id"));
        workTypeCode.setValue(data.get("code"));
        workTypeName.setValue(data.get("name"));
        
        grpEngineerId.setValue("grpEngineerId");
        grpEngineerName.setValue("grpEngineerName");
        workTypeInterval.setValue("interval");
        workTypeRepeat.setValue((data.get('isRepeat') == "1"));
        workTypeTask.setValue("task");

        workTypeWindow.setTitle('<fmt:message key="workType.edit"/>');
        workTypeWindow.show();
        workTypeCode.focus();
    }

    function deleteWorkType(arrayList) {
        maskTarget(gridWorkType);
        Ext.Ajax.request({
            url: '../workType/delete?' + arrayList,
            method: "GET",
            timeout: 10000,
            success: function (result, request) {
                unMaskTarget();
                jsonData = Ext.decode(result.responseText);
                if (jsonData.success == true) {
                    alertSuccess(jsonData.message);
                    searchWorkTypeGrid();
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
    function saveForm() {
        var valid = workTypeForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        if (hasUnicode(workTypeCode.getValue())) {
            workTypeCode.setActiveError('<fmt:message key="notUnicode"/>');
            alertError('<fmt:message key="notUnicode"/>');
            return false;
        }

        mask();
        Ext.Ajax.request({
            url: "/workType/save",
            method: "POST",
            params: {
                id: workTypeId.getValue(),
                code: workTypeCode.getValue(),
                name: workTypeName.getValue(),
                grpEngineerId: grpEngineerId.getValue(),
                interval: workTypeInterval.getValue(),
                repeat: (workTypeRepeat.getValue()) ? 1 : 0,
                task: workTypeTask.getValue(),
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    workTypeCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    workTypeWindow.hide();
                    var scrollPosition = gridWorkType.getEl().down('.x-grid-view').getScroll();
                    alertSuccess(res.message);
                    searchWorkTypeGrid();
                    gridWorkType.getView().getEl().scrollTo('Top', scrollPosition.top, true);
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
                unmask();
            },
        });
    }

    function searchWorkTypeGrid() {
        gridWorkType.getStore().getProxy().extraParams = {
            code: searchCode.getValue(),
            name: searchName.getValue(),
        };
        gridWorkType.getStore().loadPage(1, {
            callback: function (records, operation, success) {
                storeRedirectIfNotAuthen(operation);
            }
        });
    }
    
    function choosegrpEngineer(record){
        grpEngineerName.setValue(record.get('name'));
        grpEngineerId.setValue(record.get('id'));
    }
</script>