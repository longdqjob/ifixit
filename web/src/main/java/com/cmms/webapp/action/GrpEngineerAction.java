package com.cmms.webapp.action;

import com.cmms.dao.GroupEngineerDao;
import com.cmms.model.GroupEngineer;
import com.cmms.webapp.security.LoginSuccessHandler;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.opensymphony.xwork2.Preparable;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for GrpEngineerAction
 */
public class GrpEngineerAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    private GroupEngineerDao groupEngineerDao;

    public GroupEngineerDao getGroupEngineerDao() {
        return groupEngineerDao;
    }

    public void setGroupEngineerDao(GroupEngineerDao groupEngineerDao) {
        this.groupEngineerDao = groupEngineerDao;
    }

    @Override
    public void prepare() throws Exception {
    }

    public String index() {
        return SUCCESS;
    }

    public InputStream getTree() {
        try {
            String idReq = getRequest().getParameter("id");
            Integer id = null;
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
            } else {
                idReq = getRequest().getParameter("node");
            }
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
            }
            if (id == null || id < -1) {
                id = getGrpEngineerId();
            }
            return new ByteArrayInputStream(groupEngineerDao.getTreeView(id).toString().getBytes("UTF8"));
        } catch (Exception e) {
            log.error("ERROR getTree: ", e);
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
            String parent = getRequest().getParameter("parent");
            String description = getRequest().getParameter("description");
            String cost = getRequest().getParameter("cost");
            String completeCode = getRequest().getParameter("completeCode");

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            Boolean checkUnique = true;
            GroupEngineer cGroupEngineer;
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
                cGroupEngineer = groupEngineerDao.get(id);
                if (completeCode.equals(cGroupEngineer.getCompleteCode())) {
                    checkUnique = false;
                }
            } else {
                cGroupEngineer = new GroupEngineer();
            }

            //Check unique
            if (checkUnique) {
                checkUnique = groupEngineerDao.checkUnique(id, completeCode);
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

            GroupEngineer parentObj = groupEngineerDao.get(Integer.parseInt(parent));
            cGroupEngineer.setParent(parentObj);
            cGroupEngineer.setCode(code);
            cGroupEngineer.setCompleteCode(completeCode);
            cGroupEngineer.setName(name);
            cGroupEngineer.setDescription(description);
            cGroupEngineer.setCost(Float.parseFloat(cost));
            cGroupEngineer = groupEngineerDao.save(cGroupEngineer);
            if (cGroupEngineer != null) {
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
                List<Integer> list = new ArrayList<>(ids.length);
                if (ids.length == 1) {
                    list.add(Integer.parseInt(ids[0]));
                    if (groupEngineerDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (groupEngineerDao.checkUseByManHrs(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    groupEngineerDao.remove(Integer.parseInt(ids[0]));
                } else {
                    for (String idTmp : ids) {
                        list.add(Integer.parseInt(idTmp));
                    }
                    if (groupEngineerDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (groupEngineerDao.checkUseByManHrs(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    int delete = groupEngineerDao.delete(list);
                    if (delete != ids.length) {
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
