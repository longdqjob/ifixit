package com.cmms.webapp.action;

import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MaterialDao;
import com.cmms.model.Material;
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
public class MaterialAction extends BaseAction implements Preparable {
    
    private static final long serialVersionUID = -1L;
    private MaterialDao materialDao;
    private ItemTypeDao itemTypeDao;
    
    public ItemTypeDao getItemTypeDao() {
        return itemTypeDao;
    }
    
    public void setItemTypeDao(ItemTypeDao itemTypeDao) {
        this.itemTypeDao = itemTypeDao;
    }
    
    public MaterialDao getMaterialDao() {
        return materialDao;
    }
    
    public void setMaterialDao(MaterialDao materialDao) {
        this.materialDao = materialDao;
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
            Long id = null;
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
            } else {
                idReq = getRequest().getParameter("node");
            }
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
            }
            return new ByteArrayInputStream(materialDao.getTreeView(id).toString().getBytes("UTF8"));
        } catch (Exception e) {
            log.error("ERROR getTree: ", e);
            return null;
        }
    }
    
    public InputStream getLoadData() {
        try {
            JSONObject result = new JSONObject();
            String itemId = getRequest().getParameter("itemId");
            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            List<Integer> listItemType = null;
            if (!StringUtils.isBlank(itemId)) {
                listItemType = itemTypeDao.getListChildren(Integer.parseInt(itemId));
            }
            
            Map pagingMap = materialDao.getList(listItemType, code, name, start, limit);
            
            ArrayList<Material> list = new ArrayList<Material>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<Material>) pagingMap.get("list");
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
            Long id = null;
            
            String code = getRequest().getParameter("code");
            String completeCode = getRequest().getParameter("completeCode");
            String name = getRequest().getParameter("name");
            String description = getRequest().getParameter("description");
            String unit = getRequest().getParameter("unit");
            String cost = getRequest().getParameter("cost");
            String specification = getRequest().getParameter("specification");
            String parent = getRequest().getParameter("parent");
            
            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }
            
            Boolean checkUnique = true;
            Material material = new Material();
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
                material = materialDao.get(id);
                if (completeCode.equals(material.getCompleteCode())) {
                    checkUnique = false;
                }
            }
            //Check unique
            if (checkUnique) {
                checkUnique = materialDao.checkUnique(id, completeCode);
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
                Material parentObj = materialDao.get(Long.parseLong(parent));
                material.setParent(parentObj);
            }
            
            material.setCode(code);
            material.setCompleteCode(completeCode);
            material.setName(name);
            material.setDescription(description);
            material.setUnit(unit);
            material.setCost(Float.valueOf(cost));
            material.setSpecification(specification);
            material = materialDao.save(material);
            if (material != null) {
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
                List<Long> list = new ArrayList<>(ids.length);
                
                if (ids.length == 1) {
                    list.add(Long.parseLong(ids[0]));
                    if (materialDao.checkUse(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    materialDao.remove(Long.parseLong(ids[0]));
                } else {
                    for (String idTmp : ids) {
                        list.add(Long.parseLong(idTmp));
                    }
                    if (materialDao.checkUse(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    int delete = materialDao.delete(list);
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
