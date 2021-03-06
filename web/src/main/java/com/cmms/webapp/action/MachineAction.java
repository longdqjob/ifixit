package com.cmms.webapp.action;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MachineDao;
import com.cmms.dao.MachineTypeDao;
import com.cmms.model.Company;
import com.cmms.model.Machine;
import com.cmms.model.MachineType;
import com.cmms.util.DateUtil;
import com.cmms.webapp.security.LoginSuccessHandler;
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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

/**
 * Action for MachineAction
 */
public class MachineAction extends BaseAction implements Preparable {

    //<editor-fold defaultstate="collapsed" desc="Other">
    private static final long serialVersionUID = -1L;
    private ItemTypeDao itemTypeDao;
    private MachineDao machineDao;
    private CompanyDao companyDao;
    private MachineTypeDao machineTypeDao;

    public MachineTypeDao getMachineTypeDao() {
        return machineTypeDao;
    }

    public void setMachineTypeDao(MachineTypeDao machineTypeDao) {
        this.machineTypeDao = machineTypeDao;
    }

    public CompanyDao getCompanyDao() {
        return companyDao;
    }

    public void setCompanyDao(CompanyDao companyDao) {
        this.companyDao = companyDao;
    }

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
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getTree">
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

            String scompany = getRequest().getParameter("system");
            Integer companyId = null;
            if (!StringUtils.isBlank(scompany)) {
                companyId = Integer.parseInt(scompany);
            }
            List<Integer> listCompany;
            if (companyId == null || companyId < -1) {
                companyId = null;
                if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID) != null) {
                    companyId = (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID);
                }
                listCompany = getListSytem2();
            } else {
                listCompany = companyDao.getListChildren(companyId, true);
            }

            return new ByteArrayInputStream(machineDao.getTreeView(listCompany, id).toString().getBytes("UTF8"));
        } catch (Exception e) {
            log.error("ERROR getTree: ", e);
            return null;
        }
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getListSytem2">
    private List<Integer> getListSytem2() {
        List<Integer> listCompany = getListSytem();
        if (listCompany == null) {
            if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID) != null) {
                listCompany = companyDao.getListChildren((Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID), true);
                getRequest().getSession().setAttribute(LoginSuccessHandler.SESSION_LIST_SYSTEM_ID, listCompany);
            }
        }
        return listCompany;
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getLoadData">
    public InputStream getLoadData() {
        try {
            JSONObject result = new JSONObject();
            //itemType
            String itemType = getRequest().getParameter("itemType");
            Integer idItemType = null;
            if (!StringUtils.isBlank(itemType)) {
                idItemType = Integer.parseInt(itemType);
            }
            List<Integer> lstItemType = itemTypeDao.getListChildren(idItemType);

            //companyDao
            String scompany = getRequest().getParameter("system");
            Integer companyId = null;
            if (!StringUtils.isBlank(scompany)) {
                companyId = Integer.parseInt(scompany);
            }
            List<Integer> listCompany;
            if (companyId == null || companyId < -1) {
                companyId = null;
                if (getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID) != null) {
                    companyId = (Integer) getRequest().getSession().getAttribute(LoginSuccessHandler.SESSION_SYSTEM_ID);
                }
                listCompany = getListSytem2();
            } else {
                listCompany = companyDao.getListChildren(companyId, true);
            }

            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            Map pagingMap = machineDao.getList(null, listCompany, code, name, start, limit);

            ArrayList<Machine> list = new ArrayList<Machine>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<Machine>) pagingMap.get("list");
            }

            Integer count = 0;
            if (pagingMap.get("count") != null) {
                count = (Integer) pagingMap.get("count");
            }

            JSONArray jSONArray = new JSONArray();
            JSONObject tmp;
            Company company;
            MachineType machineType;
            Machine parent;
            for (Machine machine : list) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(machine, "company,machineType,parent");
                company = machine.getCompany();
                if (company != null) {
                    tmp.put("companyId", company.getId());
                    tmp.put("companyName", company.getName());
                } else {
                    tmp.put("companyId", "");
                    tmp.put("companyName", "");
                }

                machineType = machine.getMachineType();
                if (machineType != null) {
                    tmp.put("machineTypeId", machineType.getId());
                    tmp.put("machineTypeName", machineType.getName());
                    tmp.put("machineTypeCode", machineType.getCode());
                    tmp.put("machineTypeSpec", machineType.getSpecification());
                } else {
                    tmp.put("machineTypeId", "");
                    tmp.put("machineTypeName", "");
                    tmp.put("machineTypeCode", "");
                    tmp.put("machineTypeSpec", machineType.getSpecification());
                }
                parent = machine.getParent();
                if (parent != null) {
                    tmp.put("parentId", parent.getId());
                    tmp.put("parentName", parent.getName());
                } else {
                    tmp.put("parentId", "");
                    tmp.put("parentName", "");
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
    }//</editor-fold>

    //<editor-fold defaultstate="collapsed" desc="getSave">
    public InputStream getSave() {
        try {
            JSONObject result = new JSONObject();
            String idReq = getRequest().getParameter("id");
            Long id = null;

            String code = getRequest().getParameter("code");
            String name = getRequest().getParameter("name");
            String description = getRequest().getParameter("description");
            String specification = getRequest().getParameter("specification");
            String parentId = getRequest().getParameter("parentId");
            String companyId = getRequest().getParameter("companyId");
            String machineTypeId = getRequest().getParameter("machineTypeId");
            String note = getRequest().getParameter("note");
            String since = getRequest().getParameter("since");
            String completeCode = getRequest().getParameter("completeCode");
            String imgUrl = getRequest().getParameter("imgUrl");
            String imgPath = getRequest().getParameter("imgPath");

            if (StringUtils.isBlank(code)) {
                result.put("success", false);
                result.put("message", ResourceBundleUtils.getName("message.codeRequired"));
                return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
            }

            Boolean checkUnique = true;

            Machine machenic;
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
                machenic = machineDao.get(id);
                if (code.equals(machenic.getCode())) {
                    checkUnique = false;
                }
            } else {
                machenic = new Machine();
            }

            //Check unique
            if (checkUnique) {
                checkUnique = machineDao.checkUnique(id, completeCode);
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

            if (!StringUtils.isBlank(parentId)) {
                Machine mParent = machineDao.get(Long.parseLong(parentId));
                machenic.setParent(mParent);
            }
            if (!StringUtils.isBlank(companyId)) {
                Company company = companyDao.get(Integer.parseInt(companyId));
                machenic.setCompany(company);
            }
            if (!StringUtils.isBlank(machineTypeId)) {
                MachineType machineType = machineTypeDao.get(Integer.parseInt(machineTypeId));
                machenic.setMachineType(machineType);
            }
            if (!StringUtils.isBlank(since)) {
                Date d = DateUtil.convertStringToDate(since);
                machenic.setSince(new Timestamp(d.getTime()));
            }

            machenic.setCode(code);
            machenic.setName(name);
            machenic.setDescription(description);
            machenic.setSpecification(specification);
            machenic.setNote(note);
            machenic.setCompleteCode(completeCode);
            machenic.setImgPath(imgPath);
            machenic.setImgUrl(imgUrl);
            machenic = machineDao.save(machenic);
            if (machenic != null) {
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
                    if (machineDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (machineDao.checkUseWO(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    String path = machineDao.get(Long.parseLong(ids[0])).getImgPath();
                    machineDao.remove(Long.parseLong(ids[0]));
                    WebUtil.deleteFile(path);
                } else {
                    for (String idTmp : ids) {
                        list.add(Long.parseLong(idTmp));
                    }
                    if (machineDao.checkUseParent(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    if (machineDao.checkUseWO(list)) {
                        result.put("success", false);
                        result.put("message", ResourceBundleUtils.getName("deleteUsing"));
                        return new ByteArrayInputStream(result.toString().getBytes("UTF8"));
                    }
                    String[] lstPath = new String[ids.length];
                    int i = 0;
                    for (String idTmp : ids) {
                        lstPath[i++] = machineDao.get(Long.parseLong(idTmp)).getImgPath();
                    }
                    int delete = machineDao.delete(list);
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
                uploadDir += File.separator + PATH_UPLOAD + File.separator + PATH_MECHANIC + File.separator;
                result.put("success", true);
                result.put("url", "../" + PATH_UPLOAD + "/" + PATH_MECHANIC + "/" + rtn);
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

    private String saveFile() {
        InputStream stream = null;
        String rtn = null;
        try {
            String fileName = WebUtil.removeAscii(fileFileName);
            fileName = fileName.replaceAll("\\s+", "_");
            String uploadDir = ServletActionContext.getServletContext().getRealPath("/");
            uploadDir += File.separator + PATH_UPLOAD + File.separator + PATH_MECHANIC + File.separator;

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
