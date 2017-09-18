<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var selectedSystem = null;

    function updateLayOut() {
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridId').setWidth(Ext.getCmp("searchform").getWidth());
        Ext.getCmp('gridId').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 110);
        Ext.getCmp("gridId").updateLayout();
        tree.setHeight(Ext.getCmp("gridId").getHeight() - 30);
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
        mygrid.getStore().loadPage(1, {
            callback: function (records, operation, success) {
                storeRedirectIfNotAuthen(operation);
            }
        });
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
                redirectIfNotAuthen(response);
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
            companyParentCode.setValue(data.get("completeCode"));
            //alert(data.get("completeParentCode"));
        }
        companyWindow.setTitle('<fmt:message key="addCompany"/>');
        companyWindow.setIconCls("add-cls");
        companyCode.setReadOnly(false);
        companyWindow.show();
        companyCode.focus();
    }

    function editCompany(data) {
        console.log(data);
        console.log(data.get("parentId"));

        companyForm.reset();
        companyId.setValue(data.get("id"));
        companyParentId.setValue(data.get("parentId"));
        companyParentName.setValue(data.get("parentName"));
        companyParentCode.setValue(data.get("completeParentCode"));

        companyName.setValue(data.get("name"));
        companyCode.setValue(data.get("code"));
        companyFullCode.setValue(data.get("completeCode"));
        companyDescription.setValue(data.get("description"));

        companyCode.setReadOnly(true);

        companyWindow.setTitle('<fmt:message key="editCompany"/>');
        companyWindow.setIconCls("edit-cls");
        companyWindow.show();
        companyName.focus();
    }
//    function enableCode() {
//        companyCode.setReadOnly(false);
//    }
//    function disableCode() {
//        companyCode.setReadOnly(true);
//    }

    function deleteCompany(arrayList) {
        var showMask = new Ext.LoadMask({
            msg: '<fmt:message key="loading"/>',
            target: Ext.getCmp('gridId')
        });
        showMask.show();
        //find record will be delete, then find the parent
        record = store.findNode("id", arrayList, true, true, true);
        parentId = record.get("parentId");
        Ext.Ajax.request({
            url: '../company/deleteCompany?&ids=' + arrayList,
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
                //TODO reload store
//                store.reload();
                console.log(parentId);
                var path = store.findNode("id", parentId, true, true, true).getPath();
                console.log(path);
                store.load({
                    callback: function (r, options, success) {
                        tree.expandPath(path);
                    }
                });

            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
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

//        if (companyParentId.getValue() == null || companyParentId.getValue() === "") {
//            companyParentName.reset();
//            companyParentName.setActiveError("This field is required!");
//            companyTreeWindow.show();
//            return false;
//        }

        mask();
        Ext.Ajax.request({
            url: "/company/saveCompany",
            method: "POST",
            params: {
                id: companyId.getValue(),
                parent: companyParentId.getValue(),
                code: companyCode.getValue(),
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
                    if (res.message || res.message == "true") {
                        alertError(res.message);
                    } else {
                        alertSystemError();
                    }
                }

//                var path = store.findNode("id", companyId.getValue(), true, true, true).getPath();
                var path = store.findNode("id", companyParentId.getValue(), true, true, true).getPath();
                console.log(path);
                store.load({
                    callback: function (r, options, success) {
                        tree.expandPath(path);
                    }
                });

            },
            failure: function (response, opts) {
                redirectIfNotAuthen(response);
                alertSystemError();
                unmask();
            },
        });
    }


    function chooseCompany(record) {
        Ext.getCmp('companyParentName').setValue(record.get('name'));
        Ext.getCmp('companyParentId').setValue(record.get('id'));
        console.log(record.get("completeCode"));
        companyParentCode.setValue(record.get('completeCode'));


        Ext.getCmp('systemName').setValue(record.get('name'));
        Ext.getCmp('systemId').setValue(record.get('id'));
    }
</script>