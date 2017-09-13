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
        workOrderRepeat.setValue(data.get('repeat'));
        Ext.getCmp("startTime").setValue(new Date(data.get('startTime')));
        Ext.getCmp("endTime").setValue(new Date(data.get('endTime')));
        workOrderWindow.show();
        loadInfo(data.get('id'));
    }

    function chooseMechanic(record) {
        mechanicName.setValue(record.get('name'));
        mechanicId.setValue(record.get('id'));
    }

    function choosegrpEngineer(record) {
        console.log(record);
        grpEngineerName.setValue(record.get('name'));
        grpEngineerId.setValue(record.get('id'));

        mhfrmCost.setValue(record.get('cost'));
        mhGrpEngineerName.setValue(record.get('name'));
        mhGrpEngineerId.setValue(record.get('id'));
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

    function getListManHrs() {
        var data = [];
        storeManHrs.each(function (rec) {
            if (rec.get("id") != "") {
                data.push({
                    id: rec.get("id"),
                    workOrderId: rec.get("workOrderId"),
                    groupEngineerId: rec.get("engineerId"),
                    mh: rec.get("mh"),
                });
            } else {
                data.push({
                    id: 0,
                    workOrderId: rec.get("workOrderId"),
                    groupEngineerId: rec.get("engineerId"),
                    mh: rec.get("mh"),
                });
            }
        });
        return data;
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
                task: workTypeTask.getValue(),
                reason: workTypeReason.getValue(),
                note: workTypeNote.getValue(),
                manHrs: Ext.encode(getListManHrs())
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
    ////--------ManHrs------------------
    function changeHrs(oldValue, newValue) {
        mhfrmTotalCost.setValue(mhManHrs.getValue() * mhfrmCost.getValue());
    }
    function showManHrs(data) {
        manHrsForm.reset();
        if (data !== null) {
            manHrsId.setValue(data.get("id"));
            mhGrpEngineerId.setValue(data.get("engineerId"));
            mhGrpEngineerName.setValue(data.get("engineerGrp"));
            mhfrmCost.setValue(data.get("engineerCost"));
            mhManHrs.setValue(data.get("mh"));
            manHrsWindow.setTitle('<fmt:message key="mh.edit"/>');
        } else {
            manHrsWindow.setTitle('<fmt:message key="mh.add"/>');
        }
        manHrsWindow.show();
    }

    function saveManHrs() {
        manHrsWindow.hide();
    }

    function deleteManHrs(params) {
    }

    // --------------------------STOCK----------------------------
    function chooseMaterial(record) {
        stockMateId.setValue(record.get("id"));
        stockMateName.setValue(record.get("name"));
        stockUnit.setValue(record.get("unit"));
        stockUnitCost.setValue(record.get("cost"));
    }

    function showStockForm(data) {
        stockForm.reset();
        if (data !== null) {
            stockWindow.setTitle('<fmt:message key="material.edit"/>');
        } else {
            stockWindow.setTitle('<fmt:message key="material.add"/>');
        }
        stockWindow.show();
    }

    function saveStock() {
        stockWindow.hide();
    }

    function deleteStock(params) {
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

</script>