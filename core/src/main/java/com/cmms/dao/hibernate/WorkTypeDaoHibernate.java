package com.cmms.dao.hibernate;

import com.cmms.dao.WorkTypeDao;
import static com.cmms.dao.hibernate.ItemTypeDaoHibernate.TREE_LEVEL;
import com.cmms.model.Company;
import com.cmms.model.WorkType;
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
public class WorkTypeDaoHibernate extends GenericDaoHibernate<WorkType, Integer> implements WorkTypeDao {

    public WorkTypeDaoHibernate() {
        super(WorkType.class);
    }

    @Override
    public Map getList(String code, String name, Integer start, Integer limit) {
        try {
            Map result = new HashMap();
            Criteria criteria = getSession().createCriteria(WorkType.class);

            //code
            if (!StringUtils.isBlank(code)) {
                criteria.add(Restrictions.like("code", code).ignoreCase());
            }
            if (!StringUtils.isBlank(name)) {
                criteria.add(Restrictions.like("name", name).ignoreCase());
            }
            criteria.addOrder(Order.asc("code"));
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

    /**
     *
     * @param lstId
     * @return true neu duoc su dung tren WO
     */
    @Override
    public Boolean checkUseWO(List<Integer> lstId) {
        try {
            if (lstId == null || lstId.isEmpty()) {
                return false;
            }
            Query query = getSession().createSQLQuery("SELECT * FROM work_order WHERE work_type_id in (:lstId)")
                    .setParameterList("lstId", lstId);
            return (query.list().size() > 0);
        } catch (Exception ex) {
            log.error("ERROR checkUseWO: " + StringUtils.join(lstId, ","), ex);
            return null;
        }
    }
}
