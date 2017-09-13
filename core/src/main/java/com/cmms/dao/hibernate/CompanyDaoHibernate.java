package com.cmms.dao.hibernate;

import com.cmms.dao.CompanyDao;
import static com.cmms.dao.hibernate.ItemTypeDaoHibernate.TREE_LEVEL;
import com.cmms.model.Company;
import com.cmms.obj.CompanyObj;
import java.math.BigInteger;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToBeanResultTransformer;

/**
 *
 * @author thuyetlv
 */
public class CompanyDaoHibernate extends GenericDaoHibernate<Company, Integer> implements CompanyDao {

    public CompanyDaoHibernate() {
        super(Company.class);
    }

    @Override
    public List<Company> getListItem(Integer id) {
        try {
            List<Company> rtn = new LinkedList<>();
            String hql = "";
            if (id == null || id == 0) {
                hql = "SELECT * FROM company WHERE parent_id IS NULL";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Company.class)
                        .list();
            } else {
                hql = "SELECT * FROM company WHERE parent_id=:parent_id";
                rtn = getSession().createSQLQuery(hql)
                        .addEntity(Company.class)
                        .setParameter("parent_id", id)
                        .list();
            }
            return rtn;
        } catch (Exception ex) {
            log.error("ERROR getListItem: ", ex);
            return null;
        }
    }

    public JSONObject getTree(Company root) throws JSONException, SQLException {
        JSONObject obj = new JSONObject();
        JSONArray children = new JSONArray();
        Company currentGroup = root;
        obj.put("name", currentGroup.getName());
        obj.put("namedisplay", currentGroup.getCode() + "." + currentGroup.getName());
        obj.put("description", currentGroup.getDescription());
        obj.put("code", currentGroup.getCode());
        obj.put("completeCode", currentGroup.getCompleteCode());
        
        
        obj.put("completeParentCode", currentGroup.getCompany().getCompleteCode());
        obj.put("parentName", currentGroup.getCompany().getName());
        obj.put("parentId", currentGroup.getParentId());
        obj.put("state", currentGroup.getState());
        obj.put("leaf", false);
        obj.put("expand", true);
        //obj.put("iconCls", "folder");
//        obj.put("iconCls", "task-folder");
        obj.put("id", currentGroup.getId());
//        obj.put("children", children);
        return obj;
    }

    @Override
    public JSONArray getTreeView(Integer id) throws JSONException, SQLException {
        List<Company> roots = getListItem(id);

        JSONArray treeview = new JSONArray();
        for (Company root : roots) {
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
            String hql = "SELECT id,GetCompanyTree(id,:level) FamilyTree FROM company WHERE id=:parent_id";
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
    public Map getListCompany(List<Integer> listParent, String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            if (listParent == null || listParent.isEmpty()) {
                result.put("list", new ArrayList<>(0));
                result.put("count", 0L);
                return result;
            }
            HashMap<String, Object> param = new HashMap<>();
            StringBuffer sb = new StringBuffer();
            sb.setLength(0);

            StringBuffer sbCount = new StringBuffer();
            sbCount.setLength(0);

            sb.append("SELECT a.*,b.name as parent_name FROM company a LEFT JOIN company b ON a.parent_id=b.id WHERE 1=1 ");

            sbCount.append("SELECT COUNT(a.id) FROM company a WHERE 1=1 ");
            sb.append(" AND a.id IN (:lstId) ");
            sbCount.append("AND a.id IN (:lstId) ");
            param.put("lstId", listParent);

            if (!StringUtils.isBlank(code)) {
                sb.append(" AND a.code LIKE :code ");
                sbCount.append(" AND a.code LIKE :code ");
                param.put("code", "%" + code.trim() + "%");
            }
            if (!StringUtils.isBlank(name)) {
                sb.append(" AND a.name LIKE :name ");
                sbCount.append(" AND a.name LIKE :name ");
                param.put("name", "%" + name.trim() + "%");
            }

            //Count
            Long count = 0L;
            Query qCount = getSession().createSQLQuery(sbCount.toString());
            for (Map.Entry<String, Object> entrySet : param.entrySet()) {
                String key = entrySet.getKey();
                Object value = entrySet.getValue();
                if (key.equals("lstId")) {
                    qCount.setParameterList(key, (List<Integer>) value);
                } else {
                    qCount.setParameter(key, value);
                }
            }
            List<BigInteger> listCount = qCount.list();
            for (Iterator<BigInteger> iterator = listCount.iterator(); iterator.hasNext();) {
                count = iterator.next().longValue();
            }

            //List
            sb.append(" ORDER BY a.name,a.code LIMIT :start,:limit");
            param.put("start", start);
            param.put("limit", limit);
//            Query q = getSession().createSQLQuery(sb.toString())
//                    .addEntity(Company.class);
            Query q = getSession().createSQLQuery(sb.toString())
                    .setResultTransformer(
                            new AliasToBeanResultTransformer(CompanyObj.class)
                    );
            for (Map.Entry<String, Object> entrySet : param.entrySet()) {
                String key = entrySet.getKey();
                Object value = entrySet.getValue();
                if (key.equals("lstId")) {
                    q.setParameterList(key, (List<Integer>) value);
                } else {
                    q.setParameter(key, value);
                }
            }

//            List<CompanyObj> list = (List<CompanyObj>) getSessionFactory().getCurrentSession()
//                    .createSQLQuery(sb.toString())
//                    .setResultTransformer(
//                            new AliasToBeanResultTransformer(CompanyObj.class)
//                    ).list();
            result.put("list", q.list());
            result.put("count", count);
            return result;
        } catch (Exception ex) {
            log.error("ERROR getListCompany: ", ex);
            return null;
        }
    }

    @Override
    public Integer deleteCompany(List<Integer> list) {
        try {
            if (list == null || list.isEmpty()) {
                return 0;
            }
            Query q = getSession().createSQLQuery("DELETE FROM company WHERE id in (:lstId)")
                    .addEntity(Company.class)
                    .setParameterList("lstId", list);
            return q.executeUpdate();
        } catch (Exception ex) {
            log.error("ERROR deleteCompany: ", ex);
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

            Criteria criteria = session.createCriteria(Company.class);

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
