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

    function choosegrpEngineer(record) {
        engneerParentName.setValue(record.get('name'));
        engneerParentId.setValue(record.get('id'));

        grpEngineerName.setValue(record.get('name'));
        grpEngineerId.setValue(record.get('id'));

        mhfrmCost.setValue(record.get('cost'));
        mhGrpEngineerName.setValue(record.get('name'));
        mhGrpEngineerId.setValue(record.get('id'));

        generateFullCode();
    }

    function getListManHrs() {
        var data = [];
        storeManHrs.each(function (rec) {
            if (rec.get("id") != "") {
                data.push({
                    id: rec.get("id"),
                    groupEngineerId: rec.get("engineerId"),
                    mh: rec.get("mh"),
                });
            } else {
                data.push({
                    id: 0,
                    groupEngineerId: rec.get("engineerId"),
                    mh: rec.get("mh"),
                });
            }
        });
        return data;
    }

    ////--------ManHrs------------------
    function changeHrs(oldValue, newValue) {
        if (mhManHrs.getValue() != "" && mhfrmCost.getValue() != "") {
            mhfrmTotalCost.setValue(mhManHrs.getValue() * mhfrmCost.getValue());
        }
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

    var idMHsStore = -1;
    function getManHrsFromFrm() {
        idMHsStore--;
        return  {
            id: idMHsStore,
            workOrderId: 1,
            engineerId: mhGrpEngineerId.getValue(),
            engineerGrp: mhGrpEngineerName.getValue(),
            engineerCost: mhfrmCost.getValue(),
            totalCost: mhfrmTotalCost.getValue(),
            mh: mhManHrs.getValue(),
        };
    }
    function sumMhs() {
        var totalmhs = 0;
        var totalcost = 0;
        storeManHrs.each(function (rec) {
            totalmhs += parseFloat(rec.get('mh'));
            totalcost += ((parseFloat(rec.get('mh'))) * parseFloat(rec.get('engineerCost')));
        });
        manHrsTotalMh.setValue(totalmhs);
        manHrsTotalCost.setValue(totalcost);
    }
    function saveManHrs() {
        var valid = manHrsForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }
        if (manHrsId.getValue() != "" && manHrsId.getValue() != "0") {
            var index = storeManHrs.findExact("id", parseInt(manHrsId.getValue()));
            if (index > -1) {
                var rec = storeManHrs.getAt(index);
                rec.set("engineerId", parseInt(mhGrpEngineerId.getValue()));
                rec.set("engineerGrp", mhGrpEngineerName.getValue());
                rec.set("mh", parseFloat(mhManHrs.getValue()));
                rec.set("engineerCost", parseFloat(mhfrmCost.getValue()));
                rec.set("totalCost", parseFloat(mhManHrs.getValue()) * parseFloat(mhfrmCost.getValue()));
                rec.dirty = true;
            } else {
                storeManHrs.insert(0, getManHrsFromFrm());
            }
        } else {
            storeManHrs.insert(0, getManHrsFromFrm());
        }
        try {
            storeManHrs.sync();
        } catch (c) {
            console.log(c);
        }
        sumMhs();
        manHrsWindow.hide();
    }

    function deleteManHrs(rowIndex, id, params) {
        maskTarget(Ext.getCmp('gridManHrs'));
        if (id > 0) {
            Ext.Ajax.request({
                url: '../workOrder/deleteManHour?' + params,
                method: "POST",
                timeout: 10000,
                success: function (result, request) {
                    unMaskTarget();
                    jsonData = Ext.decode(result.responseText);
                    if (jsonData.success == true) {
                        alertSuccess(jsonData.message);
                        try {
                            storeManHrs.removeAt(rowIndex);
                        } catch (c) {
                            console.log(c);
                        }
                    } else {
                        if (jsonData.message) {
                            alertError(jsonData.message);
                        } else {
                            alertSystemError();
                        }
                    }
                },
                failure: function (response, opts) {
                    unMaskTarget();
                    alertSystemError();
                }
            });
        } else {
            try {
                storeManHrs.removeAt(rowIndex);
                alertSuccess('<fmt:message key="deleteSuccess"/>');
            } catch (c) {
                console.log(c);
                alertSystemError();
            }
            unMaskTarget();
        }
        sumMhs();
    }
    
    
    function saveChangeMh(id, mh, callbackSuccess, callbackFail) {
        maskTarget(Ext.getCmp("gridManHrs"));
        Ext.Ajax.request({
            url: "../workOrder/saveChangeMh",
            method: "POST",
            params: {
                id: id,
                mh: mh,
            },
            success: function (response) {
                unMaskTarget();
                console.log("---------success:---------");
                var res = JSON.parse(response.responseText);
                if ("true" == res.success || true === res.success) {
                    alertSuccess(res.message);
                    if (isFunction(callbackSuccess)) {
                        console.log("---------callbackSuccess---------");
                        callbackSuccess();
                        sumMhs();
                    }
                } else {
                    if (res.message || res.message == "true") {
                        alertError(res.message);
                    } else {
                        alertSystemError();
                    }
                    if (isFunction(callbackFail)) {
                        console.log("---------callbackFail---------");
                        callbackFail();
                    }
                }
            },
            failure: function (response, opts) {
                alertSystemError();
                unMaskTarget();
                console.log("---------response---------");
                if (isFunction(callbackFail)) {
                    console.log("---------callbackFail---------");
                    callbackFail();
                }
            },
        });
    }
</script>