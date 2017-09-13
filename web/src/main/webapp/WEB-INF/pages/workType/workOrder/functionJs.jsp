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
        workOrderForm.reset();
        workOrderWindow.setTitle('<fmt:message key="work.edit"/>');
        
        mechanicName.setValue(data.get('machineName'));
        mechanicId.setValue(data.get('machineId'));
        wWorkTypeName.setValue(data.get('workTypeName'));
        wWorkTypeId.setValue(data.get('workTypeId'));
        
        workOrderCode.setValue(data.get('code'));
        workOrderName.setValue(data.get('name'));
        
        Ext.getCmp("startTime").setValue(new Date(data.get('startTime')));
        Ext.getCmp("endTime").setValue(new Date(data.get('endTime')));
        
        workOrderWindow.show();
        gridManHrs.setHeight(workOrderForm.getHeight() - mechanic.getHeight() - workType.getHeight() - 50);
    }

    function chooseMechanic(record) {
        mechanicName.setValue(record.get('name'));
        mechanicId.setValue(record.get('id'));
    }

    function loadHistory(id) {
        gridHis.getStore().getProxy().extraParams = {
            id: id,
        };
        gridHis.getStore().loadPage(1);
    }


    function saveWorkOrder() {
        var valid = workOrderForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
//            if (mechanicTypeId.getValue() == null || mechanicTypeId.getValue() === "") {
//                mechanicTypeName.reset();
//                mechanicTypeName.setActiveError('<fmt:message key="message.required"/>');
//                return false;
//            }

//            if (!machineNote.isValid()) {
//                Ext.getCmp("tabMechanic").setActiveTab(Ext.getCmp("machineNotes"));
//            }
            return false;
        }

        maskTarget(workOrderWindow);
        Ext.Ajax.request({
            url: "/workOrder/save",
            method: "POST",
            params: {
                id: workOrderId.getValue(),
                mechanicId: mechanicId.getValue(),
                workTypeId: wWorkTypeId.getValue(),
                code: workOrderCode.getValue(),
                name: workOrderName.getValue(),
                startTime: Ext.getCmp("startTime").getRawValue(),
                endTime: Ext.getCmp("endTime").getRawValue(),
                note: "",
            },
            success: function (response) {
                unMaskTarget();
                var res = JSON.parse(response.responseText);
                if ("codeExisted" == res.success) {
                    alertError(res.message);
                    workOrderCode.setActiveError(res.message);
                } else if ("true" == res.success || true === res.success) {
                    workOrderWindow.hide();
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