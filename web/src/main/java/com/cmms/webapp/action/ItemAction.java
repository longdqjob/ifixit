package com.cmms.webapp.action;

import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MachineDao;
import com.cmms.model.GroupEngineer;
import com.cmms.model.ItemType;
import com.cmms.model.Machine;
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
 * Action for ItemAction
 */
public class ItemAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    private ItemTypeDao itemTypeDao;
    private MachineDao machineDao;

    public ItemTypeDao getItemTypeDao() {
        return itemTypeDao;
    }

    public void setItemTypeDao(ItemTypeDao itemTypeDao) {
        this.itemTypeDao = itemTypeDao;
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
            return new ByteArrayInputStream(itemTypeDao.getTreeView(id).toString().getBytes("UTF8"));
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
            String specification = getRequest().getParameter("specification");
            String completeCode = getRequest().getParameter("completeCode");

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            Boolean checkUnique = true;
            ItemType itemType;
            if (!StringUtils.isBlank(idReq)) {
                id = Integer.parseInt(idReq);
                itemType = itemTypeDao.get(id);
                if (completeCode.equals(itemType.getCompleteCode())) {
                    checkUnique = false;
                }
            } else {
                itemType = new ItemType();
            }

            //Check unique
            if (checkUnique) {
                checkUnique = itemTypeDao.checkUnique(id, completeCode);
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
                ItemType parentObj = itemTypeDao.get(Integer.parseInt(parent));
                itemType.setParent(parentObj);
            }
            itemType.setCode(code);
            itemType.setCompleteCode(completeCode);
            itemType.setName(name);
            itemType.setSpecification(specification);
            itemType = itemTypeDao.save(itemType);
            if (itemType != null) {
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
                    if (itemTypeDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (itemTypeDao.checkUseByManHrs(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    itemTypeDao.remove(Integer.parseInt(ids[0]));
                } else {
                    for (String idTmp : ids) {
                        list.add(Integer.parseInt(idTmp));
                    }
                    if (itemTypeDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (itemTypeDao.checkUseByManHrs(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    int delete = itemTypeDao.delete(list);
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
