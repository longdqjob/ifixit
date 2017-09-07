package com.cmms.webapp.action;

import com.cmms.dao.CompanyDao;
import com.cmms.dao.ItemTypeDao;
import com.cmms.dao.MachineDao;
import com.cmms.model.Company;
import com.cmms.model.Machine;
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
            String scompany = getRequest().getParameter("company");
            Integer companyId = null;
            if (!StringUtils.isBlank(scompany)) {
                companyId = Integer.parseInt(scompany);
            }
            List<Integer> listCompany = companyDao.getListChildren(companyId);

            Map pagingMap = machineDao.getList(lstItemType, listCompany, null, null, start, limit);

            ArrayList<Machine> list = new ArrayList<Machine>();
            if (pagingMap.get("list") != null) {
                list = (ArrayList<Machine>) pagingMap.get("list");
            }

            Long count = 0L;
            if (pagingMap.get("count") != null) {
                count = (Long) pagingMap.get("count");
            }

            JSONArray jSONArray = new JSONArray();
            JSONObject tmp;
            Company company;
            for (Machine machine : list) {
                tmp = new JSONObject();
                tmp = WebUtil.toJSONObject(machine, "");
                company = machine.getCompany();
                if (company != null) {
                    tmp.put("companyId", company.getId());
                    tmp.put("companyName", company.getName());
                } else {
                    tmp.put("companyId", "");
                    tmp.put("companyName", "");
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
}
