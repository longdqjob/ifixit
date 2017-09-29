package com.cmms.webapp.action;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.GroupEngineerDao;
import com.cmms.dao.WorkTypeDao;
import com.cmms.model.GroupEngineer;
import com.cmms.model.Machine;
import com.cmms.model.WorkOrder;
import com.cmms.model.WorkType;
import com.cmms.webapp.security.LoginSuccessHandler;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.cmms.webapp.util.WebUtil;
import com.opensymphony.xwork2.Preparable;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for CompanyAction
 */
public class WorkTypeAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    //<editor-fold defaultstate="collapsed" desc="get & set">
    private WorkTypeDao workTypeDao;
    private CompanyDao companyDao;
    private GroupEngineerDao groupEngineerDao;

    public GroupEngineerDao getGroupEngineerDao() {
        return groupEngineerDao;
    }

    public void setGroupEngineerDao(GroupEngineerDao groupEngineerDao) {
        this.groupEngineerDao = groupEngineerDao;
    }

    public CompanyDao getCompanyDao() {
        return companyDao;
    }

    public void setCompanyDao(CompanyDao companyDao) {
        this.companyDao = companyDao;
    }

    public WorkTypeDao getWorkTypeDao() {
        return workTypeDao;
    }

    public void setWorkTypeDao(WorkTypeDao workTypeDao) {
        this.workTypeDao = workTypeDao;
    }//</editor-fold>

    @Override
    public void prepare() throws Exception {
    }

    public String index() {
        return SUCCESS;
    }

    public InputStream getLoadData() {
        try {
            JSONObject result = new JSONObject();
            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");

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

            Map pagingMap = workTypeDao.getList(listEng, code, name, start, limit);

            ArrayList<WorkType> list = new ArrayList<WorkType>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<WorkType>) pagingMap.get("list");
            }

            Integer count = 0;
            if (pagingMap.get("count") != null) {
                count = (Integer) pagingMap.get("count");
            }

            JSONArray jSONArray = new JSONArray();
            JSONObject tmp;
            GroupEngineer groupEngineer;
            for (WorkType workType : list) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(workType, "groupEngineer");
                groupEngineer = workType.getGroupEngineer();
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

    public InputStream getSave() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Integer id = null;

            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            Boolean checkUnique = true;
            WorkType workType;
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
                workType = workTypeDao.get(id);
                if (code.equals(workType.getCode())) {
                    checkUnique = false;
                }
            } else {
                workType = new WorkType();
            }

            //Check unique
            if (checkUnique) {
                checkUnique = workTypeDao.checkUnique(id, code);
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

            String grpEngineerId = getRequest().getParameter("grpEngineerId");
            String interval = getRequest().getParameter("interval");
            String repeat = getRequest().getParameter("repeat");
            String task = getRequest().getParameter("task");

            workType.setCode(code);
            workType.setName(name);
            if (!StringUtils.isBlank(grpEngineerId) && Integer.parseInt(grpEngineerId) > 0) {
                GroupEngineer groupEngineer = groupEngineerDao.get(Integer.parseInt(grpEngineerId));
                workType.setGroupEngineer(groupEngineer);
            }
            if (!StringUtils.isBlank(interval)) {
                workType.setInterval(Integer.parseInt(interval));
            } else {
                workType.setInterval(0);
            }
            workType.setIsRepeat(Integer.parseInt(repeat));
            workType.setTask(task);
            workType = workTypeDao.save(workType);
            if (workType != null) {
                result.put("success", true);
                result.put("message", ResourceBundleUtils.getName("saveSuccess"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("saveFail"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getSaveCompany: ", ex);
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
                List<Integer> list = new ArrayList<>(ids.length);
                if (ids.length == 1) {
                    list.add(Integer.parseInt(ids[0]));
                    if (workTypeDao.checkUseWO(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    workTypeDao.remove(Integer.parseInt(ids[0]));
                } else {
                    list = new ArrayList<>(ids.length);
                    for (String idTmp : ids) {
                        list.add(Integer.parseInt(idTmp));
                    }
                    if (workTypeDao.checkUseWO(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    int delete = workTypeDao.delete(list);
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
