package com.cmms.webapp.action;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MachineDao;
import com.cmms.dao.MachineTypeDao;
import com.cmms.model.Company;
import com.cmms.model.Machine;
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
 * Action for MachineAction
 */
public class MachineAction extends BaseAction implements Preparable {

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
            return new ByteArrayInputStream(machineDao.getTreeView(id).toString().getBytes("UTF8"));
        } catch (Exception e) {
            log.error("ERROR getTree: ", e);
            return null;
        }
    }

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
            List<Integer> listCompany = companyDao.getListChildren(companyId);

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
                } else {
                    tmp.put("machineTypeId", "");
                    tmp.put("machineTypeName", "");
                    tmp.put("machineTypeCode", "");
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
    }

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

            Machine mechanic = new Machine();
            if (!StringUtils.isBlank(idReq)) {
                id = Long.parseLong(idReq);
                mechanic.setId(id);
            }
            if (!StringUtils.isBlank(parentId)) {
                Machine mParent = machineDao.get(Long.parseLong(parentId));
                mechanic.setParent(mParent);
            }
            if (!StringUtils.isBlank(companyId)) {
                Company company = companyDao.get(Integer.parseInt(companyId));
                mechanic.setCompany(company);
            }
            if (!StringUtils.isBlank(machineTypeId)) {
                MachineType machineType = machineTypeDao.get(Integer.parseInt(machineTypeId));
                mechanic.setMachineType(machineType);
            }

            mechanic.setCode(code);
            mechanic.setName(name);
            mechanic.setDescription(description);
            mechanic.setSpecification(specification);
            mechanic.setNote(note);
            mechanic = machineDao.save(mechanic);
            if (mechanic != null) {
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
                    machineDao.remove(Long.parseLong(ids[0]));
                } else {
                    List<Long> list = new ArrayList<>(ids.length);
                    for (String idTmp : ids) {
                        list.add(Long.parseLong(idTmp));
                    }
                    int delete = machineDao.delete(list);
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
