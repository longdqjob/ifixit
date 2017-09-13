package com.cmms.dao.hibernate;

import com.cmms.dao.MachineDao;
import com.cmms.model.Machine;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author thuyetlv
 */
public class MachineDaoHibernate extends GenericDaoHibernate<Machine, Long> implements MachineDao {

    public MachineDaoHibernate() {
        super(Machine.class);
    }

    @Override
    public Map getList(List<Integer> listItemType, List<Integer> listCompany, String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            Criteria criteria = getSession().createCriteria(Machine.class);

            //Name
            if (!StringUtils.isBlank(code)) {
                criteria.add(Restrictions.like("code", "%" + code.trim() + "%").ignoreCase());
            }
            if (!StringUtils.isBlank(name)) {
                criteria.add(Restrictions.like("name", "%" + name.trim() + "%").ignoreCase());
            }

            if (listCompany != null && !listCompany.isEmpty()) {
                criteria.add(Restrictions.in("company.id", listCompany));
            }
            criteria.addOrder(Order.desc("name"));

            HashMap<String, Object> param = new HashMap<>();
            StringBuffer sb = new StringBuffer();
            sb.setLength(0);

            StringBuffer sbCount = new StringBuffer();
            sbCount.setLength(0);

            sb.append("SELECT * FROM machine WHERE 1=1 ");
            sbCount.append("SELECT COUNT(id) FROM machine WHERE 1=1 ");
            if (!StringUtils.isBlank(code)) {
                sb.append(" AND code LIKE :code ");
                sbCount.append(" AND code LIKE :code ");
                param.put("code", "%" + code.trim() + "%");
            }
            if (!StringUtils.isBlank(name)) {
                sb.append(" AND name LIKE :name ");
                sbCount.append(" AND name LIKE :name ");
                param.put("name", "%" + name.trim() + "%");
            }
            if (listItemType != null && !listItemType.isEmpty()) {
                sb.append(" AND item_type_id IN (:item_type_id) ");
                sbCount.append("AND item_type_id IN (:item_type_id) ");
                param.put("item_type_id", listItemType);
            }
            if (listCompany != null && !listCompany.isEmpty()) {
                sb.append(" AND company_id IN (:company_id) ");
                sbCount.append("AND company_id IN (:company_id) ");
                param.put("company_id", listCompany);
            }

            Integer total = 0;
            if (limit != null && limit > 0) {
                // get the count
                criteria.setProjection(Projections.rowCount());
                total = ((Long) criteria.uniqueResult()).intValue();
                //Reset
                criteria.setProjection(null);
                criteria.setResultTransformer(CriteriaSpecification.DISTINCT_ROOT_ENTITY);
                //End get count

                criteria.setFirstResult(start);
                criteria.setMaxResults(limit);
            }
            result.put("list", criteria.list());
            result.put("count", total);
            return result;
        } catch (Exception ex) {
            log.error("ERROR getList: ", ex);
            return null;
        }
    }

    public JSONObject getTree(Machine root) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        Machine currentGroup = root;
        obj.put("name", currentGroup.getName());
        obj.put("description", currentGroup.getDescription());
        obj.put("code", currentGroup.getCode());
        obj.put("parentId", currentGroup.getParentId());
        obj.put("parentName", currentGroup.getParentName());
        obj.put("leaf", false);
        obj.put("expand", true);
        obj.put("iconCls", "folder");
//        obj.put("iconCls", "task-folder");
        obj.put("id", currentGroup.getId());
//        obj.put("children", children);
        return obj;
    }

    @Override
    public List<Machine> getListItem(List<Integer> lstSystem, Integer id) {
        try {
            if (lstSystem == null || lstSystem.isEmpty()) {
                return new ArrayList<>(0);
            }
            List<Machine> rtn = new LinkedList<>();
            String hql = "";
            if (id == null || id == 0) {
                hql = "SELECT * FROM machine WHERE parent_id IS NULL AND company_id IN (:lstSystem)";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Machine.class)
                        .setParameterList("lstSystem", lstSystem)
                        .list();
            } else {
                hql = "SELECT * FROM machine WHERE parent_id=:parent_id AND company_id IN (:lstSystem)";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Machine.class)
                        .setParameter("parent_id", id)
                        .setParameterList("lstSystem", lstSystem)
                        .list();
            }
            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListItem: ", ex);
            return null;
        }
    }

    @Override
    public JSONArray getTreeView(List<Integer> lstSystem, Integer id) throws JSONException, SQLException {
        List<Machine> roots = getListItem(lstSystem, id);

        JSONArray treeview = new JSONArray();
        for (Machine root : roots) {
            JSONObject tree = getTree(root);
            treeview.put(tree);
        }
        return treeview;
    }

    @Override
    public Integer delete(List<Long> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM machine WHERE id in (:lstId)")
                    .addEntity(Machine.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR delete: ", ex);
            return null;
        }
    }

    @Override
    public Boolean checkUnique(Long id, String code) {
        Boolean rtn = null;
        Session session = null;
        try {
            List<Machine> list = new ArrayList<Machine>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(Machine.class);

            //Id
            if (id != null && id > 0) {
                criteria.add(Restrictions.ne("id", id));
            }

            //Code
            if (code != null && code.trim().length() > 0) {
                criteria.add(Restrictions.eq("completeCode", code));
            }

            list = criteria.list();

            rtn = (list != null && list.size() > 0);

        } catch (Exception ex) {
            log.error("ERROR checkUnique: " + code, ex);
            return null;
        }
        return rtn;
    }
}
