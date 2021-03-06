package com.cmms.webapp.action;

import com.cmms.dao.CompanyDao;
import com.cmms.model.Company;
import com.cmms.model.GroupEngineer;
import com.cmms.webapp.security.LoginSuccessHandler;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.cmms.webapp.util.WebUtil;
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
 * Action for CompanyAction
 */
public class CompanyAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    private CompanyDao companyDao;

    public CompanyDao getCompanyDao() {
        return companyDao;
    }

    public void setCompanyDao(CompanyDao companyDao) {
        this.companyDao = companyDao;
    }

    @Override
    public void prepare() throws Exception {
    }

    public String index() {
        getSytemId();
        return SUCCESS;
    }

    public InputStream getTreeCompany() {
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
            if (id == null || id <= 0) {
                id = getSytemId();
            }
            return new ByteArrayInputStream(companyDao.getTreeView(id).toString().getBytes("UTF8"));
        } catch (Exception e) {
            log.error("ERROR getTreeCompany: ", e);
            return null;
        }
    }

    public InputStream getListCompany() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Integer id = null;
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
            }
            List<Integer> listChildrent = companyDao.getListChildren(id, true);
            Map pagingMap = companyDao.getListCompany(listChildrent, null, null, start, limit);

            ArrayList<Company> list = new ArrayList<Company>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<Company>) pagingMap.get("list");
            }

            Long count = 0L;
            if (pagingMap.get("count") != null) {
                count = (Long) pagingMap.get("count");
            }

            JSONArray jSONArray = WebUtil.toJSONArray(list);

            result.put("list", jSONArray);
            result.put("totalCount", count);

            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getListCompany: ", ex);
            return null;
        }
    }

    public InputStream getAllCompany() {
        try {
            JSONObject result = new JSONObject();
            List<Company> list = companyDao.getAll();
            JSONArray jSONArray = WebUtil.toJSONArray(list);
            result.put("list", jSONArray);
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getAllCompany: ", ex);
            return null;
        }
    }

    public InputStream getSaveCompany() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Integer id = null;

            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            String parent = getRequest().getParameter("parent");
            String description = getRequest().getParameter("description");
            String completeCode = getRequest().getParameter("completeCode");

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            if (StringUtils.isBlank(parent)) {
                if (getGrpEngineerId() > 0) {
                    result.put("success", false);
                    result.put("message", ResourceBundleUtils.getName("parentRequired"));
                    return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                }
            }

            Boolean checkUnique = true;
            Company company;
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
                company = companyDao.get(id);
                if (completeCode.equals(company.getCompleteCode())) {
                    checkUnique = false;
                } else {
                    //@todo: neu cho con thi ko cho sua code
//                    List<Integer> list = new ArrayList<>(1);
//                    list.add(id);
//                    //Thay doi code -> Kiem tra su dung
//                    if (companyDao.checkUseParent(list)) {
//                        result.put("success", false);
//                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
//                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
//                    }
                }
            } else {
                company = new Company();
                if (StringUtils.isBlank(parent)) {
                    if (getGrpEngineerId() > 0) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("parentRequired"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                } else {
                    //Khong truyen parent thi mac dinh parent la systemID cua user
                    Integer parentId = Integer.parseInt(parent);
                    if (parentId <= 0) {
                        parentId = getSytemId();
                    }
                    if (parentId > 0) {
                        Company parentObj = companyDao.get(parentId);
                        company.setCompany(parentObj);
                        completeCode = parentObj.getCompleteCode() + "." + code;
                    }
                }
            }

            //Check unique
            if (checkUnique) {
                checkUnique = companyDao.checkUnique(id, completeCode);
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
                Company parentObj = companyDao.get(Integer.parseInt(parent));
                company.setCompany(parentObj);
            }
            company.setCode(code);
            company.setName(name);
            company.setDescription(description);
            company.setCompleteCode(completeCode);
            company = companyDao.save(company);
            if (company != null) {
                if (Objects.equals(company.getId(), getSytemId())) {
                    //update Session
                    updateSessionSystem();
                }
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

    public InputStream getDeleteCompany() {
        try {
            JSONObject result = new JSONObject();
            if (ids != null && ids.length > 0) {
                List<Integer> list = new ArrayList<>(ids.length);
                if (ids.length == 1) {
                    list.add(Integer.parseInt(ids[0]));
                    if (companyDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (companyDao.checkUseByMachenic(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (companyDao.checkUseByUser(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    companyDao.remove(Integer.parseInt(ids[0]));
                } else {
                    for (String idTmp : ids) {
                        list.add(Integer.parseInt(idTmp));
                    }
                    if (companyDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (companyDao.checkUseByMachenic(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (companyDao.checkUseByUser(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    int delete = companyDao.deleteCompany(list);
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
