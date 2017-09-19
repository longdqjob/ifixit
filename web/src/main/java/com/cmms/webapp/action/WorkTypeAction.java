package com.cmms.webapp.action;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.WorkTypeDao;
import com.cmms.model.WorkType;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.opensymphony.xwork2.Preparable;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for CompanyAction
 */
public class WorkTypeAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    private WorkTypeDao workTypeDao;
    private CompanyDao companyDao;

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
            return new ByteArrayInputStream(workTypeDao.getTreeView(id).toString().getBytes("UTF8"));
        } catch (Exception e) {
            log.error("ERROR getTreeCompany: ", e);
            return null;
        }
    }

    public InputStream getSave() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Integer id = null;

            String code = getRequest().getParameter("code");
            String completeCode = getRequest().getParameter("completeCode");
            String name = getRequest().getParameter("name");
            String parent = getRequest().getParameter("parent");

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
                if (completeCode.equals(workType.getCompleteCode())) {
                    checkUnique = false;
                }
            } else {
                workType = new WorkType();
            }

            //Check unique
            if (checkUnique) {
                checkUnique = workTypeDao.checkUnique(id, completeCode);
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

            if (!StringUtils.isBlank(parent)) {
                WorkType parentObj = workTypeDao.get(Integer.parseInt(parent));
                workType.setParent(parentObj);
            }
            workType.setCode(code);
            workType.setCompleteCode(completeCode);
            workType.setName(name);
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
            log.error("ERROR getDeleteCompany: ", ex);
            return null;
        }
    }

}
