package com.cmms.dao.hibernate;

import com.cmms.dao.ItemTypeDao;
import com.cmms.model.ItemType;
import java.math.BigInteger;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author thuyetlv
 */
public class ItemTypeDaoHibernate extends GenericDaoHibernate<ItemType, Integer> implements ItemTypeDao {

    public ItemTypeDaoHibernate() {
        super(ItemType.class);
    }

    @Override
    public List<ItemType> getListItem(Integer id) {
        try {
            List<ItemType> rtn = new LinkedList<>();
            String hql;
            if (id == null || id <= 0) {
                hql = "SELECT * FROM item_type WHERE parent_id IS NULL";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(ItemType.class)
                        .list();
            } else {
                hql = "SELECT * FROM item_type WHERE parent_id=:parent_id";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(ItemType.class)
                        .setParameter("parent_id", id)
                        .list();
            }
            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListItem: ", ex);
            return null;
        }
    }

    @Override
    public JSONArray getTreeView(Integer id) throws JSONException, SQLException {
        List<ItemType> roots = getListItem(id);

        JSONArray treeview = new JSONArray();
        for (ItemType root : roots) {
            JSONObject tree = getTree(root);
            treeview.put(tree);
        }
        return treeview;
    }

    public JSONObject getTree(ItemType root) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        ItemType currentGroup = root;
        obj.put("name", currentGroup.getName());
        obj.put("code", currentGroup.getCode());
        obj.put("text", currentGroup.getText());
        obj.put("completeCode", currentGroup.getCompleteCode());
        obj.put("specification", currentGroup.getSpecification());
        obj.put("parentId", currentGroup.getParentId());
        obj.put("parentName", currentGroup.getParentName());
        obj.put("parentCode", currentGroup.getParentCode());
        obj.put("leaf", false);
        obj.put("expand", true);
        obj.put("id", currentGroup.getId());
        return obj;
    }

    public static final Integer TREE_LEVEL = 7;

    @Override
    public String getStringChildren(Integer id) {
        try {
            StringBuffer rtn = null;
            id = (id == null) ? 0 : id;
            String hql = "SELECT id,GetItemTypeTree(id,:level) FamilyTree FROM item_type WHERE id=:parent_id";
            List<Object[]> areaList = getSession().createSQLQuery(hql)
                    .setParameter("level", TREE_LEVEL)
                    .setParameter("parent_id", id)
                    .list();
            rtn = new StringBuffer();
            rtn.append(id);
            if (areaList != null && !areaList.isEmpty()) {
                for (Object[] obj : areaList) {
                    rtn.append(",").append(String.valueOf(obj[0]));
                }
            }

            return rtn.toString();
        } catch (Exception ex) {
            log.error("ERROR getStringChildren: ", ex);
            return null;
        }
    }

    @Override
    public List<Integer> getListChildren(Integer id) {
        try {
            List<Integer> rtn = null;
            id = (id == null) ? 0 : id;
            String hql = "SELECT id,GetItemTypeTree(id,:level) FamilyTree FROM item_type WHERE id=:parent_id";

            List<Object[]> areaList = getSession()
                    .createSQLQuery(hql)
                    .setParameter("level", TREE_LEVEL)
                    .setParameter("parent_id", id)
                    .list();
            rtn = new LinkedList<>();
            rtn.add(id);
            if (areaList != null && !areaList.isEmpty()) {
                String familyTree = "";
                for (Object[] obj : areaList) {
                    familyTree = String.valueOf(obj[1]);
                }
                if (familyTree.length() > 0) {
                    String[] tmp = familyTree.split(",");
                    for (String child : tmp) {
                        rtn.add(Integer.valueOf(child));
                    }
                }
            }

            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListChildren: ", ex);
            return null;
        }
    }

    @Override
    public Boolean checkUnique(Integer id, String code) {
        Boolean rtn = null;
        Session session = null;
        try {
            List<ItemType> list = new ArrayList<ItemType>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(ItemType.class);

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

    //--------------------
    @Override
    public Integer delete(List<Integer> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM item_type WHERE id in (:lstId)")
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR delete: ", ex);
            return null;
        }
    }

    /**
     *
     * @param lstId
     * @return true neu duoc su dung
     */
    @Override
    public Boolean checkUseParent(List<Integer> lstId) {
        try {
            if (lstId == null || lstId.isEmpty()) {
                return false;
            }
            String hql = "SELECT COUNT(id) FROM item_type WHERE parent_id in (:lstId)";
            Query query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);

            List list = query.list();
            return (((BigInteger) list.get(0)).intValue() > 0);
        } catch (Exception ex) {
            log.error("ERROR checkUseParent: ", ex);
            return null;
        }
    }

    /**
     *
     * @param lstId
     * @return true neu duoc su dung
     */
    @Override
    public Boolean checkUseByManHrs(List<Integer> lstId) {
        try {
            if (lstId == null || lstId.isEmpty()) {
                return false;
            }
            String hql = "SELECT COUNT(id) FROM material WHERE item_type_id in (:lstId)";
            Query query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);
            List list = query.list();
            return (((BigInteger) list.get(0)).intValue() > 0);
        } catch (Exception ex) {
            log.error("ERROR checkUseByManHrs: ", ex);
            return null;
        }
    }
}
