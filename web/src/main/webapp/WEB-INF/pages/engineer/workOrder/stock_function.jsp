<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var qtyOfMat = 0;
    function getListStock() {
        var data = [];
        storeStock.each(function (rec) {
            if (rec.get("id") != "") {
                data.push({
                    id: rec.get("id"),
                    materialId: rec.get("materialId"),
                    quantity: rec.get("quantity"),
                });
            } else {
                data.push({
                    id: 0,
                    materialId: rec.get("materialId"),
                    quantity: rec.get("quantity"),
                });
            }
        });
        return data;
    }

    // --------------------------STOCK----------------------------
    function chooseMaterial(record) {
        stockMateId.setValue(record.get("id"));
        stockMateName.setValue(record.get("name"));
        stockUnit.setValue(record.get("unit"));
        stockUnitCost.setValue(record.get("cost"));
        qtyOfMat = record.get("quantity");
        materialCode = record.get("completeCode");
        materialDesc = record.get("description");
    }

    //Return true neu vuot qua
    function checkOverQty() {
        var ttQty = 0;
        storeStock.each(function (rec) {
            if (stockMateId.getValue() == rec.get("materialId")) {
                ttQty += parseInt(rec.get('quantity'));
            }
        });
        ttQty += parseInt(stockQty.getValue());
        return (qtyOfMat < ttQty);
    }

    function calcQty() {
        if (stockQty.getValue() != "" && stockUnitCost.getValue() != "") {
            stockTotalCost.setValue(stockQty.getValue() * stockUnitCost.getValue());
        } else {
            stockTotalCost.reset();
        }
    }

    function showStockForm(data) {
        qtyOfMat = 0;
        materialCode = "";
        materialDesc = "";
        stockForm.reset();
        if (data !== null) {
            stockWindow.setTitle('<fmt:message key="material.edit"/>');
            materialCode = data.get("materialCode");
            materialDesc = data.get("materialDesc");
            stockItemId.setValue(data.get("id"));
            stockMateId.setValue(data.get("materialId"));
            stockMateName.setValue(data.get("materialName"));
            stockQty.setValue(data.get("quantity"));
            stockUnit.setValue(data.get("materialUnit"));
            stockUnitCost.setValue(data.get("materialCost"));
            qtyOfMat = data.get("materialQty");
            calcQty();
        } else {
            stockWindow.setTitle('<fmt:message key="material.add"/>');
        }
        stockWindow.show();
    }

    function sumStockCost() {
        var totalcost = 0;
        storeStock.each(function (rec) {
            totalcost += ((parseFloat(rec.get('quantity'))) * parseFloat(rec.get('materialCost')));
        });
        materialTotalCost.setValue(totalcost);
    }

    var idStockStore = -1;
    function getStockFromFrm() {
        idStockStore--;
        return  {
            id: idStockStore,
            workOrderId: 0,
            materialId: stockMateId.getValue(),
            materialCode: materialCode,
            materialName: stockMateName.getValue(),
            materialDesc: materialDesc,
            materialUnit: stockUnit.getValue(),
            materialCost: stockUnitCost.getValue(),
            quantity: stockQty.getValue(),
            materialTotalCost: parseFloat(stockUnitCost.getValue()) * parseFloat(stockQty.getValue()),
        };
    }

    function saveStock() {
        var valid = stockForm.query("field{isValid()==false}");
        if (!valid || valid.length > 0) {
            return false;
        }
//        if (parseInt(stockQty.getValue()) > parseInt(stockMatQty.getValue())) {
//            alertError('<fmt:message key="errors.wo.quantity.greater"/>' + stockMatQty.getValue());
//            stockQty.setActiveError(res.message);
//            return false;
//        }
//        if (checkOverQty()) {
//            alertError('<fmt:message key="overQty"/>');
//            stockQty.setActiveError('<fmt:message key="overQty"/>');
//            return false;
//        }
        if (stockItemId.getValue() != "" && stockItemId.getValue() != "0") {
            var index = storeStock.findExact("id", parseInt(stockItemId.getValue()));
            if (index > -1) {
                var rec = storeStock.getAt(index);
                rec.set("materialId", parseInt(stockMateId.getValue()));
                rec.set("materialCode", materialCode);
                rec.set("materialName", parseInt(stockMateName.getValue()));
                rec.set("materialDesc", materialDesc);
                rec.set("materialUnit", stockUnit.getValue());
                rec.set("materialCost", stockUnitCost.getValue());
                rec.set("quantity", stockQty.getValue());
                rec.set("materialTotalCost", parseFloat(stockUnitCost.getValue()) * parseFloat(stockQty.getValue()));
                rec.dirty = true;
                try {
                    storeStock.sync();
                } catch (c) {
                    console.log(c);
                }
            } else {
                storeStock.add(getStockFromFrm());
            }
        } else {
            storeStock.add(getStockFromFrm());
        }
        gridStock.getView().refresh();
        sumStockCost();
        stockWindow.hide();
    }

    function deleteStock(rowIndex, id, params) {
        maskTarget(Ext.getCmp('gridStock'));
        if (id > 0) {
            Ext.Ajax.request({
                url: '../workOrder/deleteStock?' + params,
                method: "POST",
                timeout: 10000,
                success: function (result, request) {
                    unMaskTarget();
                    jsonData = Ext.decode(result.responseText);
                    if (jsonData.success == true) {
                        alertSuccess(jsonData.message);
                        try {
                            storeStock.removeAt(rowIndex);
                            gridStock.getView().refresh();
                            sumStockCost();
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
                    redirectIfNotAuthen(response);
                    unMaskTarget();
                    alertSystemError();
                }
            });
        } else {
            try {
                storeStock.removeAt(rowIndex);
                gridStock.getView().refresh();
                sumStockCost();
                alertSuccess('<fmt:message key="deleteSuccess"/>');
            } catch (c) {
                console.log(c);
                alertSystemError();
            }
            unMaskTarget();
        }
    }


    function saveChangeStock(id, quantity, callbackSuccess, callbackFail) {
        maskTarget(Ext.getCmp("gridStock"));
        Ext.Ajax.request({
            url: "../workOrder/saveChangeStock",
            method: "POST",
            params: {
                id: id,
                quantity: quantity,
            },
            success: function (response) {
                unMaskTarget();
                console.log("---------success:---------");
                var res = JSON.parse(response.responseText);
                if ("true" == res.success || true === res.success) {
                    alertSuccess(res.message);
                    if (isFunction(callbackSuccess)) {
                        callbackSuccess();
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
                redirectIfNotAuthen(response);
                alertSystemError();
                unMaskTarget();
                if (isFunction(callbackFail)) {
                    console.log("---------callbackFail---------");
                    callbackFail();
                }
            },
        });
    }
</script>