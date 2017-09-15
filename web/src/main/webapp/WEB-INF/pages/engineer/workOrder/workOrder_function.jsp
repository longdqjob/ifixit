<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    //--------------------------------Mechanic----------------------------------
    function addWorkOrder(data) {
        workOrderForm.reset();
        workOrderWindow.setTitle('<fmt:message key="work.add"/>');
        workOrderWindow.show();
        loadInfo(null);
    }

    function editWorkOrder(data) {
        workOrderForm.reset();
        workOrderWindow.setTitle('<fmt:message key="work.edit"/>');
        workOrderId.setValue(data.get('id'));
        mechanicName.setValue(data.get('machineName'));
        mechanicId.setValue(data.get('machineId'));
        wWorkTypeName.setValue(data.get('workTypeName'));
        wWorkTypeId.setValue(data.get('workTypeId'));
        workOrderCode.setValue(data.get('code'));
        workOrderName.setValue(data.get('name'));
        grpEngineerId.setValue(data.get('grpEngineerId'));
        grpEngineerName.setValue(data.get('grpEngineerName'));
        workOrderStatus.setValue(data.get('status'));
        workOrderInterval.setValue(data.get('interval'));
        workOrderRepeat.setValue((data.get('isRepeat') == "1"));                
        Ext.getCmp("startTime").setValue(new Date(data.get('startTime')));
        Ext.getCmp("endTime").setValue(new Date(data.get('endTime')));
        workOrderTask.setValue(data.get('task')); 
        workOrderReason.setValue(data.get('reason')); 
        workOrderNote.setValue(data.get('note')); 
        workOrderWindow.show();
        loadInfo(data.get('id'));
    }

    function chooseMechanic(record) {
        mechanicName.setValue(record.get('name'));
        mechanicId.setValue(record.get('id'));
    }

    function loadInfo(id) {
        if (id) {
            maskTarget(workOrderWindow);
            Ext.Ajax.request({
                url: "../workOrder/loadInfo",
                method: "POST",
                params: {
                    id: id,
                    start: 0,
                    limit: 5,
                },
                success: function (response) {
                    unMaskTarget();
                    var res = JSON.parse(response.responseText);
                    storeManHrs.loadData(res.listManHrs);
                    gridManHrs.getStore().totalCount = res.totalCountManHrs;
                    gridStock.getStore().loadData(res.listStock);
                    gridStock.getStore().totalCount = res.totalCountStock;
                    loadListManHrs();
                },
                failure: function (response, opts) {
                    alertSystemError();
                    unMaskTarget();
                },
            });
        } else {
            storeManHrs.removeAll();
            gridManHrs.getStore().totalCount = 0;
            gridStock.getStore().removeAll();
            gridStock.getStore().totalCount = 0;
        }
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
            url: "../workOrder/save",
            method: "POST",
            params: {
                id: workOrderId.getValue(),
                mechanicId: mechanicId.getValue(),
                workTypeId: wWorkTypeId.getValue(),
                grpEngineerId: grpEngineerId.getValue(),
                status: workOrderStatus.getValue(),
                code: workOrderCode.getValue(),
                name: workOrderName.getValue(),
                interval: workOrderInterval.getValue(),
                repeat: (workOrderRepeat.getValue()) ? 1 : 0,
                startTime: Ext.getCmp("startTime").getRawValue(),
                endTime: Ext.getCmp("endTime").getRawValue(),
                task: workOrderTask.getValue(),
                reason: workOrderReason.getValue(),
                note: workOrderNote.getValue(),
                manHrs: Ext.encode(getListManHrs()),
                stock: Ext.encode(getListStock())
                
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

    function loadListManHrs() {
        var data = [];
        storeManHrs.each(function (rec) {
            data.push(rec.data);
        });
        storeManHrsPaging.proxy.data = data;
        console.log(data);
        storeManHrsPaging.load();
    }
    
    function chooseWorkType(record) {
        wWorkTypeName.setValue(record.get('name'));
        wWorkTypeId.setValue(record.get('id'));
    }

</script>