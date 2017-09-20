package com.cmms.dao.hibernate;

import com.cmms.dao.MaterialDao;
import com.cmms.model.GroupEngineer;
import com.cmms.model.Material;
import java.math.BigInteger;
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
public class MaterialDaoHibernate extends GenericDaoHibernate<Material, Long> implements MaterialDao {

    public MaterialDaoHibernate() {
        super(Material.class);
    }

    @Override
    public List<Material> getListItem(Long id) {
        try {
            List<Material> rtn = new LinkedList<>();
            String hql = "";
            if (id == null || id <= 0) {
                hql = "SELECT * FROM material WHERE parent_id IS NULL  order by name";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Material.class)
                        .list();
            } else {
                hql = "SELECT * FROM material WHERE parent_id=:parent_id order by name";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Material.class)
                        .setParameter("parent_id", id)
                        .list();
            }
            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListItem: ", ex);
            return null;
        }
    }

    public JSONObject getTree(Material root) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        Material item = root;
        obj.put("name", item.getName());
        obj.put("namedisplay", item.getCode() + "." + item.getName());
        obj.put("description", item.getDescription());
        obj.put("code", item.getCode());
        obj.put("unit", item.getUnit());
        obj.put("cost", item.getCost());
        obj.put("completeCode", item.getCompleteCode());
        obj.put("completeParentCode", item.getParentCode());
        obj.put("parentName", item.getParentName());
        obj.put("parentId", item.getParentId());
        obj.put("leaf", false);
        obj.put("expand", true);
        obj.put("id", item.getId());
        return obj;
    }

    @Override
    public JSONArray getTreeView(Long id) throws JSONException, SQLException {
        List<Material> roots = getListItem(id);

        JSONArray treeview = new JSONArray();
        for (Material root : roots) {
            JSONObject tree = getTree(root);
            treeview.put(tree);
        }
        return treeview;
    }

    @Override
    public Map getList(List<Integer> lstItemType, String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            Criteria criteria = getSession().createCriteria(Material.class);

            if (lstItemType != null) {
                criteria.add(Restrictions.in("itemType.id", lstItemType));
            }

            //Name
            if (!StringUtils.isBlank(code)) {
                criteria.add(Restrictions.like("code", "%" + code.trim() + "%").ignoreCase());
            }
            if (!StringUtils.isBlank(name)) {
                criteria.add(Restrictions.like("name", "%" + name.trim() + "%").ignoreCase());
            }
            criteria.addOrder(Order.desc("name"));
            Long total = 0L;
            if (limit != null && limit > 0) {
                // get the count
                criteria.setProjection(Projections.rowCount());
                total = ((Long) criteria.uniqueResult()).longValue();
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

    @Override
    public Integer delete(List<Long> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM material WHERE id in (:lstId)")
                    .addEntity(Material.class)
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
            List<Material> list = new ArrayList<Material>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(Material.class);

            //Id
            if (id != null && id > 0) {
                criteria.add(Restrictions.ne("id", id));
            }

            //Code
            if (code != null && code.trim().length() > 0) {
                criteria.add(Restrictions.eq("code", code));
            }

            list = criteria.list();

            rtn = (list != null && list.size() > 0);

        } catch (Exception ex) {
            log.error("ERROR checkUnique: " + code, ex);
            return null;
        }
        return rtn;
    }

    /**
     *
     * @param lstId
     * @return true neu duoc su dung
     */
    @Override
    public Boolean checkUse(List<Long> lstId) {
        try {
            if (lstId == null || lstId.isEmpty()) {
                return false;
            }
            String hql = "SELECT COUNT(id) FROM stock_item WHERE material_id in (:lstId)";
            Query query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);

            List list = query.list();
            return (((BigInteger) list.get(0)).intValue() > 0);
        } catch (Exception ex) {
            log.error("ERROR checkUse: ", ex);
            return null;
        }
    }

    @Override
    public HashMap<Long, Integer> getQty(List<Long> lstId) {
        try {
            Query query;
            if (lstId == null || lstId.isEmpty()) {
                return new HashMap<Long, Integer>(0);
            }
            HashMap<Long, Integer> rtn = null;
            String hql = "SELECT id,quantity FROM material WHERE id in :lstId";
            query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);

            List<Object[]> list = query.list();
            rtn = new HashMap<>(lstId.size());
            if (list != null && !list.isEmpty()) {
                for (Object[] obj : list) {
                    rtn.put(Long.valueOf(String.valueOf(obj[0])), Integer.valueOf(String.valueOf(obj[1])));
                }
            }

            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getQty: ", ex);
            return null;
        }
    }
}
