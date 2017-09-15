<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
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
        materialCode = record.get("completeCode");
        materialDesc = record.get("description");
        calcQty();
    }

    function calcQty() {
        if (stockQty.getValue() != "" && stockUnitCost.getValue() != "") {
            stockTotalCost.setValue(stockQty.getValue() * stockUnitCost.getValue());
        }
    }

    function showStockForm(data) {
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
            calcQty();
        } else {
            stockWindow.setTitle('<fmt:message key="material.add"/>');
        }
        stockWindow.show();
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
        };
    }

    function saveStock() {
        if (stockItemId.getValue() != "" && stockItemId.getValue() != "0") {
            var index = storeStock.findExact("id", parseInt(stockItemId.getValue()));
            if (index > -1) {
                var rec = storeStock.getAt(index);
                rec.set("materialId", parseInt(stockMateId.getValue()));
                rec.set("materialCode", materialCode);
                rec.set("materialName", parseInt(stockMateName.getValue()));
                rec.set("materialDesc", materialDesc);
                rec.set("materialUnit", stockUnit.getValue());
                rec.set("materialCost:", stockUnitCost.getValue());
                rec.set("quantity", stockQty.getValue());
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
                storeStock.removeAt(rowIndex);
                alertSuccess('<fmt:message key="deleteSuccess"/>');
            } catch (c) {
                console.log(c);
                alertSystemError();
            }
            unMaskTarget();
        }
    }

</script>