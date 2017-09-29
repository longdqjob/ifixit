package com.cmms.webapp.action;

import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MaterialDao;
import com.cmms.model.ItemType;
import com.cmms.model.Material;
import com.cmms.obj.MaterialObj;
import com.cmms.webapp.util.ApachePOIExcel;
import com.cmms.webapp.util.ImageUtil;
import com.cmms.webapp.util.ResourceBundleUtils;
import com.cmms.webapp.util.WebUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
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
import java.util.Arrays;
import java.util.HashMap;
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
            String rtn = saveFile(true);
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
    private String saveFile(boolean resizeImg) {
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
            String fullPath = "";
            if (resizeImg) {
                fullPath = uploadDir + "tmp_" + fileName;
            } else {
                fullPath = uploadDir + fileName;
            }
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
            if (resizeImg) {
                ImageUtil.resize(fullPath, uploadDir + fileName);
            }
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

    //<editor-fold defaultstate="collapsed" desc="checkDataWithParent">
    private Map checkDataWithParent(List data) {
        Map rtn = new HashMap<>();
        ArrayList<MaterialObj> list = new ArrayList<MaterialObj>(data.size());

        int i = 0;
        String[] tmp;
        String completeCode = "";
        //Tao list check unique completeCode
        HashMap<String, String> lstCode = new HashMap<>();
        for (Object mat : data) {
            if (i++ == 0) {
                continue;
            }
            tmp = (String[]) mat;
            if (StringUtils.isBlank(tmp[0])) {
                completeCode = tmp[1].trim();
            } else {
                completeCode = tmp[0].trim() + Material.CODE_SPA + tmp[1].trim();
                lstCode.put(tmp[0].trim(), tmp[0].trim());                     //Lay Id parent
            }
            lstCode.put(completeCode, completeCode);
        }
        HashMap<String, Long> hsmMatExits = materialDao.getList(new ArrayList<String>(lstCode.values()));

        //Tao list Material de hien thi
        i = 0;
        MaterialObj material;
        Long matId;
        for (Object mat : data) {
            if (i++ == 0) {
                continue;
            }
            tmp = (String[]) mat;
            System.out.println(Arrays.toString(tmp));
            if (StringUtils.isBlank(tmp[0])) {
                completeCode = tmp[1].trim();
            } else {
                completeCode = tmp[0].trim() + Material.CODE_SPA + tmp[1].trim();
            }

            material = new MaterialObj();
            material.setCode(tmp[1].trim());
            material.setParentCode(tmp[0].trim());
            material.setCompleteCode(completeCode);
            material.setName(tmp[2]);
            material.setUnit(tmp[3]);
            try {
                material.setQuantity(((Double) Double.parseDouble(tmp[4])).intValue());
                material.setCost(Float.parseFloat(tmp[5]));
            } catch (Exception ex) {
                log.error("EROR parse: " + Arrays.toString(tmp), ex);
            }
            material.setLocation(tmp[6]);

            //Ktra du lieu parent
            if (!StringUtils.isBlank(tmp[0])) {
                matId = hsmMatExits.get(tmp[0].trim());
                if (matId == null) {
                    material.setErrorCode(MaterialObj.ERR_PARENT_NOT_EXITS);
                    material.setMessage(ResourceBundleUtils.getName("import.parentNotExits"));
                    list.add(material);
                    continue;
                }
                material.setParentId(matId);
            }

            matId = hsmMatExits.get(completeCode);
            if (matId != null) {
                material.setErrorCode(MaterialObj.ERR_CODE_EXITS);
                material.setMessage(ResourceBundleUtils.getName("import.codeExits"));
                list.add(material);
                continue;
            }
            material.setId(Long.valueOf(0 - i));
            hsmMatExits.put(material.getCompleteCode(), material.getId());
            list.add(material);
        }
        rtn.put("list", list);
        rtn.put("totalCount", list.size());
        return rtn;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="checkData">
    private Map checkData(List data) {
        Map rtn = new HashMap<>();
        ArrayList<MaterialObj> list = new ArrayList<MaterialObj>(data.size());

        int i = 0;
        String[] tmp;
        String completeCode = "";
        //Tao list check unique completeCode
        HashMap<String, String> lstItemCode = new HashMap<>();
        HashMap<String, String> lstCode = new HashMap<>();
        for (Object mat : data) {
            if (i++ == 0) {
                continue;
            }
            tmp = (String[]) mat;
            if (StringUtils.isBlank(tmp[0])) {
                completeCode = tmp[1].trim();
            } else {
                completeCode = tmp[0].trim() + Material.CODE_SPA + tmp[1].trim();
                lstItemCode.put(tmp[0].trim(), tmp[0].trim());                     //Lay Id parent
            }
            lstCode.put(completeCode, completeCode);
        }
        HashMap<String, Long> hsmMatExits = materialDao.getList(new ArrayList<String>(lstCode.values()));

        HashMap<String, Integer> hsmItem = itemTypeDao.getList(new ArrayList<String>(lstItemCode.values()));

        //Tao list Material de hien thi
        i = 0;
        MaterialObj material;
        Long matId;
        Integer itemId;
        for (Object mat : data) {
            if (i++ == 0) {
                continue;
            }
            tmp = (String[]) mat;
            System.out.println(Arrays.toString(tmp));
            if (StringUtils.isBlank(tmp[0])) {
                completeCode = tmp[1].trim();
            } else {
                completeCode = tmp[0].trim() + Material.CODE_SPA + tmp[1].trim();
            }

            material = new MaterialObj();
            material.setCode(tmp[1].trim());
            material.setParentCode(tmp[0].trim());
            material.setCompleteCode(completeCode);
            material.setName(tmp[2]);
            material.setUnit(tmp[3]);
            try {
                material.setQuantity(((Double) Double.parseDouble(tmp[4])).intValue());
                material.setCost(Float.parseFloat(tmp[5]));
            } catch (Exception ex) {
                log.error("EROR parse: " + Arrays.toString(tmp), ex);
            }
            material.setLocation(tmp[6]);

            //Ktra du lieu parent
            if (!StringUtils.isBlank(tmp[0])) {
                itemId = hsmItem.get(tmp[0].trim());
                if (itemId == null) {
                    material.setErrorCode(MaterialObj.ERR_PARENT_NOT_EXITS);
                    material.setMessage(ResourceBundleUtils.getName("import.parentNotExits"));
                    list.add(material);
                    continue;
                }
                material.setItemTypeId(itemId);
            }

            matId = hsmMatExits.get(completeCode);
            if (matId != null) {
                material.setErrorCode(MaterialObj.ERR_CODE_EXITS);
                material.setMessage(ResourceBundleUtils.getName("import.codeExits"));
                list.add(material);
                continue;
            }
            material.setId(Long.valueOf(0 - i));
            hsmMatExits.put(material.getCompleteCode(), material.getId());
            list.add(material);
        }
        rtn.put("list", list);
        rtn.put("totalCount", list.size());
        return rtn;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getValidateImport">
    private static final int NUMBER_FIELD = 7;

    private String getExtension(String fileName) {
        if (StringUtils.isBlank(fileName)) {
            return "";
        }
        if (!fileName.contains(".")) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
    }

    public InputStream getValidateImport() {
        try {
            JSONObject result = new JSONObject();

            String extension = getExtension(fileFileName);
            if (!"xls".equalsIgnoreCase(extension) && !"xlsx".equalsIgnoreCase(extension)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("invalidFormatImport"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }
            String rtn = saveFile(false);
            if (rtn != null) {
                String uploadDir = ServletActionContext.getServletContext().getRealPath("/");
                uploadDir += File.separator + PATH_UPLOAD + File.separator + PATH_MATERIAL + File.separator;

                List data = ApachePOIExcel.readFile(uploadDir + rtn, NUMBER_FIELD, true);
                Map checkData = checkData(data);
                JSONArray jSONArray = WebUtil.toJSONArray((ArrayList<Material>) checkData.get("list"));
                result.put("list", jSONArray);
                result.put("totalCount", (Integer) checkData.get("totalCount"));
                result.put("success", true);
                if (checkData.get("message") != null && !StringUtils.isBlank((String) checkData.get("message"))) {
                    result.put("message", (String) checkData.get("message"));
                } else {
                    result.put("message", ResourceBundleUtils.getName("uploadSuccessMsg"));
                }
            } else {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("uploadFailMsg"));
            }
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getValidateImport: ", ex);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getExeImport">
    public InputStream getExeImport() {
        try {
            JSONObject result = new JSONObject();
            String dataReq = getRequest().getParameter("data");
            List<MaterialObj> listData = null;
            if (!StringUtils.isBlank(dataReq)) {
                Gson gson = new Gson();
                listData = gson.fromJson(dataReq, new TypeToken<List<MaterialObj>>() {
                }.getType());
                Integer rtn = materialDao.insertListUseSql(listData);
                if (rtn != null && rtn > 0) {
                    result.put("success", true);
                    result.put("message", ResourceBundleUtils.getName("import.success"));
                } else {
                    result.put("success", false);
                    result.put("message", ResourceBundleUtils.getName("import.fail"));
                }
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            result.put("success", false);
            result.put("message", ResourceBundleUtils.getName("import.noData"));
            return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
        } catch (Exception ex) {
            log.error("ERROR getExeImport: ", ex);
            return null;
        }
    }//</editor-fold>
}
