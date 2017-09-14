package com.cmms.dao.hibernate;

import com.cmms.dao.WorkTypeDao;
import static com.cmms.dao.hibernate.ItemTypeDaoHibernate.TREE_LEVEL;
import com.cmms.model.Company;
import com.cmms.model.WorkType;
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
public class WorkTypeDaoHibernate extends GenericDaoHibernate<WorkType, Integer> implements WorkTypeDao {

    public WorkTypeDaoHibernate() {
        super(WorkType.class);
    }

    @Override
    public List<WorkType> getListItem(Integer id) {
        try {
            List<WorkType> rtn = new LinkedList<>();
            String hql = "";
            if (id == null || id <= 0) {
                hql = "SELECT * FROM work_type WHERE parent_id IS NULL";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(WorkType.class)
                        .list();
            } else {
                hql = "SELECT * FROM work_type WHERE parent_id=:parent_id";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(WorkType.class)
                        .setParameter("parent_id", id)
                        .list();
            }
            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListItem: ", ex);
            return null;
        }
    }

    public JSONObject getTree(WorkType root) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        WorkType currentGroup = root;
        obj.put("name", currentGroup.getName());
        obj.put("code", currentGroup.getCode());
        obj.put("parentId", currentGroup.getParentId());
        obj.put("leaf", false);
        obj.put("expand", true);
        obj.put("id", currentGroup.getId());
        return obj;
    }

    @Override
    public JSONArray getTreeView(Integer id) throws JSONException, SQLException {
        List<WorkType> roots = getListItem(id);

        JSONArray treeview = new JSONArray();
        for (WorkType root : roots) {
            JSONObject tree = getTree(root);
            treeview.put(tree);
        }
        return treeview;
    }

    @Override
    public List<Integer> getListChildren(Integer id) {
        try {
            List<Integer> rtn = null;
            Query query;
            if (id == null || id <= 0) {
                return new ArrayList<Integer>(0);
            }
            String hql = "SELECT id,GetWorkTypeTree(id,:level) FamilyTree FROM work_type WHERE id=:parent_id";
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
            Query q = getSession().createSQLQuery("DELETE FROM work_type WHERE id in (:lstId)")
                    .addEntity(WorkType.class)
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
            List<Company> list = new ArrayList<Company>();

            session = this.getSessionFactory().openSession();
            session = getSession();
            if (!session.isOpen() || !session.isConnected()) {
                log.debug("Session is close...." + session.isOpen() + " --- " + session.isConnected());
                session = this.getSessionFactory().openSession();
            }

            Criteria criteria = session.createCriteria(WorkType.class);

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

}
