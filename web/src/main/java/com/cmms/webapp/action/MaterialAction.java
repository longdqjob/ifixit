package com.cmms.webapp.action;

import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MaterialDao;
import com.cmms.model.ItemType;
import com.cmms.model.Material;
import com.cmms.webapp.util.ImageUtil;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.cmms.webapp.util.WebUtil;
import com.opensymphony.xwork2.Preparable;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for MachineTypeAction
 */
public class MaterialAction extends BaseAction implements Preparable {

    private static final long serialVersionUID = -1L;
    //<editor-fold defaultstate="collapsed" desc="comment">
    private MaterialDao materialDao;
    private ItemTypeDao itemTypeDao;
    private File file;
    private String fileFileName;

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getFileFileName() {
        return fileFileName;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

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
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getTree">
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
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getLoadData">
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
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSave">
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
            String itemTypeId = getRequest().getParameter("itemTypeId");
            String quantity = getRequest().getParameter("quantity");
            String imgUrl = getRequest().getParameter("imgUrl");
            String imgPath = getRequest().getParameter("imgPath");
            String location = getRequest().getParameter("location");

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            String lastPath = "";
            Boolean checkUnique = true;
            Material material = new Material();
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
                material = materialDao.get(id);
                lastPath = material.getImgPath();
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
            if (!StringUtils.isBlank(itemTypeId)) {
                ItemType itemType = itemTypeDao.get(Integer.parseInt(itemTypeId));
                material.setItemType(itemType);
            }

            material.setCode(code);
            material.setCompleteCode(completeCode);
            material.setName(name);
            material.setDescription(description);
            material.setUnit(unit);
            material.setCost(Float.valueOf(cost));
            material.setSpecification(specification);
            material.setQuantity(Integer.parseInt(quantity));
            material.setImgPath(imgPath);
            material.setImgUrl(imgUrl);
            material.setLocation(location);
            material = materialDao.save(material);
            if (material != null) {
                if (!StringUtils.isBlank(lastPath) && !lastPath.equals(material.getImgPath())) {
                    WebUtil.deleteFile(lastPath);
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
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSaveChange">
    public InputStream getSaveChange() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            String quantity = getRequest().getParameter("quantity");
            String unit = getRequest().getParameter("unit");
            String cost = getRequest().getParameter("cost");
            Material material = materialDao.get(Long.parseLong(idReq));
            if (material == null) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("systemError"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }
            material.setQuantity(Integer.parseInt(quantity));
            material.setUnit(unit);
            material.setCost(Float.valueOf(cost));
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

                if (ids.length == 1) {
                    list.add(Long.parseLong(ids[0]));
                    if (materialDao.checkUse(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    String path = materialDao.get(Long.parseLong(ids[0])).getImgPath();
                    materialDao.remove(Long.parseLong(ids[0]));
                    WebUtil.deleteFile(path);
                } else {
                    for (String idTmp : ids) {
                        list.add(Long.parseLong(idTmp));
                    }
                    if (materialDao.checkUse(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    String[] lstPath = new String[ids.length];
                    int i = 0;
                    for (String idTmp : ids) {
                        lstPath[i++] = materialDao.get(Long.parseLong(idTmp)).getImgPath();
                    }

                    int delete = materialDao.delete(list);
                    if (delete != ids.length) {
                        log.warn("deleteCompany rtn: " + delete + " list: " + ids.length);
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteFail"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    for (String path : lstPath) {
                        WebUtil.deleteFile(path);
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
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSaveImg">
    public InputStream getSaveImg() {
        try {
            JSONObject result = new JSONObject();
            String rtn = saveFile();
            if (rtn != null) {
                String uploadDir = ServletActionContext.getServletContext().getRealPath("/");
                uploadDir += File.separator + PATH_UPLOAD + File.separator + PATH_MATERIAL + File.separator;
                result.put("success", true);
                result.put("url", "../" + PATH_UPLOAD + "/" + PATH_MATERIAL + "/" + rtn);
                result.put("path", uploadDir + rtn);
                result.put("message", ResourceBundleUtils.getName("uploadSuccessMsg"));
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("uploadFailMsg"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getSaveImg: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="saveFile">
    private String saveFile() {
        InputStream stream = null;
        String rtn = null;
        try {
            String fileName = WebUtil.removeAscii(fileFileName);
            fileName = fileName.replaceAll("\\s+", "_");
            String uploadDir = ServletActionContext.getServletContext().getRealPath("/");
            uploadDir += File.separator + PATH_UPLOAD + File.separator + PATH_MATERIAL + File.separator;

            File theDir = new File(uploadDir);
            // if the directory does not exist, create it
            if (!theDir.exists()) {
                log.info("mkdirs: " + uploadDir);
                try {
                    theDir.mkdirs();
                } catch (Exception ex) {
                    //handle it
                    log.info("mkdirs Exception: ", ex);
                }
            }

            stream = new FileInputStream(this.file);
            String fullPath = uploadDir + "tmp_" + fileName;
            fullPath = fullPath.replace("\\", File.separator);
            // write the file to the file specified
            log.info("-------fullPath: " + fullPath);
            try (OutputStream bos = new FileOutputStream(fullPath)) {
                int bytesRead;
                byte[] buffer = new byte[8192];
                while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
                    bos.write(buffer, 0, bytesRead);
                }
                bos.flush();
            }
            ImageUtil.resize(fullPath, uploadDir + fileName);
            rtn = fileName;
        } catch (FileNotFoundException ex) {
            log.error("ERROR FileNotFoundException: ", ex);
        } catch (Exception ex) {
            log.error("ERROR Exception: ", ex);
        } finally {
            try {
                if (stream != null) {
                    stream.close();
                }
            } catch (IOException ex) {
                log.error("ERROR IOException: ", ex);
            }
        }
        return rtn;
    }//</editor-fold>
}
