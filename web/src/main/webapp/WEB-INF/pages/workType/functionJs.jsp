<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var selectedSystem = -10;

    function updateLayOut() {
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridId').setWidth(Ext.getCmp("searchform").getWidth());
        Ext.getCmp('gridId').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 110);
        Ext.getCmp("gridId").updateLayout();
    }

    function loadWorkOrder(system) {
        if (!system) {
            system = selectedSystem;
        }
        mygrid.getStore().getProxy().extraParams = {
            system: system,
            code: searchCode.getValue(),
            name: searchName.getValue(),
        };
        mygrid.getStore().loadPage(1);
    }

    function testAjax() {
        Ext.Ajax.request({
            url: '../workOrder/loadData?id=1',
            method: "POST",
            timeout: 10000,
            success: function (result, request) {
                console.log("-----------success");
            },
            failure: function (response, opts) {
                console.log("-----------failure");
                console.log(response);
                alertSystemError();
            }
        });
    }

    function addWorkType(data) {
        workTypeForm.reset();
        if (data != null) {
            workTypeParentId.setValue(data.get("id"));
            workTypeParentName.setValue(data.get("name"));
        }
        workTypeWindow.setTitle('<fmt:message key="workType.add"/>');
        workTypeWindow.show();
    }

    function editWorkType(data) {
        workTypeForm.reset();
        workTypeId.setValue(data.get("id"));
        workTypeParentId.setValue(data.get("parent_id"));
        workTypeParentName.setValue(data.get("parent_name"));
        workTypeName.setValue(data.get("name"));
        workTypeCode.setValue(data.get("code"));
        workTypeFullCode.setValue(data.get("code"));
        workTypeWindow.setTitle('<fmt:message key="workType.add"/>');
        workTypeWindow.show();
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
    function saveWorkType() {
        var valid = workTypeForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        if (workTypeParentId.getValue() == null || workTypeParentId.getValue() === "") {
            workTypeParentName.reset();
            workTypeParentName.setActiveError("This field is required!");
            return false;
        }

        mask();
        Ext.Ajax.request({
            url: "/workType/save",
            method: "POST",
            params: {
                id: workTypeId.getValue(),
                parent: workTypeParentId.getValue(),
                code: workTypeFullCode.getValue(),
                name: workTypeName.getValue(),
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    companyCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    workTypeWindow.hide();
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
                unmask();
            },
        });
    }

    function chooseWorkType(record) {
        workTypeParentName.setValue(record.get('name'));
        workTypeParentId.setValue(record.get('id'));
        wWorkTypeName.setValue(record.get('name'));
        wWorkTypeId.setValue(record.get('id'));
    }
</script>