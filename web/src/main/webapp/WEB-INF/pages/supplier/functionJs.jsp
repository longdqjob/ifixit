<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function updateLayOut() {
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridId').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 120);
        Ext.getCmp("gridId").updateLayout();
    }

    function addSupplier() {
        supplierForm.reset();
        supplierWindow.setTitle('<fmt:message key="supplier.add"/>');
        supplierWindow.show();
        supplierCode.focus();
    }

    function editSupplier(data) {
        supplierForm.reset();
        supplierId.setValue(data.get("id"));
        supplierCode.setValue(data.get("code"));
        supplierName.setValue(data.get("name"));
        supplierContact.setValue(data.get("contact"));
        supplierPhone.setValue(data.get("phone"));

        supplierWindow.setTitle('<fmt:message key="supplier.edit"/>');
        supplierWindow.show();
        supplierCode.focus();
    }

    function deleteSupplier(arrayList) {
        var showMask = new Ext.LoadMask({
            msg: '<fmt:message key="loading"/>',
            target: Ext.getCmp('gridId')
        });
        showMask.show();
        Ext.Ajax.request({
            url: '../supplier/delete?' + arrayList,
            method: "GET",
            timeout: 10000,
            success: function (result, request) {
                showMask.hide();
                jsonData = Ext.decode(result.responseText);
                if (jsonData.success == true) {
                    alertSuccess(jsonData.message);
                    searchGrid();
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
        var valid = supplierForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        mask();
        Ext.Ajax.request({
            url: "/supplier/save",
            method: "POST",
            params: {
                id: supplierId.getValue(),
                code: supplierCode.getValue(),
                name: supplierName.getValue(),
                contact: supplierContact.getValue(),
                phone: supplierPhone.getValue(),
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    supplierCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    supplierWindow.hide();
                    var scrollPosition = mygrid.getEl().down('.x-grid-view').getScroll();
                    alertSuccess(res.message);
                    searchGrid();
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
                alertSystemError();
                unmask();
            },
        });
    }

    function searchGrid() {
        mygrid.getStore().getProxy().extraParams = {
            code: searchCode.getValue(),
            name: searchName.getValue(),
            contact: searchContact.getValue(),
            phone: searchPhone.getValue(),
        };
        mygrid.getStore().loadPage(1);
    }
</script>