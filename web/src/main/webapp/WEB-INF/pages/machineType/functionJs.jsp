<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function updateLayOut() {
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridId').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 120);
        Ext.getCmp("gridId").updateLayout();
    }

    function add() {
        addForm.reset();
        addWindow.setTitle('<fmt:message key="machineType.add"/>');
        addWindow.show();
        Ext.getCmp("tabSpecification").setActiveTab(Ext.getCmp("specification1"));
        machineTypeCode.focus();
    }

    function edit(data) {
        addForm.reset();
        machineTypeId.setValue(data.get("id"));
        machineTypeCode.setValue(data.get("code"));
        machineTypeName.setValue(data.get("name"));
        machineTypeDescription.setValue(data.get("description"));
        machineTypeNote.setValue(data.get("note"));
        fillSpecific(data.get("specification"));
        addWindow.setTitle('<fmt:message key="machineType.edit"/>');
        addWindow.show();
        Ext.getCmp("tabSpecification").setActiveTab(Ext.getCmp("specification1"));
        machineTypeCode.focus();
    }

    function deleteItem(arrayList) {
        var showMask = new Ext.LoadMask({
            msg: '<fmt:message key="loading"/>',
            target: Ext.getCmp('gridId')
        });
        showMask.show();
        Ext.Ajax.request({
            url: '/machineType/delete?' + arrayList,
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
        createSpecific();
        var valid = addForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }

        mask();
        Ext.Ajax.request({
            url: "/machineType/save",
            method: "POST",
            params: {
                id: machineTypeId.getValue(),
                code: machineTypeCode.getValue(),
                name: machineTypeName.getValue(),
                description: machineTypeDescription.getValue(),
                note: machineTypeNote.getValue(),
                specification: Ext.encode(createSpecific()),
            },
            success: function (response) {
                unmask();
                var res = JSON.parse(response.responseText);
                if ("true" == res.success || true === res.success) {
                    addWindow.hide();
                    var scrollPosition = mygrid.getEl().down('.x-grid-view').getScroll();
                    alertSuccess(res.message);
                    searchGrid();
                    mygrid.getView().getEl().scrollTo('Top', scrollPosition.top, true);
                } else {
                    alertError(res.message);
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
        };
        mygrid.getStore().loadPage(1);
    }

    function generateSpecific(idx) {
        return Ext.create('Ext.form.field.Text', {
            xtype: 'textfield',
            grow: true,
            tabIndex: parseInt(idx) + 4,
            fieldLabel: idx,
            name: 'specification',
            id: "specification_" + idx,
            labelAlign: 'left',
            anchor: '100%',
            allowBlank: true,
            margin: '10 10 10 10',
            width: 350,
            maxLength: 50,
        });
    }

    function fillSpecific(input) {
        if (input != null && input != "") {
            var obj = Ext.decode(input);
            for (var key in obj) {
                if (key) {
                    Ext.getCmp("specification_" + key).setValue(obj[key]);
                }
            }
        }
    }

    function createSpecific() {
        var tmp;
        var rtn = {};
        for (var i = 1; i <= maxSpecification; i++) {
            if (i < 10) {
                tmp = "0" + i;
            } else {
                tmp = "" + i;
            }
            if (Ext.getCmp("specification_" + tmp).getValue() != "") {
                rtn[tmp] = Ext.getCmp("specification_" + tmp).getValue();
            }
        }
        return rtn;
    }
</script>