package com.cmms.webapp.action;

import com.cmms.dao.MachineTypeDao;
import com.cmms.model.MachineType;
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
 * Action for MachineTypeAction
 */
public class MachineTypeAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    private MachineTypeDao machineTypeDao;

    public MachineTypeDao getMachineTypeDao() {
        return machineTypeDao;
    }

    public void setMachineTypeDao(MachineTypeDao machineTypeDao) {
        this.machineTypeDao = machineTypeDao;
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
            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            Map pagingMap = machineTypeDao.getList(code, name, start, limit);

            ArrayList<MachineType> list = new ArrayList<MachineType>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<MachineType>) pagingMap.get("list");
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
            String description = getRequest().getParameter("description");
            String specification = getRequest().getParameter("specification");
            String note = getRequest().getParameter("note");

            MachineType machineType = new MachineType();
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
                machineType.setId(id);
            }
            machineType.setCode(code);
            machineType.setName(name);
            machineType.setDescription(description);
            machineType.setSpecification(specification);
            machineType.setNote(note);
            machineType = machineTypeDao.save(machineType);
            if (machineType != null) {
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
                    machineTypeDao.remove(Integer.parseInt(ids[0]));
                } else {
                    List<Integer> list = new ArrayList<>(ids.length);
                    for (String idTmp : ids) {
                        list.add(Integer.parseInt(idTmp));
                    }
                    int delete = machineTypeDao.delete(list);
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
