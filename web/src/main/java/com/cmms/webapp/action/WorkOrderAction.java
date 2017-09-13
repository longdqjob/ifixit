package com.cmms.webapp.action;

import com.cmms.dao.GroupEngineerDao;
import com.cmms.dao.MachineDao;
import com.cmms.dao.WorkOrderDao;
import com.cmms.dao.WorkTypeDao;
import com.cmms.model.Machine;
import com.cmms.model.WorkOrder;
import com.cmms.model.WorkType;
import com.cmms.webapp.security.LoginSuccessHandler;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.cmms.webapp.util.WebUtil;
import com.opensymphony.xwork2.Preparable;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for MachineAction
 */
public class WorkOrderAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    private GroupEngineerDao groupEngineerDao;
    private MachineDao machineDao;
    private WorkTypeDao workTypeDao;
    private WorkOrderDao workOrderDao;

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
    }

    public String index() {
        return SUCCESS;
    }

    public InputStream getLoadData() {
        try {
            JSONObject result = new JSONObject();
            //companyDao
            String sWorkType = getRequest().getParameter("workType");
            Integer companyId = null;
            if (!StringUtils.isBlank(sWorkType)) {
                companyId = Integer.parseInt(sWorkType);
            }
            List<Integer> listWorkType;
            if (companyId == null || companyId < -1) {
                companyId = null;
                if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID) != null) {
                    companyId = (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID);
                }
                listWorkType = getListSytem();
            } else {
                listWorkType = workTypeDao.getListChildren(companyId);
            }

            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            Map pagingMap = workOrderDao.getList(listWorkType, code, name, start, limit);

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
            for (WorkOrder workOrder : list) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(workOrder, "workType,machine");
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

    public InputStream getSave() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Long id = null;

            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            String workTypeId = getRequest().getParameter("workTypeId");
            String mechanicId = getRequest().getParameter("mechanicId");
            String startTime = getRequest().getParameter("startTime");
            String endTime = getRequest().getParameter("endTime");

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
            workOrder.setCode(code);
            workOrder.setName(name);
            workOrder.setStartTime(sdf.parse(startTime));
            workOrder.setEndTime(sdf.parse(endTime));
            workOrder = workOrderDao.save(workOrder);
            if (workOrder != null) {
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
