package com.cmms.webapp.action;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.GroupEngineerDao;
import com.cmms.dao.MachineDao;
import com.cmms.dao.ManHoursDao;
import com.cmms.dao.MaterialDao;
import com.cmms.dao.StockItemDao;
import com.cmms.dao.WorkOrderDao;
import com.cmms.dao.WorkTypeDao;
import com.cmms.model.GroupEngineer;
import com.cmms.model.Machine;
import com.cmms.model.ManHours;
import com.cmms.model.ManHoursObj;
import com.cmms.model.Material;
import com.cmms.model.StockItem;
import com.cmms.model.StockItemObj;
import com.cmms.model.WorkOrder;
import com.cmms.model.WorkType;
import com.cmms.webapp.security.LoginSuccessHandler;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.cmms.webapp.util.WebUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.opensymphony.xwork2.Preparable;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for MachineAction
 */
public class WorkOrderAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    //<editor-fold defaultstate="collapsed" desc="getAndSet">
    private GroupEngineerDao groupEngineerDao;
    private MachineDao machineDao;
    private WorkTypeDao workTypeDao;
    private WorkOrderDao workOrderDao;
    private CompanyDao companyDao;
    private MaterialDao materialDao;
    private ManHoursDao manHoursDao;
    private StockItemDao stockItemDao;

    public MaterialDao getMaterialDao() {
        return materialDao;
    }

    public void setMaterialDao(MaterialDao materialDao) {
        this.materialDao = materialDao;
    }

    public ManHoursDao getManHoursDao() {
        return manHoursDao;
    }

    public void setManHoursDao(ManHoursDao manHoursDao) {
        this.manHoursDao = manHoursDao;
    }

    public StockItemDao getStockItemDao() {
        return stockItemDao;
    }

    public void setStockItemDao(StockItemDao stockItemDao) {
        this.stockItemDao = stockItemDao;
    }

    public CompanyDao getCompanyDao() {
        return companyDao;
    }

    public void setCompanyDao(CompanyDao companyDao) {
        this.companyDao = companyDao;
    }

    public GroupEngineerDao getGroupEngineerDao() {
        return groupEngineerDao;
    }

    public void setGroupEngineerDao(GroupEngineerDao groupEngineerDao) {
        this.groupEngineerDao = groupEngineerDao;
    }

    public WorkTypeDao getWorkTypeDao() {
        return workTypeDao;
    }

    public void setWorkTypeDao(WorkTypeDao workTypeDao) {
        this.workTypeDao = workTypeDao;
    }

    public WorkOrderDao getWorkOrderDao() {
        return workOrderDao;
    }

    public void setWorkOrderDao(WorkOrderDao workOrderDao) {
        this.workOrderDao = workOrderDao;
    }

    public MachineDao getMachineDao() {
        return machineDao;
    }

    public void setMachineDao(MachineDao machineDao) {
        this.machineDao = machineDao;
    }

    @Override
    public void prepare() throws Exception {
    }//</editor-fold>

    public String index() {
        getGrpEngineerId();
        return SUCCESS;
    }

    //<editor-fold defaultstate="collapsed" desc="getLoadWOHis">
    public InputStream getLoadWOHis() {
        try {
            JSONObject result = new JSONObject();
            String mechanicReq = getRequest().getParameter("mechanicId");
            String sStatusReq = getRequest().getParameter("sStatus");
            List<Integer> listEng = groupEngineerDao.getListChildren(getGrpEngineerId());
            Map pagingMap = workOrderDao.getList(listEng, null, Long.parseLong(mechanicReq), sStatusReq, null, null, start, limit);

            ArrayList<WorkOrder> list = new ArrayList<WorkOrder>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<WorkOrder>) pagingMap.get("list");
            }

            Integer count = 0;
            if (pagingMap.get("count") != null) {
                count = (Integer) pagingMap.get("count");
            }

            JSONArray jSONArray = new JSONArray();
            JSONObject tmp;
            for (WorkOrder workOrder : list) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(workOrder, "workType,machine,groupEngineer");
                jSONArray.put(tmp);
            }

            result.put("list", jSONArray);
            result.put("totalCount", count);
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getLoadData: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getLoadData">
    public InputStream getLoadData() {
        try {
            JSONObject result = new JSONObject();
            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");

            //listWorkType
            String sWorkType = getRequest().getParameter("workType");
            Integer workTypeReq = null;
            if (!StringUtils.isBlank(sWorkType)) {
                workTypeReq = Integer.parseInt(sWorkType);
            }
            List<Integer> listWorkType = null;
            if (workTypeReq != null && workTypeReq > 0) {
                listWorkType.add(workTypeReq);
            }

            //groupEngineerDao
            String engineerIdReq = getRequest().getParameter("engineerId");
            Integer engineerId = null;
            if (!StringUtils.isBlank(engineerIdReq)) {
                engineerId = Integer.parseInt(engineerIdReq);
            }
            List<Integer> listEng;
            if (engineerId == null || engineerId <= 0) {
                engineerId = null;
                if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP) != null) {
                    engineerId = (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_ENGINNER_GRP);
                }
                listEng = getListGrpEngineer();
            } else {
                listEng = groupEngineerDao.getListChildren(engineerId);
            }

            Map pagingMap = workOrderDao.getList(listEng, listWorkType, null, null, code, name, start, limit);

            ArrayList<WorkOrder> list = new ArrayList<WorkOrder>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<WorkOrder>) pagingMap.get("list");
            }

            Integer count = 0;
            if (pagingMap.get("count") != null) {
                count = (Integer) pagingMap.get("count");
            }

            JSONArray jSONArray = new JSONArray();
            JSONObject tmp;
            WorkType workType;
            Machine machine;
            GroupEngineer groupEngineer;
            for (WorkOrder workOrder : list) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(workOrder, "workType,machine,groupEngineer");
                workType = workOrder.getWorkType();
                if (workType != null) {
                    tmp.put("workTypeId", workType.getId());
                    tmp.put("workTypeName", workType.getName());
                } else {
                    tmp.put("workTypeId", "");
                    tmp.put("workTypeName", "");
                }
                machine = workOrder.getMachine();
                if (machine != null) {
                    tmp.put("machineId", machine.getId());
                    tmp.put("machineName", machine.getName());
                } else {
                    tmp.put("machineId", "");
                    tmp.put("machineName", "");
                }
                groupEngineer = workOrder.getGroupEngineer();
                if (groupEngineer != null) {
                    tmp.put("grpEngineerId", groupEngineer.getId());
                    tmp.put("grpEngineerName", groupEngineer.getName());
                } else {
                    tmp.put("grpEngineerId", "");
                    tmp.put("grpEngineerName", "");
                }
                jSONArray.put(tmp);
            }

            result.put("list", jSONArray);
            result.put("totalCount", count);
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getLoadData: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getLoadInfo">
    public InputStream getLoadInfo() {
        try {
            JSONObject result = new JSONObject();
            Long workOrderId = Long.parseLong(getRequest().getParameter("id"));
            //manHoursDao
            Map mapManHours = manHoursDao.getList(workOrderId, start, limit);
            ArrayList<ManHours> listManHrs = new ArrayList<ManHours>();
            if (mapManHours.get("list") != null) {
                listManHrs = (ArrayList<ManHours>) mapManHours.get("list");
            }

            Integer countManHrs = 0;
            if (mapManHours.get("count") != null) {
                countManHrs = (Integer) mapManHours.get("count");
            }

            JSONArray jsArrayManHrs = new JSONArray();
            JSONObject tmp;
            GroupEngineer engineer;
            Float cost;
            for (ManHours manHours : listManHrs) {
                cost = 0F;
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(manHours, "workOrder,groupEngineer");
                engineer = manHours.getGroupEngineer();
                if (engineer != null) {
                    tmp.put("engineerId", engineer.getId());
                    tmp.put("engineerGrp", engineer.getName());
                    tmp.put("engineerCost", engineer.getCost());
                    cost = engineer.getCost();
                } else {
                    tmp.put("engineerId", "");
                    tmp.put("engineerGrp", "");
                    tmp.put("engineerCost", "");
                }
                tmp.put("totalCost", manHours.getMh() * cost);
                tmp.put("workOrderId", workOrderId);
                jsArrayManHrs.put(tmp);
            }
            result.put("listManHrs", jsArrayManHrs);
            result.put("totalCountManHrs", countManHrs);

            //stockItemDao
            Map mapStock = stockItemDao.getList(workOrderId, start, limit);
            ArrayList<StockItem> listStock = new ArrayList<StockItem>();
            if (mapStock.get("list") != null) {
                listStock = (ArrayList<StockItem>) mapStock.get("list");
            }

            Integer countStock = 0;
            if (mapStock.get("count") != null) {
                countStock = (Integer) mapStock.get("count");
            }

            JSONArray jsArrayStock = new JSONArray();
            Material material;
            Float stockTotalCost = 0F;
            for (StockItem item : listStock) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(item, "workOrder,material");
                material = item.getMaterial();
                if (material != null) {
                    tmp.put("materialId", material.getId());
                    tmp.put("materialCode", material.getCode());
                    tmp.put("materialName", material.getName());
                    tmp.put("materialDesc", material.getDescription());
                    tmp.put("materialUnit", material.getUnit());
                    tmp.put("materialCost", material.getCost());
                    tmp.put("materialQty", material.getQuantity());
                    tmp.put("materialTotalCost", material.getCost() * item.getQuantity());
                    stockTotalCost += material.getCost() * item.getQuantity();
                } else {
                    tmp.put("materialId", "");
                    tmp.put("materialCode", "");
                    tmp.put("materialName", "");
                    tmp.put("materialDesc", "");
                    tmp.put("materialUnit", "");
                    tmp.put("materialCost", "");
                    tmp.put("materialQty", 0);
                    tmp.put("materialTotalCost", "0");
                }
                tmp.put("stockTotalCost", stockTotalCost);
                tmp.put("workOrderId", workOrderId);
                jsArrayStock.put(tmp);
            }
            result.put("listStock", jsArrayStock);
            result.put("totalCountStock", countStock);
            //Return
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getLoadInfo: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSave">
    public InputStream getSave() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Long id = null;

            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            String workTypeId = getRequest().getParameter("workTypeId");
            String mechanicId = getRequest().getParameter("mechanicId");
            String grpEngineerId = getRequest().getParameter("grpEngineerId");
            String status = getRequest().getParameter("status");
            String interval = getRequest().getParameter("interval");
            String repeat = getRequest().getParameter("repeat");
            String startTime = getRequest().getParameter("startTime");
            String endTime = getRequest().getParameter("endTime");
            String task = getRequest().getParameter("task");
            String note = getRequest().getParameter("note");
            String reason = getRequest().getParameter("reason");
            List<ManHoursObj> listManHours = null;
            Gson gson = new Gson();

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            Boolean updateQtyMat = false;
            //Check StockItem vuot qua so luong
            String stockReq = getRequest().getParameter("stock");
            List<StockItemObj> listStock = null;
            if (!StringUtils.isBlank(stockReq)) {
                listStock = gson.fromJson(stockReq, new TypeToken<List<StockItemObj>>() {
                }.getType());

                //Kiem tra so luong mat neu trang thai la COMPLETE
                if (WorkOrder.STATUS_COMPLETE == Integer.parseInt(status)) {
                    if (!checkQtyMaterial(listStock)) {
                        result.put("success", "overQty");
                        result.put("message", ResourceBundleUtils.getName("overQty"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    updateQtyMat = true;
                }
            }

            Boolean checkUnique = true;

            WorkOrder workOrder;
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
                workOrder = workOrderDao.get(id);
                if (code.equals(workOrder.getCode())) {
                    checkUnique = false;
                }
            } else {
                workOrder = new WorkOrder();
            }

            //Check unique
            if (checkUnique) {
                checkUnique = workOrderDao.checkUnique(id, code);
                if (checkUnique == null) {
                    result.put("success", false);
                    result.put("message", ResourceBundleUtils.getName("systemError"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                } else if (checkUnique) {
                    result.put("success", "codeExisted");
                    result.put("message", ResourceBundleUtils.getName("message.codeExisted"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
            }

            if (!StringUtils.isBlank(workTypeId)) {
                WorkType workType = workTypeDao.get(Integer.parseInt(workTypeId));
                workOrder.setWorkType(workType);
            }
            if (!StringUtils.isBlank(mechanicId)) {
                Machine machine = machineDao.get(Long.parseLong(mechanicId));
                workOrder.setMachine(machine);
            }
            if (!StringUtils.isBlank(grpEngineerId)) {
                GroupEngineer groupEngineer = groupEngineerDao.get(Integer.parseInt(grpEngineerId));
                workOrder.setGroupEngineer(groupEngineer);
            }
            workOrder.setCode(code);
            workOrder.setName(name);
            workOrder.setStartTime(sdf.parse(startTime));
            workOrder.setEndTime(sdf.parse(endTime));
            workOrder.setStatus(Integer.parseInt(status));
            if (!StringUtils.isBlank(interval)) {
                workOrder.setInterval(Integer.parseInt(interval));
            } else {
                workOrder.setInterval(0);
            }
            workOrder.setIsRepeat(Integer.parseInt(repeat));
            workOrder.setTask(task);
            workOrder.setNote(note);
            workOrder.setReason(reason);

            //Clone WO
            WorkOrder woClone = null;
            if (Objects.equals(WorkOrder.STATUS_COMPLETE, workOrder.getStatus())
                    && workOrder.getIsRepeat() != null && workOrder.getIsRepeat() > 0) {
                //Clone WO
                woClone = workOrder.cloneWo();
            }
            workOrder = workOrderDao.save(workOrder);
            if (workOrder != null) {
                if (woClone != null) {
                    //Clone WO
                    woClone = workOrderDao.save(woClone);
                    log.info("-----------CLONE WO: " + workOrder.getId() + " ---> " + woClone.getId());
                }
                Float totalMh = 0F;
                Float totalCost = 0F;
                //<editor-fold defaultstate="collapsed" desc="Save list man_hour">
                String manHrs = getRequest().getParameter("manHrs");
                if (!StringUtils.isBlank(manHrs)) {
                    listManHours = gson.fromJson(manHrs, new TypeToken<List<ManHoursObj>>() {
                    }.getType());
                }
                if (listManHours != null && !listManHours.isEmpty()) {
                    ManHours manHours;
                    GroupEngineer groupEngineer;
                    Integer tmpEngineerId = -1;
                    Boolean change = false;
                    for (ManHoursObj manHoursObj : listManHours) {
                        groupEngineer = groupEngineerDao.get(manHoursObj.getGroupEngineerId());
                        change = false;
                        if (manHoursObj.getId() <= 0) {
                            //Add
                            manHours = new ManHours();
                            manHours.setWorkOrder(workOrder);
                            tmpEngineerId = -100;
                            change = true;
                        } else {
                            //Edit
                            log.info("Edit manHoursObj: " + manHoursObj.getId());
                            manHours = manHoursDao.get(manHoursObj.getId());
                            tmpEngineerId = manHours.getGroupEngineerId();
                            if (!Objects.equals(manHoursObj.getMh(), manHours.getMh())) {
                                change = true;
                            }
                        }
                        if (!Objects.equals(tmpEngineerId, manHoursObj.getGroupEngineerId())) {
                            manHours.setGroupEngineer(groupEngineer);
                            change = true;
                        }
                        log.info("Edit manHoursObj change: " + change);
                        if (change) {
                            manHours.setMh(manHoursObj.getMh());
                            manHoursDao.save(manHours);
                        }
                        totalMh += manHoursObj.getMh();
                        totalCost += manHoursObj.getMh() * groupEngineer.getCost();
                    }
                }//</editor-fold>

                Float sotckTotalCost = 0F;
                //<editor-fold defaultstate="collapsed" desc="save stock_item">
                if (listStock != null && !listStock.isEmpty()) {
                    StockItem stockItem;
                    Material material;
                    Long materialId = -1L;
                    Boolean change = false;
                    for (StockItemObj stockItemObj : listStock) {
                        change = false;
                        material = materialDao.get(stockItemObj.getMaterialId());
                        if (stockItemObj.getId() <= 0) {
                            //Add
                            stockItem = new StockItem();
                            stockItem.setWorkOrder(workOrder);
                            materialId = -1L;
                            change = true;
                        } else {
                            //Edit
                            log.info("Edit stockItem: " + stockItemObj.getId());
                            stockItem = stockItemDao.get(stockItemObj.getId());
                            materialId = stockItem.getMaterialId();
                            if (!Objects.equals(stockItem.getQuantity(), stockItemObj.getQuantity())) {
                                change = true;
                            }
                        }
                        if (!Objects.equals(materialId, stockItemObj.getMaterialId())) {
                            stockItem.setMaterial(material);
                            change = true;
                        }
                        log.info("Edit stockItem change: " + change);
                        if (change) {
                            stockItem.setQuantity(stockItemObj.getQuantity());
                            stockItemDao.save(stockItem);
                        }

                        //Cap nhat Qty cua material
                        if (updateQtyMat) {
                            material.setQuantity(material.getQuantity() - stockItem.getQuantity());
                            material = materialDao.save(material);
                        }
                        sotckTotalCost += stockItem.getQuantity() * material.getCost();
                    }
                }//</editor-fold>

                //Save total
                workOrder.setMhTotal(totalMh);
                workOrder.setMhTotalCost(totalCost);
                workOrder.setStockTotalCost(sotckTotalCost);
                workOrder = workOrderDao.save(workOrder);

                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("saveSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("saveFail"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getSave: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSaveChange">
    public InputStream getSaveChange() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            String statusReq = getRequest().getParameter("status");
            WorkOrder workOrder = workOrderDao.get(Long.parseLong(idReq));
            ArrayList<StockItem> listStock = new ArrayList<StockItem>();
            //Chuyen sang trang thai COMPLETE -> Kiem tra quantity cua material + Clone neu repeat
            WorkOrder woClone = null;

            if (WorkOrder.STATUS_COMPLETE == Integer.parseInt(statusReq)) {
                Map mapStock = stockItemDao.getList(workOrder.getId(), null, null);
                if (mapStock.get("list") != null) {
                    listStock = (ArrayList<StockItem>) mapStock.get("list");
                }
                if (!checkQtyMaterial(listStock)) {
                    result.put("success", "overQty");
                    result.put("message", ResourceBundleUtils.getName("overQty"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }

                if (workOrder.getIsRepeat() != null && workOrder.getIsRepeat() > 0) {
                    //Clone WO
                    woClone = workOrder.cloneWo();
                }
            }
            workOrder.setStatus(Integer.parseInt(statusReq));
            workOrder = workOrderDao.save(workOrder);
            if (workOrder != null) {
                //Clone
                if(woClone != null){
                    woClone = workOrderDao.save(woClone);
                    log.info("-----------CLONE WO: " + workOrder.getId() + " ---> " + woClone.getId());
                }
                //Chuyen sang trang thai COMPLETE -> tru quantity cua material
                if (WorkOrder.STATUS_COMPLETE == Integer.parseInt(statusReq)) {
                    Material material;
                    for (StockItem stockItem : listStock) {
                        if (stockItem.getQuantity() > 0) {
                            material = materialDao.get(stockItem.getMaterialId());
                            material.setQuantity(material.getQuantity() - stockItem.getQuantity());
                            material = materialDao.save(material);
                        }
                    }
                }

                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("saveSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("saveFail"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getSaveChange: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getDelete">
    private String[] ids;

    public String[] getIds() {
        return ids;
    }

    public void setIds(String[] ids) {
        this.ids = ids;
    }

    public InputStream getDelete() {
        try {
            JSONObject result = new JSONObject();
            if (ids != null && ids.length > 0) {
                List<Long> list = new ArrayList<>(ids.length);
                for (String idTmp : ids) {
                    list.add(Long.parseLong(idTmp));
                }
                Boolean validToDelete = workOrderDao.validToDelete(list);
                if (validToDelete != null && validToDelete) {
                    result.put("success", false);
                    result.put("message", ResourceBundleUtils.getName("deleteWoComplete"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
                int delete = workOrderDao.delete(list);
                if (delete != ids.length) {
                    log.warn("deleteCompany rtn: " + delete + " list: " + ids.length);
                    result.put("success", false);
                    result.put("message", ResourceBundleUtils.getName("deleteFail"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("deleteSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("notSelect"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getDelete: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getDeleteManHour">
    public InputStream getDeleteManHour() {
        try {
            String idReq = getRequest().getParameter("id");
            JSONObject result = new JSONObject();
            if (!StringUtils.isBlank(idReq)) {
                Long id = Long.parseLong(idReq);
                ManHours manHours = manHoursDao.get(id);
                WorkOrder workOrder = manHours.getWorkOrder();
                if (id > 0) {
                    manHoursDao.remove(id);
                }
                calcToTalMh(workOrder);
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("deleteSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("notSelect"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getDeleteManHour: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getDeleteStock">
    public InputStream getDeleteStock() {
        try {
            String idReq = getRequest().getParameter("id");
            JSONObject result = new JSONObject();
            if (!StringUtils.isBlank(idReq)) {
                Long id = Long.parseLong(idReq);
                int lastQty = 0;
                StockItem stockItem = stockItemDao.get(id);
                lastQty = stockItem.getQuantity();
                Material material = stockItem.getMaterial();
                WorkOrder workOrder = stockItem.getWorkOrder();
                if (id > 0) {
                    stockItemDao.remove(id);
                    if (lastQty > 0) {
                        material.setQuantity(material.getQuantity() + lastQty);
                        materialDao.save(material);
                    }
                }
                calcToTalStock(workOrder);
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("deleteSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("notSelect"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getDeleteStock: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSaveChangeMh">
    public InputStream getSaveChangeMh() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            String mhReq = getRequest().getParameter("mh");
            ManHours manHours = manHoursDao.get(Long.parseLong(idReq));
            manHours.setMh(Float.parseFloat(mhReq));
            manHours = manHoursDao.save(manHours);
            if (manHours != null) {
                //Tinh tai total
                calcToTalMh(manHours.getWorkOrder());
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("saveSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("saveFail"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getSaveChangeMh: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSaveChangeStock">
    public InputStream getSaveChangeStock() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            String quantityReq = getRequest().getParameter("quantity");
            int lastQty = 0;
            StockItem stockItem = stockItemDao.get(Long.parseLong(idReq));
            lastQty = stockItem.getQuantity();
            Material material = stockItem.getMaterial();
            stockItem.setQuantity(Integer.parseInt(quantityReq));
            stockItem = stockItemDao.save(stockItem);
            if (stockItem != null) {
                //Cap nhat quantity cua material
                material.setQuantity(material.getQuantity() - stockItem.getQuantity() + lastQty);
                material = materialDao.save(material);
                //Tinh tai total
                calcToTalStock(stockItem.getWorkOrder());
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("saveSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("saveFail"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getSaveChangeStock: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="calcToTalMh">
    private void calcToTalMh(WorkOrder workOrder) {
        Map mapManHours = manHoursDao.getList(workOrder.getId(), null, null);
        ArrayList<ManHours> listManHrs = new ArrayList<ManHours>();
        if (mapManHours.get("list") != null) {
            listManHrs = (ArrayList<ManHours>) mapManHours.get("list");
        }

        GroupEngineer engineer;
        Float totalMh = 0F;
        Float totalCost = 0F;
        for (ManHours manHours : listManHrs) {
            totalMh += manHours.getMh();
            engineer = manHours.getGroupEngineer();
            if (engineer != null) {
                totalCost += (manHours.getMh() * engineer.getCost());
            }
        }
        workOrder.setMhTotal(totalMh);
        workOrder.setMhTotalCost(totalCost);
        workOrder = workOrderDao.save(workOrder);
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="calcToTalStock">
    private void calcToTalStock(WorkOrder workOrder) {
        Map mapStock = stockItemDao.getList(workOrder.getId(), null, null);
        ArrayList<StockItem> listStock = new ArrayList<StockItem>();
        if (mapStock.get("list") != null) {
            listStock = (ArrayList<StockItem>) mapStock.get("list");
        }

        Material material;
        Float totalCost = 0F;
        for (StockItem stockItem : listStock) {
            material = stockItem.getMaterial();
            if (material != null) {
                totalCost += (stockItem.getQuantity() * material.getCost());
            }
        }
        workOrder.setStockTotalCost(totalCost);
        workOrder = workOrderDao.save(workOrder);
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="checkQtyMaterial">
    //Return false neu vuot qua
    private boolean checkQtyMaterial(ArrayList<StockItem> listStock) {
        List<Long> lstMat = new ArrayList<Long>(listStock.size());
        for (StockItem soObj : listStock) {
            lstMat.add(soObj.getMaterialId());
        }
        HashMap<Long, Integer> hsmMatQty = materialDao.getQty(lstMat);

        //Check so luong
        Integer tmp = 0;
        for (StockItem soObj : listStock) {
            tmp = hsmMatQty.get(soObj.getMaterialId());
            log.info("-------getMaterialId|qty: " + soObj.getMaterialId() + " | " + tmp);
            //Khong ton tai Material hoac qty cua MAterial da het
            if (tmp == null || tmp <= 0) {
                return false;
            }
            //So luong item lon hon so luong qty cua MAterial
            tmp = tmp - soObj.getQuantity();
            if (tmp < 0) {
                return false;
            }
            //Cap nhat gia tri  qty cua MAterial  sau khi tru vao HashMap
            hsmMatQty.put(soObj.getMaterialId(), tmp);
        }
        return true;
    }

    private boolean checkQtyMaterial(List<StockItemObj> listStock) {
        List<Long> lstMat = new ArrayList<Long>(listStock.size());
        for (StockItemObj soObj : listStock) {
            lstMat.add(soObj.getMaterialId());
        }
        HashMap<Long, Integer> hsmMatQty = materialDao.getQty(lstMat);

        //Check so luong
        Integer tmp = 0;
        for (StockItemObj soObj : listStock) {
            tmp = hsmMatQty.get(soObj.getMaterialId());
            log.info("-------getMaterialId|qty: " + soObj.getMaterialId() + " | " + tmp);
            //Khong ton tai Material hoac qty cua MAterial da het
            if (tmp == null || tmp <= 0) {
                return false;
            }
            //So luong item lon hon so luong qty cua MAterial
            tmp = tmp - soObj.getQuantity();
            if (tmp < 0) {
                return false;
            }
            //Cap nhat gia tri  qty cua MAterial  sau khi tru vao HashMap
            hsmMatQty.put(soObj.getMaterialId(), tmp);
        }
        return true;
    }//</editor-fold>
}
