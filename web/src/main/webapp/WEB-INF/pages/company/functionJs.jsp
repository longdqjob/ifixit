<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var selectedSystem = null;

    function updateLayOut() {
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridId').setWidth(Ext.getCmp("searchform").getWidth());
        Ext.getCmp('gridId').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 110);
        Ext.getCmp("gridId").updateLayout();
    }

    function loadMachine(system) {
        if (!system) {
            system = (selectedSystem != null) ? selectedSystem.get("id") : -10;
        }
        mygrid.getStore().getProxy().extraParams = {
            system: system,
            code: searchCode.getValue(),
            name: searchName.getValue(),
        };
        mygrid.getStore().loadPage(1);
    }

    function resetForm(callback) {
        mask();
        Ext.Ajax.request({
            url: "/company/getAllCompany",
            method: "GET",
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                companyParentStore.loadData(res.list);
                if (isFunction(callback)) {
                    callback();
                }
            },
            failure: function (response, opts) {
                alertSystemError();
                unmask();
            },
        });
    }

    function addCompany(data) {
//        resetForm(function () {
//            companyForm.reset();
//            if (parentId != null) {
//                companyParent.setValue(parentId);
//            }
//        });
        companyForm.reset();
        if (data != null) {
            companyParentId.setValue(data.get("id"));
            companyParentName.setValue(data.get("name"));
        }
        companyWindow.setTitle('<fmt:message key="addCompany"/>');
        companyWindow.setIconCls("add-cls");
        enableCode();
        companyWindow.show();
        companyParent.focus();
    }

    function editCompany(data) {
        companyForm.reset();
        companyId.setValue(data.get("id"));
        companyParentId.setValue(data.get("parent_id"));
        companyParentName.setValue(data.get("parentName"));
        companyParentCode.setValue(data.get("completeParentCode"));

        companyName.setValue(data.get("name"));
        companyCode.setValue(data.get("code"));
        companyFullCode.setValue(data.get("completeCode"));
        companyDescription.setValue(data.get("description"));

        disableCode();

        companyWindow.setTitle('<fmt:message key="editCompany"/>');
        companyWindow.setIconCls("edit-cls");
        companyWindow.show();
        companyParent.focus();
    }
    function enableCode() {
        companyCode.setReadOnly(false);
        companyFullCode.setReadOnly(false);
    }
    function disableCode() {
        companyCode.setReadOnly(true);
        companyFullCode.setReadOnly(true);
    }

    function deleteCompany(arrayList) {
        var showMask = new Ext.LoadMask({
            msg: '<fmt:message key="loading"/>',
            target: Ext.getCmp('gridId')
        });
        showMask.show();
        Ext.Ajax.request({
            url: '../company/deleteCompany?' + arrayList,
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
    function saveForm() {
        var valid = companyForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        if (companyParentId.getValue() == null || companyParentId.getValue() === "") {
            companyParentName.reset();
            companyParentName.setActiveError("This field is required!");
            companyTreeWindow.show();
            return false;
        }

        mask();
        Ext.Ajax.request({
            url: "/company/saveCompany",
            method: "POST",
            params: {
                id: companyId.getValue(),
                parent: companyParentId.getValue(),
                code: companyFullCode.getValue(),
                name: companyName.getValue(),
                description: companyDescription.getValue(),
                completeCode: companyFullCode.getValue()
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    companyCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    companyWindow.hide();
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

    function chooseCompany(record) {
        Ext.getCmp('companyParentName').setValue(record.get('name'));
        Ext.getCmp('companyParentId').setValue(record.get('id'));
        alert(record.get('completeParentCode'));
     //   Ext.getCmp('companyParentCode').setValue(record.get('completeParentCode'));


        Ext.getCmp('systemName').setValue(record.get('name'));
        Ext.getCmp('systemId').setValue(record.get('id'));
    }
</script>