<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function changeCode(oldValue, newValue) {
        if (mechanicTypeCode.getValue() != "") {
            Ext.getCmp("mechanicFullCode").setText('<fmt:message key="machine.fullCode"/>: ' + mechanicTypeCode.getValue() + "." + newValue);
            mechanicCompleteCode.setValue(mechanicTypeCode.getValue() + "." + newValue)
        } else {
            Ext.getCmp("mechanicFullCode").setText('<fmt:message key="machine.fullCode"/>: ' + newValue);
            mechanicCompleteCode.setValue(newValue)
        }
        
        

    }
    //--------------------------------Mechanic----------------------------------
    function addWorkOrder(data) {
        workOrderForm.reset();
        workOrderWindow.setTitle('<fmt:message key="work.add"/>');
        workOrderWindow.show();
        gridManHrs.setHeight(workOrderForm.getHeight() - mechanic.getHeight() - workType.getHeight() - 50);
    }

    function editWorkOrder(data) {
        resetLabelSpec();
        workOrderForm.reset();
        workOrderWindow.setTitle('<fmt:message key="work.edit"/>');
        workOrderWindow.show();
        gridManHrs.setHeight(workOrderForm.getHeight() - mechanic.getHeight() - workType.getHeight() - 50);
    }

    function chooseMechanicType(record) {
        maskTarget(mechanicWindow);
        Ext.getCmp('mechanicTypeName').setValue(record.get('name'));
        Ext.getCmp('mechanicTypeId').setValue(record.get('id'));
        Ext.getCmp('mechanicTypeCode').setValue(record.get('code'));
        changeCode("", mechanicCode.getValue());
        fillSpecific(record.get('specification'));
        unMaskTarget();
    }

    function chooseMechanic(record) {
        Ext.getCmp('fatherName').setValue(record.get('name'));
        Ext.getCmp('fatherId').setValue(record.get('id'));
    }

    function loadHistory(id) {
        gridHis.getStore().getProxy().extraParams = {
            id: id,
        };
        gridHis.getStore().loadPage(1);
    }


    function saveWorkOrder() {
        var valid = mechanicForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            if (mechanicTypeId.getValue() == null || mechanicTypeId.getValue() === "") {
                mechanicTypeName.reset();
                mechanicTypeName.setActiveError('<fmt:message key="message.required"/>');
                return false;
            }

            if (systemId.getValue() == null || systemId.getValue() === "") {
                Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("indentify"));
                systemName.reset();
                systemName.setActiveError('<fmt:message key="message.required"/>');
                return false;
            }

            if (!machineNote.isValid()) {
                Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("machineNotes"));
            }
            return false;
        }

        if (mechanicTypeId.getValue() == null || mechanicTypeId.getValue() === "") {
            mechanicTypeName.reset();
            mechanicTypeName.setActiveError('<fmt:message key="message.required"/>');
            mechanicTypeWindow.show();
            return false;
        }

        if (systemId.getValue() == null || systemId.getValue() === "") {
            Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("indentify"));
            systemName.reset();
            systemName.setActiveError('<fmt:message key="message.required"/>');
            companyTreeWindow.show();
            return false;
        }

        maskTarget(mechanicWindow);
        Ext.Ajax.request({
            url: "/machine/save",
            method: "POST",
            params: {
                id: mechanicId.getValue(),
                code: mechanicCode.getValue(),
                name: mechanicName.getValue(),
                description: "",
                specification: Ext.encode(createSpecific()),
                parentId: fatherId.getValue(),
                companyId: systemId.getValue(),
                machineTypeId: mechanicTypeId.getValue(),
                note: "",
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    mechanicCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    mechanicWindow.hide();
                    var scrollPosition = mygrid.getEl().down('.x-grid-view').getScroll();
                    alertSuccess(res.message);
                    loadWorkOrder();
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
                unMaskTarget();
            },
        });
    }
    
    function deleteWorkOrder(params) {
    }
</script>