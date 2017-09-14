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
        return SUCCESS;
    }

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
                listWorkType = workTypeDao.getListChildren(workTypeReq);
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

            Map pagingMap = workOrderDao.getList(listEng, listWorkType, code, name, start, limit);

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
                if (workOrder != null) {
                    tmp.put("workTypeId", workType.getId());
                    tmp.put("workTypeName", workType.getName());
                } else {
                    tmp.put("workTypeId", "");
                    tmp.put("workTypeName", "");
                }
                machine = workOrder.getMachine();
                if (workOrder != null) {
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
    }

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
            for (ManHours manHours : listManHrs) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(manHours, "workOrder,groupEngineer");
                engineer = manHours.getGroupEngineer();
                if (engineer != null) {
                    tmp.put("engineerId", engineer.getId());
                    tmp.put("engineerGrp", engineer.getName());
                    tmp.put("engineerCost", engineer.getCost());
                } else {
                    tmp.put("engineerId", "");
                    tmp.put("engineerGrp", "");
                    tmp.put("engineerCost", "");
                }
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
                } else {
                    tmp.put("materialId", "");
                    tmp.put("materialCode", "");
                    tmp.put("materialName", "");
                    tmp.put("materialDesc", "");
                    tmp.put("materialUnit", "");
                }
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
    }

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
            String manHrs = getRequest().getParameter("manHrs");
            String note = getRequest().getParameter("note");
            String reason = getRequest().getParameter("reason");
            List<ManHoursObj> listManHours = null;
            Gson gson = new Gson();
            if (!StringUtils.isBlank(manHrs)) {
                listManHours = gson.fromJson(manHrs, new TypeToken<List<ManHoursObj>>() {
                }.getType());
            }

            log.info("--------listManHours: " + listManHours.size());

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
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
                GroupEngineer groupEngineer = groupEngineerDao.get(Integer.parseInt(workTypeId));
                workOrder.setGroupEngineer(groupEngineer);
            }
            workOrder.setCode(code);
            workOrder.setName(name);
            workOrder.setStartTime(sdf.parse(startTime));
            workOrder.setEndTime(sdf.parse(endTime));
            workOrder.setStatus(Integer.parseInt(status));
            workOrder.setInterval(Integer.parseInt(interval));
            workOrder.setIsRepeat(Integer.parseInt(repeat));
            workOrder.setTask(task);
            workOrder.setNote(note);
            workOrder.setReason(reason);
            workOrder = workOrderDao.save(workOrder);
            if (workOrder != null) {
                if (listManHours != null && !listManHours.isEmpty()) {
                    ManHours manHours;
                    GroupEngineer groupEngineer;
                    Integer tmpEngineerId = -1;
                    Boolean change = false;
                    for (ManHoursObj manHoursObj : listManHours) {
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
                            groupEngineer = groupEngineerDao.get(manHoursObj.getGroupEngineerId());
                            manHours.setGroupEngineer(groupEngineer);
                            change = true;
                        }
                        log.info("Edit manHoursObj change: " + change);
                        if (change) {
                            manHours.setMh(manHoursObj.getMh());
                            manHoursDao.save(manHours);
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
            log.error("ERROR getSave: ", ex);
            return null;
        }
    }

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
                if (ids.length == 1) {
                    workOrderDao.remove(Long.parseLong(ids[0]));
                } else {
                    List<Long> list = new ArrayList<>(ids.length);
                    for (String idTmp : ids) {
                        list.add(Long.parseLong(idTmp));
                    }
                    int delete = workOrderDao.delete(list);
                    if (delete != ids.length) {
                        log.warn("deleteCompany rtn: " + delete + " list: " + ids.length);
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteFail"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
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
    }
}
