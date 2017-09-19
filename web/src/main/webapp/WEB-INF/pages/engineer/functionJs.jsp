<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var selectedSystem = null;
    var engParentNode = 0;

    function updateLayOut() {
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridId').setWidth(Ext.getCmp("searchform").getWidth());
        Ext.getCmp('gridId').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 110);
        Ext.getCmp("gridId").updateLayout();
        tree.setHeight(Ext.getCmp("gridId").getHeight()-5);
    }

    function loadWorkOrder(engineerId) {
        var prEng = null;
        if (engineerId) {
            prEng = engineerId;
        } else {
            if (selectedSystem) {
                prEng = selectedSystem.get("id");
            }
        }
        mygrid.getStore().getProxy().extraParams = {
            engineerId: prEng,
            code: searchCode.getValue(),
            name: searchName.getValue(),
        };
        mygrid.getStore().loadPage(1, {
            callback: function (records, operation, success) {
                storeRedirectIfNotAuthen(operation);
            }
        });
    }

    function addEngineer(data) {
        engneerForm.reset();
        engneerCode.setReadOnly(false);
        if (data != null) {
            console.log(data);
            engneerParentId.setValue(data.get("id"));
            engneerParentName.setValue(data.get("name"));
            engneerParentCode.setValue(data.get("completeCode"));
        }

        engneerWindow.setTitle('<fmt:message key="grpEngineer.add"/>');
        engneerWindow.show();
    }

    function editEngineer(data) {
        engneerForm.reset();
        engneerId.setValue(data.get("id"));
        engneerParentId.setValue(data.get("parentId"));
        engneerParentName.setValue(data.get("parentName"));
        engneerParentCode.setValue(data.get("completeParentCode"));
        engneerName.setValue(data.get("name"));
        engneerDes.setValue(data.get("description"));
        engneerCode.setValue(data.get("code"));
        engneerFullCode.setValue(data.get("completeCode"));
        engneerCost.setValue(data.get("cost"));
        //Set reaonly for edit
        engneerCode.setReadOnly(true);
        Ext.getCmp("btnEngneerParent").hide();

        engneerWindow.setTitle('<fmt:message key="grpEngineer.edit"/>');
        engneerWindow.show();
    }

    function generateFullCode() {
        if (engneerParentCode.getValue() != "") {
            engneerFullCode.setValue(engneerParentCode.getValue() + "." + engneerCode.getValue());
        } else {
            engneerFullCode.setValue(engneerCode.getValue());
        }
    }

    function deleteEngineer(arrayList) {
        maskTarget(tree);
        Ext.Ajax.request({
            url: '../grpEngineer/delete?' + arrayList,
            method: "POST",
            timeout: 10000,
            success: function (result, request) {
                unMaskTarget();
                jsonData = Ext.decode(result.responseText);
                if (jsonData.success == true) {
                    alertSuccess(jsonData.message);
                    reloadTreeEng();
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
    function saveEngineer() {
        var valid = engneerForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        mask();
        Ext.Ajax.request({
            url: "/grpEngineer/save",
            method: "POST",
            params: {
                id: engneerId.getValue(),
                parent: engneerParentId.getValue(),
                code: engneerCode.getValue(),
                completeCode: engneerFullCode.getValue(),
                name: engneerName.getValue(),
                description: engneerDes.getValue(),
                cost: engneerCost.getValue(),
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    engneerCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    alertSuccess(res.message);
                    engneerWindow.hide();
                    reloadTreeEng();
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

    function reloadTreeEng() {
        var path = storeEngineer.findNode("id", engParentNode, true, true, true).getPath();
        storeEngineer.load({
            callback: function (r, options, success) {
                tree.expandPath(path);
            }
        });
    }
</script>