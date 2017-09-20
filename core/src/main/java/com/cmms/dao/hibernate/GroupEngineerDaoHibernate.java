package com.cmms.dao.hibernate;

import com.cmms.dao.GroupEngineerDao;
import static com.cmms.dao.hibernate.ItemTypeDaoHibernate.TREE_LEVEL;
import com.cmms.model.GroupEngineer;
import com.cmms.model.WorkOrder;
import java.math.BigInteger;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import static org.hibernate.criterion.Projections.id;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author thuyetlv
 */
public class GroupEngineerDaoHibernate extends GenericDaoHibernate<GroupEngineer, Integer> implements GroupEngineerDao {

    public GroupEngineerDaoHibernate() {
        super(GroupEngineer.class);
    }

    @Override
    public List<GroupEngineer> getListItem(Integer id) {
        try {
            List<GroupEngineer> rtn = new LinkedList<>();
            String hql = "";
            if (id == null || id <= 0) {
                hql = "SELECT * FROM group_engineer WHERE parent_id IS NULL ORDER BY `complete_code`,`name` ASC";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(GroupEngineer.class)
                        .list();
            } else {
                hql = "SELECT * FROM group_engineer WHERE parent_id=:parent_id ORDER BY `complete_code`,`name` ASC";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(GroupEngineer.class)
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
    public JSONObject getTree(GroupEngineer root, Boolean group) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        GroupEngineer grpEnineer = root;
        obj.put("name", grpEnineer.getName());
        obj.put("namedisplay", grpEnineer.getCode() + "." + grpEnineer.getName());
        obj.put("description", grpEnineer.getDescription());
        obj.put("code", grpEnineer.getCode());
        obj.put("completeCode", grpEnineer.getCompleteCode());
        obj.put("cost", grpEnineer.getCost());
        obj.put("completeParentCode", grpEnineer.getParentCode());
        obj.put("parentName", grpEnineer.getParentName());
        obj.put("parentId", grpEnineer.getParentId());
        obj.put("leaf", false);
        obj.put("expand", true);
        obj.put("id", grpEnineer.getId());

        if (group != null && group) {
            obj.put("countComplete", 0);
            obj.put("countOpen", 0);
            obj.put("countOverDue", 0);
            List<Integer> lstChild = getListChildren(root.getId());
            if (lstChild != null && !lstChild.isEmpty()) {
                obj.put("countOverDue", countWoOverDue(lstChild));
            }
        }
        return obj;
    }

    private Integer countWoOverDue(List<Integer> lstId) {
        try {
            String hql = "SELECT COUNT(`id`) FROM `work_order` "
                    + " WHERE `status`= :status AND `group_engineer_id` IN :lstId ";
            Query query = getSession()
                    .createSQLQuery(hql)
                    .setParameter("status", WorkOrder.STATUS_OVERDUE)
                    .setParameterList("lstId", lstId);
            
            List list = query.list();
            return ((BigInteger) list.get(0)).intValue();
        } catch (Exception ex) {
            log.error("ERROR countWoOverDue: ", ex);
            return null;
        }
    }

    private HashMap<Integer, GroupEngineer> groupWo(List<Integer> lstId) {
        try {
            String hql = "SELECT "
                    + "  `group_engineer_id`,"
                    + "  SUM(CASE `status` WHEN 0 THEN 1 ELSE 0 END)  AS `complete`,"
                    + "  SUM(CASE `status` WHEN 1 THEN 1 ELSE 0 END)  AS `open`,"
                    + "  SUM(CASE `status` WHEN 2 THEN 1 ELSE 0 END)  AS `overdue` "
                    + " FROM `work_order` "
                    + " WHERE `group_engineer_id` IN :lstId "
                    + " GROUP BY `group_engineer_id`";
            Query query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);

            List<Object[]> areaList = query.list();
            HashMap<Integer, GroupEngineer> rtn = new HashMap<Integer, GroupEngineer>();
            GroupEngineer groupEngineer;
            if (areaList != null && !areaList.isEmpty()) {
                for (Object[] obj : areaList) {
                    groupEngineer = new GroupEngineer();
                    groupEngineer.setId(Integer.valueOf(String.valueOf(obj[0])));
                    if (obj[1] != null && String.valueOf(obj[1]) != null) {
                        groupEngineer.setCountComplete(Integer.valueOf(String.valueOf(obj[1])));
                    }
                    if (obj[2] != null && String.valueOf(obj[2]) != null) {
                        groupEngineer.setCountOpen(Integer.valueOf(String.valueOf(obj[2])));
                    }
                    if (obj[3] != null && String.valueOf(obj[3]) != null) {
                        groupEngineer.setCountOverDue(Integer.valueOf(String.valueOf(obj[3])));
                    }
                    rtn.put(groupEngineer.getId(), groupEngineer);
                }
            }

            return rtn;
        } catch (Exception ex) {
            log.error("ERROR groupWo: ", ex);
            return null;
        }
    }

    @Override
    public JSONArray getTreeView(Integer id, Boolean group) throws JSONException, SQLException {
        List<GroupEngineer> roots = getListItem(id);
        JSONArray treeview = new JSONArray();
        for (GroupEngineer root : roots) {
            JSONObject tree = getTree(root, group);
            treeview.put(tree);
        }
        return treeview;
    }

    @Override
    public List<Integer> getListChildren(Integer id) {
        try {
            List<Integer> rtn = null;
            Query query;
            if (id == null) {
                return new ArrayList<Integer>(0);
            }
            if (id <= 0) {
                List<GroupEngineer> list = getAll();
                rtn = new LinkedList<>();
                for (GroupEngineer grp : list) {
                    rtn.add(grp.getId());
                }
                return rtn;
            } else {
                String hql = "SELECT id,GetEngineerTree(id,:level) FamilyTree FROM group_engineer WHERE id=:parent_id";
                query = getSession()
                        .createSQLQuery(hql)
                        .setParameter("level", TREE_LEVEL)
                        .setParameter("parent_id", id);

                List<Object[]> areaList = query.list();
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
            }
        } catch (Exception ex) {
            log.error("ERROR getListChildren: ", ex);
            return null;
        }
    }

    @Override
    public Integer delete(List<Integer> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM group_engineer WHERE id in (:lstId)")
                    .addEntity(GroupEngineer.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR delete: ", ex);
            return null;
        }
    }

    @Override
    public Boolean checkUnique(Integer id, String code) {
        Boolean rtn = null;
        Session session = null;
        try {
            List<GroupEngineer> list = new ArrayList<GroupEngineer>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(GroupEngineer.class);

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
            String hql = "SELECT COUNT(id) FROM group_engineer WHERE parent_id in (:lstId)";
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
    public Boolean checkUseByWo(List<Integer> lstId) {
        try {
            if (lstId == null || lstId.isEmpty()) {
                return false;
            }
            String hql = "SELECT COUNT(id) FROM work_order WHERE group_engineer_id in (:lstId)";
            Query query = getSession()
                    .createSQLQuery(hql)
                    .setParameterList("lstId", lstId);

            List list = query.list();
            return (((BigInteger) list.get(0)).intValue() > 0);
        } catch (Exception ex) {
            log.error("ERROR checkUseByWo: ", ex);
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
            String hql = "SELECT COUNT(id) FROM man_hours WHERE group_engineer_id in (:lstId)";
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
